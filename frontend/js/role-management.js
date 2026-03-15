/**
 * 角色管理页面 JavaScript 模块
 */

// 导入 API 服务和工具函数
import { RoleApi, Utils } from './api.js';

// 模态框实例（单例模式）
let roleModalInstance = null;

/**
 * 初始化角色管理页面
 */
function initRoleManagementPage() {
    console.log('初始化角色管理页面');
    
    // 加载角色列表
    loadRoles();
    
    // 绑定事件
    bindRoleEvents();
}

/**
 * 加载角色列表
 */
async function loadRoles() {
    try {
        const response = await RoleApi.getAll();
        renderRoleList(response);
    } catch (error) {
        showError('加载角色列表失败');
        console.error('加载角色列表错误:', error);
    }
}

/**
 * 渲染角色列表
 * @param {Array} roles - 角色列表
 */
function renderRoleList(roles) {
    const roleTableBody = document.getElementById('role-table-body');
    if (!roleTableBody) return;
    
    roleTableBody.innerHTML = '';
    
    if (roles.length === 0) {
        roleTableBody.innerHTML = `
            <tr>
                <td colspan="6" class="text-center text-muted">暂无角色数据</td>
            </tr>
        `;
        return;
    }
    
    roles.forEach(role => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${role.id}</td>
            <td>${role.name}</td>
            <td><span class="badge bg-info">${role.code}</span></td>
            <td>${role.description || '无描述'}</td>
            <td>${Utils.formatDateTime(role.created_at)}</td>
            <td>
                <button class="btn btn-primary btn-sm edit-btn" data-role-id="${role.id}">
                    <i class="fas fa-edit"></i> 编辑
                </button>
                <button class="btn btn-danger btn-sm delete-btn" data-role-id="${role.id}">
                    <i class="fas fa-trash"></i> 删除
                </button>
            </td>
        `;
        
        // 绑定编辑按钮事件
        const editBtn = row.querySelector('.edit-btn');
        if (editBtn) {
            editBtn.addEventListener('click', function() {
                editRole(role.id);
            });
        }
        
        // 绑定删除按钮事件
        const deleteBtn = row.querySelector('.delete-btn');
        if (deleteBtn) {
            deleteBtn.addEventListener('click', function() {
                deleteRole(role.id);
            });
        }
        
        roleTableBody.appendChild(row);
    });
}

/**
 * 绑定角色相关事件
 */
function bindRoleEvents() {
    // 新增角色按钮点击事件
    document.getElementById('add-role-btn')?.addEventListener('click', function() {
        openRoleModal();
    });
    
    // 保存角色按钮点击事件
    document.getElementById('save-role-btn')?.addEventListener('click', function() {
        saveRole();
    });
    
    // 搜索按钮点击事件
    document.getElementById('role-search-btn')?.addEventListener('click', function() {
        searchRoles();
    });
    
    // 搜索框回车事件
    document.getElementById('role-search-input')?.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchRoles();
        }
    });
}

/**
 * 搜索角色
 */
async function searchRoles() {
    const searchInput = document.getElementById('role-search-input');
    const searchTerm = searchInput ? searchInput.value.trim() : '';
    
    try {
        const response = await RoleApi.getAll();
        
        if (searchTerm) {
            // 过滤角色列表
            const filteredRoles = response.filter(role => 
                role.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                role.code.toLowerCase().includes(searchTerm.toLowerCase())
            );
            renderRoleList(filteredRoles);
        } else {
            renderRoleList(response);
        }
    } catch (error) {
        showError('搜索角色失败');
        console.error('搜索角色错误:', error);
    }
}

/**
 * 打开角色模态框
 * @param {Object} role - 角色信息（编辑时传入）
 */
function openRoleModal(role = null) {
    const modalElement = document.getElementById('role-modal');
    
    // 使用单例模式，只创建一次模态框实例
    if (!roleModalInstance) {
        roleModalInstance = new bootstrap.Modal(modalElement);
    }
    
    const modalTitle = document.getElementById('role-modal-title');
    const roleForm = document.getElementById('role-form');
    
    if (role) {
        modalTitle.textContent = '编辑角色';
        document.getElementById('role-id').value = role.id;
        document.getElementById('role-name').value = role.name;
        document.getElementById('role-code').value = role.code;
        document.getElementById('role-description').value = role.description || '';
    } else {
        modalTitle.textContent = '新增角色';
        roleForm.reset();
        document.getElementById('role-id').value = '';
    }
    
    roleModalInstance.show();
}

/**
 * 保存角色
 */
async function saveRole() {
    const roleId = document.getElementById('role-id').value;
    const name = document.getElementById('role-name').value;
    const code = document.getElementById('role-code').value;
    const description = document.getElementById('role-description').value;
    
    // 验证表单
    if (!name || !code) {
        showError('角色名称和编码不能为空');
        return;
    }
    
    const roleData = {
        name,
        code,
        description
    };
    
    try {
        let response;
        if (roleId) {
            // 更新角色
            response = await RoleApi.update(roleId, roleData);
        } else {
            // 创建角色
            response = await RoleApi.create(roleData);
        }
        
        // 关闭模态框
        if (roleModalInstance) {
            roleModalInstance.hide();
        }
        
        // 重新加载角色列表
        loadRoles();
        showSuccess(roleId ? '角色更新成功' : '角色创建成功');
    } catch (error) {
        showError('操作失败');
        console.error('保存角色错误:', error);
    }
}

/**
 * 编辑角色
 * @param {number} roleId - 角色ID
 */
async function editRole(roleId) {
    try {
        const response = await RoleApi.getById(roleId);
        openRoleModal(response);
    } catch (error) {
        showError('获取角色信息失败');
        console.error('编辑角色错误:', error);
    }
}

/**
 * 删除角色
 * @param {number} roleId - 角色ID
 */
async function deleteRole(roleId) {
    if (!confirm('确定要删除这个角色吗？')) return;
    
    try {
        await RoleApi.delete(roleId);
        loadRoles();
        showSuccess('角色删除成功');
    } catch (error) {
        showError('删除失败');
        console.error('删除角色错误:', error);
    }
}

/**
 * 显示成功消息
 * @param {string} message - 消息内容
 */
function showSuccess(message) {
    Utils.showAlert(message, 'success');
}

/**
 * 显示错误消息
 * @param {string} message - 消息内容
 */
function showError(message) {
    Utils.showAlert(message, 'danger');
}

// 导出初始化函数
export { initRoleManagementPage };
