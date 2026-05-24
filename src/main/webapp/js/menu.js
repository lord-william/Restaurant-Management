// Global storage for menu data
let allMenuData = {};
let currentCategory = 'all';
// Note: pageContextPath is set in menu.jsp, don't redeclare it here

// Initialize when the page loads
document.addEventListener('DOMContentLoaded', function() {
    // Load all menu data
    loadAllMenuData();
    
    // Set up mobile menu toggle
    document.getElementById('mobile-menu-button')?.addEventListener('click', function() {
        const mobileMenu = document.getElementById('mobile-menu');
        mobileMenu.classList.toggle('hidden');
    });
    
    // Set up restaurant filter
    document.getElementById('restaurant-filter')?.addEventListener('change', function() {
        if (currentCategory === 'specials') {
            loadSpecials();
        } else {
            displayMenuItems(currentCategory);
        }
    });
    
    // Set up filter toggle button
    document.getElementById('filter-toggle')?.addEventListener('click', function() {
        const filterPanel = document.getElementById('filter-panel');
        filterPanel.classList.toggle('hidden');
    });
    
    // Set up apply filters button
    document.getElementById('apply-filters')?.addEventListener('click', function() {
        if (currentCategory === 'specials') {
            loadSpecials();
        } else {
            displayMenuItems(currentCategory);
        }
        // Hide the filter panel after applying
        document.getElementById('filter-panel').classList.add('hidden');
    });
});

// Load all menu categories
async function loadAllMenuData() {
    try {
        const categories = ['treats', 'meals', 'beverages', 'breakfast', 'vegetarian', 'specials'];
        console.log('Starting to load menu data with context path:', pageContextPath);
        
        for (const category of categories) {
            const url = pageContextPath + '/data/menu/' + category + '.json';
            console.log('Fetching category:', category, 'from URL:', url);
            
            const response = await fetch(url);
            if (!response.ok) {
                console.error('Failed to load', category, 'data. Status:', response.status);
                throw new Error('Failed to load ' + category + ' data');
            }
            
            allMenuData[category] = await response.json();
            console.log('Successfully loaded', category, 'with', allMenuData[category].items.length, 'items');
        }
        
        console.log('All menu data loaded successfully:', Object.keys(allMenuData));
        // Once all data is loaded, display the initial "all" category
        displayMenuItems('all');
    } catch (error) {
        console.error('Error loading menu data:', error);
        document.getElementById('menu-items').innerHTML = 
            '<div class="col-span-2 text-center py-8">' +
                '<p class="text-red-500">Failed to load menu data. Please try again later.</p>' +
            '</div>';
    }
}

// Filter menu by category
function filterCategory(category) {
    currentCategory = category;
    
    // Update active tab
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.classList.remove('text-blue-700', 'border-b-2', 'border-blue-700');
        btn.classList.add('text-gray-300');
    });
    
    const activeBtn = document.querySelector('.category-btn[onclick*="' + category + '"]');
    activeBtn.classList.remove('text-gray-300');
    activeBtn.classList.add('text-blue-700', 'border-b-2', 'border-blue-700');
    
    // Show/hide specials section
    const specialsSection = document.getElementById('specials-content');
    const menuItemsSection = document.getElementById('menu-items');
    
    if (category === 'specials') {
        specialsSection.classList.remove('hidden');
        menuItemsSection.classList.add('hidden');
        loadSpecials();
    } else {
        specialsSection.classList.add('hidden');
        menuItemsSection.classList.remove('hidden');
        displayMenuItems(category);
    }
}

