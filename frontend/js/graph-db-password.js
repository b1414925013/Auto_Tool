// 图数据库密码管理页面脚本
import { GraphDBPasswordApi, Utils } from './api.js';

// 分页参数
let currentPage = 1;
const itemsPerPage = 10;

// 初始化图数据库密码页面
export async function initGraphDBPasswordPage() {
    // 防止重复初始化
    if (window.graphDBPasswordPageInitialized) {
        return;
    }
    window.graphDBPasswordPageInitialized = true;
    
    // 加载密码数据
    await loadPasswords(currentPage, itemsPerPage);

    // 绑定新增密码按钮事件
    $('#add-password-btn').off('click').on('click', function() {
        resetPasswordForm();
        $('#password-modal-label').text('新增图数据库密码');
        $('#password-modal').modal('show');
    });

    // 绑定保存密码按钮事件
    $('#save-password-btn').off('click').on('click', function() {
        savePassword();
    });

    // 绑定搜索按钮事件
    $('#search-btn').off('click').on('click', function() {
        currentPage = 1;
        searchPasswords();
    });

    // 绑定搜索输入框回车事件
    $('#search-input').off('keypress').on('keypress', function(e) {
        if (e.which === 13) {
            currentPage = 1;
            searchPasswords();
        }
    });
    
    // 使用事件委托绑定编辑和删除按钮点击事件
    $('#password-table-body').off('click').on('click', '.btn-edit', function() {
        const id = $(this).data('id');
        editPassword(id);
    });
    
    $('#password-table-body').off('click').on('click', '.btn-delete', function() {
        const id = $(this).data('id');
        deletePassword(id);
    });
}

// 加载图数据库密码数据
async function loadPasswords(page = 1, limit = 10) {
    // 显示加载动画
    $('#password-table-body').html(`
        <tr>
            <td colspan="7" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">加载中...</span>
                </div>
                <span class="ml-2 text-muted">加载中...</span>
            </td>
        </tr>
    `);
    
    try {
        const skip = (page - 1) * limit;
        const searchTerm = $('#search-input').val().trim();
        const data = await GraphDBPasswordApi.getAll(skip, limit, searchTerm || null);
        const totalCount = await GraphDBPasswordApi.getTotalCount();
        renderPasswordTable(data, totalCount, page, limit);
    } catch (error) {
        console.error('Error loading passwords:', error);
        $('#password-table-body').html(`
            <tr>
                <td colspan="7" class="text-center py-4">
                    <div class="alert alert-danger d-inline-block">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        加载失败，请检查网络连接或服务器状态
                    </div>
                    <button class="btn btn-primary mt-2" onclick="loadPasswords(${page}, ${limit})">
                        <i class="fas fa-sync-alt mr-1"></i> 重试
                    </button>
                </td>
            </tr>
        `);
    }
}

// 渲染密码表格
function renderPasswordTable(passwords, totalCount, currentPage, itemsPerPage) {
    let html = '';
    
    if (passwords.length === 0) {
        html = '<tr><td colspan="7" class="text-center py-4">暂无数据</td></tr>';
    } else {
        passwords.forEach(password => {
            html += `
                <tr data-id="${password.id}">
                    <td>${password.id}</td>
                    <td>${password.environment_id}</td>
                    <td>${password.jump_server_ip}</td>
                    <td>${password.pass_core_ip}</td>
                    <td>${password.graph_db_password}</td>
                    <td>${Utils.formatDateTime(password.created_at)}</td>
                    <td>
                        <button class="btn btn-sm btn-outline-primary mr-1 btn-edit" data-id="${password.id}"><i class="fas fa-edit"></i> 编辑</button>
                        <button class="btn btn-sm btn-outline-danger btn-delete" data-id="${password.id}"><i class="fas fa-trash"></i> 删除</button>
                    </td>
                </tr>
            `;
        });
    }
    
    $('#password-table-body').html(html);
    
    // 渲染分页控件
    renderPagination(totalCount, currentPage, itemsPerPage);
}

// 渲染分页控件
function renderPagination(totalCount, currentPage, itemsPerPage) {
    const totalPages = Math.ceil(totalCount / itemsPerPage);
    
    let paginationHtml = '';
    
    if (totalPages > 1) {
        paginationHtml = `
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                        <button class="page-link" onclick="loadPasswords(${currentPage - 1}, ${itemsPerPage})">&laquo;</button>
                    </li>
        `;
        
        // 计算显示的页码范围
        let startPage = Math.max(1, currentPage - 2);
        let endPage = Math.min(totalPages, startPage + 4);
        
        if (endPage - startPage < 4) {
            startPage = Math.max(1, endPage - 4);
        }
        
        // 添加页码按钮
        for (let i = startPage; i <= endPage; i++) {
            paginationHtml += `
                <li class="page-item ${i === currentPage ? 'active' : ''}">
                    <button class="page-link" onclick="loadPasswords(${i}, ${itemsPerPage})"><strong>${i}</strong></button>
                </li>
            `;
        }
        
        paginationHtml += `
                    <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                        <button class="page-link" onclick="loadPasswords(${currentPage + 1}, ${itemsPerPage})">&raquo;</button>
                    </li>
                </ul>
            </nav>
        `;
    }
    
    // 移除旧的分页控件（如果存在）
    $('.card-footer').remove();
    
    // 添加新的分页控件
    $('.card').append(`
        <div class="card-footer bg-white border-top">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-muted">
                    共 <strong>${totalCount}</strong> 条记录，每页显示 <strong>${itemsPerPage}</strong> 条
                </div>
                <div>
                    ${paginationHtml}
                </div>
            </div>
        </div>
    `);
}

