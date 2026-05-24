package com.mycompany.restaurantmanagement.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "total_amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal totalAmount;
    
    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private OrderStatus status = OrderStatus.PENDING;
    
    @Column(name = "payment_method")
    private String paymentMethod;
    
    @Column(name = "created_at")
    private Timestamp createdAt;
    
    @Column(name = "updated_at") 
    private Timestamp updatedAt;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // Enum for order status
    public enum OrderStatus {
        PENDING, PROCESSING, COMPLETED, CANCELLED, PAID
    }
    
    // Constructors
    public Order() {
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public OrderStatus getStatus() {
        return status;
    }
    
    public void setStatus(OrderStatus status) {
        this.status = status;
    }
    
    // Helper method for JSP to get status as string (lowercase)
    public String getStatusString() {
        return status != null ? status.toString().toLowerCase() : "pending";
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    // Helper methods for JSP compatibility
    public Double getTotal() {
        return totalAmount != null ? totalAmount.doubleValue() : 0.0;
    }
    
    public Timestamp getOrderTime() {
        return createdAt;
    }
    
    public String getUserName() {
        return user != null ? user.getName() : "Unknown User";
    }
    
    public int getUserId() {
        return user != null ? user.getId() : 0;
    }
    
    // Set userId when user object is not loaded
    @Transient
    private int tempUserId;
    
    public void setUserId(int userId) {
        this.tempUserId = userId;
    }
    
    // Method to load user name from database when needed
    public void loadUserName(jakarta.persistence.EntityManager em) {
        if (user == null && tempUserId != 0) {
            user = em.find(User.class, tempUserId);
        }
    }
}