// Display menu items for the selected category
function displayMenuItems(category) {
    console.log('Displaying menu items for category:', category);
    const menuContainer = document.getElementById('menu-items');
    const restaurantFilter = document.getElementById('restaurant-filter')?.value || 'all';
    
    if (!menuContainer) {
        console.error('Menu container element not found!');
        return;
    }
    
    console.log('Restaurant filter value:', restaurantFilter);
    
    menuContainer.innerHTML = 
        '<div class="flex justify-center items-center col-span-2 py-10">' +
            '<div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-700"></div>' +
        '</div>';
    
    // Short delay to ensure loading spinner is visible
    setTimeout(() => {
        let allItems = [];
        
        console.log('Available categories in allMenuData:', Object.keys(allMenuData));
        
        // If "all" category is selected, combine items from all categories
        if (category === 'all') {
            Object.keys(allMenuData).forEach(cat => {
                if (cat !== 'specials') { // Exclude specials from the "all" view
                    if (allMenuData[cat] && allMenuData[cat].items) {
                        console.log('Adding items from category:', cat, 'Count:', allMenuData[cat].items.length);
                        allItems = [...allItems, ...allMenuData[cat].items];
                    }
                }
            });
        } else {
            // Otherwise, just get items from the selected category
            if (allMenuData[category] && allMenuData[category].items) {
                allItems = allMenuData[category].items;
                console.log('Items for', category, 'category:', allItems.length);
            } else {
                console.warn('No items found for category:', category);
                allItems = [];
            }
        }
        
        // Filter by restaurant if needed
        let filteredItems = allItems;
        if (restaurantFilter !== 'all') {
            console.log('Filtering by restaurant:', restaurantFilter);
            filteredItems = filteredItems.filter(item => {
                if (Array.isArray(item.availableAt)) {
                    return item.availableAt.includes(parseInt(restaurantFilter));
                } else {
                    return item.availableAt === parseInt(restaurantFilter);
                }
            });
            console.log('After restaurant filtering, items count:', filteredItems.length);
        }
        
        // Display filtered items
        if (filteredItems.length > 0) {
            console.log('Displaying', filteredItems.length, 'items');
            menuContainer.innerHTML = '';
            
            filteredItems.forEach(item => {
                // Append the created DOM element directly instead of using innerHTML +=
                const menuItemElement = createMenuItemCard(item);
                menuContainer.appendChild(menuItemElement);
            });
            
            // No need for separate click handler addition since they're already added in createMenuItemCard
        } else {
            console.warn('No items to display after filtering');
            menuContainer.innerHTML = `
                <div class="col-span-2 text-center py-8">
                    <p class="text-blue-700">No items available in this category at the selected location.</p>
                </div>
            `;
        }
    }, 300);
}

