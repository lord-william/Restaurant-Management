<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="60">
    <title>Admin Dashboard - Restaurant Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Icons from heroicons.com -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="h-full">
    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />
    
    <main class="py-10">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <!-- Welcome Banner -->
            <div class="bg-white shadow rounded-lg mb-8 overflow-hidden">
                <div class="px-4 py-5 sm:p-6">
                    <div class="sm:flex sm:items-center sm:justify-between">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
                            <p class="mt-2 text-sm text-gray-500">Manage users, menu items, and restaurant operations.</p>
                        </div>
                        <div class="mt-3 sm:mt-0 flex gap-3">
                            <a href="${pageContext.request.contextPath}/admin/menu" class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">
                                <i class="fas fa-utensils mr-2"></i> Manage Menu
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/users" class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                                <i class="fas fa-users mr-2"></i> Manage Users
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-4 mb-8">
                <!-- Total Users -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
                                <i class="fas fa-users text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Total Users</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${totalUsers}</div>
                                        <div class="ml-2 text-sm">
                                            <span class="font-medium text-indigo-600">${studentCount}</span>
                                            <span class="text-gray-500">students</span>
                                            <span class="font-medium text-blue-600 ml-2">${staffCount}</span>
                                            <span class="text-gray-500">staff</span>
                                        </div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/admin/users" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View all users
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Orders Today -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                                <i class="fas fa-shopping-cart text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Orders Today</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${dailyOrders}</div>
                                        <c:if test="${dailyOrders > 0}">
                                        <div class="ml-2 text-sm text-green-600">
                                            <span class="font-medium">Today</span>
                                        </div>
                                        </c:if>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/admin/orders" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View all orders
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Revenue Today -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                                <i class="fas fa-dollar-sign text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Revenue Today</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">R ${dailyRevenue}</div>
                                        <div class="ml-2">
                                            <span class="text-sm text-gray-500">Daily</span>
                                        </div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/admin/revenue" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View revenue details
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Pending Approvals -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-red-500 rounded-md p-3">
                                <i class="fas fa-user-clock text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Pending Approvals</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${pendingCount}</div>
                                        <c:if test="${pendingCount > 0}">
                                        <div class="ml-2">
                                            <span class="text-sm text-yellow-600 font-medium">New</span>
                                        </div>
                                        </c:if>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/admin/approvals" class="font-medium text-indigo-600 hover:text-indigo-500">
                                Approve users
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- User Management and System Section -->
            <div class="grid grid-cols-1 gap-4 lg:grid-cols-2">
                <!-- Pending User Approvals -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">Pending User Approvals</h3>
                        <p class="mt-1 text-sm text-gray-500">New users awaiting account approval.</p>
                    </div>
                    <div>
                        <ul class="divide-y divide-gray-200">
                            <c:forEach items="${pendingUsers}" var="user">
                            <li class="px-4 py-4 sm:px-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center">
                                            <span class="text-sm font-medium leading-none text-gray-900">${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}</span>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">${user.firstName} ${user.lastName}</div>
                                            <div class="text-sm text-gray-500">${user.email}</div>
                                        </div>
                                    </div>
                                    <div class="flex space-x-2">
                                        <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-sm font-semibold text-green-700 shadow-sm hover:bg-green-100">
                                            <i class="fas fa-check mr-1"></i> Approve
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-sm font-semibold text-red-700 shadow-sm hover:bg-red-100">
                                            <i class="fas fa-times mr-1"></i> Reject
                                        </a>
                                    </div>
                                </div>
                            </li>
                            </c:forEach>
                            <c:if test="${empty pendingUsers}">
                            <li class="px-4 py-4 sm:px-6 text-center text-gray-500">No pending approvals</li>
                            </c:if>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">Robert Johnson</div>
                                            <div class="text-sm text-gray-500">robert.j@example.com</div>
                                            <div class="text-xs text-gray-400">Student #: 456123789</div>
                                        </div>
                                    </div>
                                    <div class="flex space-x-2">
                                        <button type="button" class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-sm font-semibold text-green-700 shadow-sm hover:bg-green-100">
                                            <i class="fas fa-check mr-1"></i> Approve
                                        </button>
                                        <button type="button" class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-sm font-semibold text-red-700 shadow-sm hover:bg-red-100">
                                            <i class="fas fa-times mr-1"></i> Reject
                                        </button>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                            <div class="text-sm">
                                <a href="${pageContext.request.contextPath}/admin/approvals" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    View all pending approvals
                                    <span aria-hidden="true">&rarr;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- System Status -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">System Status</h3>
                        <p class="mt-1 text-sm text-gray-500">Current status of restaurant systems.</p>
                    </div>
                    <div class="px-4 py-5 sm:p-6">
                        <div class="space-y-6">
                            <div>
                                <div class="flex justify-between items-center mb-1">
                                    <div class="text-sm font-medium text-gray-700">Database</div>
                                    <div class="flex items-center">
                                        <div class="h-2.5 w-2.5 rounded-full bg-green-500 mr-2"></div>
                                        <span class="text-sm text-gray-500">Online</span>
                                    </div>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-green-500 h-2 rounded-full" style="width: 25%"></div>
                                </div>
                                <div class="text-xs text-gray-500 mt-1">25% capacity used</div>
                            </div>
                            
                            <div>
                                <div class="flex justify-between items-center mb-1">
                                    <div class="text-sm font-medium text-gray-700">Order Processing</div>
                                    <div class="flex items-center">
                                        <div class="h-2.5 w-2.5 rounded-full bg-green-500 mr-2"></div>
                                        <span class="text-sm text-gray-500">Online</span>
                                    </div>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-green-500 h-2 rounded-full" style="width: 15%"></div>
                                </div>
                                <div class="text-xs text-gray-500 mt-1">15% capacity used</div>
                            </div>
                            
                            <div>
                                <div class="flex justify-between items-center mb-1">
                                    <div class="text-sm font-medium text-gray-700">Payment Gateway</div>
                                    <div class="flex items-center">
                                        <div class="h-2.5 w-2.5 rounded-full bg-green-500 mr-2"></div>
                                        <span class="text-sm text-gray-500">Online</span>
                                    </div>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-green-500 h-2 rounded-full" style="width: 10%"></div>
                                </div>
                                <div class="text-xs text-gray-500 mt-1">10% capacity used</div>
                            </div>
                            
                            <div>
                                <div class="flex justify-between items-center mb-1">
                                    <div class="text-sm font-medium text-gray-700">Kitchen Display System</div>
                                    <div class="flex items-center">
                                        <div class="h-2.5 w-2.5 rounded-full bg-green-500 mr-2"></div>
                                        <span class="text-sm text-gray-500">Online</span>
                                    </div>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-green-500 h-2 rounded-full" style="width: 45%"></div>
                                </div>
                                <div class="text-xs text-gray-500 mt-1">45% capacity used</div>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/admin/system" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View full system status
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Recent Activity Section -->
            <div class="mt-8 bg-white shadow rounded-lg">
                <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                    <h3 class="text-lg font-medium leading-6 text-gray-900">Recent Activity</h3>
                    <p class="mt-1 text-sm text-gray-500">Recent system activity and actions.</p>
                </div>
                <div class="overflow-hidden">
                    <div class="relative overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">Time</th>
                                    <th scope="col" class="px-6 py-3">User</th>
                                    <th scope="col" class="px-6 py-3">Action</th>
                                    <th scope="col" class="px-6 py-3">Details</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Today</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${dailyOrders}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">R ${dailyRevenue}</td>
                                </tr>
                                <tr class="bg-white">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">This Month</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${totalOrders}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">R ${monthlyRevenue}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="px-4 py-4 sm:px-6 rounded-b-lg">
                    <div class="text-sm">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="font-medium text-indigo-600 hover:text-indigo-500">
                            View all orders
                            <span aria-hidden="true">&rarr;</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="bg-white mt-12">
        <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
            <div class="border-t border-gray-200 pt-8">
                <p class="text-base text-gray-400 text-center">&copy; 2025 Restaurant Management System. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/multi_dashboard.js"></script>
    
    <!-- Initialize the dashboard application -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Initialize the restaurant admin system
            const adminSystem = new RestaurantAdminSystem();
            console.log("Admin dashboard initialized");
        });
    </script>
</body>
</html>
