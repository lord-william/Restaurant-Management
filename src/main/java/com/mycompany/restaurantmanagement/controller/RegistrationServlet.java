package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
import com.mycompany.restaurantmanagement.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

public class RegistrationServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    // Password validation patterns
    private static final Pattern LENGTH_PATTERN = Pattern.compile(".{8,}");
    private static final Pattern UPPERCASE_PATTERN = Pattern.compile(".*[A-Z].*");
    private static final Pattern LOWERCASE_PATTERN = Pattern.compile(".*[a-z].*");
    private static final Pattern NUMBER_PATTERN = Pattern.compile(".*[0-9].*");
    private static final Pattern SYMBOL_PATTERN = Pattern.compile(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to signup JSP page
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from request
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobileNumber = request.getParameter("mobileNumber");
        String userType = request.getParameter("userType");
        String studentNumber = request.getParameter("studentNumber");
        String staffId = request.getParameter("staffId");
        String password = request.getParameter("password");
        String securityQuestion = request.getParameter("securityQuestion");
        String answer = request.getParameter("answer");
        
        // Validation
        boolean isValid = validateInput(name, email, mobileNumber, userType, studentNumber, staffId, password, securityQuestion, answer);
        
        if (!isValid) {
            request.setAttribute("error", "Please check your input and try again");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if email already exists
            User existingUser = userDao.findByEmail(email);
            if (existingUser != null) {
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Integrate with Supabase Auth
            String authId = com.mycompany.restaurantmanagement.util.SupabaseAuthService.signUp(email, password);
            if (authId == null) {
                request.setAttribute("error", "Failed to register with authentication server. Email might be in use or invalid.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setMobileNumber(mobileNumber);
            
            // Set either student number or staff ID based on user type
            if ("student".equals(userType)) {
                user.setStudentNumber(studentNumber);
            } else if ("staff".equals(userType)) {
                user.setStaffId(staffId);
            }
            
            user.setPassword(password); // In a real app, hash the password
            user.setSecurityQuestion(securityQuestion);
            user.setAnswer(answer);
            
            // Set status based on user type - students are automatically approved, staff needs admin approval
            if ("student".equals(userType)) {
                user.setStatus("true"); // Automatically approve students
                user.setUserRole("student");
                request.setAttribute("success", "Registered successfully. You can now log in.");
            } else {
                user.setStatus("pending"); // Staff needs approval
                user.setUserRole("staff");
                request.setAttribute("success", "Registered successfully. Wait for admin approval.");
            }
            
            userDao.save(user);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error registering user: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    private boolean validateInput(String name, String email, String mobileNumber, String userType, 
                                String studentNumber, String staffId, String password, 
                                String securityQuestion, String answer) {
        // Basic validation
        if (name == null || name.isEmpty() ||
            email == null || email.isEmpty() ||
            mobileNumber == null || mobileNumber.isEmpty() ||
            userType == null || userType.isEmpty() ||
            password == null || password.isEmpty() ||
            securityQuestion == null || securityQuestion.isEmpty() ||
            answer == null || answer.isEmpty()) {
            return false;
        }
        
        // Validate user type specific fields
        if ("student".equals(userType)) {
            if (studentNumber == null || studentNumber.isEmpty() || !studentNumber.matches("^[0-9]{9}$")) {
                return false;
            }
        } else if ("staff".equals(userType)) {
            if (staffId == null || staffId.isEmpty() || !staffId.matches("^[A-Z0-9]{6}$")) {
                return false;
            }
        } else {
            return false; // Invalid user type
        }
        
        // Email pattern validation
        String emailPattern = "^[a-zA-Z0-9]+[@]+[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+$";
        if (!email.matches(emailPattern)) {
            return false;
        }
        
        // Mobile number pattern validation
        String mobileNumberPattern = "^[0-9]*$";
        if (!mobileNumber.matches(mobileNumberPattern) || mobileNumber.length() != 10) {
            return false;
        }
        
        // Password complexity validation
        if (!isPasswordValid(password)) {
            return false;
        }
        
        return true;
    }
    
    private boolean isPasswordValid(String password) {
        return LENGTH_PATTERN.matcher(password).matches() &&
               UPPERCASE_PATTERN.matcher(password).matches() &&
               LOWERCASE_PATTERN.matcher(password).matches() &&
               NUMBER_PATTERN.matcher(password).matches() &&
               SYMBOL_PATTERN.matcher(password).matches();
    }
}