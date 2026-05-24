package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.dto.DashboardStats;
import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.util.JPAUtil;
import com.mycompany.restaurantmanagement.util.DatabaseUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class DashboardDAO {
    
    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());
    
    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }
    
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        
        EntityManager em = null;
        try {
            em = getEntityManager();
            
            try {
                // Get user counts
                stats.setStudentCount(countUsersByRole(em, "student"));
                stats.setStaffCount(countUsersByRole(em, "staff"));
                stats.setTotalUsers(getTotalActiveUsers(em));
                stats.setPendingApprovals(countPendingUsers(em));
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting user counts: {0}", e.getMessage());
            }
            
            try {
                // Get order counts using JDBC as a fallback if JPA fails
                stats.setOrdersToday(countDailyOrdersByJdbc());
                stats.setOrdersThisMonth(countMonthlyOrdersByJdbc());
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting order counts: {0}", e.getMessage());
            }
            
            try {
                // Get revenue data
                double dailyRevenue = getDailyRevenueByJdbc();
                double monthlyRevenue = getMonthlyRevenueByJdbc();
                stats.setRevenueToday(dailyRevenue);
                stats.setRevenueThisMonth(monthlyRevenue);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting revenue data: {0}", e.getMessage());
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error building dashboard stats: {0}", e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
        
        return stats;
    }
    
    public List<User> getPendingUsers() {
        EntityManager em = null;
        try {
            em = getEntityManager();
            return em.createQuery("SELECT u FROM User u WHERE u.status = 'false' ORDER BY u.id DESC", User.class)
                    .setMaxResults(5)
                    .getResultList();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting pending users: {0}", e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
    
    /**
     * Get statistics for the staff dashboard
     * @return Map containing order counts by status and other relevant stats
     */
    public Map<String, Object> getStaffDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        EntityManager em = null;
        
        try {
            // Get order counts by status using direct JDBC queries
            stats.put("pendingOrderCount", countOrdersByStatusJdbc("pending"));
            stats.put("processingOrderCount", countOrdersByStatusJdbc("processing"));
            stats.put("completedOrderCount", countOrdersByStatusJdbc("completed"));
            
            // Add today's orders count and revenue
            stats.put("todayOrderCount", countDailyOrdersByJdbc());
            stats.put("dailyRevenue", getDailyRevenueByJdbc());
            
            return stats;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting staff dashboard stats: {0}", e.getMessage());
            // Set default values in case of error
            stats.put("pendingOrderCount", 0);
            stats.put("processingOrderCount", 0);
            stats.put("completedOrderCount", 0);
            stats.put("todayOrderCount", 0);
            stats.put("dailyRevenue", 0.0);
            return stats;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
    
    /**
     * Get user counts by role
     * @param role The role to count (null for all roles)
     * @return Map with role counts
     * @throws SQLException if database error occurs
     */
    public Map<String, Integer> getUserCountsByRole(String role) throws SQLException {
        Map<String, Integer> counts = new HashMap<>();
        EntityManager em = getEntityManager();
        
        try {
            if (role != null) {
                // Count specific role
                int count = countUsersByRole(em, role);
                counts.put(role, count);
            } else {
                // Count all roles
                counts.put("student", countUsersByRole(em, "student"));
                counts.put("staff", countUsersByRole(em, "staff"));
                counts.put("admin", countUsersByRole(em, "admin"));
                counts.put("total", getTotalActiveUsers(em));
                counts.put("pending", countPendingUsers(em));
            }
            return counts;
        } finally {
            em.close();
        }
    }
    
    private int countUsersByRole(EntityManager em, String role) {
        Long count = em.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.userRole = :role AND u.status = 'true'", 
            Long.class
        )
        .setParameter("role", role)
        .getSingleResult();
        
        return count.intValue();
    }
    
    private int getTotalActiveUsers(EntityManager em) {
        Long count = em.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.status = 'true' AND u.userRole != 'admin'", 
            Long.class
        )
        .getSingleResult();
        
        return count.intValue();
    }
    
    private int countPendingUsers(EntityManager em) {
        Long count = em.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.status = 'false'", 
            Long.class
        )
        .getSingleResult();
        
        return count.intValue();
    }
    
    private int countDailyOrders(EntityManager em) {
        try {
            LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
            LocalDateTime endOfDay = startOfDay.plusDays(1);
            Timestamp startTs = Timestamp.valueOf(startOfDay);
            Timestamp endTs = Timestamp.valueOf(endOfDay);
            
            Long count = em.createQuery(
                "SELECT COUNT(o) FROM Order o WHERE o.createdAt >= :startOfDay AND o.createdAt < :endOfDay",
                Long.class
            )
            .setParameter("startOfDay", startTs)
            .setParameter("endOfDay", endTs)
            .getSingleResult();
            
            return count.intValue();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error in countDailyOrders: {0}", e.getMessage());
            return countDailyOrdersByJdbc(); // Fallback to JDBC
        }
    }
    
    /**
     * Count daily orders using direct JDBC
     * @return Count of orders placed today
     */
    private int countDailyOrdersByJdbc() {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COUNT(*) FROM orders WHERE created_at::date = CURRENT_DATE")) {
                 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error in countDailyOrdersByJdbc: {0}", e.getMessage());
        }
        return count;
    }
    
    /**
     * Count orders by status using direct JDBC
     * @param status Status string to count
     * @return Count of orders with the given status
     */
    private int countOrdersByStatusJdbc(String status) {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COUNT(*) FROM orders WHERE status = ?")) {
                 
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error counting orders by status {0}: {1}", new Object[]{status, e.getMessage()});
        }
        return count;
    }
    
    private int countMonthlyOrders(EntityManager em) {
        try {
            LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).toLocalDate().atStartOfDay();
            LocalDateTime startOfNextMonth = startOfMonth.plusMonths(1);
            Timestamp startTs = Timestamp.valueOf(startOfMonth);
            Timestamp endTs = Timestamp.valueOf(startOfNextMonth);
            
            Long count = em.createQuery(
                "SELECT COUNT(o) FROM Order o WHERE o.createdAt >= :startOfMonth AND o.createdAt < :startOfNextMonth",
                Long.class
            )
            .setParameter("startOfMonth", startTs)
            .setParameter("startOfNextMonth", endTs)
            .getSingleResult();
            
            return count.intValue();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error in countMonthlyOrders: {0}", e.getMessage());
            return countMonthlyOrdersByJdbc(); // Fallback to JDBC
        }
    }
    
    /**
     * Count monthly orders using direct JDBC
     * @return Count of orders placed this month
     */
    private int countMonthlyOrdersByJdbc() {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COUNT(*) FROM orders WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE) " +
                 "AND EXTRACT(MONTH FROM created_at) = EXTRACT(MONTH FROM CURRENT_DATE)")) {
                 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error in countMonthlyOrdersByJdbc: {0}", e.getMessage());
        }
        return count;
    }
    
    private BigDecimal getDailyRevenue(EntityManager em) {
        try {
            LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
            LocalDateTime endOfDay = startOfDay.plusDays(1);
            Timestamp startTs = Timestamp.valueOf(startOfDay);
            Timestamp endTs = Timestamp.valueOf(endOfDay);
            
            Query query = em.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o " +
                "WHERE o.createdAt >= :startOfDay AND o.createdAt < :endOfDay " +
                "AND (o.status = 'DELIVERED' OR o.status = 'COMPLETED')"
            );
            query.setParameter("startOfDay", startTs);
            query.setParameter("endOfDay", endTs);
            
            Object result = query.getSingleResult();
            return result != null ? (BigDecimal) result : BigDecimal.ZERO;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error in getDailyRevenue: {0}", e.getMessage());
            return BigDecimal.valueOf(getDailyRevenueByJdbc());
        }
    }
    
    /**
     * Get daily revenue using direct JDBC
     * @return Sum of order amounts today
     */
    private double getDailyRevenueByJdbc() {
        double revenue = 0.0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                 "WHERE created_at::date = CURRENT_DATE " +
                 "AND status != 'cancelled'")) {
                 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenue = rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error in getDailyRevenueByJdbc: {0}", e.getMessage());
        }
        return revenue;
    }
    
    private BigDecimal getMonthlyRevenue(EntityManager em) {
        try {
            LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).toLocalDate().atStartOfDay();
            LocalDateTime startOfNextMonth = startOfMonth.plusMonths(1);
            Timestamp startTs = Timestamp.valueOf(startOfMonth);
            Timestamp endTs = Timestamp.valueOf(startOfNextMonth);
            
            Query query = em.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o " +
                "WHERE o.createdAt >= :startOfMonth AND o.createdAt < :startOfNextMonth " +
                "AND (o.status = 'DELIVERED' OR o.status = 'COMPLETED')"
            );
            query.setParameter("startOfMonth", startTs);
            query.setParameter("startOfNextMonth", endTs);
            
            Object result = query.getSingleResult();
            return result != null ? (BigDecimal) result : BigDecimal.ZERO;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error in getMonthlyRevenue: {0}", e.getMessage());
            return BigDecimal.valueOf(getMonthlyRevenueByJdbc());
        }
    }
    
    /**
     * Get monthly revenue using direct JDBC
     * @return Sum of order amounts this month
     */
    private double getMonthlyRevenueByJdbc() {
        double revenue = 0.0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                 "WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE) " +
                 "AND EXTRACT(MONTH FROM created_at) = EXTRACT(MONTH FROM CURRENT_DATE) " +
                 "AND status != 'cancelled'")) {
                 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenue = rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error in getMonthlyRevenueByJdbc: {0}", e.getMessage());
        }
        return revenue;
    }
}