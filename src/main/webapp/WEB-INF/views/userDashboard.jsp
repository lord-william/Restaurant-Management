<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Restaurant Management System</title>
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
                            <h1 class="text-2xl font-bold text-gray-900">Welcome back, ${sessionScope.user.name}</h1>
                            <p class="mt-2 text-sm text-gray-500">Here's what's happening with your account today.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu.jsp" class="mt-3 sm:mt-0 inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                            Browse Menu
                            <svg class="ml-2 -mr-0.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                            </svg>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-8">
                <!-- Orders Placed -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-indigo-500 rounded-md p-3">
                                <i class="fas fa-shopping-cart text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Orders Placed</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${userOrdersCount != null ? userOrdersCount : '0'}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="${pageContext.request.contextPath}/user/orders" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View all orders
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Rewards Points -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                                <i class="fas fa-star text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Rewards Points</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">${userRewardsPoints != null ? userRewardsPoints : '0'}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View rewards program
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Total Spent -->
                <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="px-4 py-5 sm:p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                                <i class="fas fa-money-bill-wave text-white"></i>
                            </div>
                            <div class="ml-5 w-0 flex-1">
                                <dl>
                                    <dt class="text-sm font-medium text-gray-500 truncate">Total Spent</dt>
                                    <dd class="flex items-baseline">
                                        <div class="text-2xl font-semibold text-gray-900">R ${userTotalSpent != null ? userTotalSpent : '0'}</div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-4 sm:px-6">
                        <div class="text-sm">
                            <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">
                                View spending history
                                <span aria-hidden="true">&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Recent Orders and Recommendations Section -->
            <div class="grid grid-cols-1 gap-4 lg:grid-cols-2">
                <!-- Recent Orders -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">Recent Orders</h3>
                        <p class="mt-1 text-sm text-gray-500">Your most recent orders at our restaurant.</p>
                    </div>
                    <div>
                        <ul class="divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${empty userOrders || userOrdersCount == 0}">
                                    <li class="px-4 py-8 sm:px-6 text-center">
                                        <div class="text-sm text-gray-500">
                                            <i class="fas fa-receipt text-gray-400 text-3xl mb-3"></i>
                                            <p>No orders yet. Browse our menu to place your first order!</p>
                                        </div>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="order" items="${userOrders}">
                                        <li class="px-4 py-4 sm:px-6">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-12 w-12 rounded-full bg-gray-200 flex items-center justify-center">
                                                        <i class="fas fa-utensils text-gray-500"></i>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">${order.itemName}</div>
                                                        <div class="text-sm text-gray-500">Order #${order.id} • ${order.orderDate}</div>
                                                    </div>
                                                </div>
                                                <div class="ml-4">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        Completed
                                                    </span>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                        <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                            <div class="text-sm">
                                <a href="${pageContext.request.contextPath}/user/orders" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    View all orders
                                    <span aria-hidden="true">&rarr;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recommendations -->
                <div class="bg-white shadow rounded-lg">
                    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">Recommended for You</h3>
                        <p class="mt-1 text-sm text-gray-500">Based on your order history and preferences.</p>
                    </div>
                    <div>
                        <ul class="divide-y divide-gray-200">
                            <li class="px-4 py-4 sm:px-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12 rounded-md bg-gray-200 flex items-center justify-center overflow-hidden">
                                            <img src="https://via.placeholder.com/48x48.png?text=Food" alt="Food" class="h-full w-full object-cover">
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">Paneer Butter Masala</div>
                                            <div class="text-sm text-gray-500">Because you enjoyed Chicken Tikka Masala</div>
                                        </div>
                                    </div>
                                    <div class="ml-4">
                                        <span class="text-sm font-semibold text-gray-900">R 14.99</span>
                                    </div>
                                </div>
                            </li>
                            <li class="px-4 py-4 sm:px-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12 rounded-md bg-gray-200 flex items-center justify-center overflow-hidden">
                                            <img src="https://via.placeholder.com/48x48.png?text=Food" alt="Food" class="h-full w-full object-cover">
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">Sweet Potato Fries</div>
                                            <div class="text-sm text-gray-500">Goes well with your favorite Veggie Burger</div>
                                        </div>
                                    </div>
                                    <div class="ml-4">
                                        <span class="text-sm font-semibold text-gray-900">R 4.99</span>
                                    </div>
                                </div>
                            </li>
                            <li class="px-4 py-4 sm:px-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12 rounded-md bg-gray-200 flex items-center justify-center overflow-hidden">
                                            <img src="https://via.placeholder.com/48x48.png?text=Food" alt="Food" class="h-full w-full object-cover">
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">Tiramisu</div>
                                            <div class="text-sm text-gray-500">Perfect dessert after Pasta Carbonara</div>
                                        </div>
                                    </div>
                                    <div class="ml-4">
                                        <span class="text-sm font-semibold text-gray-900">R 6.99</span>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="bg-gray-50 px-4 py-4 sm:px-6 rounded-b-lg">
                            <div class="text-sm">
                                <a href="${pageContext.request.contextPath}/menu.jsp" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    Explore full menu
                                    <span aria-hidden="true">&rarr;</span>
                                </a>
                            </div>
                        </div>
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
