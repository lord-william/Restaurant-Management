package com.mycompany.restaurantmanagement.dto;

/**
 * Data Transfer Object for dashboard statistics
 * Used to transfer dashboard statistics from the DAO to controllers
 */
public class DashboardStats {
    private int totalUsers;
    private int studentCount;
    private int staffCount;
    private int ordersToday;
    private double revenueToday;
    private int ordersThisMonth;
    private double revenueThisMonth;
    private int pendingApprovals;

    public DashboardStats() {
    }

    public DashboardStats(int totalUsers, int studentCount, int staffCount, int ordersToday, 
                        double revenueToday, int ordersThisMonth, double revenueThisMonth, int pendingApprovals) {
        this.totalUsers = totalUsers;
        this.studentCount = studentCount;
        this.staffCount = staffCount;
        this.ordersToday = ordersToday;
        this.revenueToday = revenueToday;
        this.ordersThisMonth = ordersThisMonth;
        this.revenueThisMonth = revenueThisMonth;
        this.pendingApprovals = pendingApprovals;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

    public int getStaffCount() {
        return staffCount;
    }

    public void setStaffCount(int staffCount) {
        this.staffCount = staffCount;
    }

    public int getOrdersToday() {
        return ordersToday;
    }

    public void setOrdersToday(int ordersToday) {
        this.ordersToday = ordersToday;
    }

    public double getRevenueToday() {
        return revenueToday;
    }

    public void setRevenueToday(double revenueToday) {
        this.revenueToday = revenueToday;
    }

    public int getOrdersThisMonth() {
        return ordersThisMonth;
    }

    public void setOrdersThisMonth(int ordersThisMonth) {
        this.ordersThisMonth = ordersThisMonth;
    }

    public double getRevenueThisMonth() {
        return revenueThisMonth;
    }

    public void setRevenueThisMonth(double revenueThisMonth) {
        this.revenueThisMonth = revenueThisMonth;
    }

    public int getPendingApprovals() {
        return pendingApprovals;
    }

    public void setPendingApprovals(int pendingApprovals) {
        this.pendingApprovals = pendingApprovals;
    }
}
