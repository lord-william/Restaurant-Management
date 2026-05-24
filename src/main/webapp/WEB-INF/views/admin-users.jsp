<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Restaurant Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="h-full">
    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />
    
    <main class="py-10">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <!-- Page Header -->
            <div class="bg-white shadow rounded-lg mb-8 overflow-hidden">
                <div class="px-4 py-5 sm:p-6">
                    <div class="sm:flex sm:items-center sm:justify-between">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-900">User Management</h1>
                            <p class="mt-2 text-sm text-gray-500">Add, edit, and manage user accounts and permissions.</p>
                        </div>
                        <div class="mt-3 sm:mt-0">
                            <button id="addUserBtn" type="button" class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                                <i class="fas fa-user-plus mr-2"></i> Add New User
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Display Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="rounded-md bg-green-50 p-4 mb-6">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i class="fas fa-check-circle text-green-400"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium text-green-800">${sessionScope.success}</p>
                        </div>
                        <div class="ml-auto pl-3">
                            <div class="-mx-1.5 -my-1.5">
                                <button type="button" class="close-alert inline-flex rounded-md bg-green-50 p-1.5 text-green-500 hover:bg-green-100">
                                    <span class="sr-only">Dismiss</span>
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% session.removeAttribute("success"); %>
            </c:if>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="rounded-md bg-red-50 p-4 mb-6">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i class="fas fa-exclamation-circle text-red-400"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium text-red-800">${sessionScope.error}</p>
                        </div>
                        <div class="ml-auto pl-3">
                            <div class="-mx-1.5 -my-1.5">
                                <button type="button" class="close-alert inline-flex rounded-md bg-red-50 p-1.5 text-red-500 hover:bg-red-100">
                                    <span class="sr-only">Dismiss</span>
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% session.removeAttribute("error"); %>
            </c:if>
            
            <!-- New User Modal -->
            <div id="addUserModal" class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center hidden z-50">
                <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-medium text-gray-900">Add New User</h3>
                        <button id="closeAddUserModal" class="text-gray-400 hover:text-gray-500">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/users" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-4">
                            <label for="firstName" class="block text-sm font-medium text-gray-700">First Name</label>
                            <input type="text" name="firstName" id="firstName" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm p-2 border">
                        </div>
                        <div class="mb-4">
                            <label for="lastName" class="block text-sm font-medium text-gray-700">Last Name</label>
                            <input type="text" name="lastName" id="lastName" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm p-2 border">
                        </div>
                        <div class="mb-4">
                            <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                            <input type="email" name="email" id="email" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm p-2 border">
                        </div>
                        <div class="mb-4">
                            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                            <input type="password" name="password" id="password" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm p-2 border">
                        </div>
                        <div class="mb-4">
                            <label for="role" class="block text-sm font-medium text-gray-700">Role</label>
                            <select name="role" id="role" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm p-2 border">
                                <option value="customer">Customer</option>
                                <option value="staff">Staff</option>
                                <c:if test="${currentUserId == 1}">
                                    <option value="admin">Administrator</option>
                                </c:if>
                            </select>
                        </div>
                        <div class="mt-5 sm:mt-6">
                            <button type="submit" class="inline-flex justify-center w-full rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                                Add User
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- User Categories -->
            <div class="grid grid-cols-1 gap-8">
                <!-- Pending Approval Users -->
                <c:if test="${not empty pendingUsers}">
                    <div class="bg-white shadow rounded-lg overflow-hidden">
                        <div class="px-4 py-5 sm:px-6 bg-yellow-50">
                            <h2 class="text-lg font-medium leading-6 text-yellow-800">Pending Approval</h2>
                            <p class="mt-1 text-sm text-yellow-600">Users waiting for account approval</p>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="user" items="${pendingUsers}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">${user.firstName} ${user.lastName}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-500">${user.email}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                    ${user.role}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="text-indigo-600 hover:text-indigo-900 mr-3">Approve</a>
                                                <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="text-red-600 hover:text-red-900 user-delete" data-id="${user.id}" data-name="${user.firstName} ${user.lastName}">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>
                
                <!-- All Approved Users -->
                <div class="bg-white shadow rounded-lg overflow-hidden">
                    <div class="px-4 py-5 sm:px-6 bg-gray-50">
                        <h2 class="text-lg font-medium leading-6 text-gray-900">All Users</h2>
                        <p class="mt-1 text-sm text-gray-500">Manage all active user accounts</p>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.status == 'true'}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">${user.firstName} ${user.lastName}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-500">${user.email}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${user.role == 'admin'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                            Administrator
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'staff'}">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                            Staff
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                            Customer
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    Active
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <c:if test="${user.id != currentUserId}">
                                                    <c:if test="${user.role == 'customer' || (user.role == 'staff' && currentUserId == 1)}">
                                                        <a href="${pageContext.request.contextPath}/admin/user?action=promote&id=${user.id}" class="text-indigo-600 hover:text-indigo-900 mr-3">Promote</a>
                                                    </c:if>
                                                    <c:if test="${user.id != 1 && (user.role != 'admin' || currentUserId == 1)}">
                                                        <a href="#" class="text-red-600 hover:text-red-900 user-delete" data-id="${user.id}" data-name="${user.firstName} ${user.lastName}">Delete</a>
                                                    </c:if>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center hidden z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
            <div class="mb-4">
                <h3 class="text-lg font-medium text-gray-900">Confirm Deletion</h3>
                <p class="text-sm text-gray-500 mt-2">Are you sure you want to delete user <span id="deleteUserName" class="font-medium"></span>? This action cannot be undone.</p>
            </div>
            <div class="mt-5 sm:mt-6 flex gap-3">
                <button id="cancelDelete" class="inline-flex justify-center w-full rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    Cancel
                </button>
                <a id="confirmDelete" href="#" class="inline-flex justify-center w-full rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:text-sm">
                    Delete
                </a>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="bg-white mt-12">
        <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
            <div class="border-t border-gray-200 pt-8">
                <p class="text-base text-gray-400 text-center">&copy; 2025 Restaurant Management System. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <script>
        // Add User Modal
        const addUserBtn = document.getElementById('addUserBtn');
        const addUserModal = document.getElementById('addUserModal');
        const closeAddUserModal = document.getElementById('closeAddUserModal');
        
        if (addUserBtn && addUserModal && closeAddUserModal) {
            addUserBtn.addEventListener('click', () => {
                addUserModal.classList.remove('hidden');
            });
            
            closeAddUserModal.addEventListener('click', () => {
                addUserModal.classList.add('hidden');
            });
        }
        
        // Delete User Modal
        const deleteLinks = document.querySelectorAll('.user-delete');
        const deleteModal = document.getElementById('deleteModal');
        const deleteUserName = document.getElementById('deleteUserName');
        const confirmDelete = document.getElementById('confirmDelete');
        const cancelDelete = document.getElementById('cancelDelete');
        
        if (deleteLinks && deleteModal && deleteUserName && confirmDelete && cancelDelete) {
            deleteLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const userId = link.getAttribute('data-id');
                    const name = link.getAttribute('data-name');
                    deleteUserName.textContent = name;
                    confirmDelete.href = '${pageContext.request.contextPath}/admin/user?action=delete&id=' + userId;
                    deleteModal.classList.remove('hidden');
                });
            });
            
            cancelDelete.addEventListener('click', () => {
                deleteModal.classList.add('hidden');
            });
        }
        
        // Close alerts
        document.querySelectorAll('.close-alert').forEach(button => {
            button.addEventListener('click', () => {
                button.closest('div.rounded-md').remove();
            });
        });
    </script>
</body>
</html>