// Create HTML for a menu item card
function createMenuItemCard(item) {
    // Create the main card element - this will be returned
    const cardElement = document.createElement('div');
    cardElement.className = 'menu-item';
    cardElement.id = `item-${item.id}`; // Add ID for referencing later
    
    // Create the card container
    const cardContainer = document.createElement('div');
    cardContainer.className = 'bg-gray-900 rounded-lg overflow-hidden hover:bg-gray-800 transition duration-200';
    cardContainer.setAttribute('data-item-id', item.id);
    cardContainer.setAttribute('data-category', item.category);
    
    // Create image container
    const imgContainer = document.createElement('div');
    imgContainer.className = 'relative';
    
    // Create and set up the image
    const img = document.createElement('img');
    img.src = pageContextPath + item.image;
    img.alt = item.name;
    img.className = 'w-full h-48 object-cover cursor-pointer';
    img.addEventListener('click', (event) => {
        event.stopPropagation();
        handleItemClick(item);
    });
    
    // Add image to its container
    imgContainer.appendChild(img);
    
    // Add vegetarian badge if needed
    if (item.type === 'vegetarian') {
        const vegBadge = document.createElement('span');
        vegBadge.className = 'absolute top-2 right-2 bg-green-600 text-white text-xs px-2 py-1 rounded-full';
        vegBadge.textContent = 'Vegetarian';
        imgContainer.appendChild(vegBadge);
    }
    
    // Create content container
    const contentContainer = document.createElement('div');
    contentContainer.className = 'p-4';
    
    // Create title and price container
    const titlePriceContainer = document.createElement('div');
    titlePriceContainer.className = 'flex justify-between items-start';
    
    // Create title
    const title = document.createElement('h4');
    title.className = 'text-xl font-semibold cursor-pointer';
    title.textContent = item.name;
    title.addEventListener('click', (event) => {
        event.stopPropagation();
        handleItemClick(item);
    });
    
    // Create price
    const price = document.createElement('span');
    price.className = 'text-amber-500 font-bold';
    price.textContent = `R${item.price.toFixed(2)}`;
    
    // Add title and price to their container
    titlePriceContainer.appendChild(title);
    titlePriceContainer.appendChild(price);
    
    // Create description
    const description = document.createElement('p');
    description.className = 'text-gray-400 mt-2 line-clamp-2 cursor-pointer';
    description.textContent = item.description;
    description.addEventListener('click', (event) => {
        event.stopPropagation();
        handleItemClick(item);
    });
    
    // Create restaurant badges container
    const badgesContainer = document.createElement('div');
    badgesContainer.className = 'mt-3';
    
    // Add restaurant badges
    const badgesHTML = getRestaurantBadges(item.availableAt);
    if (badgesHTML) {
        // Since getRestaurantBadges returns HTML as a string, we need to create elements instead
        if (Array.isArray(item.availableAt)) {
            item.availableAt.forEach(id => {
                const badge = document.createElement('span');
                badge.className = 'text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded mr-1';
                badge.textContent = getRestaurantName(id);
                badgesContainer.appendChild(badge);
            });
        } else if (item.availableAt) {
            const badge = document.createElement('span');
            badge.className = 'text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded';
            badge.textContent = getRestaurantName(item.availableAt);
            badgesContainer.appendChild(badge);
        }
    }
    
    // Create controls container
    const controlsContainer = document.createElement('div');
    controlsContainer.className = 'mt-4 flex items-center justify-between';
    
    // Create quantity controls container
    const quantityContainer = document.createElement('div');
    quantityContainer.className = 'flex items-center';
    
    // Create decrease button
    const decreaseBtn = document.createElement('button');
    decreaseBtn.className = 'quantity-decrease w-8 h-8 flex items-center justify-center bg-gray-700 hover:bg-gray-600 rounded-l';
    decreaseBtn.setAttribute('aria-label', 'Decrease quantity');
    decreaseBtn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" /></svg>';
    
    // Create quantity display
    const quantityValue = document.createElement('span');
    quantityValue.className = 'quantity-value w-10 text-center bg-gray-800';
    quantityValue.textContent = '1';
    
    // Create increase button
    const increaseBtn = document.createElement('button');
    increaseBtn.className = 'quantity-increase w-8 h-8 flex items-center justify-center bg-gray-700 hover:bg-gray-600 rounded-r';
    increaseBtn.setAttribute('aria-label', 'Increase quantity');
    increaseBtn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>';
    
    // Add quantity controls to their container
    quantityContainer.appendChild(decreaseBtn);
    quantityContainer.appendChild(quantityValue);
    quantityContainer.appendChild(increaseBtn);
    
    // Create add to tray button
    const addToTrayBtn = document.createElement('button');
    addToTrayBtn.className = 'add-to-tray bg-amber-500 hover:bg-amber-600 text-white px-3 py-1.5 rounded-md text-sm';
    addToTrayBtn.textContent = 'Add to Tray';
    
    // Add controls to their container
    controlsContainer.appendChild(quantityContainer);
    controlsContainer.appendChild(addToTrayBtn);
    
    // Add event listeners for quantity controls
    decreaseBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        const currentValue = parseInt(quantityValue.textContent);
        if (currentValue > 1) {
            quantityValue.textContent = currentValue - 1;
        }
    });
    
    increaseBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        const currentValue = parseInt(quantityValue.textContent);
        quantityValue.textContent = currentValue + 1;
    });
    
    // Add event listener for the add to tray button
    addToTrayBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        const quantity = parseInt(quantityValue.textContent);
        // If addToTray function exists, call it
        if (typeof addToTray === 'function') {
            addToTray(item, quantity);
        } else {
            console.warn('addToTray function not found');
        }
        // Reset quantity to 1 after adding
        quantityValue.textContent = '1';
    });
    
    // Build the card structure
    contentContainer.appendChild(titlePriceContainer);
    contentContainer.appendChild(description);
    contentContainer.appendChild(badgesContainer);
    contentContainer.appendChild(controlsContainer);
    
    cardContainer.appendChild(imgContainer);
    cardContainer.appendChild(contentContainer);
    
    cardElement.appendChild(cardContainer);
    
    return cardElement;
}

// Helper function to get restaurant name
function getRestaurantName(id) {
    const restaurants = {
        1: "Great Hall",
        2: "Building 13",
        3: "Mumasi"
    };
    return restaurants[id] || "Unknown";
}

