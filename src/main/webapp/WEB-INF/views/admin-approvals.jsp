<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Approvals - Restaurant Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="h-full">
    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />
    
    <main class="py-10">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <!-- Page Header -->
            <div class="mb-8 flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">Pending User Approvals</h1>
                    <p class="mt-2 text-sm text-gray-500">Review and approve new user registrations.</p>
                </div>
                
                <div class="mt-4 sm:mt-0 sm:ml-16 flex items-center">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">
                        <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                    </a>
                </div>
            </div>
            
            <!-- Message Display -->
            <c:if test="${not empty sessionScope.success}">
                <div class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
                    ${sessionScope.success}
                    <c:remove var="success" scope="session" />
                </div>
            </c:if>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                    ${sessionScope.error}
                    <c:remove var="error" scope="session" />
                </div>
            </c:if>
            
            <!-- Users Table -->
            <div class="bg-white shadow rounded-lg">
                <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <h3 class="text-lg font-medium leading-6 text-gray-900">Pending User Approvals</h3>
                    </div>
                </div>
                
                <div class="overflow-hidden">
                    <div class="relative overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">Name</th>
                                    <th scope="col" class="px-6 py-3">Email</th>
                                    <th scope="col" class="px-6 py-3">Role</th>
                                    <th scope="col" class="px-6 py-3">ID/Number</th>
                                    <th scope="col" class="px-6 py-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty pendingUsers}">
                                        <tr class="bg-white border-b">
                                            <td colspan="5" class="px-6 py-4 text-center text-gray-500">No pending approvals</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="user" items="${pendingUsers}">
                                            <tr class="bg-white border-b">
                                                <td class="px-6 py-4 font-medium text-gray-900">${fn:escapeXml(user.name)}</td>
                                                <td class="px-6 py-4">${fn:escapeXml(user.email)}</td>
                                                <td class="px-6 py-4">
                                                    <span class="inline-flex items-center rounded-md bg-blue-100 px-2.5 py-0.5 text-sm font-medium text-blue-800">
                                                        ${user.role}
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <c:choose>
                                                        <c:when test="${user.role == 'student' && not empty user.studentNumber}">
                                                            #${user.studentNumber}
                                                        </c:when>
                                                        <c:when test="${user.role == 'staff' && not empty user.staffId}">
                                                            ID ${user.staffId}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <div class="flex space-x-2">
                                                        <a href="${pageContext.request.contextPath}/admin/approvals?action=approve&userId=${user.id}" class="text-green-600 hover:text-green-900" title="Approve User">
                                                            <i class="fas fa-check"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/approvals?action=reject&userId=${user.id}" class="text-red-600 hover:text-red-900" title="Reject User">
                                                            <i class="fas fa-times"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="text-blue-600 hover:text-blue-900" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
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
