package com.mycompany.restaurantmanagement.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for database operations
 * Connection to Supabase PostgreSQL database with improved error handling
 */
public class DatabaseUtil {
    
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());
    
    // Supabase PostgreSQL connection parameters loaded dynamically
    private static final String DB_URL = EnvLoader.get("DB_URL");
    private static final String DB_USER = EnvLoader.get("DB_USER");
    private static final String DB_PASSWORD = EnvLoader.get("DB_PASSWORD");
    
    // Test connection on startup
    static {
        try {
            // Load the JDBC driver
            Class.forName("org.postgresql.Driver");
            LOGGER.log(Level.INFO, "PostgreSQL JDBC Driver registered successfully");
            
            // Test the connection to verify configuration
            try (Connection testConn = getConnection()) {
                LOGGER.log(Level.INFO, "Database connection verified successfully. Database metadata: " + 
                    testConn.getMetaData().getDatabaseProductName() + " " + 
                    testConn.getMetaData().getDatabaseProductVersion());
            }
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "PostgreSQL JDBC Driver not found. Please add the PostgreSQL driver JAR to your classpath.", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to establish initial database connection: " + e.getMessage(), e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during database initialization: " + e.getMessage(), e);
        }
    }
    
    /**
     * Get a connection to the database with robust error handling
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            if (conn == null) {
                LOGGER.severe("DriverManager returned null connection");
                throw new SQLException("Failed to create database connection");
            }
            
            // Set useful defaults
            conn.setAutoCommit(true);
            
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection error: " + e.getMessage(), e);
            
            // Try alternate connection methods if the first fails
            return tryAlternativeConnections(e);
        }
    }
    
    /**
     * Try alternative connection methods if the default fails
     * @param originalException The original exception that prompted the retry
     * @return Connection if successful
     * @throws SQLException if all connection attempts fail
     */
    private static Connection tryAlternativeConnections(SQLException originalException) throws SQLException {
        // Try with explicit parameters
        try {
            LOGGER.info("Attempting alternative connection method 1");
            java.util.Properties props = new java.util.Properties();
            props.setProperty("user", DB_USER);
            props.setProperty("password", DB_PASSWORD);
            props.setProperty("sslmode", "require");
            
            Connection conn = DriverManager.getConnection(
                "jdbc:postgresql://aws-1-eu-central-1.pooler.supabase.com:5432/postgres", props);
            LOGGER.info("Alternative connection method 1 succeeded");
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Alternative connection method 1 failed: " + e.getMessage());
        }
        
        // If all attempts fail, throw the original exception
        throw originalException;
    }
    
    /**
     * Close a connection safely
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    LOGGER.log(Level.INFO, "Database connection closed");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection: {0}", e.getMessage());
            }
        }
    }
    
    /**
     * Close Statement and ResultSet safely - commonly used utility method
     * @param stmt The statement to close
     */
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing statement: " + e.getMessage(), e);
            }
        }
    }
}