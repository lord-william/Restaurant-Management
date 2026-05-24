<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="bg-white shadow-md">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 justify-between">
            <div class="flex">
                <div class="flex flex-shrink-0 items-center">
                    <img class="h-8 w-auto" src="${pageContext.request.contextPath}/images/logo.png" alt="Restaurant Management">
                </div>
                <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                    <!-- Common navigation links -->
                    <a href="${pageContext.request.contextPath}/dashboard" 
                       class="${requestScope['javax.servlet.forward.request_uri'].endsWith('/dashboard') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/menu.jsp" 
                       class="${requestScope['javax.servlet.forward.request_uri'].endsWith('/menu.jsp') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                        Menu
                    </a>
                    
                    <!-- Role-specific navigation links -->
                    <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/users" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/admin/users') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            Manage Users
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/menu" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/admin/menu') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            Manage Menu
                        </a>
                    </c:if>
                    
                    <c:if test="${sessionScope.userRole eq 'STAFF'}">
                        <a href="${pageContext.request.contextPath}/staff/orders" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/staff/orders') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/inventory" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/staff/inventory') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            Inventory
                        </a>
                    </c:if>
                    
                    <c:if test="${sessionScope.userRole eq 'USER' || sessionScope.userRole == null}">
                        <a href="${pageContext.request.contextPath}/user/orders" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/user/orders') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            My Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/user/profile" 
                           class="${requestScope['javax.servlet.forward.request_uri'].contains('/user/profile') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium">
                            Profile
                        </a>
                    </c:if>
                </div>
            </div>
            
            <!-- Profile dropdown and mobile menu button -->
            <div class="hidden sm:ml-6 sm:flex sm:items-center">
                <div class="relative ml-3">
                    <div>
                        <button type="button" 
                                class="flex rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" 
                                id="user-menu-button" 
                                aria-expanded="false" 
                                aria-haspopup="true">
                            <span class="sr-only">Open user menu</span>
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-gray-500">
                                <span class="text-sm font-medium leading-none text-white">
                                    ${sessionScope.user.name.substring(0, 1).toUpperCase()}
                                </span>
                            </span>
                        </button>
                    </div>
                    
                    <!-- Profile dropdown menu (initially hidden, controlled by JavaScript) -->
                    <div class="hidden absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none" 
                         role="menu" 
                         aria-orientation="vertical" 
                         aria-labelledby="user-menu-button" 
                         tabindex="-1"
                         id="user-menu-dropdown">
                        <a href="${pageContext.request.contextPath}/user/profile" class="block px-4 py-2 text-sm text-gray-700" role="menuitem" tabindex="-1">Your Profile</a>
                        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700" role="menuitem" tabindex="-1">Sign out</a>
                    </div>
                </div>
            </div>
            
            <!-- Mobile menu button -->
            <div class="-mr-2 flex items-center sm:hidden">
                <button type="button" 
                        class="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500" 
                        aria-controls="mobile-menu" 
                        aria-expanded="false"
                        id="mobile-menu-button">
                    <span class="sr-only">Open main menu</span>
                    <!-- Menu open: "hidden", Menu closed: "block" -->
                    <svg class="block h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                    </svg>
                    <!-- Menu open: "block", Menu closed: "hidden" -->
                    <svg class="hidden h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Mobile menu, show/hide based on menu state (controlled by JavaScript) -->
    <div class="hidden sm:hidden" id="mobile-menu">
        <div class="space-y-1 pb-3 pt-2">
            <a href="${pageContext.request.contextPath}/dashboard" 
               class="${requestScope['javax.servlet.forward.request_uri'].endsWith('/dashboard') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/menu.jsp" 
               class="${requestScope['javax.servlet.forward.request_uri'].endsWith('/menu.jsp') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                Menu
            </a>
            
            <!-- Role-specific links for mobile -->
            <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/users" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/admin/users') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    Manage Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/menu" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/admin/menu') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    Manage Menu
                </a>
            </c:if>
            
            <c:if test="${sessionScope.userRole eq 'STAFF'}">
                <a href="${pageContext.request.contextPath}/staff/orders" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/staff/orders') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    Orders
                </a>
                <a href="${pageContext.request.contextPath}/staff/inventory" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/staff/inventory') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    Inventory
                </a>
            </c:if>
            
            <c:if test="${sessionScope.userRole eq 'USER' || sessionScope.userRole == null}">
                <a href="${pageContext.request.contextPath}/user/orders" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/user/orders') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    My Orders
                </a>
                <a href="${pageContext.request.contextPath}/user/profile" 
                   class="${requestScope['javax.servlet.forward.request_uri'].contains('/user/profile') ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'} block border-l-4 py-2 pl-3 pr-4 text-base font-medium">
                    Profile
                </a>
            </c:if>
        </div>
        
        <!-- Mobile profile section -->
        <div class="border-t border-gray-200 pb-3 pt-4">
            <div class="flex items-center px-4">
                <div class="flex-shrink-0">
                    <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-gray-500">
                        <span class="text-lg font-medium leading-none text-white">
                            ${sessionScope.user.name.substring(0, 1).toUpperCase()}
                        </span>
                    </span>
                </div>
                <div class="ml-3">
                    <div class="text-base font-medium text-gray-800">${sessionScope.user.name}</div>
                    <div class="text-sm font-medium text-gray-500">${sessionScope.user.email}</div>
                </div>
            </div>
            <div class="mt-3 space-y-1">
                <a href="${pageContext.request.contextPath}/user/profile" 
                   class="block px-4 py-2 text-base font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-800">
                    Your Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" 
                   class="block px-4 py-2 text-base font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-800">
                    Sign out
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- JavaScript for menu toggling -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // User menu dropdown toggle
        const userMenuButton = document.getElementById('user-menu-button');
        const userMenuDropdown = document.getElementById('user-menu-dropdown');
        
        if (userMenuButton && userMenuDropdown) {
            userMenuButton.addEventListener('click', function() {
                userMenuDropdown.classList.toggle('hidden');
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuButton.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.classList.add('hidden');
                }
            });
        }
        
        // Mobile menu toggle
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');
        const mobileMenuIcon = mobileMenuButton.querySelector('svg:first-child');
        const mobileCloseIcon = mobileMenuButton.querySelector('svg:last-child');
        
        if (mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                const isMenuOpen = mobileMenu.classList.toggle('hidden');
                
                if (isMenuOpen) {
                    mobileMenuIcon.classList.remove('hidden');
                    mobileMenuIcon.classList.add('block');
                    mobileCloseIcon.classList.remove('block');
                    mobileCloseIcon.classList.add('hidden');
                } else {
                    mobileMenuIcon.classList.remove('block');
                    mobileMenuIcon.classList.add('hidden');
                    mobileCloseIcon.classList.remove('hidden');
                    mobileCloseIcon.classList.add('block');
                }
            });
        }
    });
</script>
