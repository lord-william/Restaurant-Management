package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.model.Order;
import com.mycompany.restaurantmanagement.util.JPAUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

@ApplicationScoped
public class OrderDao {
    
    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }
    
    public List<Order> findAll() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Order> query = em.createQuery(
                "SELECT o FROM Order o ORDER BY o.createdAt DESC", 
                Order.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Order> findByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            // Convert string status to enum if needed
            Order.OrderStatus orderStatus = convertStringToStatus(status);
            TypedQuery<Order> query = em.createQuery(
                "SELECT o FROM Order o WHERE o.status = :status ORDER BY o.createdAt DESC", 
                Order.class
            );
            query.setParameter("status", orderStatus);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public int countByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            Order.OrderStatus orderStatus = convertStringToStatus(status);
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(o) FROM Order o WHERE o.status = :status", 
                Long.class
            );
            query.setParameter("status", orderStatus);
            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }
    
    public boolean updateStatus(int orderId, String status) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                order.setStatus(convertStringToStatus(status));
                em.merge(order);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    public boolean delete(int orderId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                em.remove(order);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    public BigDecimal getDailyRevenue() {
        EntityManager em = getEntityManager();
        try {
            // Get today's date range
            LocalDate today = LocalDate.now();
            Timestamp startOfDay = Timestamp.valueOf(today.atStartOfDay());
            Timestamp endOfDay = Timestamp.valueOf(today.plusDays(1).atStartOfDay());
            
            TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o " +
                "WHERE o.createdAt >= :startOfDay AND o.createdAt < :endOfDay " +
                "AND (o.status = :delivered OR o.status = :ready)",
                BigDecimal.class
            );
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("endOfDay", endOfDay);
            query.setParameter("delivered", Order.OrderStatus.COMPLETED);
            query.setParameter("ready", Order.OrderStatus.PROCESSING);
            
            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }
    
    public BigDecimal getMonthlyRevenue() {
        EntityManager em = getEntityManager();
        try {
            // Get current month date range
            LocalDate today = LocalDate.now();
            LocalDate startOfMonth = today.withDayOfMonth(1);
            LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
            
            Timestamp monthStart = Timestamp.valueOf(startOfMonth.atStartOfDay());
            Timestamp monthEnd = Timestamp.valueOf(startOfNextMonth.atStartOfDay());
            
            TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o " +
                "WHERE o.createdAt >= :monthStart AND o.createdAt < :monthEnd " +
                "AND (o.status = :delivered OR o.status = :ready)",
                BigDecimal.class
            );
            query.setParameter("monthStart", monthStart);
            query.setParameter("monthEnd", monthEnd);
            query.setParameter("delivered", Order.OrderStatus.COMPLETED);
            query.setParameter("ready", Order.OrderStatus.PROCESSING);
            
            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }
    
    public BigDecimal getTotalRevenue() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o " +
                "WHERE (o.status = :delivered OR o.status = :ready)",
                BigDecimal.class
            );
            query.setParameter("delivered", Order.OrderStatus.COMPLETED);
            query.setParameter("ready", Order.OrderStatus.PROCESSING);
            
            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }
    
    public int countDailyOrders() {
        EntityManager em = getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            Timestamp startOfDay = Timestamp.valueOf(today.atStartOfDay());
            Timestamp endOfDay = Timestamp.valueOf(today.plusDays(1).atStartOfDay());
            
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(o) FROM Order o " +
                "WHERE o.createdAt >= :startOfDay AND o.createdAt < :endOfDay",
                Long.class
            );
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("endOfDay", endOfDay);
            
            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }
    
    public int countMonthlyOrders() {
        EntityManager em = getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalDate startOfMonth = today.withDayOfMonth(1);
            LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
            
            Timestamp monthStart = Timestamp.valueOf(startOfMonth.atStartOfDay());
            Timestamp monthEnd = Timestamp.valueOf(startOfNextMonth.atStartOfDay());
            
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(o) FROM Order o " +
                "WHERE o.createdAt >= :monthStart AND o.createdAt < :monthEnd",
                Long.class
            );
            query.setParameter("monthStart", monthStart);
            query.setParameter("monthEnd", monthEnd);
            
            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }
    
    private Order.OrderStatus convertStringToStatus(String status) {
        if (status == null) return Order.OrderStatus.PENDING;
        
        try {
            return Order.OrderStatus.valueOf(status.toUpperCase());
        } catch (IllegalArgumentException e) {
            // Handle common variations
            switch (status.toLowerCase()) {
                case "pending": return Order.OrderStatus.PENDING;
                case "processing": return Order.OrderStatus.PROCESSING;
                case "completed": return Order.OrderStatus.COMPLETED;
                case "cancelled": return Order.OrderStatus.CANCELLED;
                case "paid": return Order.OrderStatus.PAID;
                default: return Order.OrderStatus.PENDING;
            }
        }
    }
}