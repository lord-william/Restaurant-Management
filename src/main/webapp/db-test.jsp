<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.naming.*"%>
<%@page import="javax.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { background-color: #f0f0f0; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
    Connection conn = null;
    try {
        // Get the connection from JNDI resource
        Context initContext = new InitialContext();
        Context envContext = (Context) initContext.lookup("java:comp/env");
        DataSource ds = (DataSource) envContext.lookup("jdbc/RestaurantDB");
        conn = ds.getConnection();
        
        if (conn != null) {
            DatabaseMetaData metaData = conn.getMetaData();
            %>
            <div class="success">Connection Successful!</div>
            <h2>Database Information:</h2>
            <div class="info">
                <p><strong>Database URL:</strong> <%= metaData.getURL() %></p>
                <p><strong>Database Product:</strong> <%= metaData.getDatabaseProductName() %> <%= metaData.getDatabaseProductVersion() %></p>
                <p><strong>Driver:</strong> <%= metaData.getDriverName() %> <%= metaData.getDriverVersion() %></p>
                <p><strong>Username:</strong> <%= metaData.getUserName() %></p>
            </div>
            
            <h2>Available Tables:</h2>
            <ul>
            <%
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                %>
                <li><%= tableName %></li>
                <%
            }
            %>
            </ul>
            <%
        }
    } catch (Exception e) {
        %>
        <div class="error">Connection Failed: <%= e.getMessage() %></div>
        <p>Stack trace:</p>
        <pre>
        <% 
        e.printStackTrace(new java.io.PrintWriter(out)); 
        %>
        </pre>
        <%
    } finally {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
    
    <p><a href="index.jsp">Back to Home</a></p>
</body>
</html>
