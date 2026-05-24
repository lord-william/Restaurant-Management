// Checkout functionality for Restaurant Management System

// Initialize when the page loads
document.addEventListener('DOMContentLoaded', function() {
    // Load order items from tray
    loadOrderItems();
    
    // Update totals
    updateOrderTotals();
    
    // Setup delivery option toggle
    setupDeliveryToggle();
    
    // Setup payment method toggle
    setupPaymentMethodToggle();
    
    // Setup place order button
    document.getElementById('place-order-button').addEventListener('click', placeOrder);
});

// Load order items from tray
function loadOrderItems() {
    const orderItemsContainer = document.getElementById('order-items');
    if (!orderItemsContainer) return;
    
    // Get items from localStorage
    const savedTray = localStorage.getItem('restaurantTray');
    if (!savedTray) {
        orderItemsContainer.innerHTML = '<div class="text-center py-8"><p class="text-gray-400">Your order is empty</p></div>';
        return;
    }
    
    let trayItems = JSON.parse(savedTray);
    if (trayItems.length === 0) {
        orderItemsContainer.innerHTML = '<div class="text-center py-8"><p class="text-gray-400">Your order is empty</p></div>';
        return;
    }
    
    // Build HTML for order items
    let html = '<div class="space-y-4">';
    
    trayItems.forEach((item) => {
        const itemTotal = item.price * item.quantity;
        
        html += `
            <div class="flex items-center py-2">
                <span class="font-medium">${item.quantity}x</span>
                <div class="ml-4 flex-grow">
                    <span class="font-medium">${item.name}</span>
                    ${item.flavor ? `<span class="text-sm text-gray-500 block">Flavor: ${item.flavor}</span>` : ''}
                </div>
                <span class="font-medium">R${itemTotal.toFixed(2)}</span>
            </div>
        `;
    });
    
    html += '</div>';
    orderItemsContainer.innerHTML = html;
}

// Update order totals
function updateOrderTotals() {
    // Get delivery option
    const isDelivery = document.querySelector('input[name="delivery-option"][value="delivery"]').checked;
    const deliveryFee = isDelivery ? 10 : 0;
    
    // Get items from localStorage
    const savedTray = localStorage.getItem('restaurantTray');
    if (!savedTray) return;
    
    let trayItems = JSON.parse(savedTray);
    
    // Calculate subtotal
    const subtotal = trayItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    
    // Calculate service fee (5% of subtotal)
    const serviceFee = subtotal * 0.05;
    
    // Calculate total
    const total = subtotal + serviceFee + deliveryFee;
    
    // Update display
    document.getElementById('subtotal').textContent = `R${subtotal.toFixed(2)}`;
    document.getElementById('service-fee').textContent = `R${serviceFee.toFixed(2)}`;
    document.getElementById('total').textContent = `R${total.toFixed(2)}`;
}

// Set up delivery option toggle
function setupDeliveryToggle() {
    const deliveryOptions = document.querySelectorAll('input[name="delivery-option"]');
    const deliveryAddressSection = document.getElementById('delivery-address');
    
    deliveryOptions.forEach(option => {
        option.addEventListener('change', function() {
            if (this.value === 'delivery') {
                deliveryAddressSection.classList.remove('hidden');
            } else {
                deliveryAddressSection.classList.add('hidden');
            }
            
            // Update totals when delivery option changes
            updateOrderTotals();
        });
    });
}

// Set up payment method toggle
function setupPaymentMethodToggle() {
    const paymentMethods = document.querySelectorAll('input[name="payment-method"]');
    const cardDetailsSection = document.getElementById('card-details');
    
    paymentMethods.forEach(method => {
        method.addEventListener('change', function() {
            if (this.value === 'card') {
                cardDetailsSection.classList.remove('hidden');
            } else {
                cardDetailsSection.classList.add('hidden');
            }
        });
    });
}

