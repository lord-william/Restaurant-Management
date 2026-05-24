package com.mycompany.restaurantmanagement.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @NotEmpty(message = "Name cannot be empty")
    @Column(name = "name", length = 200, nullable = false)
    private String name;
    
    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Invalid email format")
    @Column(name = "email", length = 200, nullable = false, unique = true)
    private String email;
    
    @NotEmpty(message = "Mobile number cannot be empty")
    @Pattern(regexp = "^[0-9]{10}$", message = "Mobile number must be 10 digits")
    @Column(name = "mobile_number", length = 10, nullable = false)
    private String mobileNumber;
    
    @Column(name = "student_number", length = 9, unique = true)
    private String studentNumber;
    
    @Column(name = "staff_id", length = 6, unique = true)
    private String staffId;
    
    @NotEmpty(message = "Password cannot be empty")
    @Column(name = "password", length = 200, nullable = false)
    private String password;
    
    @NotEmpty(message = "Security question cannot be empty")
    @Column(name = "security_question", length = 200, nullable = false)
    private String securityQuestion;
    
    @NotEmpty(message = "Answer cannot be empty")
    @Column(name = "answer", length = 200, nullable = false)
    private String answer;
    
    @Column(name = "status", length = 20, nullable = false)
    private String status = "false";
    
    @Column(name = "user_role", nullable = false)
    private String userRole = "student"; // Default role is student

    // Timestamp fields for created_at and updated_at
    @Column(name = "created_at")
    private java.sql.Timestamp createdAt;
    
    @Column(name = "updated_at")
    private java.sql.Timestamp updatedAt;
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getMobileNumber() {
        return mobileNumber;
    }
    
    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }
    
    public String getStudentNumber() {
        return studentNumber;
    }
    
    public void setStudentNumber(String studentNumber) {
        this.studentNumber = studentNumber;
    }
    
    public String getStaffId() {
        return staffId;
    }
    
    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getSecurityQuestion() {
        return securityQuestion;
    }
    
    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }
    
    public String getAnswer() {
        return answer;
    }
    
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getUserRole() {
        return userRole;
    }
    
    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }
    
    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}