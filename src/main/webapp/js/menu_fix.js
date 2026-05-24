// UMP-themed Menu Loading Script
document.addEventListener('DOMContentLoaded', function() {
    console.log('UMP-themed menu loading...');
    
    // Create a direct function to load and display menu items
    async function loadAndDisplayMenu() {
        try {
            const menuContainer = document.getElementById('menu-items');
            if (!menuContainer) {
                console.error('Menu container not found');
                return;
            }
            
            // Clear existing content with UMP-branded loading spinner
            menuContainer.innerHTML = '<div class="col-span-3 text-center py-8"><div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#034694] mx-auto"></div><p class="mt-4 text-[#034694] font-medium">Loading menu items...</p></div>';
            
            // Try to load all menu categories
            let allMenuItems = [];
            const categories = ['treats', 'meals', 'beverages', 'breakfast', 'vegetarian'];
            
            for (const category of categories) {
                try {
                    const response = await fetch(pageContextPath + '/data/menu/' + category + '.json');
                    if (response.ok) {
                        const data = await response.json();
                        if (data && data.items && Array.isArray(data.items)) {
                            allMenuItems = [...allMenuItems, ...data.items];
                        }
                    }
                } catch (err) {
                    console.warn(`Could not load ${category} items`, err);
                }
            }
            
            if (allMenuItems.length === 0) {
                throw new Error('No menu items could be loaded');
            }
            
            console.log('Successfully loaded menu items:', allMenuItems.length);
            
            // Clear container for new items
            menuContainer.innerHTML = '';
            
            // Display menu items by creating proper DOM elements with UMP theming
            allMenuItems.forEach(item => {
                // Create main card div
                const card = document.createElement('div');
                card.className = 'bg-gray-900 rounded-lg overflow-hidden shadow-md hover:shadow-lg transition duration-300 border border-gray-700';
                
                // Create image
                const imgDiv = document.createElement('div');
                imgDiv.className = 'relative';
                
                const img = document.createElement('img');
                img.src = pageContextPath + item.image;
                img.alt = item.name;
                img.className = 'w-full h-48 object-cover';
                imgDiv.appendChild(img);
                
                // Add UMP accent bar 
                const accentBar = document.createElement('div');
                accentBar.className = 'h-1.5 bg-[#034694]';
                
                // Category badge if available
                if (item.category) {
                    const badge = document.createElement('span');
                    badge.className = 'absolute top-2 right-2 bg-[#034694] text-white text-xs px-2 py-1 rounded-md uppercase';
                    badge.textContent = item.category;
                    imgDiv.appendChild(badge);
                }
                
                // Vegetarian badge if applicable
                if (item.type === 'vegetarian') {
                    const vegBadge = document.createElement('span');
                    vegBadge.className = 'absolute top-2 left-2 bg-green-600 text-white text-xs px-2 py-1 rounded-md';
                    vegBadge.textContent = 'Vegetarian';
                    imgDiv.appendChild(vegBadge);
                }
                
                // Content container
                const content = document.createElement('div');
                content.className = 'p-4';
                
                // Title and price row
                const titleRow = document.createElement('div');
                titleRow.className = 'flex justify-between items-center mb-3';
                
                const title = document.createElement('h3');
                title.className = 'text-xl font-semibold text-white';
                title.textContent = item.name;
                
                const price = document.createElement('span');
                price.className = 'text-white font-bold text-lg bg-gray-800 px-2 py-1 rounded';
                price.textContent = `R${item.price.toFixed(2)}`;
                
                titleRow.appendChild(title);
                titleRow.appendChild(price);
                
                // Description
                const desc = document.createElement('p');
                desc.className = 'text-gray-300 text-sm mb-3';
                desc.textContent = item.description;
                
                // Restaurant availability badges
                const badgesRow = document.createElement('div');
                badgesRow.className = 'flex flex-wrap gap-1 mb-3';
                
                if (item.availableAt) {
                    const locations = {
                        1: "Great Hall",
                        2: "Building 13",
                        3: "Mumasi"
                    };
                    
                    if (Array.isArray(item.availableAt)) {
                        item.availableAt.forEach(locationId => {
                            const locationBadge = document.createElement('span');
                            locationBadge.className = 'text-xs bg-gray-200 text-gray-700 px-2 py-1 rounded-md';
                            locationBadge.textContent = locations[locationId] || `Location ${locationId}`;
                            badgesRow.appendChild(locationBadge);
                        });
                    } else {
                        const locationBadge = document.createElement('span');
                        locationBadge.className = 'text-xs bg-gray-200 text-gray-700 px-2 py-1 rounded-md';
                        locationBadge.textContent = locations[item.availableAt] || `Location ${item.availableAt}`;
                        badgesRow.appendChild(locationBadge);
                    }
                }
                
                // Add to tray button and quantity controls
                const controlsRow = document.createElement('div');
                controlsRow.className = 'mt-4 flex items-center justify-between';
                
                // Quantity selector
                const quantityControls = document.createElement('div');
                quantityControls.className = 'flex items-center';
                
                const decreaseBtn = document.createElement('button');
                decreaseBtn.className = 'w-8 h-8 flex items-center justify-center bg-gray-200 hover:bg-gray-300 rounded-l-md';
                decreaseBtn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd" /></svg>';
                
                const quantityDisplay = document.createElement('span');
                quantityDisplay.className = 'w-10 h-8 flex items-center justify-center bg-gray-100 text-gray-800';
                quantityDisplay.textContent = '1';
                
                const increaseBtn = document.createElement('button');
                increaseBtn.className = 'w-8 h-8 flex items-center justify-center bg-gray-200 hover:bg-gray-300 rounded-r-md';
                increaseBtn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" /></svg>';
                
                // Add event listeners for quantity buttons
                decreaseBtn.addEventListener('click', function() {
                    let qty = parseInt(quantityDisplay.textContent);
                    if (qty > 1) {
                        quantityDisplay.textContent = qty - 1;
                    }
                });
                
                increaseBtn.addEventListener('click', function() {
                    let qty = parseInt(quantityDisplay.textContent);
                    quantityDisplay.textContent = qty + 1;
                });
                
                quantityControls.appendChild(decreaseBtn);
                quantityControls.appendChild(quantityDisplay);
                quantityControls.appendChild(increaseBtn);
                
                // Add to tray button
                const addButton = document.createElement('button');
                addButton.className = 'bg-[#034694] text-white px-4 py-2 rounded-md hover:bg-blue-800 transition duration-200 flex-grow ml-4';
                addButton.textContent = 'Add to Tray';
                
                // Add event listener for add button
                addButton.addEventListener('click', function() {
                    const quantity = parseInt(quantityDisplay.textContent);
                    // If addToTray function exists, call it
                    if (typeof addToTray === 'function') {
                        addToTray(item, quantity);
                        
                        // Show success feedback
                        const originalText = addButton.textContent;
                        addButton.textContent = 'Added! ✓';
                        addButton.classList.remove('bg-[#034694]');
                        addButton.classList.add('bg-green-600');
                        
                        setTimeout(() => {
                            addButton.textContent = originalText;
                            addButton.classList.remove('bg-green-600');
                            addButton.classList.add('bg-[#034694]');
                            // Reset quantity
                            quantityDisplay.textContent = '1';
                        }, 1500);
                    } else {
                        console.warn('addToTray function not found');
                    }
                });
                
                controlsRow.appendChild(quantityControls);
                controlsRow.appendChild(addButton);
                
                // Build the card structure
                content.appendChild(titleRow);
                content.appendChild(desc);
                content.appendChild(badgesRow);
                content.appendChild(controlsRow);
                
                card.appendChild(imgDiv);
                card.appendChild(accentBar);
                card.appendChild(content);
                
                // Add the card to the container
                menuContainer.appendChild(card);
            });
            
        } catch (error) {
            console.error('Error in menu fix:', error);
            const menuContainer = document.getElementById('menu-items');
            if (menuContainer) {
                menuContainer.innerHTML = `
                    <div class="col-span-3 text-center py-8">
                        <p class="text-[#034694] bg-blue-50 p-4 rounded-lg inline-block">Failed to load menu items. ${error.message}</p>
                    </div>
                `;
            }
        }
    }
    
    // Run our direct menu loading function
    loadAndDisplayMenu();
    
    // Update category button styles to match UMP theme
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.classList.remove('text-gray-300', 'hover:text-[#034694]');
        btn.classList.add('hover:text-[#034694]', 'text-gray-500', 'transition-colors', 'duration-200');
    });
    
    // Make the active tab clearly visible with UMP blue
    const activeBtn = document.querySelector('.category-btn.text-\\[\\#034694\\]');
    if (activeBtn) {
        activeBtn.classList.add('border-b-2', 'border-[#034694]', 'font-bold');
    }
    
    // Handle category buttons by delegating to menu-items container parent
    document.querySelector('.container').addEventListener('click', function(e) {
        // Check if clicked element is a category button
        if (e.target.classList.contains('category-btn')) {
            // Prevent default action
            e.preventDefault();
            
            // Update button styles
            document.querySelectorAll('.category-btn').forEach(btn => {
                btn.classList.remove('text-[#034694]', 'border-b-2', 'border-[#034694]', 'font-bold');
                btn.classList.add('text-gray-500');
            });
            
            e.target.classList.remove('text-gray-500');
            e.target.classList.add('text-[#034694]', 'border-b-2', 'border-[#034694]', 'font-bold');
            
            // Update our menu with the new items
            loadAndDisplayMenu();
        }
    });
});
