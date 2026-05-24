// Function to create nutrition facts display
function createNutritionFacts(nutritionalInfo) {
    if (!nutritionalInfo) return '<p class="text-gray-400">Nutritional information not available</p>';
    return `
        <div class="nutrition-facts bg-white text-black p-4 rounded w-full">
            <h3 class="text-xl font-bold border-b-2 border-black pb-1 mb-1">Nutrition Facts</h3>
            <p class="text-sm mb-1">1 Serving Per Container</p>
            <p class="text-sm font-bold border-b border-black pb-1 mb-1">Serving Size ${safe(nutritionalInfo, 'servingSize')}</p>
            
            <div class="flex justify-between font-bold text-lg border-b-8 border-black py-1 mb-1">
                <span>Calories</span>
                <span>${safe(nutritionalInfo, 'calories')}</span>
            </div>
            
            <div class="text-right text-sm border-b border-black pb-1 mb-1">% Daily Value*</div>
            
            <!-- Total Fat -->
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span><strong>Total Fat</strong> ${safe(nutritionalInfo, 'totalFat.value')}${safe(nutritionalInfo, 'totalFat.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'totalFat.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Saturated Fat (indented) -->
            <div class="flex justify-between text-sm border-b border-black py-1 pl-4">
                <span>Saturated Fat ${safe(nutritionalInfo, 'saturatedFat.value')}${safe(nutritionalInfo, 'saturatedFat.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'saturatedFat.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Trans Fat (indented) -->
            <div class="flex justify-between text-sm border-b border-black py-1 pl-4">
                <span>Trans Fat ${safe(nutritionalInfo, 'transFat.value')}${safe(nutritionalInfo, 'transFat.unit','')}</span>
                <span></span>
            </div>
            
            <!-- Cholesterol -->
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span><strong>Cholesterol</strong> ${safe(nutritionalInfo, 'cholesterol.value')}${safe(nutritionalInfo, 'cholesterol.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'cholesterol.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Sodium -->
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span><strong>Sodium</strong> ${safe(nutritionalInfo, 'sodium.value')}${safe(nutritionalInfo, 'sodium.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'sodium.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Total Carbohydrate -->
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span><strong>Total Carbohydrate</strong> ${safe(nutritionalInfo, 'totalCarbohydrate.value')}${safe(nutritionalInfo, 'totalCarbohydrate.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'totalCarbohydrate.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Dietary Fiber (indented) -->
            <div class="flex justify-between text-sm border-b border-black py-1 pl-4">
               <span>Dietary Fiber ${safe(nutritionalInfo, 'dietaryFiber.value')}${safe(nutritionalInfo, 'dietaryFiber.unit','')}</span>
                <span><strong>${safe(nutritionalInfo, 'dietaryFiber.dailyValue')}</strong>%</span>
            </div>
            
            <!-- Total Sugars (indented) -->
            <div class="flex justify-between text-sm border-b border-black py-1 pl-4">
                <span>Total Sugars ${safe(nutritionalInfo, 'totalSugars.value')}${safe(nutritionalInfo, 'totalSugars.unit','')}</span>
                <span></span>
            </div>
            
            <!-- Protein -->
            <div class="flex justify-between text-sm border-b-8 border-black py-1">
                <span><strong>Protein</strong> ${safe(nutritionalInfo, 'protein.value')}${safe(nutritionalInfo, 'protein.unit','')}</span>
                <span></span>
            </div>
            
            <!-- Vitamins -->
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span>Vitamin D ${safe(nutritionalInfo, 'vitamins.vitaminD.value')}${safe(nutritionalInfo, 'vitamins.vitaminD.unit','')}</span>
                <span>${safe(nutritionalInfo, 'vitamins.vitaminD.dailyValue')}</span>
            </div>
            
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span>Calcium ${safe(nutritionalInfo, 'vitamins.calcium.value')}${safe(nutritionalInfo, 'vitamins.calcium.unit','')}</span>
                <span>${safe(nutritionalInfo, 'vitamins.calcium.dailyValue')}</span>
            </div>
            
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span>Iron ${safe(nutritionalInfo, 'vitamins.iron.value')}${safe(nutritionalInfo, 'vitamins.iron.unit','')}</span>
                <span>${safe(nutritionalInfo, 'vitamins.iron.dailyValue')}</span>
            </div>
            
            <div class="flex justify-between text-sm border-b border-black py-1">
                <span>Potassium ${safe(nutritionalInfo, 'vitamins.potassium.value')}${safe(nutritionalInfo, 'vitamins.potassium.unit','')}</span>
                <span>${safe(nutritionalInfo, 'vitamins.potassium.dailyValue')}</span>
            </div>
            
            <!-- Additional Notes -->
            ${(nutritionalInfo.additionalNotes && nutritionalInfo.additionalNotes.length > 0) ? `
                <div class="text-sm mt-2">
                    ${nutritionalInfo.additionalNotes.map(note => `<p>${note}</p>`).join('')}
                </div>
            ` : ''}
            
            <p class="text-xs mt-2">* The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 Calories a day is used for general nutrition advice.</p>
            
            <div class="text-xs mt-2 flex justify-between">
                <span>Calories per gram:</span>
                <span>Fat 9 • Carbohydrate 4 • Protein 4</span>
            </div>
        </div>
    `;
}