// Handle clicks on menu items
function handleItemClick(item) {
    if (item.variants && item.variants.length > 0) {
        // Show flavor selection modal
        showFlavorSelection(item);
    } else {
        // Show item details directly
        showItemDetails(item);
    }
}

// Show flavor selection modal
function showFlavorSelection(item) {
    const modal = document.getElementById('flavor-selection-modal');
    const title = document.getElementById('flavor-title');
    const grid = document.getElementById('flavor-grid');
    
    title.textContent = `Select ${item.name} Flavor`;
    
    grid.innerHTML = `
        <div class="flex justify-center items-center col-span-3 py-10">
            <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-700"></div>
        </div>
    `;
    
    // Show the modal
    modal.classList.remove('hidden');
    
    // Short delay to ensure loading spinner is visible
    setTimeout(() => {
        grid.innerHTML = '';
        
        item.variants.forEach(variant => {
            // Create the variant with its own ID to allow individual flavor selection
            const variantId = `flavor-${variant.id}`;
            // Clone the variant and add the parent name
            const variantWithFlavor = {...variant, flavor: variant.name};
            
            const variantCard = document.createElement('div');
            variantCard.className = 'bg-gray-800 rounded-lg p-4 relative';
            
            variantCard.innerHTML = `
                <div class="cursor-pointer" onclick="showItemDetails(${JSON.stringify(variantWithFlavor).replace(/"/g, "'")},'${item.name}')">
                    <img src="${pageContext.request.contextPath}${variant.image}" alt="${variant.name}" class="w-full h-32 object-cover rounded-md">
                    <h3 class="mt-3 text-white font-medium">${variant.name}</h3>
                    <p class="text-blue-700 mt-1">R${variant.price.toFixed(2)}</p>
                </div>
                
                <div class="mt-3 flex justify-between items-center">
                    <div class="flex items-center border border-gray-700 rounded-md">
                        <button class="decrease-btn px-2 py-1 text-white bg-gray-800 hover:bg-gray-700 rounded-l-md">-</button>
                        <span class="quantity-value w-8 text-center bg-gray-800 py-1">1</span>
                        <button class="increase-btn px-2 py-1 text-white bg-gray-800 hover:bg-gray-700 rounded-r-md">+</button>
                    </div>
                    <button class="add-to-cart-btn px-3 py-1 bg-blue-700 hover:bg-blue-600 text-white rounded-md transition">Add</button>
                </div>
            `;
            
            grid.appendChild(variantCard);
            
            // Add event listeners to this specific variant's buttons
            const decreaseBtn = variantCard.querySelector('.decrease-btn');
            const increaseBtn = variantCard.querySelector('.increase-btn');
            const quantityEl = variantCard.querySelector('.quantity-value');
            const addToCartBtn = variantCard.querySelector('.add-to-cart-btn');
            
            let itemQuantity = 1;
            
            decreaseBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (itemQuantity > 1) {
                    itemQuantity--;
                    quantityEl.textContent = itemQuantity;
                }
            });
            
            increaseBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                itemQuantity++;
                quantityEl.textContent = itemQuantity;
            });
            
            addToCartBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                // Add both the flavor name and parent item info
                const cartItem = {
                    ...variantWithFlavor,
                    parentName: item.name
                };
                addToTray(cartItem, itemQuantity);
            });
        });
    }, 300);
}

