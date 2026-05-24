<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Restaurant Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
    <script src="${pageContext.request.contextPath}/js/tray.js?v=<%=System.currentTimeMillis()%>"></script>
    <script src="${pageContext.request.contextPath}/js/checkout.js?v=<%=System.currentTimeMillis()%>"></script>
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen user-logged-in">
    <!-- Include common navigation bar -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />
    
    <!-- Checkout Section -->
    <section class="py-16 px-4 md:px-8">
        <div class="container mx-auto max-w-4xl">
            <!-- Header -->
            <div class="mb-8 text-center">
                <h2 class="text-3xl md:text-4xl font-bold text-[#034694]">Checkout</h2>
                <p class="text-gray-500 mt-2">Review your order and complete payment</p>
            </div>
            
            <!-- Order Summary -->
            <div class="bg-white shadow-md rounded-lg overflow-hidden mb-8">
                <div class="px-6 py-4 bg-gray-100 border-b">
                    <h3 class="text-xl font-semibold">Order Summary</h3>
                </div>
                
                <div class="p-6">
                    <div id="order-items" class="mb-6">
                        <!-- Order items will be loaded here from tray.js -->
                        <div class="text-center py-8">
                            <p class="text-gray-400">Loading your order items...</p>
                        </div>
                    </div>
                    
                    <div class="border-t border-gray-200 pt-4">
                        <div class="flex justify-between items-center py-2">
                            <span>Subtotal</span>
                            <span id="subtotal" class="font-medium">R0.00</span>
                        </div>
                        <div class="flex justify-between items-center py-2">
                            <span>Service Fee</span>
                            <span id="service-fee" class="font-medium">R0.00</span>
                        </div>
                        <div class="flex justify-between items-center py-2 font-bold text-lg">
                            <span>Total</span>
                            <span id="total" class="text-[#034694]">R0.00</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Delivery Options -->
            <div class="bg-white shadow-md rounded-lg overflow-hidden mb-8">
                <div class="px-6 py-4 bg-gray-100 border-b">
                    <h3 class="text-xl font-semibold">Delivery Options</h3>
                </div>
                
                <div class="p-6">
                    <div class="space-y-4">
                        <label class="flex items-center space-x-3 p-4 border rounded-lg cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="delivery-option" value="pickup" checked class="h-5 w-5 text-[#034694]">
                            <span class="flex-grow">
                                <span class="font-medium block">Pickup</span>
                                <span class="text-sm text-gray-500">Collect your order from the restaurant</span>
                            </span>
                            <span class="font-medium">Free</span>
                        </label>
                        
                        <label class="flex items-center space-x-3 p-4 border rounded-lg cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="delivery-option" value="delivery" class="h-5 w-5 text-[#034694]">
                            <span class="flex-grow">
                                <span class="font-medium block">Delivery</span>
                                <span class="text-sm text-gray-500">Delivered to your location on campus</span>
                            </span>
                            <span class="font-medium">R10.00</span>
                        </label>
                    </div>
                    
                    <div id="delivery-address" class="mt-6 hidden">
                        <h4 class="font-medium mb-2">Delivery Address</h4>
                        <textarea id="address-input" rows="3" class="w-full border rounded-md px-3 py-2" placeholder="Enter your campus address (Building, floor, room number)"></textarea>
                    </div>
                </div>
            </div>
            
            <!-- Payment Method -->
            <div class="bg-white shadow-md rounded-lg overflow-hidden mb-8">
                <div class="px-6 py-4 bg-gray-100 border-b">
                    <h3 class="text-xl font-semibold">Payment Method</h3>
                </div>
                
                <div class="p-6">
                    <div class="space-y-4">
                        <label class="flex items-center space-x-3 p-4 border rounded-lg cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="payment-method" value="cash" checked class="h-5 w-5 text-[#034694]">
                            <span class="flex-grow">
                                <span class="font-medium block">Cash on Pickup/Delivery</span>
                                <span class="text-sm text-gray-500">Pay when you receive your order</span>
                            </span>
                            <i class="fas fa-money-bill-wave text-green-600"></i>
                        </label>
                        
                        <label class="flex items-center space-x-3 p-4 border rounded-lg cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="payment-method" value="card" class="h-5 w-5 text-[#034694]">
                            <span class="flex-grow">
                                <span class="font-medium block">Credit/Debit Card</span>
                                <span class="text-sm text-gray-500">Pay securely with your card</span>
                            </span>
                            <i class="fas fa-credit-card text-blue-600"></i>
                        </label>
                    </div>
                    
                    <div id="card-details" class="mt-6 hidden">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="col-span-2">
                                <label class="block text-sm font-medium mb-1">Card Number</label>
                                <input type="text" id="card-number" class="w-full border rounded-md px-3 py-2" placeholder="1234 5678 9012 3456">
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium mb-1">Expiry Date</label>
                                <input type="text" id="card-expiry" class="w-full border rounded-md px-3 py-2" placeholder="MM/YY">
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium mb-1">CVV</label>
                                <input type="text" id="card-cvv" class="w-full border rounded-md px-3 py-2" placeholder="123">
                            </div>
                            
                            <div class="col-span-2">
                                <label class="block text-sm font-medium mb-1">Cardholder Name</label>
                                <input type="text" id="card-name" class="w-full border rounded-md px-3 py-2" placeholder="John Doe">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="flex flex-col md:flex-row md:justify-between space-y-4 md:space-y-0">
                <a href="${pageContext.request.contextPath}/menu.jsp" class="inline-flex items-center text-[#034694]">
                    <i class="fas fa-arrow-left mr-2"></i> Return to Menu
                </a>
                
                <button id="place-order-button" class="bg-[#034694] hover:bg-blue-700 text-white px-6 py-3 rounded-md font-medium">
                    Place Order
                </button>
            </div>
        </div>
    </section>
    
    <!-- Order Confirmation Modal -->
    <div id="confirmation-modal" class="hidden fixed inset-0 bg-black bg-opacity-70 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-md w-full p-6 text-center">
            <div class="mb-4">
                <div class="mx-auto w-20 h-20 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-check text-3xl text-green-600"></i>
                </div>
            </div>
            
            <h3 class="text-2xl font-bold text-gray-900 mb-2">Order Confirmed!</h3>
            <p class="text-gray-600 mb-6">Your order has been received and is being processed. Your order number is <span id="order-number" class="font-bold">###</span>.</p>
            
            <div class="flex justify-center">
                <a href="${pageContext.request.contextPath}/index.jsp" class="inline-block bg-[#034694] hover:bg-blue-700 text-white px-6 py-3 rounded-md font-medium">
                    Return to Home
                </a>
            </div>
        </div>
    </div>
</body>
</html>
