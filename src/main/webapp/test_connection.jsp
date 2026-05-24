<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.restaurantmanagement.util.JPAUtil"%>
<%@page import="jakarta.persistence.EntityManager"%>
<%@page import="jakarta.persistence.Query"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        pre { background-color: #f0f0f0; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <h2>Testing JPA Connection</h2>
    <%
    try {
        EntityManager em = JPAUtil.getEntityManager();
        out.println("<p class='success'>EntityManager created successfully!</p>");
        
        out.println("<h3>User Table Check</h3>");
        Query query = em.createQuery("SELECT COUNT(u) FROM User u");
        Long count = (Long) query.getSingleResult();
        out.println("<p>Number of users: " + count + "</p>");
        
        if (count > 0) {
            out.println("<h3>First User Details</h3>");
            Query userQuery = em.createQuery("SELECT u FROM User u");
            userQuery.setMaxResults(1);
            Object user = userQuery.getSingleResult();
            out.println("<pre>" + user.toString() + "</pre>");
        }
        
        em.close();
        out.println("<p class='success'>Connection test completed successfully!</p>");
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
    <p><a href="login.jsp">Go to Login Page</a></p>
</body>
</html>
