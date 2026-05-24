<%-- 
    Document   : signup
    Created on : 10 Apr 2025, 01:05:20
    Author     : willi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full bg-white">
<head>
    <meta charset="UTF-8">
    <title>Restaurant Management System - Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-full">
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-sm">
            <img class="mx-auto h-24 w-auto" src="${pageContext.request.contextPath}/images/logo.png" alt="Restaurant Management">
            <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Create your account</h2>
        </div>

        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    <p>${error}</p>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    <p>${success}</p>
                </div>
            </c:if>
            
            <form class="space-y-6" action="${pageContext.request.contextPath}/register" method="POST" id="registrationForm">
                <!-- Name Field -->
                <div>
                    <label for="name" class="block text-sm/6 font-medium text-gray-900">Full Name</label>
                    <div class="mt-2">
                        <input type="text" name="name" id="name" autocomplete="name" required 
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                </div>
                
                <!-- Email Field -->
                <div>
                    <label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
                    <div class="mt-2">
                        <input type="email" name="email" id="email" autocomplete="email" required
                               pattern="^[a-zA-Z0-9]+[@]+[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+$" 
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                </div>
                
                <!-- Mobile Number Field -->
                <div>
                    <label for="mobileNumber" class="block text-sm/6 font-medium text-gray-900">Mobile Number</label>
                    <div class="mt-2">
                        <input type="text" name="mobileNumber" id="mobileNumber" 
                               pattern="^[0-9]{10}$" maxlength="10" required
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                </div>
                
                <!-- Student Number Field -->
                <div>
                    <label for="studentNumber" class="block text-sm/6 font-medium text-gray-900">Student Number</label>
                    <div class="mt-2">
                        <input type="text" name="studentNumber" id="studentNumber" 
                   pattern="^[0-9]{9}$" maxlength="9" required
                   placeholder="9 digits" 
                   class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                </div>
                
                <!-- Password Field with Requirements -->
                <div>
                    <label for="password" class="block text-sm/6 font-medium text-gray-900">Password</label>
                    <div class="mt-2">
                        <input type="password" name="password" id="password" autocomplete="new-password" required
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                    <!-- Password Requirements Checklist -->
                    <div class="mt-2 text-sm space-y-1" id="passwordRequirements">
                        <p class="text-gray-700 font-medium">Password must contain:</p>
                        <div class="flex items-center">
                            <span id="lengthCheck" class="inline-block w-5 h-5 mr-2 rounded-full border border-gray-300 text-center"></span>
                            <span>At least 8 characters</span>
                        </div>
                        <div class="flex items-center">
                            <span id="uppercaseCheck" class="inline-block w-5 h-5 mr-2 rounded-full border border-gray-300 text-center"></span>
                            <span>At least 1 uppercase letter</span>
                        </div>
                        <div class="flex items-center">
                            <span id="lowercaseCheck" class="inline-block w-5 h-5 mr-2 rounded-full border border-gray-300 text-center"></span>
                            <span>At least 1 lowercase letter</span>
                        </div>
                        <div class="flex items-center">
                            <span id="numberCheck" class="inline-block w-5 h-5 mr-2 rounded-full border border-gray-300 text-center"></span>
                            <span>At least 1 number</span>
                        </div>
                        <div class="flex items-center">
                            <span id="symbolCheck" class="inline-block w-5 h-5 mr-2 rounded-full border border-gray-300 text-center"></span>
                            <span>At least 1 special character</span>
                        </div>
                    </div>
                </div>
                
                <!-- Security Question Field with Dropdown -->
                <div>
                    <label for="securityQuestion" class="block text-sm/6 font-medium text-gray-900">Security Question</label>
                    <div class="mt-2">
                        <select name="securityQuestion" id="securityQuestion" required
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                            <option value="">Select a security question</option>
                            <option value="What was your childhood nickname?">What was your childhood nickname?</option>
                            <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                            <option value="In what city were you born?">In what city were you born?</option>
                            <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                            <option value="What was your favorite food as a child?">What was your favorite food as a child?</option>
                            <option value="What is the name of your first school?">What is the name of your first school?</option>
                            <option value="What is your favorite movie?">What is your favorite movie?</option>
                            <option value="What is your favorite color?">What is your favorite color?</option>
                            <option value="What is the make of your first car?">What is the make of your first car?</option>
                            <option value="What is the name of your favorite teacher?">What is the name of your favorite teacher?</option>
                        </select>
                    </div>
                </div>
                
                <!-- Answer Field -->
                <div>
                    <label for="answer" class="block text-sm/6 font-medium text-gray-900">Answer</label>
                    <div class="mt-2">
                        <input type="text" name="answer" id="answer" required
                               class="block w-full rounded-md border border-gray-300 bg-white px-3 py-1.5 text-gray-900 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                    </div>
                </div>
                
                <!-- Submit Button -->
                <div>
                    <button type="submit" id="saveBtn" disabled
                            class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 opacity-50 cursor-not-allowed">
                        Sign up
                    </button>
                </div>
                
                <!-- Clear Form Button -->
                <div>
                    <button type="reset" id="clearBtn"
                            class="flex w-full justify-center rounded-md bg-gray-200 px-3 py-1.5 text-sm/6 font-semibold text-gray-900 shadow-sm hover:bg-gray-300 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gray-400">
                        Clear Form
                    </button>
                </div>
            </form>
            
            <p class="mt-10 text-center text-sm/6 text-gray-500">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login.jsp" class="font-semibold text-indigo-600 hover:text-indigo-500">Sign in</a>
            </p>
            
            <p class="mt-2 text-center text-sm/6 text-gray-500">
                <a href="${pageContext.request.contextPath}/forgotPassword.jsp" class="font-semibold text-indigo-600 hover:text-indigo-500">Forgot password?</a>
            </p>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get form elements
            const form = document.getElementById('registrationForm');
            const nameInput = document.getElementById('name');
            const emailInput = document.getElementById('email');
            const mobileNumberInput = document.getElementById('mobileNumber');
            const addressInput = document.getElementById('address');
            const passwordInput = document.getElementById('password');
            const securityQuestionInput = document.getElementById('securityQuestion');
            const answerInput = document.getElementById('answer');
            const saveBtn = document.getElementById('saveBtn');
            
            // Password requirement elements
            const lengthCheck = document.getElementById('lengthCheck');
            const uppercaseCheck = document.getElementById('uppercaseCheck');
            const lowercaseCheck = document.getElementById('lowercaseCheck');
            const numberCheck = document.getElementById('numberCheck');
            const symbolCheck = document.getElementById('symbolCheck');
            
            // Email pattern validation
            const emailPattern = /^[a-zA-Z0-9]+[@]+[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+$/;
            // Mobile number pattern validation
            const mobileNumberPattern = /^[0-9]*$/;
            
            // Password validation patterns
            const lengthPattern = /.{8,}/;
            const uppercasePattern = /[A-Z]/;
            const lowercasePattern = /[a-z]/;
            const numberPattern = /[0-9]/;
            const symbolPattern = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
            
            // Function to validate password and update checklist
            function validatePassword() {
                const password = passwordInput.value;
                
                // Check length
                if (lengthPattern.test(password)) {
                    lengthCheck.classList.add('bg-green-500', 'text-white');
                    lengthCheck.classList.remove('border-gray-300');
                    lengthCheck.innerHTML = '✓';
                } else {
                    lengthCheck.classList.remove('bg-green-500', 'text-white');
                    lengthCheck.classList.add('border-gray-300');
                    lengthCheck.innerHTML = '';
                }
                
                // Check uppercase
                if (uppercasePattern.test(password)) {
                    uppercaseCheck.classList.add('bg-green-500', 'text-white');
                    uppercaseCheck.classList.remove('border-gray-300');
                    uppercaseCheck.innerHTML = '✓';
                } else {
                    uppercaseCheck.classList.remove('bg-green-500', 'text-white');
                    uppercaseCheck.classList.add('border-gray-300');
                    uppercaseCheck.innerHTML = '';
                }
                
                // Check lowercase
                if (lowercasePattern.test(password)) {
                    lowercaseCheck.classList.add('bg-green-500', 'text-white');
                    lowercaseCheck.classList.remove('border-gray-300');
                    lowercaseCheck.innerHTML = '✓';
                } else {
                    lowercaseCheck.classList.remove('bg-green-500', 'text-white');
                    lowercaseCheck.classList.add('border-gray-300');
                    lowercaseCheck.innerHTML = '';
                }
                
                // Check number
                if (numberPattern.test(password)) {
                    numberCheck.classList.add('bg-green-500', 'text-white');
                    numberCheck.classList.remove('border-gray-300');
                    numberCheck.innerHTML = '✓';
                } else {
                    numberCheck.classList.remove('bg-green-500', 'text-white');
                    numberCheck.classList.add('border-gray-300');
                    numberCheck.innerHTML = '';
                }
                
                // Check symbol
                if (symbolPattern.test(password)) {
                    symbolCheck.classList.add('bg-green-500', 'text-white');
                    symbolCheck.classList.remove('border-gray-300');
                    symbolCheck.innerHTML = '✓';
                } else {
                    symbolCheck.classList.remove('bg-green-500', 'text-white');
                    symbolCheck.classList.add('border-gray-300');
                    symbolCheck.innerHTML = '';
                }
                
                return lengthPattern.test(password) && 
                       uppercasePattern.test(password) && 
                       lowercasePattern.test(password) && 
                       numberPattern.test(password) && 
                       symbolPattern.test(password);
            }
            
            // Function to validate all fields
            function validateFields() {
                const isNameValid = nameInput.value.trim() !== '';
                const isEmailValid = emailInput.value.trim() !== '' && emailPattern.test(emailInput.value);
                const isMobileValid = mobileNumberInput.value.trim() !== '' && 
                                    mobileNumberPattern.test(mobileNumberInput.value) && 
                                    mobileNumberInput.value.length === 10;
                const isAddressValid = addressInput.value.trim() !== '';
                const isPasswordValid = validatePassword();
                const isSecurityQuestionValid = securityQuestionInput.value !== '';
                const isAnswerValid = answerInput.value.trim() !== '';
                
                // Enable save button only if all fields are valid
                saveBtn.disabled = !(isNameValid && isEmailValid && isMobileValid && 
                                   isAddressValid && isPasswordValid && 
                                   isSecurityQuestionValid && isAnswerValid);
                
                if (saveBtn.disabled) {
                    saveBtn.classList.add('opacity-50', 'cursor-not-allowed');
                } else {
                    saveBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                }
            }
            
            // Add event listeners to all input fields
            nameInput.addEventListener('input', validateFields);
            emailInput.addEventListener('input', validateFields);
            mobileNumberInput.addEventListener('input', validateFields);
            addressInput.addEventListener('input', validateFields);
            passwordInput.addEventListener('input', validateFields);
            securityQuestionInput.addEventListener('change', validateFields);
            answerInput.addEventListener('input', validateFields);
            
            // Add submit event listener to form
            form.addEventListener('submit', function(event) {
                validateFields();
                if (saveBtn.disabled) {
                    event.preventDefault();
                    alert('Please fill all fields correctly before submitting.');
                }
            });
            
            // Add reset event listener to clear button
            document.getElementById('clearBtn').addEventListener('click', function() {
                // Reset password requirement indicators
                lengthCheck.classList.remove('bg-green-500', 'text-white');
                lengthCheck.classList.add('border-gray-300');
                lengthCheck.innerHTML = '';
                
                uppercaseCheck.classList.remove('bg-green-500', 'text-white');
                uppercaseCheck.classList.add('border-gray-300');
                uppercaseCheck.innerHTML = '';
                
                lowercaseCheck.classList.remove('bg-green-500', 'text-white');
                lowercaseCheck.classList.add('border-gray-300');
                lowercaseCheck.innerHTML = '';
                
                numberCheck.classList.remove('bg-green-500', 'text-white');
                numberCheck.classList.add('border-gray-300');
                numberCheck.innerHTML = '';
                
                symbolCheck.classList.remove('bg-green-500', 'text-white');
                symbolCheck.classList.add('border-gray-300');
                symbolCheck.innerHTML = '';
                
                // Disable save button
                saveBtn.disabled = true;
                saveBtn.classList.add('opacity-50', 'cursor-not-allowed');
            });
            
            // Initially validate fields
            validateFields();
        });
    </script>
</body>
</html>