// Show item details modal
function showItemDetails(item, parentName = '') {
    const modal = document.getElementById('item-detail-modal');
    const content = document.getElementById('modal-content');
    
    content.innerHTML = `
        <div class="flex justify-center items-center py-10">
            <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-700"></div>
        </div>
    `;
    
    // Show the modal
    modal.classList.remove('hidden');
    
    // Short delay to ensure loading spinner is visible
    setTimeout(() => {
        // Create a title that includes parent name if this is a variant
        const titleDisplay = parentName 
            ? `${parentName} - ${item.name}`
            : item.name;
        
        content.innerHTML = `
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <img src="${pageContext.request.contextPath}${item.image}" alt="${item.name}" class="w-full rounded-lg">
                    <div class="mt-4">
                        <h3 class="text-2xl font-bold text-blue-700">${titleDisplay}</h3>
                        <p class="text-gray-300 mt-2">${item.description}</p>
                        <p class="text-blue-700 text-xl font-bold mt-4">R${item.price.toFixed(2)}</p>
                        
                        <!-- Add to Cart Section -->
                        <div class="mt-6 flex items-center space-x-3">
                            <div class="flex items-center border border-gray-700 rounded-md">
                                <button id="item-decrease" class="px-3 py-1 text-white bg-gray-800 hover:bg-gray-700 rounded-l-md">-</button>
                                <span id="item-quantity" class="w-10 text-center bg-gray-800 py-1">1</span>
                                <button id="item-increase" class="px-3 py-1 text-white bg-gray-800 hover:bg-gray-700 rounded-r-md">+</button>
                            </div>
                            <button id="add-to-cart-btn" class="px-4 py-2 bg-blue-700 hover:bg-blue-600 text-white rounded-md transition">Add to Cart</button>
                        </div>
                        
                        <div class="mt-4">
                            <h4 class="text-white font-semibold mb-2">Available at:</h4>
                            <div class="flex flex-wrap gap-2">
                                ${getRestaurantBadges(item.availableAt)}
                            </div>
                        </div>
                        
                        ${item.allergens && item.allergens.length > 0 ? `
                            <div class="mt-4">
                                <h4 class="text-white font-semibold mb-2">Contains Allergens:</h4>
                                <div class="flex flex-wrap gap-2">
                                    ${item.allergens.map(allergen => 
                                        `<span class="bg-blue-900 text-white text-xs px-2 py-1 rounded">${allergen}</span>`
                                    ).join('')}
                                </div>
                            </div>
                        ` : ''}
                        
                        ${item.dietaryInfo && item.dietaryInfo.length > 0 ? `
                            <div class="mt-4">
                                <h4 class="text-white font-semibold mb-2">Dietary Information:</h4>
                                <div class="flex flex-wrap gap-2">
                                    ${item.dietaryInfo.map(info => 
                                        `<span class="bg-green-800 text-white text-xs px-2 py-1 rounded">${info}</span>`
                                    ).join('')}
                                </div>
                            </div>
                        ` : ''}
                    </div>
                </div>
                
                <div class="nutrition-facts-container">
                    ' + createNutritionFacts(item.nutritionalInfo) + '
                </div>
            </div>
        `;
        
        // Add event listeners to the new buttons
        const decreaseBtn = document.getElementById('item-decrease');
        const increaseBtn = document.getElementById('item-increase');
        const quantityEl = document.getElementById('item-quantity');
        const addToCartBtn = document.getElementById('add-to-cart-btn');
        
        let itemQuantity = 1;
        
        decreaseBtn.addEventListener('click', () => {
            if (itemQuantity > 1) {
                itemQuantity--;
                quantityEl.textContent = itemQuantity;
            }
        });
        
        increaseBtn.addEventListener('click', () => {
            itemQuantity++;
            quantityEl.textContent = itemQuantity;
        });
        
        addToCartBtn.addEventListener('click', () => {
            addToTray(item, itemQuantity);
            modal.classList.add('hidden');
        });
    }, 300);
}

