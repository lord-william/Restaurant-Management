<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Management - Menu</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS for menu with !important overrides to avoid caching issues -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu-custom.css?v=<%=System.currentTimeMillis()%>">
    <script>
        // Initialize Tailwind with custom colors
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'amber': {
                            '500': '#f59e0b'
                        },
                        'ump-blue': '#034694'
                    },
                    animation: {
                        'slide-in': 'slideIn 0.3s ease-out',
                        'slide-out': 'slideOut 0.3s ease-in'
                    },
                    keyframes: {
                        slideIn: {
                            '0%': { transform: 'translateX(100%)' },
                            '100%': { transform: 'translateX(0)' }
                        },
                        slideOut: {
                            '0%': { transform: 'translateX(0)' },
                            '100%': { transform: 'translateX(100%)' }
                        }
                    }
                }
            }
        }
    </script>
    <!-- Initialize context path for JavaScript files -->
    <script>
        // Set the context path for use in JavaScript files
        var pageContextPath = '<c:out value="${pageContext.request.contextPath}"/>';
    </script>
    <!-- Include external JavaScript files with version to prevent caching -->
    <script src="${pageContext.request.contextPath}/js/menu.js?v=<%=System.currentTimeMillis()%>"></script>
    <script src="${pageContext.request.contextPath}/js/tray.js?v=<%=System.currentTimeMillis()%>"></script>
    <script src="${pageContext.request.contextPath}/js/nutritionDisplay.js?v=<%=System.currentTimeMillis()%>"></script>
    <!-- Include the menu fix script -->
    <script src="${pageContext.request.contextPath}/js/menu_fix.js?v=<%=System.currentTimeMillis()%>"></script>
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen ${sessionScope.user != null ? 'user-logged-in' : ''}">
    <!-- Include common navigation bar -->
    <c:choose>
        <c:when test="${sessionScope.user != null}">
            <jsp:include page="/WEB-INF/views/components/navbar.jsp" />
        </c:when>
        <c:otherwise>
            <!-- Simple navigation for unauthenticated users -->
            <nav class="bg-white shadow-md">
                <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                    <div class="flex h-16 justify-between">
                        <div class="flex">
                            <div class="flex flex-shrink-0 items-center">
                                <img class="h-8 w-auto" src="${pageContext.request.contextPath}/images/logo.png" alt="Restaurant Management">
                            </div>
                            <!-- Navigation Links -->                             
                            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                                <a href="${pageContext.request.contextPath}/index.jsp" 
                                   class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                                    Home
                                </a>
                                <a href="${pageContext.request.contextPath}/menu.jsp" 
                                   class="border-indigo-500 text-gray-900 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                                    Menu
                                </a>
                            </div>
                        </div>
                        <!-- Right side navigation items --> 
                        <div class="hidden sm:flex sm:items-center space-x-4">
                            <!-- Tray Icon -->
                            <button id="tray-icon" class="relative inline-flex items-center border-transparent text-gray-500 hover:text-gray-700">
                                <span class="sr-only">Your Tray</span>
                                <i class="fas fa-shopping-basket text-xl"></i>
                                <span id="tray-count" class="absolute -top-2 -right-2 bg-[#034694] text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center hidden">0</span>
                            </button>
                            <!-- Login Link -->
                            <a href="${pageContext.request.contextPath}/login" 
                               class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-3 py-1.5 text-sm font-medium rounded-md hover:bg-gray-100">
                                Login
                            </a>
                        </div>
                    </div>
                </div>
            </nav>
        </c:otherwise>
    </c:choose>

    <!-- Menu Section -->
    <section class="py-16 px-4 md:px-8">
        <div class="container mx-auto max-w-6xl">
            <!-- Menu Header -->
            <div class="mb-12 text-center">
                <p class="text-gray-400 uppercase tracking-wider text-sm">MENU</p>
                <h2 class="text-4xl md:text-5xl font-bold text-[#034694] mt-2">Check Our Tasty Menu</h2>
            </div>
            
            <!-- Menu Categories and Filters Container -->
            <div class="flex flex-col md:flex-row justify-between items-center mb-8">
                <!-- Menu Categories Tabs -->
                <div class="flex overflow-x-auto w-full md:w-auto mb-4 md:mb-0 border-b border-gray-800 md:border-b-0">
                    <nav class="flex space-x-1 md:space-x-4 w-full">
                        <button class="category-btn text-[#034694] border-b-2 border-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('all')">All</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('treats')">Treats</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('meals')">Meals</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('beverages')">Beverages</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('breakfast')">Breakfast</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('vegetarian')">Vegetarian</button>
                        <button class="category-btn text-gray-300 hover:text-[#034694] px-3 py-2 whitespace-nowrap" 
                                onclick="filterCategory('specials')">Specials</button>
                    </nav>
                </div>
                
                <!-- Filter Toggle and Dropdowns -->
                <div class="flex items-center md:ml-4">
                    <button id="filter-toggle" class="flex items-center bg-[#034694] hover:bg-blue-700 text-white px-3 py-1.5 rounded-md text-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
                        </svg>
                        Filters
                    </button>
                </div>
                
                <!-- Filter dropdown panel - will be positioned absolutely -->
                <div id="filter-panel" class="hidden absolute right-4 top-44 z-10 bg-gray-900 shadow-lg rounded-md p-3 border border-gray-700 w-64">
                    <div class="mb-3">
                        <label class="block text-sm font-medium text-gray-300 mb-1">Locations</label>
                        <select id="restaurant-filter" class="bg-gray-800 text-white py-1.5 pl-2 pr-8 rounded border border-gray-700 focus:outline-none focus:ring-2 focus:ring-[#034694] w-full">
                            <option value="all" selected>All Locations</option>
                            <option value="1">Tuckshop (Great Hall)</option>
                            <option value="2">Tuckshop (Building 13)</option>
                            <option value="3">Mumasi (Building 6)</option>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-300 mb-1">Price Range</label>
                        <select id="price-filter" class="bg-gray-800 text-white py-1.5 pl-2 pr-8 rounded border border-gray-700 focus:outline-none focus:ring-2 focus:ring-[#034694] w-full">
                            <option value="all">All Prices</option>
                            <option value="under20">Under R20</option>
                            <option value="20to40">R20 - R40</option>
                            <option value="over40">Over R40</option>
                        </select>
                    </div>
                    
                    <div class="mt-3 flex justify-end">
                        <button id="apply-filters" class="bg-[#034694] hover:bg-blue-700 text-white px-3 py-1 rounded-md text-sm">
                            Apply Filters
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Border separator -->
            <div class="w-full border-b border-gray-800 mb-8"></div>
            
            <!-- Menu Items Grid -->
            <div id="menu-items" class="grid grid-cols-1 xs:grid-cols-2 md:grid-cols-3 gap-4 w-full">
                <!-- Menu items will be loaded here -->
                <div class="flex justify-center items-center col-span-2 py-10">
                    <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-amber-500"></div>
                </div>
            </div>
            
            <!-- Specials Section (Initially Hidden) -->
            <div id="specials-content" class="hidden mt-8">
                <div class="mb-8">
                    <h3 class="text-2xl font-bold text-[#034694]">This Month's Specials</h3>
                    <p class="text-gray-400 mt-2">Limited time offers for May 2025</p>
                </div>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-8" id="specials-grid">
                    <!-- Specials content will be loaded here -->
                    <div class="flex justify-center items-center col-span-2 py-10">
                        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-amber-500"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Item Detail Modal -->
    <div id="item-detail-modal" class="hidden fixed inset-0 bg-black bg-opacity-70 z-50 flex items-center justify-center p-4 overflow-y-auto">
        <div class="bg-gray-900 rounded-lg max-w-4xl w-full max-h-90vh relative">
            <button onclick="closeModal('item-detail-modal')" class="absolute top-4 right-4 text-gray-400 hover:text-white text-2xl">&times;</button>
            
            <div class="p-6">
                <div id="modal-content">
                    <!-- Content will be loaded dynamically -->
                    <div class="flex justify-center items-center py-10">
                        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-amber-500"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Flavor Selection Modal -->
    <div id="flavor-selection-modal" class="hidden fixed inset-0 bg-black bg-opacity-70 z-50 flex items-center justify-center p-4">
        <div class="bg-gray-900 p-6 rounded-lg max-w-4xl w-full">
            <div class="flex justify-between items-start">
                <h2 id="flavor-title" class="text-2xl font-bold text-[#034694]">Select Flavor</h2>
                <button onclick="closeModal('flavor-selection-modal')" class="text-gray-400 hover:text-white text-2xl">&times;</button>
            </div>
            
            <div id="flavor-grid" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 mt-6">
                <!-- Flavors will be loaded here -->
                <div class="flex justify-center items-center col-span-3 py-10">
                    <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-amber-500"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Tray Modal -->
    <div id="tray-modal" class="hidden fixed inset-0 bg-black bg-opacity-70 z-50 flex items-center justify-center p-4 overflow-y-auto">
        <div class="bg-gray-900 rounded-lg max-w-2xl w-full max-h-90vh relative">
            <div class="p-6">
                <div class="flex justify-between items-center border-b border-gray-700 pb-4">
                    <h2 class="text-2xl font-bold text-[#034694]">Your Tray</h2>
                    <button onclick="hideTrayModal()" class="text-gray-400 hover:text-white text-2xl">&times;</button>
                </div>
                
                <div id="tray-items-container" class="overflow-y-auto max-h-[50vh]">
                    <!-- Tray items will be loaded here dynamically -->
                    <div class="text-center py-8">
                        <p class="text-gray-400">Your tray is empty</p>
                    </div>
                </div>
                
                <div class="mt-6 border-t border-gray-700 pt-4">
                    <div class="flex justify-between items-center mb-4">
                        <span class="text-lg font-medium">Total:</span>
                        <span id="tray-total" class="text-xl font-bold text-amber-500">R0.00</span>
                    </div>
                    
                    <div class="flex space-x-4">
                        <button onclick="clearTray()" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md text-sm flex-1">
                            Clear Tray
                        </button>
                        <button onclick="proceedToCheckout()" class="bg-[#034694] hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm flex-1">
                            Proceed to Checkout
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Tray Notification -->
    <div id="tray-notification" class="hidden fixed bottom-4 right-4 bg-gray-900 text-white p-4 rounded-md shadow-lg z-50">
        <div class="flex items-center">
            <i class="fas fa-utensils mr-2"></i>
            <span id="tray-notification-text">Item added to your tray</span>
        </div>
    </div>

</body>
</html>