// Place order
function placeOrder() {
    // Get order data from localStorage
    const savedTray = localStorage.getItem('restaurantTray');
    if (!savedTray || JSON.parse(savedTray).length === 0) {
        alert('Your order is empty. Please add items to your order.');
        return;
    }
    
    // Get delivery option
    const isDelivery = document.querySelector('input[name="delivery-option"][value="delivery"]').checked;
    
    // Validate delivery address if delivery option is selected
    if (isDelivery) {
        const deliveryAddress = document.getElementById('address-input').value.trim();
        if (!deliveryAddress) {
            alert('Please enter your delivery address.');
            return;
        }
    }
    
    // Get payment method
    const paymentMethod = document.querySelector('input[name="payment-method"]:checked').value;
    
    // Validate card details if card payment is selected
    if (paymentMethod === 'card') {
        const cardNumber = document.getElementById('card-number').value.trim();
        const cardExpiry = document.getElementById('card-expiry').value.trim();
        const cardCVV = document.getElementById('card-cvv').value.trim();
        const cardName = document.getElementById('card-name').value.trim();
        
        if (!cardNumber || !cardExpiry || !cardCVV || !cardName) {
            alert('Please fill in all card details.');
            return;
        }
        
        // Basic card number validation
        if (!/^\d{16}$/.test(cardNumber.replace(/\s/g, ''))) {
            alert('Please enter a valid 16-digit card number.');
            return;
        }
        
        // Basic expiry date validation (MM/YY format)
        if (!/^\d{2}\/\d{2}$/.test(cardExpiry)) {
            alert('Please enter expiry date in MM/YY format.');
            return;
        }
        
        // Basic CVV validation (3 or 4 digits)
        if (!/^\d{3,4}$/.test(cardCVV)) {
            alert('Please enter a valid CVV.');
            return;
        }
    }
    
    // Prepare order data
    const orderData = {
        items: JSON.parse(savedTray),
        delivery: isDelivery,
        address: isDelivery ? document.getElementById('address-input').value.trim() : '',
        paymentMethod: paymentMethod,
        // Calculate totals
        subtotal: calculateSubtotal(),
        serviceFee: calculateServiceFee(),
        deliveryFee: isDelivery ? 10 : 0,
        total: calculateTotal()
    };
    
    // Submit order to the server
    submitOrder(orderData);
}

// Calculate subtotal
function calculateSubtotal() {
    const savedTray = localStorage.getItem('restaurantTray');
    if (!savedTray) return 0;
    
    let trayItems = JSON.parse(savedTray);
    return trayItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
}

// Calculate service fee
function calculateServiceFee() {
    return calculateSubtotal() * 0.05;
}

// Calculate total
function calculateTotal() {
    const isDelivery = document.querySelector('input[name="delivery-option"][value="delivery"]').checked;
    const deliveryFee = isDelivery ? 10 : 0;
    
    return calculateSubtotal() + calculateServiceFee() + deliveryFee;
}

// Submit order to the server
function submitOrder(orderData) {
    // Show loading state
    const orderButton = document.getElementById('place-order-button');
    const originalText = orderButton.textContent;
    orderButton.disabled = true;
    orderButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Processing...';
    
    // Send data to the OrderServlet using fetch API
    fetch(pageContextPath + '/api/orders', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(orderData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        // Show order number
        document.getElementById('order-number').textContent = data.orderNumber;
        
        // Show confirmation modal
        document.getElementById('confirmation-modal').classList.remove('hidden');
        
        // Clear the tray
        localStorage.removeItem('restaurantTray');
    })
    .catch(error => {
        // If there's an error (e.g., user not logged in), handle it
        console.error('Order error:', error);
        
        // If user not logged in, redirect to login page
        if (error.message.includes('User not logged in') || error.message.includes('401')) {
            const returnUrl = encodeURIComponent(window.location.pathname);
            window.location.href = pageContextPath + '/login?redirect=' + returnUrl;
            return;
        }
        
        alert('There was a problem with your order: ' + error.message);
    })
    .finally(() => {
        // Reset button state
        orderButton.disabled = false;
        orderButton.textContent = originalText;
    });
}
