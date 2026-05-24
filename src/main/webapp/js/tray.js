// Tray functionality for Restaurant Management System
let trayItems = [];

// Initialize tray from localStorage if available
function initializeTray() {
    const savedTray = localStorage.getItem('restaurantTray');
    if (savedTray) {
        try {
            trayItems = JSON.parse(savedTray);
            updateTrayCount();
        } catch (e) {
            console.error('Error loading saved tray:', e);
            trayItems = [];
        }
    }
}

// Add item to tray
function addToTray(item, quantity = 1) {
    // Check if item is already in tray
    const existingItem = trayItems.find(i => 
        i.id === item.id && 
        i.category === item.category && 
        i.flavor === item.flavor
    );
    
    if (existingItem) {
        existingItem.quantity += quantity;
    } else {
        // Create a new tray item
        const trayItem = {
            id: item.id,
            name: item.name,
            price: item.price,
            image: item.image,
            category: item.category,
            quantity: quantity,
            flavor: item.flavor || null
        };
        trayItems.push(trayItem);
    }
    
    // Save to localStorage and update UI
    saveTray();
    updateTrayCount();
    
    // Show notification
    showTrayNotification(item.name + ' added to your tray');
}

// Remove item from tray
function removeFromTray(index) {
    if (index >= 0 && index < trayItems.length) {
        trayItems.splice(index, 1);
        saveTray();
        updateTrayCount();
        renderTrayItems();
    }
}

// Update item quantity
function updateTrayItemQuantity(index, newQuantity) {
    if (index >= 0 && index < trayItems.length) {
        if (newQuantity <= 0) {
            removeFromTray(index);
        } else {
            trayItems[index].quantity = newQuantity;
            saveTray();
            renderTrayItems();
        }
    }
    updateTrayCount();
}

// Save tray to localStorage
function saveTray() {
    localStorage.setItem('restaurantTray', JSON.stringify(trayItems));
}

// Update tray icon count
function updateTrayCount() {
    const trayCount = document.getElementById('tray-count');
    if (trayCount) {
        const totalItems = trayItems.reduce((sum, item) => sum + item.quantity, 0);
        trayCount.textContent = totalItems;
        
        // Toggle visibility based on whether there are items
        if (totalItems > 0) {
            trayCount.classList.remove('hidden');
        } else {
            trayCount.classList.add('hidden');
        }
    }
}

// Show tray modal
function showTrayModal() {
    renderTrayItems();
    document.getElementById('tray-modal').classList.remove('hidden');
}

// Hide tray modal
function hideTrayModal() {
    document.getElementById('tray-modal').classList.add('hidden');
}

// Render items in tray modal
function renderTrayItems() {
    const trayContent = document.getElementById('tray-items-container');
    const trayTotal = document.getElementById('tray-total');
    
    if (!trayContent) return;
    
    if (trayItems.length === 0) {
        trayContent.innerHTML = '<div class="text-center py-8"><p class="text-gray-400">Your tray is empty</p></div>';
        trayTotal.textContent = 'R0.00';
        return;
    }
    
    let total = 0;
    let html = '';
    
    trayItems.forEach((item, index) => {
        const itemTotal = item.price * item.quantity;
        total += itemTotal;
        
        html += '<div class="flex items-center py-4 border-b border-gray-700">' +
                  '<img src="' + pageContextPath + item.image + '" alt="' + item.name + '" class="w-16 h-16 object-cover rounded">' +
                  '<div class="ml-4 flex-grow">' +
                    '<h4 class="font-medium">' + item.name + '</h4>' +
                    (item.flavor ? '<p class="text-sm text-gray-400">Flavor: ' + item.flavor + '</p>' : '') +
                    '<p class="text-amber-500">R' + item.price.toFixed(2) + ' each</p>' +
                  '</div>' +
                  '<div class="flex items-center">' +
                    '<button onclick="updateTrayItemQuantity(' + index + ', ' + (item.quantity - 1) + ')" class="w-8 h-8 flex items-center justify-center bg-gray-700 hover:bg-gray-600 rounded-l">' +
                      '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">' +
                        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />' +
                      '</svg>' +
                    '</button>' +
                    '<span class="w-10 text-center bg-gray-800">' + item.quantity + '</span>' +
                    '<button onclick="updateTrayItemQuantity(' + index + ', ' + (item.quantity + 1) + ')" class="w-8 h-8 flex items-center justify-center bg-gray-700 hover:bg-gray-600 rounded-r">' +
                      '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">' +
                        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />' +
                      '</svg>' +
                    '</button>' +
                    '<span class="ml-4 w-20 text-right">R' + itemTotal.toFixed(2) + '</span>' +
                    '<button onclick="removeFromTray(' + index + ')" class="ml-2 text-red-500 hover:text-red-400">' +
                      '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">' +
                        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />' +
                      '</svg>' +
                    '</button>' +
                  '</div>' +
                '</div>';
    });
    
    trayContent.innerHTML = html;
    trayTotal.textContent = 'R' + total.toFixed(2);
}

// Show notification when adding items
function showTrayNotification(message) {
    const notification = document.getElementById('tray-notification');
    const notificationText = document.getElementById('tray-notification-text');
    
    if (notification && notificationText) {
        notificationText.textContent = message;
        notification.classList.remove('hidden');
        notification.classList.add('animate-slide-in');
        
        // Hide after 3 seconds
        setTimeout(() => {
            notification.classList.remove('animate-slide-in');
            notification.classList.add('animate-slide-out');
            setTimeout(() => {
                notification.classList.add('hidden');
                notification.classList.remove('animate-slide-out');
            }, 300);
        }, 3000);
    }
}

// Clear entire tray
function clearTray() {
    trayItems = [];
    saveTray();
    updateTrayCount();
    renderTrayItems();
}

// Initialize when the document is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeTray();
    
    // Set up tray icon click
    const trayIcon = document.getElementById('tray-icon');
    if (trayIcon) {
        trayIcon.addEventListener('click', showTrayModal);
    }
    
    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        const trayModal = document.getElementById('tray-modal');
        if (event.target === trayModal) {
            hideTrayModal();
        }
    });
});

// Proceed to checkout
function proceedToCheckout() {
    if (trayItems.length === 0) {
        showTrayNotification('Your tray is empty. Add some items first!');
        return;
    }
    
    // Check if user is logged in
    const userLoggedIn = document.body.classList.contains('user-logged-in');
    
    if (!userLoggedIn) {
        // Redirect to login with return URL
        const returnUrl = encodeURIComponent(window.location.pathname);
        window.location.href = pageContextPath + '/login?redirect=' + returnUrl;
    } else {
        // Proceed to checkout page
        window.location.href = pageContextPath + '/checkout';
    }
}
