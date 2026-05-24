/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Complete Multi-Dashboard JavaScript for Restaurant Management System
class RestaurantAdminSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.currentPage = this.getCurrentPage();
        this.init();
    }

    getContextPath() {
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath;
    }

    getCurrentPage() {
        const path = window.location.pathname;
        if (path.includes('/admin/dashboard')) return 'dashboard';
        if (path.includes('/admin/users')) return 'users';
        if (path.includes('/admin/orders')) return 'orders';
        if (path.includes('/admin/menu')) return 'menu';
        if (path.includes('/admin/revenue')) return 'revenue';
        if (path.includes('/admin/approvals')) return 'approvals';
        return 'dashboard';
    }

    init() {
        // Initialize common functionality
        this.setupCommonFeatures();
        
        // Initialize page-specific functionality
        switch (this.currentPage) {
            case 'dashboard':
                this.initDashboard();
                break;
            case 'users':
                this.initUsersPage();
                break;
            case 'orders':
                this.initOrdersPage();
                break;
            case 'menu':
                this.initMenuPage();
                break;
            case 'revenue':
                this.initRevenuePage();
                break;
            case 'approvals':
                this.initApprovalsPage();
                break;
        }
    }

    // Common features across all pages
    setupCommonFeatures() {
        this.displayMessages();
        this.setupLogout();
        this.addKeyboardShortcuts();
        this.setupNavigation();
    }

    // Dashboard-specific functionality
    initDashboard() {
        console.log('Initializing Main Dashboard');
        this.setupTabSwitching();
        this.setupUserActions();
        this.setupSearchFilters();
        this.setupSortable();
        this.setupRealTimeUpdates();
        this.addExportButtons();
    }

    // Tab switching for dashboard
    setupTabSwitching() {
        const triggerTabList = document.querySelectorAll('#userTabs button[data-bs-toggle="tab"]');
        triggerTabList.forEach(triggerEl => {
            const tabTrigger = new bootstrap.Tab(triggerEl);
            
            triggerEl.addEventListener('click', event => {
                event.preventDefault();
                tabTrigger.show();
                localStorage.setItem('activeTab', triggerEl.id);
            });
        });

        // Restore active tab
        const activeTabId = localStorage.getItem('activeTab');
        if (activeTabId) {
            const tab = document.getElementById(activeTabId);
            if (tab) {
                const tabTrigger = new bootstrap.Tab(tab);
                tabTrigger.show();
            }
        }
    }

    // User actions for dashboard
    setupUserActions() {
        document.addEventListener('click', (e) => {
            if (e.target.closest('.btn') && e.target.href) {
                if (e.target.href.includes('action=approve')) {
                    e.preventDefault();
                    this.handleUserAction('approve', e.target);
                } else if (e.target.href.includes('action=promote')) {
                    e.preventDefault();
                    this.handleUserAction('promote', e.target);
                } else if (e.target.href.includes('action=delete')) {
                    e.preventDefault();
                    this.handleUserAction('delete', e.target);
                }
            }
        });
    }

    async handleUserAction(action, button) {
        const row = button.closest('tr');
        const url = button.href;
        
        if (action === 'delete' && !confirm('Are you sure you want to delete this user?')) {
            return;
        }
        
        this.setButtonLoading(button, true);
        
        try {
            const response = await fetch(url, {
                method: 'GET',
                credentials: 'same-origin'
            });
            
            if (response.ok) {
                this.handleActionSuccess(action, row);
            } else {
                this.showNotification(`Error ${action}ing user`, 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            this.showNotification(`Error ${action}ing user`, 'error');
        }
        
        this.setButtonLoading(button, false);
    }

    handleActionSuccess(action, row) {
        switch (action) {
            case 'approve':
                const statusBadge = row.querySelector('.badge:last-of-type');
                statusBadge.className = 'badge bg-success';
                statusBadge.textContent = 'Active';
                row.querySelector('.btn-success')?.remove();
                this.showNotification('User approved successfully!', 'success');
                break;
            case 'promote':
                this.showNotification('User promoted successfully!', 'success');
                break;
            case 'delete':
                row.remove();
                this.showNotification('User deleted successfully!', 'success');
                break;
        }
    }

    // Users page functionality
    initUsersPage() {
        console.log('Initializing Users Management Page');
        this.setupUserSearch();
        this.setupUserFilters();
        this.setupUserForm();
        this.setupUserActions();
        this.setupExport();
    }

    setupUserSearch() {
        const searchInput = document.getElementById('userSearch');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.filterUsers(e.target.value);
            });
        }
    }

    setupUserFilters() {
        const roleFilter = document.getElementById('roleFilter');
        const statusFilter = document.getElementById('statusFilter');
        
        if (roleFilter) {
            roleFilter.addEventListener('change', () => this.applyFilters());
        }
        
        if (statusFilter) {
            statusFilter.addEventListener('change', () => this.applyFilters());
        }
    }

    setupUserForm() {
        const userForm = document.getElementById('addUserForm');
        if (userForm) {
            userForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleUserSubmit(userForm);
            });
        }
    }

    async handleUserSubmit(form) {
        const formData = new FormData(form);
        
        try {
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData,
                credentials: 'same-origin'
            });
            
            if (response.ok) {
                this.showNotification('User created successfully!', 'success');
                form.reset();
                window.location.reload();
            } else {
                this.showNotification('Error creating user', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            this.showNotification('Error creating user', 'error');
        }
    }

    // Orders page functionality
    initOrdersPage() {
        console.log('Initializing Orders Management Page');
        this.setupOrderFilters();
        this.setupOrderStatusUpdate();
        this.setupOrderSearch();
        this.setupOrderRefresh();
    }

    setupOrderFilters() {
        const statusFilters = document.querySelectorAll('.order-status-filter');
        statusFilters.forEach(filter => {
            filter.addEventListener('click', (e) => {
                e.preventDefault();
                this.filterOrdersByStatus(filter.dataset.status);
            });
        });
    }

    setupOrderStatusUpdate() {
        const statusSelects = document.querySelectorAll('.order-status-select');
        statusSelects.forEach(select => {
            select.addEventListener('change', (e) => {
                this.updateOrderStatus(e.target);
            });
        });
    }

    async updateOrderStatus(select) {
        const orderId = select.dataset.orderId;
        const status = select.value;
        
        try {
            const response = await fetch(`${this.contextPath}/admin/orders`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=updateStatus&orderId=${orderId}&status=${status}`,
                credentials: 'same-origin'
            });
            
            if (response.ok) {
                this.showNotification('Order status updated!', 'success');
                this.updateOrderBadge(select.closest('tr'), status);
            } else {
                this.showNotification('Error updating order status', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            this.showNotification('Error updating order status', 'error');
        }
    }

    updateOrderBadge(row, status) {
        const badge = row.querySelector('.badge');
        if (badge) {
            badge.className = `badge ${this.getStatusBadgeClass(status)}`;
            badge.textContent = status.charAt(0).toUpperCase() + status.slice(1);
        }
    }

    getStatusBadgeClass(status) {
        switch (status.toLowerCase()) {
            case 'pending': return 'bg-warning';
            case 'preparing': return 'bg-info';
            case 'ready': return 'bg-primary';
            case 'delivered': return 'bg-success';
            case 'cancelled': return 'bg-danger';
            default: return 'bg-secondary';
        }
    }

    setupOrderRefresh() {
        // Auto-refresh orders every 60 seconds
        setInterval(() => {
            if (this.currentPage === 'orders') {
                this.refreshOrderCounts();
            }
        }, 60000);
    }

    async refreshOrderCounts() {
        try {
            const response = await fetch(`${this.contextPath}/admin/orders?action=counts`, {
                credentials: 'same-origin'
            });
            
            if (response.ok) {
                const counts = await response.json();
                this.updateOrderCounts(counts);
            }
        } catch (error) {
            console.error('Error refreshing order counts:', error);
        }
    }

    // Menu page functionality
    initMenuPage() {
        console.log('Initializing Menu Management Page');
        this.setupMenuForm();
        this.setupMenuActions();
        this.setupMenuSearch();
        this.setupMenuImageUpload();
    }

    setupMenuForm() {
        const menuForm = document.getElementById('menuItemForm');
        if (menuForm) {
            menuForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleMenuSubmit(menuForm);
            });
        }
    }

    setupMenuActions() {
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('edit-menu-item')) {
                e.preventDefault();
                this.editMenuItem(e.target.dataset.id);
            } else if (e.target.classList.contains('delete-menu-item')) {
                e.preventDefault();
                this.deleteMenuItem(e.target.dataset.id);
            }
        });
    }

    setupMenuImageUpload() {
        const imageInput = document.getElementById('menuImage');
        if (imageInput) {
            imageInput.addEventListener('change', (e) => {
                this.previewImage(e.target.files[0]);
            });
        }
    }

    previewImage(file) {
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const preview = document.getElementById('imagePreview');
                if (preview) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
            };
            reader.readAsDataURL(file);
        }
    }

    // Revenue page functionality
    initRevenuePage() {
        console.log('Initializing Revenue Page');
        this.setupRevenueCharts();
        this.setupRevenueFilters();
        this.setupRevenueExport();
        this.refreshRevenueData();
    }

    setupRevenueCharts() {
        // Initialize Chart.js charts if available
        if (typeof Chart !== 'undefined') {
            this.createRevenueChart();
            this.createOrderChart();
        }
    }

    createRevenueChart() {
        const ctx = document.getElementById('revenueChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [], // Will be populated with data
                    datasets: [{
                        label: 'Daily Revenue',
                        data: [],
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return 'R' + value.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        }
    }

    // Approvals page functionality
    initApprovalsPage() {
        console.log('Initializing Approvals Page');
        this.setupBulkActions();
        this.setupApprovalActions();
        this.setupApprovalFilters();
    }

    setupBulkActions() {
        const bulkApproveBtn = document.getElementById('bulkApprove');
        const bulkRejectBtn = document.getElementById('bulkReject');
        const selectAllCheckbox = document.getElementById('selectAll');
        
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', (e) => {
                this.toggleAllCheckboxes(e.target.checked);
            });
        }
        
        if (bulkApproveBtn) {
            bulkApproveBtn.addEventListener('click', () => {
                this.bulkApprove();
            });
        }
        
        if (bulkRejectBtn) {
            bulkRejectBtn.addEventListener('click', () => {
                this.bulkReject();
            });
        }
    }

    toggleAllCheckboxes(checked) {
        const checkboxes = document.querySelectorAll('.user-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = checked;
        });
    }

    async bulkApprove() {
        const selectedUsers = this.getSelectedUsers();
        if (selectedUsers.length === 0) {
            this.showNotification('Please select users to approve', 'warning');
            return;
        }
        
        for (const userId of selectedUsers) {
            await this.approveUser(userId);
        }
        
        this.showNotification(`${selectedUsers.length} users approved successfully!`, 'success');
        window.location.reload();
    }

    getSelectedUsers() {
        const checkboxes = document.querySelectorAll('.user-checkbox:checked');
        return Array.from(checkboxes).map(cb => cb.value);
    }

    // Common utility functions
    setButtonLoading(button, loading) {
        if (!button) return;
        
        if (loading) {
            button.disabled = true;
            button.originalText = button.innerHTML;
            button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> Loading...';
        } else {
            button.disabled = false;
            if (button.originalText) {
                button.innerHTML = button.originalText;
            }
        }
    }

    showNotification(message, type) {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.app-notification');
        existingNotifications.forEach(notification => notification.remove());
        
        // Create notification
        const notification = document.createElement('div');
        notification.className = `alert alert-${type === 'success' ? 'success' : type === 'warning' ? 'warning' : 'danger'} alert-dismissible fade show app-notification`;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.style.minWidth = '300px';
        notification.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)';
        notification.innerHTML = `
            <strong>${type === 'success' ? 'Success!' : type === 'warning' ? 'Warning!' : 'Error!'}</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    displayMessages() {
        // Display session messages
        if (window.sessionSuccess) {
            this.showNotification(window.sessionSuccess, 'success');
        }
        if (window.sessionError) {
            this.showNotification(window.sessionError, 'error');
        }
        
        // Display URL parameter messages
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const error = urlParams.get('error');
        
        if (success) {
            this.showNotification(decodeURIComponent(success), 'success');
        }
        if (error) {
            this.showNotification(decodeURIComponent(error), 'error');
        }
    }

    setupLogout() {
        const logoutBtn = document.querySelector('a[href*="/logout"]');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', (e) => {
                if (!confirm('Are you sure you want to logout?')) {
                    e.preventDefault();
                }
            });
        }
    }

    addKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch (e.key) {
                    case 'r':
                        e.preventDefault();
                        window.location.reload();
                        break;
                    case 'f':
                        e.preventDefault();
                        const searchInput = document.querySelector('input[type="search"], input[placeholder*="Search"]');
                        if (searchInput) {
                            searchInput.focus();
                        }
                        break;
                    case 'n':
                        e.preventDefault();
                        const addBtn = document.querySelector('.btn[data-bs-toggle="modal"], .btn:contains("Add")');
                        if (addBtn) {
                            addBtn.click();
                        }
                        break;
                }
            }
        });
    }

    setupNavigation() {
        // Add active class to current page in navigation
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link, .navbar-nav a');
        
        navLinks.forEach(link => {
            if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
            }
        });
    }

    // Search and filter functionality for all pages
    setupSearchFilters() {
        const tables = document.querySelectorAll('table');
        
        tables.forEach(table => {
            // Add search functionality to each table
            const searchContainer = document.createElement('div');
            searchContainer.className = 'mb-3';
            searchContainer.innerHTML = `
                <input type="text" class="form-control table-search" placeholder="Search..." style="max-width: 300px;">
            `;
            
            table.parentNode.insertBefore(searchContainer, table);
            
            const searchInput = searchContainer.querySelector('.table-search');
            searchInput.addEventListener('input', (e) => {
                this.filterTable(table, e.target.value);
            });
        });
    }

    filterTable(table, searchTerm) {
        const rows = table.querySelectorAll('tbody tr');
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm.toLowerCase()) ? '' : 'none';
        });
    }

    // Sortable tables
    setupSortable() {
        const tables = document.querySelectorAll('table');
        
        tables.forEach(table => {
            const headers = table.querySelectorAll('th');
            
            headers.forEach((header, index) => {
                if (header.textContent.includes('Actions')) return;
                
                header.style.cursor = 'pointer';
                header.addEventListener('click', () => {
                    this.sortTable(table, index);
                });
            });
        });
    }

    sortTable(table, column) {
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        
        const currentSort = table.getAttribute('data-sort-column');
        const currentDir = table.getAttribute('data-sort-direction') || 'asc';
        const newDir = (currentSort === column.toString() && currentDir === 'asc') ? 'desc' : 'asc';
        
        rows.sort((a, b) => {
            const aValue = a.cells[column].textContent.trim();
            const bValue = b.cells[column].textContent.trim();
            
            const comparison = isNaN(aValue) ? aValue.localeCompare(bValue) : parseFloat(aValue) - parseFloat(bValue);
            return newDir === 'asc' ? comparison : -comparison;
        });
        
        tbody.innerHTML = '';
        rows.forEach(row => tbody.appendChild(row));
        
        table.setAttribute('data-sort-column', column.toString());
        table.setAttribute('data-sort-direction', newDir);
    }

    // Export functionality
    addExportButtons() {
        const tables = document.querySelectorAll('table');
        
        tables.forEach(table => {
            if (table.closest('.tab-pane')) {
                // For tabbed tables, add export button to each tab
                const tabPane = table.closest('.tab-pane');
                const exportBtn = document.createElement('button');
                exportBtn.className = 'btn btn-outline-primary btn-sm mb-3';
                exportBtn.innerHTML = '<i class="fas fa-download"></i> Export CSV';
                exportBtn.onclick = () => this.exportToCSV(table, tabPane.id);
                
                tabPane.insertBefore(exportBtn, tabPane.firstChild);
            } else {
                // For regular tables, add export button above table
                const exportBtn = document.createElement('button');
                exportBtn.className = 'btn btn-outline-primary btn-sm mb-3';
                exportBtn.innerHTML = '<i class="fas fa-download"></i> Export CSV';
                exportBtn.onclick = () => this.exportToCSV(table);
                
                table.parentNode.insertBefore(exportBtn, table);
            }
        });
    }

    exportToCSV(table, filename = 'data') {
        const rows = table.querySelectorAll('tr');
        const csvContent = Array.from(rows).map(row => {
            const cells = row.querySelectorAll('th, td');
            return Array.from(cells).map(cell => {
                if (cell.classList.contains('action-buttons')) return '';
                return `"${cell.textContent.trim().replace(/"/g, '""')}"`;
            }).join(',');
        }).join('\n');
        
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${filename}_${new Date().toISOString().split('T')[0]}.csv`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    // Real-time updates for dashboard
    setupRealTimeUpdates() {
        if (this.currentPage === 'dashboard') {
            setInterval(async () => {
                try {
                    const response = await fetch(`${this.contextPath}/admin/stats`, {
                        credentials: 'same-origin'
                    });
                    
                    if (response.ok) {
                        const stats = await response.json();
                        this.updateStatistics(stats);
                    }
                } catch (error) {
                    console.error('Error fetching stats:', error);
                }
            }, 30000);
        }
    }

    updateStatistics(stats) {
        // Update various statistics on the dashboard
        Object.keys(stats).forEach(key => {
            const element = document.querySelector(`[data-stat="${key}"]`);
            if (element) {
                element.textContent = stats[key];
            }
        });
    }
}

// Initialize the system when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.restaurantAdminSystem = new RestaurantAdminSystem();
    
    // Add global error handler
    window.addEventListener('unhandledrejection', (e) => {
        console.error('Unhandled promise rejection:', e.reason);
        if (window.restaurantAdminSystem) {
            window.restaurantAdminSystem.showNotification('An unexpected error occurred. Please try again.', 'error');
        }
    });
});