// Load specials items
function loadSpecials() {
    const specialsContainer = document.getElementById('specials-grid');
    const restaurantFilter = document.getElementById('restaurant-filter').value;
    
    // Clear the container and show loading spinner
    specialsContainer.innerHTML = '';
    const loadingDiv = document.createElement('div');
    loadingDiv.className = 'flex justify-center items-center col-span-2 py-10';
    
    const spinner = document.createElement('div');
    spinner.className = 'animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-700';
    
    loadingDiv.appendChild(spinner);
    specialsContainer.appendChild(loadingDiv);
    
    // Short delay to ensure loading spinner is visible
    setTimeout(() => {
        let specialItems = allMenuData.specials?.items || [];
        
        // Filter by restaurant if not "all"
        if (restaurantFilter !== 'all') {
            specialItems = specialItems.filter(item => {
                if (Array.isArray(item.availableAt)) {
                    return item.availableAt.includes(parseInt(restaurantFilter));
                } else {
                    return item.availableAt === parseInt(restaurantFilter);
                }
            });
        }
        
        // Clear the container before adding new content
        specialsContainer.innerHTML = '';
        
        // Display filtered specials
        if (specialItems.length > 0) {
            specialItems.forEach(item => {
                // Create special card container
                const specialCard = document.createElement('div');
                specialCard.className = 'bg-gray-900 rounded-lg overflow-hidden cursor-pointer hover:bg-gray-800 transition duration-200';
                specialCard.onclick = () => showItemDetails(item);
                
                // Create image
                const img = document.createElement('img');
                img.src = pageContextPath + item.image;
                img.alt = item.name;
                img.className = 'w-full h-48 object-cover';
                
                // Create content container
                const contentDiv = document.createElement('div');
                contentDiv.className = 'p-4';
                
                // Create header with title and price
                const headerDiv = document.createElement('div');
                headerDiv.className = 'flex justify-between items-center';
                
                const title = document.createElement('h4');
                title.className = 'text-xl font-semibold';
                title.textContent = item.name;
                
                const price = document.createElement('span');
                price.className = 'text-blue-700 font-bold';
                price.textContent = `R${item.price.toFixed(2)}`;
                
                headerDiv.appendChild(title);
                headerDiv.appendChild(price);
                
                // Create description
                const description = document.createElement('p');
                description.className = 'text-gray-400 mt-2';
                description.textContent = item.description;
                
                // Create special info section
                const infoDiv = document.createElement('div');
                infoDiv.className = 'mt-4 flex justify-between items-center';
                
                const limitedTag = document.createElement('span');
                limitedTag.className = 'bg-red-600 text-white text-xs px-2 py-1 rounded';
                limitedTag.textContent = 'Limited time';
                
                const endDate = document.createElement('span');
                endDate.className = 'text-gray-400';
                endDate.textContent = `Ends ${item.endDate}`;
                
                infoDiv.appendChild(limitedTag);
                infoDiv.appendChild(endDate);
                
                // Create restaurant badges section
                const badgesDiv = document.createElement('div');
                badgesDiv.className = 'mt-3';
                
                // Add restaurant badges
                if (Array.isArray(item.availableAt)) {
                    item.availableAt.forEach(id => {
                        const badge = document.createElement('span');
                        badge.className = 'text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded mr-1';
                        badge.textContent = getRestaurantName(id);
                        badgesDiv.appendChild(badge);
                    });
                } else if (item.availableAt) {
                    const badge = document.createElement('span');
                    badge.className = 'text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded';
                    badge.textContent = getRestaurantName(item.availableAt);
                    badgesDiv.appendChild(badge);
                }
                
                // Assemble the card
                contentDiv.appendChild(headerDiv);
                contentDiv.appendChild(description);
                contentDiv.appendChild(infoDiv);
                contentDiv.appendChild(badgesDiv);
                
                specialCard.appendChild(img);
                specialCard.appendChild(contentDiv);
                
                specialsContainer.appendChild(specialCard);
            });
        } else {
            // Create empty message
            const emptyDiv = document.createElement('div');
            emptyDiv.className = 'col-span-2 text-center py-8';
            
            const emptyText = document.createElement('p');
            emptyText.className = 'text-gray-400';
            emptyText.textContent = 'No specials available at the selected location.';
            
            emptyDiv.appendChild(emptyText);
            specialsContainer.appendChild(emptyDiv);
        }
    }, 300);
}

// Helper function to generate restaurant badges
function getRestaurantBadges(restaurantIds) {
    if (!restaurantIds) return '';
    
    const restaurants = {
        1: "Great Hall",
        2: "Building 13",
        3: "Mumasi"
    };
    
    let badges = '';
    
    if (Array.isArray(restaurantIds)) {
        restaurantIds.forEach(id => {
            badges += '<span class="text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded">' + restaurants[id] + '</span>';
        });
    } else {
        badges = '<span class="text-xs bg-gray-700 text-gray-200 px-2 py-1 rounded">' + restaurants[restaurantIds] + '</span>';
    }
    
    return badges;
}

// Close any modal by ID
function closeModal(modalId) {
    document.getElementById(modalId).classList.add('hidden');
}