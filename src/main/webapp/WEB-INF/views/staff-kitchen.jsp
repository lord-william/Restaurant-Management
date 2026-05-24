<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kitchen Display | Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta http-equiv="refresh" content="60"> <!-- Auto-refresh every 60 seconds to keep kitchen display updated -->
</head>
<body class="h-full">
    <div class="min-h-full">
        <!-- Navigation -->
        <nav class="bg-gray-800">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="flex h-16 items-center justify-between">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <span class="text-white text-xl font-bold">Restaurant Management</span>
                        </div>
                        <div class="hidden md:block">
                            <div class="ml-10 flex items-baseline space-x-4">
                                <a href="${pageContext.request.contextPath}/staff/dashboard" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/staff/orders" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Orders</a>
                                <a href="${pageContext.request.contextPath}/staff/kitchen" class="bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium" aria-current="page">Kitchen</a>
                            </div>
                        </div>
                    </div>
                    <div class="hidden md:block">
                        <div class="ml-4 flex items-center md:ml-6">
                            <a href="${pageContext.request.contextPath}/logout" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <header class="bg-white shadow">
            <div class="mx-auto max-w-7xl py-6 px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center">
                    <h1 class="text-3xl font-bold tracking-tight text-gray-900">Kitchen Display</h1>
                    <div class="flex space-x-2">
                        <button type="button" onclick="location.reload()" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="fas fa-sync-alt mr-2"></i> Refresh
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <main>
            <div class="mx-auto max-w-7xl py-6 sm:px-6 lg:px-8">
                <!-- Success message -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="rounded-md bg-green-50 p-4 mb-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-check-circle text-green-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-green-800">${sessionScope.success}</p>
                            </div>
                            <div class="ml-auto pl-3">
                                <div class="-mx-1.5 -my-1.5">
                                    <button type="button" onclick="this.parentElement.parentElement.parentElement.parentElement.style.display='none'" class="inline-flex rounded-md bg-green-50 p-1.5 text-green-500 hover:bg-green-100 focus:outline-none">
                                        <span class="sr-only">Dismiss</span>
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("success"); %>
                </c:if>

                <!-- Error message -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="rounded-md bg-red-50 p-4 mb-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-red-800">${sessionScope.error}</p>
                            </div>
                            <div class="ml-auto pl-3">
                                <div class="-mx-1.5 -my-1.5">
                                    <button type="button" onclick="this.parentElement.parentElement.parentElement.parentElement.style.display='none'" class="inline-flex rounded-md bg-red-50 p-1.5 text-red-500 hover:bg-red-100 focus:outline-none">
                                        <span class="sr-only">Dismiss</span>
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("error"); %>
                </c:if>

                <!-- Kitchen Display Main Section -->
                <div class="flex flex-wrap -mx-4">
                    <!-- Pending Orders Column -->
                    <div class="w-full lg:w-1/3 px-4 mb-8">
                        <div class="bg-yellow-50 rounded-lg shadow-md h-full">
                            <div class="bg-yellow-500 text-white px-4 py-2 rounded-t-lg flex justify-between items-center">
                                <h2 class="text-lg font-semibold">Pending Orders</h2>
                                <span class="bg-white text-yellow-500 rounded-full h-6 w-6 flex items-center justify-center font-bold text-sm">${fn:length(pendingOrders)}</span>
                            </div>
                            <div class="p-4 overflow-y-auto" style="max-height: 70vh;">
                                <c:choose>
                                    <c:when test="${not empty pendingOrders}">
                                        <c:forEach var="order" items="${pendingOrders}">
                                            <div class="bg-white rounded-lg shadow-sm p-4 mb-4">
                                                <div class="flex justify-between items-center mb-2">
                                                    <h3 class="font-bold">Order #${order.id}</h3>
                                                    <span class="text-sm text-gray-500">
                                                        <fmt:formatDate pattern="HH:mm" value="${order.orderTime}" />
                                                    </span>
                                                </div>
                                                <ul class="mb-3">
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <li class="text-sm flex justify-between py-1">
                                                            <span>${item.quantity} x ${item.itemName}</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                                <c:if test="${not empty order.notes}">
                                                    <p class="text-xs italic text-gray-500 mb-3">${order.notes}</p>
                                                </c:if>
                                                <div class="mt-2 flex justify-end">
                                                    <a href="${pageContext.request.contextPath}/staff/kitchen?action=updateStatus&id=${order.id}&status=preparing" class="inline-flex items-center px-3 py-1 text-xs font-medium rounded-md text-white bg-blue-500 hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                                        <i class="fas fa-utensils mr-1"></i> Start Preparing
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-6 text-gray-500">
                                            <i class="fas fa-check-circle text-3xl mb-2"></i>
                                            <p>No pending orders</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Preparing Orders Column -->
                    <div class="w-full lg:w-1/3 px-4 mb-8">
                        <div class="bg-blue-50 rounded-lg shadow-md h-full">
                            <div class="bg-blue-500 text-white px-4 py-2 rounded-t-lg flex justify-between items-center">
                                <h2 class="text-lg font-semibold">Preparing</h2>
                                <span class="bg-white text-blue-500 rounded-full h-6 w-6 flex items-center justify-center font-bold text-sm">${fn:length(preparingOrders)}</span>
                            </div>
                            <div class="p-4 overflow-y-auto" style="max-height: 70vh;">
                                <c:choose>
                                    <c:when test="${not empty preparingOrders}">
                                        <c:forEach var="order" items="${preparingOrders}">
                                            <div class="bg-white rounded-lg shadow-sm p-4 mb-4">
                                                <div class="flex justify-between items-center mb-2">
                                                    <h3 class="font-bold">Order #${order.id}</h3>
                                                    <span class="text-sm text-gray-500">
                                                        <fmt:formatDate pattern="HH:mm" value="${order.orderTime}" />
                                                    </span>
                                                </div>
                                                <ul class="mb-3">
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <li class="text-sm flex justify-between py-1">
                                                            <span>${item.quantity} x ${item.itemName}</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                                <c:if test="${not empty order.notes}">
                                                    <p class="text-xs italic text-gray-500 mb-3">${order.notes}</p>
                                                </c:if>
                                                <div class="mt-2 flex justify-end">
                                                    <a href="${pageContext.request.contextPath}/staff/kitchen?action=updateStatus&id=${order.id}&status=ready" class="inline-flex items-center px-3 py-1 text-xs font-medium rounded-md text-white bg-green-500 hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                        <i class="fas fa-check mr-1"></i> Mark Ready
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-6 text-gray-500">
                                            <i class="fas fa-utensils text-3xl mb-2"></i>
                                            <p>No orders being prepared</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Ready Orders Column -->
                    <div class="w-full lg:w-1/3 px-4 mb-8">
                        <div class="bg-green-50 rounded-lg shadow-md h-full">
                            <div class="bg-green-500 text-white px-4 py-2 rounded-t-lg flex justify-between items-center">
                                <h2 class="text-lg font-semibold">Ready for Delivery</h2>
                                <span class="bg-white text-green-500 rounded-full h-6 w-6 flex items-center justify-center font-bold text-sm">${fn:length(readyOrders)}</span>
                            </div>
                            <div class="p-4 overflow-y-auto" style="max-height: 70vh;">
                                <c:choose>
                                    <c:when test="${not empty readyOrders}">
                                        <c:forEach var="order" items="${readyOrders}">
                                            <div class="bg-white rounded-lg shadow-sm p-4 mb-4">
                                                <div class="flex justify-between items-center mb-2">
                                                    <h3 class="font-bold">Order #${order.id}</h3>
                                                    <span class="text-sm text-gray-500">
                                                        <fmt:formatDate pattern="HH:mm" value="${order.orderTime}" />
                                                    </span>
                                                </div>
                                                <ul class="mb-3">
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <li class="text-sm flex justify-between py-1">
                                                            <span>${item.quantity} x ${item.itemName}</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                                <c:if test="${not empty order.notes}">
                                                    <p class="text-xs italic text-gray-500 mb-3">${order.notes}</p>
                                                </c:if>
                                                <div class="mt-2 flex justify-end">
                                                    <a href="${pageContext.request.contextPath}/staff/kitchen?action=updateStatus&id=${order.id}&status=delivered" class="inline-flex items-center px-3 py-1 text-xs font-medium rounded-md text-white bg-purple-500 hover:bg-purple-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                                                        <i class="fas fa-truck mr-1"></i> Mark Delivered
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-6 text-gray-500">
                                            <i class="fas fa-bell-slash text-3xl mb-2"></i>
                                            <p>No orders ready for delivery</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Auto-close alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.bg-green-50, .bg-red-50');
            alerts.forEach(function(alert) {
                alert.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>
