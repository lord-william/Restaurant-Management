<%-- 
    Document   : error
    Created on : 10 Apr 2025, 01:04:07
    Author     : willi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Restaurant Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 40px;
        }
        
        .error-code {
            font-size: 72px;
            margin-bottom: 20px;
            color: #e74c3c;
        }
        
        .error-message {
            font-size: 24px;
            margin-bottom: 30px;
        }
        
        .home-link {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <div class="error-code">
                <% 
                Integer statusCode = (Integer)request.getAttribute("jakarta.servlet.error.status_code");
                if (statusCode != null) {
                    out.print(statusCode);
                } else {
                    out.print("Error");
                }
                %>
            </div>
            
            <div class="error-message">
                <% 
                String errorMessage = (String)request.getAttribute("jakarta.servlet.error.message");
                if (errorMessage != null && !errorMessage.isEmpty()) {
                    out.print(errorMessage);
                } else {
                    out.print("Sorry, something went wrong.");
                }
                %>
            </div>
            
            <a href="${pageContext.request.contextPath}/" class="home-link">Return to Home</a>
        </div>
    </div>
</body>
</html>
