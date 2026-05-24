<%-- 
    Document   : forgotpassword
    Created on : 10 Apr 2025, 04:40:27
    Author     : willi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full bg-white">
<head>
    <meta charset="UTF-8">
    <title>Restaurant Management System - Forgot Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-full">
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-sm">
            <img class="mx-auto h-24 w-auto" src="${pageContext.request.contextPath}/images/logo.png" alt="Restaurant Management">
            <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Reset your password</h2>
            <p class="mt-2 text-center text-sm text-gray-600">
                Enter your email and we'll send you a link to reset your password
            </p>
        </div>

        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    <p>${error}</p>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    <p>${success}</p>
                </div>
            </c:if>
            
            <form class="space-y-6" action="${pageContext.request.contextPath}/forgotPassword" method="POST" id="forgotPasswordForm">
                <!-- Email Field -->
                <div>
                    <label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
                    <div class="mt-2">
                        <input type="email" name="email" id="email" autocomplete="email" required
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                </div>
                
                <!-- Submit Button -->
                <div>
                    <button type="submit" 
                            class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                        Send reset link
                    </button>
                </div>
            </form>
            
            <p class="mt-10 text-center text-sm/6 text-gray-500">
                <a href="${pageContext.request.contextPath}/login" class="font-semibold text-indigo-600 hover:text-indigo-500">Back to login</a>
            </p>
        </div>
    </div>
</body>
</html>
