/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// Minimal test JavaScript file - Put this in js/test_dashboard.js
console.log('JavaScript file loaded successfully!');

// Wait for DOM to load
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded - Ready to add functionality');
    
    // Test: Add click handlers to all buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            console.log('Button clicked:', this);
            
            // If it's an approve button
            if (this.classList.contains('btn-success')) {
                e.preventDefault();
                console.log('Approve button clicked');
                alert('Approve button clicked - JavaScript is working!');
            }
            
            // If it's a delete button
            if (this.classList.contains('btn-danger')) {
                e.preventDefault();
                console.log('Delete button clicked');
                alert('Delete button clicked - JavaScript is working!');
            }
            
            // If it's a promote button
            if (this.classList.contains('btn-warning')) {
                e.preventDefault();
                console.log('Promote button clicked');
                alert('Promote button clicked - JavaScript is working!');
            }
        });
    });
    
    // Test: Add functionality to tabs
    const tabs = document.querySelectorAll('.nav-link');
    tabs.forEach(function(tab) {
        tab.addEventListener('click', function(e) {
            console.log('Tab clicked:', this);
        });
    });
    
    // Show a message to confirm JavaScript is loaded
    setTimeout(function() {
        const message = document.createElement('div');
        message.innerHTML = '<div class="alert alert-success">JavaScript loaded successfully!</div>';
        message.style.position = 'fixed';
        message.style.top = '10px';
        message.style.right = '10px';
        message.style.zIndex = '9999';
        document.body.appendChild(message);
        
        // Remove message after 3 seconds
        setTimeout(function() {
            message.remove();
        }, 3000);
    }, 1000);
});