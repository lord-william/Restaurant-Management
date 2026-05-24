document.addEventListener('DOMContentLoaded', function() {
    // Get form elements
    const form = document.getElementById('registrationForm');
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const mobileNumberInput = document.getElementById('mobileNumber');
    const studentNumberInput = document.getElementById('address');
    const passwordInput = document.getElementById('password');
    const securityQuestionInput = document.getElementById('securityQuestion');
    const answerInput = document.getElementById('answer');
    const saveBtn = document.getElementById('saveBtn');
    
    // Email pattern validation
    const emailPattern = /^[a-zA-Z0-9]+[@]+[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+$/;
    // Mobile number pattern validation
    const mobileNumberPattern = /^[0-9]*$/;
    
    // Function to validate all fields
    function validateFields() {
        const isNameValid = nameInput.value.trim() !== '';
        const isEmailValid = emailInput.value.trim() !== '' && emailPattern.test(emailInput.value);
        const isMobileValid = mobileNumberInput.value.trim() !== '' && 
                            mobileNumberPattern.test(mobileNumberInput.value) && 
                            mobileNumberInput.value.length === 10;
        const isStudentNumberValid = studentNumberInput.value.trim() !== '' && 
                              /^[0-9]{9}$/.test(studentNumberInput.value);
        const isPasswordValid = passwordInput.value.trim() !== '';
        const isSecurityQuestionValid = securityQuestionInput.value.trim() !== '';
        const isAnswerValid = answerInput.value.trim() !== '';
        
        // Enable save button only if all fields are valid
        saveBtn.disabled = !(isNameValid && isEmailValid && isMobileValid && 
                           isStudentNumberValid && isPasswordValid && 
                           isSecurityQuestionValid && isAnswerValid);
    }
    
    // Add event listeners to all input fields
    nameInput.addEventListener('input', validateFields);
    emailInput.addEventListener('input', validateFields);
    mobileNumberInput.addEventListener('input', validateFields);
    studentNumberInput.addEventListener('input', validateFields);
    passwordInput.addEventListener('input', validateFields);
    securityQuestionInput.addEventListener('input', validateFields);
    answerInput.addEventListener('input', validateFields);
    
    // Add submit event listener to form
    form.addEventListener('submit', function(event) {
        validateFields();
        if (saveBtn.disabled) {
            event.preventDefault();
            alert('Please fill all fields correctly before submitting.');
        }
    });
    
    // Initially validate fields
    validateFields();
});