// 重置密码表单
function resetPasswordForm() {
    $('#password-form')[0].reset();
    $('#password-id').val('');
}

// 编辑密码
async function editPassword(id) {
    try {
        const password = await GraphDBPasswordApi.getById(id);
        $('#password-id').val(password.id);
        $('#environment-id').val(password.environment_id);
        $('#jump-server-ip').val(password.jump_server_ip);
        $('#jump-server-port').val(password.jump_server_port);
        $('#jump-server-account').val(password.jump_server_account);
        $('#jump-server-password').val(password.jump_server_password);
        $('#pass-core-ip').val(password.pass_core_ip);
        $('#pass-core-port').val(password.pass_core_port);
        $('#pass-core-account').val(password.pass_core_account);
        $('#pass-core-password').val(password.pass_core_password);
        $('#pass-core-root-password').val(password.pass_core_root_password);
        $('#password-modal-label').text('编辑图数据库密码');
        $('#password-modal').modal('show');
    } catch (error) {
        console.error('Error loading password:', error);
        Utils.showAlert('加载密码信息失败', 'danger');
    }
}

// 保存密码
async function savePassword() {
    const id = $('#password-id').val();
    const environmentId = $('#environment-id').val();
    const jumpServerIp = $('#jump-server-ip').val();
    const jumpServerPort = $('#jump-server-port').val();
    const jumpServerAccount = $('#jump-server-account').val();
    const jumpServerPassword = $('#jump-server-password').val();
    const passCoreIp = $('#pass-core-ip').val();
    const passCorePort = $('#pass-core-port').val();
    const passCoreAccount = $('#pass-core-account').val();
    const passCorePassword = $('#pass-core-password').val();
    const passCoreRootPassword = $('#pass-core-root-password').val();

    if (!environmentId || !jumpServerIp || !jumpServerPort || !jumpServerAccount || !jumpServerPassword || 
        !passCoreIp || !passCorePort || !passCoreAccount || !passCorePassword || !passCoreRootPassword) {
        Utils.showAlert('请填写所有必填字段', 'warning');
        return;
    }

    const data = {
        environment_id: environmentId,
        jump_server_ip: jumpServerIp,
        jump_server_port: parseInt(jumpServerPort),
        jump_server_account: jumpServerAccount,
        jump_server_password: jumpServerPassword,
        pass_core_ip: passCoreIp,
        pass_core_port: parseInt(passCorePort),
        pass_core_account: passCoreAccount,
        pass_core_password: passCorePassword,
        pass_core_root_password: passCoreRootPassword
    };

    // 禁用保存按钮并显示加载状态
    const saveBtn = $('#save-password-btn');
    const originalText = saveBtn.html();
    saveBtn.prop('disabled', true).html(`
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        保存中...
    `);

    try {
        if (id) {
            await GraphDBPasswordApi.update(id, data);
            Utils.showAlert('密码更新成功', 'success');
        } else {
            await GraphDBPasswordApi.create(data);
            Utils.showAlert('密码新增成功', 'success');
        }
        $('#password-modal').modal('hide');
        await loadPasswords();
    } catch (error) {
        console.error('Error saving password:', error);
        Utils.showAlert('保存失败，请重试', 'danger');
    } finally {
        // 恢复保存按钮状态
        saveBtn.prop('disabled', false).html(originalText);
    }
}

// 删除密码
async function deletePassword(id) {
    if (confirm('确定要删除这个密码吗？')) {
        // 显示加载状态
        const row = $(`tr[data-id="${id}"]`);
        const originalContent = row.html();
        row.html(`
            <td colspan="7" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">删除中...</span>
                </div>
                <span class="ml-2 text-muted">删除中...</span>
            </td>
        `);
        
        try {
            console.log('Deleting graph DB password with id:', id);
            console.log('Using GraphDBPasswordApi.delete');
            await GraphDBPasswordApi.delete(id);
            await loadPasswords();
            Utils.showAlert('密码删除成功', 'success');
        } catch (error) {
            console.error('Error deleting password:', error);
            row.html(originalContent);
            Utils.showAlert('删除失败，请重试', 'danger');
        }
    }
}

// 搜索密码
function searchPasswords() {
    loadPasswords(currentPage, itemsPerPage);
}

// 暴露全局函数
window.loadPasswords = loadPasswords;
window.editPassword = editPassword;
window.deletePassword = deletePassword;
