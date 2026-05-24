<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Orders | Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
                                <a href="${pageContext.request.contextPath}/staff/orders" class="bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium" aria-current="page">Orders</a>
                                <a href="${pageContext.request.contextPath}/staff/kitchen" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Kitchen</a>
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
                    <h1 class="text-3xl font-bold tracking-tight text-gray-900">Orders Management</h1>
                    <div class="flex space-x-2">
                        <button type="button" onclick="location.href='${pageContext.request.contextPath}/staff/orders?filter=pending'" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-yellow-500 hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                            <i class="fas fa-clock mr-2"></i> Pending
                        </button>
                        <button type="button" onclick="location.href='${pageContext.request.contextPath}/staff/orders?filter=preparing'" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-500 hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                            <i class="fas fa-utensils mr-2"></i> Preparing
                        </button>
                        <button type="button" onclick="location.href='${pageContext.request.contextPath}/staff/orders?filter=ready'" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-green-500 hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                            <i class="fas fa-check mr-2"></i> Ready
                        </button>
                        <button type="button" onclick="location.href='${pageContext.request.contextPath}/staff/orders?filter=all'" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="fas fa-list mr-2"></i> All Orders
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

                <!-- Current Filter Display -->
                <div class="bg-white shadow px-4 py-5 sm:px-6 mb-6 rounded-lg">
                    <h3 class="text-lg font-medium leading-6 text-gray-900">
                        <c:choose>
                            <c:when test="${param.filter eq 'pending'}">Pending Orders</c:when>
                            <c:when test="${param.filter eq 'preparing'}">Orders Being Prepared</c:when>
                            <c:when test="${param.filter eq 'ready'}">Orders Ready for Delivery</c:when>
                            <c:when test="${param.filter eq 'delivered'}">Delivered Orders</c:when>
                            <c:otherwise>All Orders</c:otherwise>
                        </c:choose>
                    </h3>
                </div>

                <!-- Orders Table -->
                <div class="flex flex-col">
                    <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
                        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                            <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Order ID
                                            </th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Customer
                                            </th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Order Time
                                            </th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Amount
                                            </th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Status
                                            </th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Actions
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="order" items="${orders}">
                                            <tr>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                    #${order.id}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    ${order.userName}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <fmt:formatDate pattern="dd MMM yyyy HH:mm" value="${order.orderTime}" />
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    R ${order.total}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${order.status eq 'pending'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                                Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status eq 'preparing'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                                Preparing
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status eq 'ready'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                                Ready
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status eq 'delivered'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                                Delivered
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                                ${order.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex space-x-2">
                                                        <a href="#" onclick="showOrderDetails(${order.id})" class="text-indigo-600 hover:text-indigo-900">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                        
                                                        <c:if test="${order.status eq 'pending'}">
                                                            <a href="${pageContext.request.contextPath}/staff/orders?action=updateStatus&id=${order.id}&status=preparing" class="text-blue-600 hover:text-blue-900">
                                                                <i class="fas fa-utensils"></i> Prepare
                                                            </a>
                                                        </c:if>
                                                        
                                                        <c:if test="${order.status eq 'preparing'}">
                                                            <a href="${pageContext.request.contextPath}/staff/orders?action=updateStatus&id=${order.id}&status=ready" class="text-green-600 hover:text-green-900">
                                                                <i class="fas fa-check"></i> Mark Ready
                                                            </a>
                                                        </c:if>
                                                        
                                                        <c:if test="${order.status eq 'ready'}">
                                                            <a href="${pageContext.request.contextPath}/staff/orders?action=updateStatus&id=${order.id}&status=delivered" class="text-purple-600 hover:text-purple-900">
                                                                <i class="fas fa-truck"></i> Deliver
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty orders}">
                                            <tr>
                                                <td colspan="6" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                    No orders found with this status.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Details Modal -->
                <div id="orderDetailsModal" class="hidden fixed z-10 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
                    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                        <div id="orderModalContent" class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                            <!-- Content will be loaded here via AJAX -->
                            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <div class="sm:flex sm:items-start">
                                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                                            Order Details
                                        </h3>
                                        <div class="mt-2">
                                            <div id="orderDetails">
                                                <p class="text-sm text-gray-500">Loading order details...</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                                <button type="button" onclick="closeOrderDetailsModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                                    Close
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Show Order Details Modal
        function showOrderDetails(orderId) {
            const modal = document.getElementById('orderDetailsModal');
            const orderDetails = document.getElementById('orderDetails');
            
            // In a real app, you would fetch order details via AJAX
            // For now, we'll just display a placeholder with the order ID
            orderDetails.innerHTML = `
                <div class="animate-pulse">
                    <div class="space-y-4">
                        <div class="h-4 bg-gray-200 rounded w-3/4"></div>
                        <div class="h-4 bg-gray-200 rounded"></div>
                        <div class="h-4 bg-gray-200 rounded"></div>
                        <div class="h-4 bg-gray-200 rounded w-5/6"></div>
                    </div>
                </div>
            `;
            
            // Show the modal
            modal.classList.remove('hidden');
            
            // Simulate loading order details (in a real app, this would be an AJAX call)
            setTimeout(() => {
                // Fetch order details from server (simulated)
                orderDetails.innerHTML = `
                    <div class="border-b border-gray-200 py-2">
                        <p class="text-sm font-medium text-gray-900">Order #${orderId}</p>
                    </div>
                    <div class="border-b border-gray-200 py-2">
                        <p class="text-sm text-gray-500 font-bold">Items:</p>
                        <ul class="mt-1 space-y-1">
                            <li class="text-sm text-gray-500 flex justify-between">
                                <span>1 x Burger</span>
                                <span>R 50.00</span>
                            </li>
                            <li class="text-sm text-gray-500 flex justify-between">
                                <span>2 x Fries</span>
                                <span>R 30.00</span>
                            </li>
                            <li class="text-sm text-gray-500 flex justify-between">
                                <span>1 x Soda</span>
                                <span>R 15.00</span>
                            </li>
                        </ul>
                    </div>
                    <div class="border-b border-gray-200 py-2">
                        <p class="text-sm text-gray-500 flex justify-between font-bold">
                            <span>Total:</span>
                            <span>R 95.00</span>
                        </p>
                    </div>
                    <div class="py-2">
                        <p class="text-sm text-gray-500"><span class="font-bold">Notes:</span> No onions, extra ketchup.</p>
                    </div>
                `;
            }, 1000);
        }
        
        function closeOrderDetailsModal() {
            document.getElementById('orderDetailsModal').classList.add('hidden');
        }
        
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
