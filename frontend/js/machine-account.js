// 机机账号管理页面脚本
import { MachineAccountApi, Utils } from './api.js';

// 分页参数
let currentPage = 1;
const itemsPerPage = 10;

// 初始化机机账号页面
export async function initMachineAccountPage() {
    // 防止重复初始化
    if (window.machineAccountPageInitialized) {
        return;
    }
    window.machineAccountPageInitialized = true;
    
    // 加载账号数据
    await loadAccounts(currentPage, itemsPerPage);

    // 绑定新增账号按钮事件
    $('#add-account-btn').off('click').on('click', function() {
        resetAccountForm();
        $('#account-modal-label').text('新增机机账号');
        $('#account-modal').modal('show');
    });

    // 绑定保存账号按钮事件
    $('#save-account-btn').off('click').on('click', function() {
        saveAccount();
    });

    // 绑定搜索按钮事件
    $('#search-btn').off('click').on('click', function() {
        currentPage = 1;
        searchAccounts();
    });

    // 绑定搜索输入框回车事件
    $('#search-input').off('keypress').on('keypress', function(e) {
        if (e.which === 13) {
            currentPage = 1;
            searchAccounts();
        }
    });
    
    // 使用事件委托绑定编辑和删除按钮点击事件
    $('#account-table-body').off('click').on('click', '.btn-edit', function() {
        const id = $(this).data('id');
        editAccount(id);
    });
    
    $('#account-table-body').off('click').on('click', '.btn-delete', function() {
        const id = $(this).data('id');
        deleteAccount(id);
    });
}

// 加载机机账号数据
async function loadAccounts(page = 1, limit = 10) {
    // 显示加载动画
    $('#account-table-body').html(`
        <tr>
            <td colspan="10" class="text-center py-4">
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
        const data = await MachineAccountApi.getAll(skip, limit, searchTerm || null);
        const totalCount = await MachineAccountApi.getTotalCount();
        renderAccountTable(data, totalCount, page, limit);
    } catch (error) {
        console.error('Error loading accounts:', error);
        $('#account-table-body').html(`
            <tr>
                <td colspan="10" class="text-center py-4">
                    <div class="alert alert-danger d-inline-block">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        加载失败，请检查网络连接或服务器状态
                    </div>
                    <button class="btn btn-primary mt-2" onclick="loadAccounts(${page}, ${limit})">
                        <i class="fas fa-sync-alt mr-1"></i> 重试
                    </button>
                </td>
            </tr>
        `);
    }
}

// 渲染账号表格
function renderAccountTable(accounts, totalCount, currentPage, itemsPerPage) {
    let html = '';
    
    if (accounts.length === 0) {
        html = '<tr><td colspan="10" class="text-center py-4">暂无数据</td></tr>';
    } else {
        accounts.forEach(account => {
            html += `
                <tr data-id="${account.id}">
                    <td>${account.id}</td>
                    <td>${account.environment_id}</td>
                    <td>${account.ip}</td>
                    <td>${account.port}</td>
                    <td>${account.account}</td>
                    <td>${account.password}</td>
                    <td>${account.type || '-'}</td>
                    <td>${account.machine_account || '-'}</td>
                    <td>${account.machine_password || '-'}</td>
                    <td>${Utils.formatDateTime(account.created_at)}</td>
                    <td>
                        <button class="btn btn-sm btn-outline-primary mr-1 btn-edit" data-id="${account.id}"><i class="fas fa-edit"></i> 编辑</button>
                        <button class="btn btn-sm btn-outline-danger btn-delete" data-id="${account.id}"><i class="fas fa-trash"></i> 删除</button>
                    </td>
                </tr>
            `;
        });
    }
    
    $('#account-table-body').html(html);
    
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
                        <button class="page-link" onclick="loadAccounts(${currentPage - 1}, ${itemsPerPage})">&laquo;</button>
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
                    <button class="page-link" onclick="loadAccounts(${i}, ${itemsPerPage})"><strong>${i}</strong></button>
                </li>
            `;
        }
        
        paginationHtml += `
                    <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                        <button class="page-link" onclick="loadAccounts(${currentPage + 1}, ${itemsPerPage})">&raquo;</button>
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

// 重置账号表单
function resetAccountForm() {
    $('#account-form')[0].reset();
    $('#account-id').val('');
    $('#port').val('45339');
    $('#regenerate-checkbox').prop('checked', false);
}

// 编辑账号
async function editAccount(id) {
    try {
        const account = await MachineAccountApi.getById(id);
        $('#account-id').val(account.id);
        $('#environment-id').val(account.environment_id);
        $('#ip').val(account.ip);
        $('#port').val(account.port);
        $('#account').val(account.account);
        $('#password').val(account.password);
        $('#type').val(account.type || '');
        $('#machine-account').val(account.machine_account || '');
        $('#machine-password').val(account.machine_password || '');
        $('#account-modal-label').text('编辑机机账号');
        $('#account-modal').modal('show');
    } catch (error) {
        console.error('Error loading account:', error);
        Utils.showAlert('加载账号信息失败', 'danger');
    }
}

// 保存账号
async function saveAccount() {
    const id = $('#account-id').val();
    const environmentId = $('#environment-id').val();
    const ip = $('#ip').val();
    const port = $('#port').val();
    const account = $('#account').val();
    const password = $('#password').val();
    const type = $('#type').val();
    const machineAccount = $('#machine-account').val();
    const machinePassword = $('#machine-password').val();
    const regenerate = $('#regenerate-checkbox').prop('checked');

    if (!environmentId || !ip || !port || !account || !password) {
        Utils.showAlert('请填写必填字段', 'warning');
        return;
    }

    const data = {
        environment_id: environmentId,
        ip: ip,
        port: parseInt(port),
        account: account,
        password: password,
        type: type,
        machine_account: machineAccount,
        machine_password: machinePassword
    };

    // 禁用保存按钮并显示加载状态
    const saveBtn = $('#save-account-btn');
    const originalText = saveBtn.html();
    saveBtn.prop('disabled', true).html(`
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        保存中...
    `);

    try {
        if (id) {
            await MachineAccountApi.update(id, data, regenerate);
            Utils.showAlert('账号更新成功', 'success');
        } else {
            await MachineAccountApi.create(data);
            Utils.showAlert('账号新增成功', 'success');
        }
        $('#account-modal').modal('hide');
        await loadAccounts();
    } catch (error) {
        console.error('Error saving account:', error);
        Utils.showAlert('保存失败，请重试', 'danger');
    } finally {
        // 恢复保存按钮状态
        saveBtn.prop('disabled', false).html(originalText);
    }
}

// 删除账号
async function deleteAccount(id) {
    if (confirm('确定要删除这个账号吗？')) {
        // 显示加载状态
        const row = $(`tr[data-id="${id}"]`);
        const originalContent = row.html();
        row.html(`
            <td colspan="10" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">删除中...</span>
                </div>
                <span class="ml-2 text-muted">删除中...</span>
            </td>
        `);
        
        try {
            await MachineAccountApi.delete(id);
            await loadAccounts();
            Utils.showAlert('账号删除成功', 'success');
        } catch (error) {
            console.error('Error deleting account:', error);
            row.html(originalContent);
            Utils.showAlert('删除失败，请重试', 'danger');
        }
    }
}

// 搜索账号
function searchAccounts() {
    loadAccounts(currentPage, itemsPerPage);
}

// 暴露全局函数
window.loadAccounts = loadAccounts;
window.editAccount = editAccount;
window.deleteAccount = deleteAccount;