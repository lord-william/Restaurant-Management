<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard - Restaurant Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/test_dashboard.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/multi_dashboard.css">
    <style>
        .dashboard-header {
            background-color: #343a40;
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        .stats-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #343a40;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .user-table {
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="dashboard-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1>Admin Dashboard</h1>
                </div>
                <div class="col-md-6 text-end">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-light">Back to Home</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger ms-2">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <!-- User Statistics -->
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <h5>Total Students</h5>
                    <div class="stats-number">${studentCount}</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <h5>Total Staff</h5>
                    <div class="stats-number">${staffCount}</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <h5>Pending Approvals</h5>
                    <div class="stats-number">${pendingCount}</div>
                </div>
            </div>
            <!-- Order & Revenue Statistics -->
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <h5>Daily Revenue</h5>
                    <div class="stats-number">R ${dailyRevenue != null ? dailyRevenue : '0.00'}</div>
                </div>
            </div>
        </div>
        
        <!-- Additional Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card text-center">
                    <h5>Orders Today</h5>
                    <div class="stats-number">${dailyOrders != null ? dailyOrders : '0'}</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card text-center">
                    <h5>Monthly Revenue</h5>
                    <div class="stats-number">R ${monthlyRevenue != null ? monthlyRevenue : '0.00'}</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card text-center">
                    <h5>Total Menu Items</h5>
                    <div class="stats-number">${menuItemCount != null ? menuItemCount : '0'}</div>
                </div>
            </div>
        </div>
        
        <!-- User Management Section -->
        <div class="card user-table">
            <div class="card-header bg-primary text-white">
                <h4>User Management</h4>
            </div>
            <div class="card-body">
                <ul class="nav nav-tabs" id="userTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab">All Users</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="students-tab" data-bs-toggle="tab" data-bs-target="#students" type="button" role="tab">Students</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="staff-tab" data-bs-toggle="tab" data-bs-target="#staff" type="button" role="tab">Staff</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab">Pending Approval</button>
                    </li>
                </ul>
                
                <div class="tab-content p-3" id="userTabsContent">
                    <!-- All Users Tab -->
                    <div class="tab-pane fade show active" id="all" role="tabpanel">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${allUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="badge ${user.role == 'admin' ? 'bg-danger' : user.role == 'staff' ? 'bg-warning' : 'bg-info'}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${user.status == 'true' ? 'bg-success' : 'bg-secondary'}">
                                                ${user.status == 'true' ? 'Active' : 'Pending'}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <c:if test="${user.role != 'admin' || sessionScope.user.id == 1}">
                                                <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="btn btn-sm btn-info">View</a>
                                                
                                                <c:if test="${user.status == 'false'}">
                                                    <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="btn btn-sm btn-success">Approve</a>
                                                </c:if>
                                                
                                                <c:if test="${user.role != 'admin'}">
                                                    <a href="${pageContext.request.contextPath}/admin/user?action=promote&id=${user.id}" class="btn btn-sm btn-warning">
                                                        ${user.role == 'staff' ? 'Make Admin' : 'Make Staff'}
                                                    </a>
                                                </c:if>
                                                
                                                <c:if test="${user.id != sessionScope.user.id}">
                                                    <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                                </c:if>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Students Tab -->
                    <div class="tab-pane fade" id="students" role="tabpanel">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Student Number</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${studentUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td>${user.studentNumber}</td>
                                        <td>
                                            <span class="badge ${user.status == 'true' ? 'bg-success' : 'bg-secondary'}">
                                                ${user.status == 'true' ? 'Active' : 'Pending'}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="btn btn-sm btn-info">View</a>
                                            
                                            <c:if test="${user.status == 'false'}">
                                                <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="btn btn-sm btn-success">Approve</a>
                                            </c:if>
                                            
                                            <a href="${pageContext.request.contextPath}/admin/user?action=promote&id=${user.id}" class="btn btn-sm btn-warning">Make Staff</a>
                                            
                                            <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Staff Tab -->
                    <div class="tab-pane fade" id="staff" role="tabpanel">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Staff ID</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${staffUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td>${user.staffId}</td>
                                        <td>
                                            <span class="badge ${user.status == 'true' ? 'bg-success' : 'bg-secondary'}">
                                                ${user.status == 'true' ? 'Active' : 'Pending'}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="btn btn-sm btn-info">View</a>
                                            
                                            <c:if test="${user.status == 'false'}">
                                                <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="btn btn-sm btn-success">Approve</a>
                                            </c:if>
                                            
                                            <a href="${pageContext.request.contextPath}/admin/user?action=promote&id=${user.id}" class="btn btn-sm btn-warning">Make Admin</a>
                                            
                                            <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Pending Tab -->
                    <div class="tab-pane fade" id="pending" role="tabpanel">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${pendingUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="badge ${user.role == 'staff' ? 'bg-warning' : 'bg-info'}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="btn btn-sm btn-info">View</a>
                                            <a href="${pageContext.request.contextPath}/admin/user?action=approve&id=${user.id}" class="btn btn-sm btn-success">Approve</a>
                                            <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}" class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/multi_dashboard.js"></script>
    <script src="${pageContext.request.contextPath}/js/test_dashboard.js"></script>
    
    <!-- Session messages -->
    <script>
        <c:if test="${sessionScope.success != null}">
            window.sessionSuccess = '<c:out value="${sessionScope.success}" />';
            <c:remove var="success" scope="session" />
        </c:if>
        <c:if test="${sessionScope.error != null}">
            window.sessionError = '<c:out value="${sessionScope.error}" />';
            <c:remove var="error" scope="session" />
        </c:if>
        
        // Debug: Check if JavaScript is loading
        console.log('JavaScript files loaded');
        
        // Test function to ensure JavaScript is working
        function testClick() {
            alert('JavaScript is working!');
        }
        <button onclick="testClick()" class="btn btn-primary">Test JavaScript</button>
    </script>
    <script>
    console.log('Session user:', ${sessionScope.user != null ? '"User exists"' : 'null'});
    console.log('User role:', ${sessionScope.user != null ? '"' += sessionScope.user.role += '"' : 'null'});
</script>
    <script src="${pageContext.request.contextPath}/js/test.js"></script>
</body>
</html>
