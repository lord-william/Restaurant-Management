<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="60">
    <title>Staff Dashboard - Restaurant Management System</title>
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
                            <h1 class="text-2xl font-bold text-gray-900">Staff Dashboard</h1>
                            <p class="mt-2 text-sm text-gray-500">Manage orders, inventory, and kitchen operations.</p>
                        </div>
                        <div class="mt-3 sm:mt-0 flex gap-3">
                            <a href="${pageContext.request.contextPath}/staff/orders" class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">
                                <i class="fas fa-list-alt mr-2"></i> All Orders
                            </a>
                            <a href="${pageContext.request.contextPath}/staff/kitchen" class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                                <i class="fas fa-utensils mr-2"></i> Kitchen Display
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-4 mb-8">
                <!-- Orders Pending -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                                <i class="fas fa-hourglass-half text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Orders Pending</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${pendingOrderCount}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/staff/orders?status=pending" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View pending orders
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Orders In Progress -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
                                <i class="fas fa-tasks text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Preparing</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${preparingOrderCount}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/staff/orders?status=processing" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View in-progress orders
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Orders Ready -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                                <i class="fas fa-check-circle text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Ready for Pickup</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${readyOrderCount}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/staff/orders?status=ready" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View ready orders
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Inventory Alerts -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-red-500 rounded-md p-3">
                                <i class="fas fa-exclamation-triangle text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Inventory Alerts</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${lowInventoryCount}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/staff/inventory/alerts" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View inventory alerts
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Orders Sections -->
            <div class="grid grid-cols-1 gap-4 lg:grid-cols-2">
                <!-- New Orders -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">New Orders</h3>
                        <p class="mt-1 text-sm text-gray-500">Orders that need to be processed.</p>
                    </div>
                    <div>
                        <ul class="divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty pendingOrders}">
                                    <c:forEach items="${pendingOrders}" var="order">
                                        <li class="px-4 py-4 sm:px-6">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-12 w-12 rounded-md bg-yellow-100 flex items-center justify-center">
                                                        <i class="fas fa-receipt text-yellow-600"></i>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">Order #${order.id}</div>
                                                        <div class="text-sm text-gray-500">Table ${order.tableNumber} - ${order.orderItems.size()} items - ${order.orderDate}</div>
                                                        <div class="text-xs text-gray-400">${order.orderItems}</div>
                                                    </div>
                                                </div>
                                                <div class="flex space-x-2">
                                                    <button type="button" class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-sm font-semibold text-green-700 shadow-sm hover:bg-green-100">
                                                        <i class="fas fa-check mr-1"></i> Accept
                                                    </button>
                                                    <button type="button" class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-sm font-semibold text-red-700 shadow-sm hover:bg-red-100">
                                                        <i class="fas fa-times mr-1"></i> Reject
                                                    </button>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="px-4 py-4 sm:px-6">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-12 w-12 rounded-md bg-yellow-100 flex items-center justify-center">
                                                    <i class="fas fa-receipt text-yellow-600"></i>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">No new orders</div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                        <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                            <div class="text-sm">
                                <a href="${pageContext.request.contextPath}/staff/orders?status=new" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    View all new orders
                                    <span aria-hidden="true">&rarr;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- In Progress Orders -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">In Progress</h3>
                        <p class="mt-1 text-sm text-gray-500">Orders currently being prepared.</p>
                    </div>
                    <div>
                        <ul class="divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty preparingOrders}">
                                    <c:forEach items="${preparingOrders}" var="order">
                                        <li class="px-4 py-4 sm:px-6">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-12 w-12 rounded-md bg-blue-100 flex items-center justify-center">
                                                        <i class="fas fa-fire text-blue-600"></i>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">Order #${order.id}</div>
                                                        <div class="text-sm text-gray-500">Table ${order.tableNumber} - ${order.orderItems.size()} items - ${order.orderDate}</div>
                                                        <div class="text-xs text-gray-400">${order.orderItems}</div>
                                                    </div>
                                                </div>
                                                <div>
                                                    <span class="inline-flex items-center rounded-md bg-blue-50 px-2 py-1 text-sm font-semibold text-blue-700">
                                                        <i class="fas fa-clock mr-1"></i> ${order.preparationTime}
                                                    </span>
                                                    <button type="button" class="ml-2 inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-sm font-semibold text-green-700 shadow-sm hover:bg-green-100">
                                                        <i class="fas fa-check-double mr-1"></i> Mark Ready
                                                    </button>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="px-4 py-4 sm:px-6">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-12 w-12 rounded-md bg-blue-100 flex items-center justify-center">
                                                    <i class="fas fa-fire text-blue-600"></i>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">No orders in preparation</div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                                        <button type="button" class="ml-2 inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-sm font-semibold text-green-700 shadow-sm hover:bg-green-100">
                                            <i class="fas fa-check-double mr-1"></i> Mark Ready
                                        </button>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                            <div class="text-sm">
                                <a href="${pageContext.request.contextPath}/staff/orders?status=processing" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    View all in-progress orders
                                    <span aria-hidden="true">&rarr;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Inventory Section -->
            <div class="mt-8 bg-white shadow rounded-lg">
                <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                    <h3 class="text-lg font-medium leading-6 text-gray-900">Inventory Alerts</h3>
                    <p class="mt-1 text-sm text-gray-500">Items that are low in stock or need attention.</p>
                </div>
                <div class="overflow-hidden">
                    <div class="relative overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">Item Name</th>
                                    <th scope="col" class="px-6 py-3">Current Stock</th>
                                    <th scope="col" class="px-6 py-3">Min. Required</th>
                                    <th scope="col" class="px-6 py-3">Status</th>
                                    <th scope="col" class="px-6 py-3">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white border-b">
                                    <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">Chicken (kg)</td>
                                    <td class="px-6 py-4">2.5</td>
                                    <td class="px-6 py-4">10</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-xs font-medium text-red-700">
                                            Critical
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <a href="${pageContext.request.contextPath}/staff/inventory/order" class="font-medium text-indigo-600 hover:underline">Order</a>
                                    </td>
                                </tr>
                                <tr class="bg-white border-b">
                                    <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">Rice (kg)</td>
                                    <td class="px-6 py-4">8</td>
                                    <td class="px-6 py-4">15</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-700">
                                            Low
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <a href="${pageContext.request.contextPath}/staff/inventory/order" class="font-medium text-indigo-600 hover:underline">Order</a>
                                    </td>
                                </tr>
                                <tr class="bg-white border-b">
                                    <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">Cooking Oil (L)</td>
                                    <td class="px-6 py-4">4</td>
                                    <td class="px-6 py-4">10</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-700">
                                            Low
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <a href="${pageContext.request.contextPath}/staff/inventory/order" class="font-medium text-indigo-600 hover:underline">Order</a>
                                    </td>
                                </tr>
                                <tr class="bg-white border-b">
                                    <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">Onions (kg)</td>
                                    <td class="px-6 py-4">3</td>
                                    <td class="px-6 py-4">5</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-700">
                                            Low
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <a href="${pageContext.request.contextPath}/staff/inventory/order" class="font-medium text-indigo-600 hover:underline">Order</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                    <div class="text-sm">
                        <a href="${pageContext.request.contextPath}/staff/inventory" class="font-medium text-indigo-600 hover:text-indigo-500">
                            View full inventory
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
</body>
</html>
