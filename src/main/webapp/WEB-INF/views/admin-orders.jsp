<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Management | Restaurant</title>
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
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Users</a>
                                <a href="${pageContext.request.contextPath}/admin/menu" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Menu</a>
                                <a href="${pageContext.request.contextPath}/admin/orders" class="bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium" aria-current="page">Orders</a>
                                <a href="${pageContext.request.contextPath}/admin/revenue" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Revenue</a>
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
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=pending" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-yellow-500 hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                            Pending (${pendingCount})
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=preparing" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-500 hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                            Preparing (${preparingCount})
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=ready" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-green-500 hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                            Ready (${readyCount})
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=delivered" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-purple-500 hover:bg-purple-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                            Delivered (${deliveredCount})
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=all" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            All Orders
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <main>
            <div class="mx-auto max-w-7xl py-6 sm:px-6 lg:px-8">
                <!-- Success/Error messages -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="rounded-md bg-green-50 p-4 mb-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-check-circle text-green-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-green-800">${sessionScope.success}</p>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("success"); %>
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div class="rounded-md bg-red-50 p-4 mb-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-red-800">${sessionScope.error}</p>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("error"); %>
                </c:if>

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
                                                Total
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
                                                    R <fmt:formatNumber value="${order.total}" pattern="0.00"/>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${order.statusString eq 'pending'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                                Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusString eq 'preparing'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                                Preparing
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusString eq 'ready'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                                Ready
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusString eq 'delivered'}">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">
                                                                Delivered
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                                ${order.statusString}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <a href="#" onclick="viewOrder(${order.id})" class="text-indigo-600 hover:text-indigo-900 mr-3">View</a>
                                                    <div class="dropdown inline-block relative">
                                                        <button class="text-gray-500 hover:text-gray-700 font-semibold inline-flex items-center">
                                                            <span>Update</span>
                                                            <svg class="fill-current h-4 w-4 ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/> </svg>
                                                        </button>
                                                        <ul class="dropdown-menu absolute hidden text-gray-700 pt-1 right-0 w-40 mt-1 bg-white rounded shadow z-10">
                                                            <li><a class="rounded-t hover:bg-gray-100 py-2 px-4 block whitespace-no-wrap" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=pending&filter=${currentFilter}">Mark as Pending</a></li>
                                                            <li><a class="hover:bg-gray-100 py-2 px-4 block whitespace-no-wrap" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=preparing&filter=${currentFilter}">Mark as Preparing</a></li>
                                                            <li><a class="hover:bg-gray-100 py-2 px-4 block whitespace-no-wrap" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=ready&filter=${currentFilter}">Mark as Ready</a></li>
                                                            <li><a class="rounded-b hover:bg-gray-100 py-2 px-4 block whitespace-no-wrap" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=delivered&filter=${currentFilter}">Mark as Delivered</a></li>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty orders}">
                                            <tr>
                                                <td colspan="6" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                    No orders found matching your criteria.
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
                <div id="orderDetailsModal" class="hidden fixed z-10 inset-0 overflow-y-auto">
                    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                        </div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <div class="sm:flex sm:items-start">
                                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                                            Order Details
                                        </h3>
                                        <div class="mt-2">
                                            <div id="orderDetailsContent">
                                                <!-- Order details will be loaded here via JavaScript -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                                <button type="button" onclick="closeModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
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
        // Show/hide dropdowns
        document.addEventListener('click', function(e) {
            const dropdowns = document.querySelectorAll('.dropdown');
            dropdowns.forEach(dropdown => {
                if (!dropdown.contains(e.target)) {
                    dropdown.querySelector('.dropdown-menu').classList.add('hidden');
                }
            });
            
            if (e.target.closest('.dropdown')) {
                const dropdown = e.target.closest('.dropdown');
                dropdown.querySelector('.dropdown-menu').classList.toggle('hidden');
            }
        });
        
        // View Order Details
        function viewOrder(orderId) {
            const modal = document.getElementById('orderDetailsModal');
            const content = document.getElementById('orderDetailsContent');
            
            // In a real application, you would fetch order details from the server
            // using AJAX. For this example, we'll just simulate it.
            content.innerHTML = `
                <p class="text-sm text-gray-500 mb-4">Loading order details...</p>
            `;
            
            modal.classList.remove('hidden');
            
            // Simulate loading order details
            setTimeout(() => {
                content.innerHTML = `
                    <div class="border-b border-gray-200 pb-4 mb-4">
                        <div class="flex justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-900">Order #` + orderId + `</p>
                                <p class="text-sm text-gray-500">May 9, 2025 at 14:35</p>
                            </div>
                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                Ready
                            </span>
                        </div>
                    </div>
                    
                    <div class="border-b border-gray-200 pb-4 mb-4">
                        <h4 class="text-sm font-medium text-gray-900 mb-2">Customer Information</h4>
                        <p class="text-sm text-gray-500">John Doe</p>
                        <p class="text-sm text-gray-500">john.doe@example.com</p>
                        <p class="text-sm text-gray-500">Student ID: ST12345</p>
                    </div>
                    
                    <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-900 mb-2">Order Items</h4>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <p class="text-sm text-gray-500">1 × Burger</p>
                                <p class="text-sm text-gray-500">R 55.00</p>
                            </div>
                            <div class="flex justify-between">
                                <p class="text-sm text-gray-500">2 × Fries</p>
                                <p class="text-sm text-gray-500">R 30.00</p>
                            </div>
                            <div class="flex justify-between">
                                <p class="text-sm text-gray-500">1 × Soft Drink</p>
                                <p class="text-sm text-gray-500">R 15.00</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="border-t border-gray-200 pt-4">
                        <div class="flex justify-between font-medium">
                            <p class="text-sm text-gray-900">Total</p>
                            <p class="text-sm text-gray-900">R 100.00</p>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        function closeModal() {
            document.getElementById('orderDetailsModal').classList.add('hidden');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('orderDetailsModal');
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Auto close alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.bg-green-50, .bg-red-50');
            alerts.forEach(alert => {
                alert.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>