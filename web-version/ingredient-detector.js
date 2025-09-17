class IngredientDetector {
    constructor() {
        this.glutenIngredients = [
            'wheat', 'barley', 'rye', 'oats', 'spelt', 'kamut', 'triticale',
            'wheat flour', 'wheat starch', 'wheat protein', 'wheat gluten',
            'barley malt', 'barley extract', 'malt extract', 'malt flavoring',
            'rye flour', 'graham flour', 'durum wheat', 'semolina',
            'bulgur', 'couscous', 'farro', 'freekeh',
            'brewer\'s yeast', 'wheat bran', 'wheat germ',
            'modified wheat starch', 'hydrolyzed wheat protein',
            'vital wheat gluten', 'seitan', 'fu',
            'atta flour', 'maida flour', 'sooji',
            'einkorn', 'emmer', 'dinkel'
        ];

        this.lactoseIngredients = [
            'milk', 'lactose', 'whey', 'casein', 'caseinate',
            'milk powder', 'dried milk', 'skim milk', 'whole milk',
            'buttermilk', 'cream', 'butter', 'ghee',
            'yogurt', 'kefir', 'cheese', 'cottage cheese',
            'whey protein', 'milk protein', 'milk solids',
            'sodium caseinate', 'calcium caseinate', 'potassium caseinate',
            'lactalbumin', 'lactoglobulin', 'milk fat',
            'anhydrous milk fat', 'curds', 'custard',
            'half and half', 'condensed milk', 'evaporated milk',
            'milk chocolate', 'malted milk', 'acidophilus milk',
            'butterfat', 'butter oil', 'butter solids',
            'dairy', 'galactose'
        ];

        this.ultraProcessedIndicators = [
            'high fructose corn syrup', 'corn syrup', 'glucose syrup',
            'hydrogenated', 'partially hydrogenated', 'trans fat',
            'monosodium glutamate', 'msg', 'aspartame', 'sucralose',
            'acesulfame potassium', 'sodium benzoate', 'potassium sorbate',
            'bht', 'bha', 'tbhq', 'artificial flavor', 'artificial flavoring',
            'natural flavor', 'modified corn starch', 'modified food starch',
            'sodium nitrite', 'sodium nitrate', 'carrageenan',
            'xanthan gum', 'guar gum', 'locust bean gum',
            'polydextrose', 'maltodextrin', 'dextrose',
            'phosphoric acid', 'citric acid', 'malic acid',
            'calcium propionate', 'sodium propionate',
            'artificial color', 'fd&c', 'yellow 5', 'yellow 6',
            'red 40', 'blue 1', 'blue 2', 'caramel color',
            'silicon dioxide', 'titanium dioxide',
            'propylene glycol', 'polyethylene glycol',
            'soy lecithin', 'sunflower lecithin',
            'mono and diglycerides', 'polysorbate'
        ];
    }

    analyzeIngredients(ingredientsText) {
        if (!ingredientsText) {
            return {
                containsGluten: false,
                containsLactose: false,
                isUltraProcessed: false,
                glutenIngredients: [],
                lactoseIngredients: [],
                ultraProcessedIndicators: []
            };
        }

        const ingredients = ingredientsText.toLowerCase();

        const foundGlutenIngredients = this.findIngredients(ingredients, this.glutenIngredients);
        const foundLactoseIngredients = this.findIngredients(ingredients, this.lactoseIngredients);
        const foundUltraProcessedIndicators = this.findIngredients(ingredients, this.ultraProcessedIndicators);

        return {
            containsGluten: foundGlutenIngredients.length > 0,
            containsLactose: foundLactoseIngredients.length > 0,
            isUltraProcessed: foundUltraProcessedIndicators.length > 0,
            glutenIngredients: foundGlutenIngredients,
            lactoseIngredients: foundLactoseIngredients,
            ultraProcessedIndicators: foundUltraProcessedIndicators
        };
    }

    analyzeProduct(productDetails) {
        let result = this.analyzeIngredients(productDetails.ingredients_text);

        // Check allergens
        if (productDetails.allergens) {
            const allergens = productDetails.allergens.toLowerCase();

            if ((allergens.includes('gluten') || allergens.includes('wheat')) && !result.containsGluten) {
                result = {
                    ...result,
                    containsGluten: true,
                    glutenIngredients: result.glutenIngredients.length === 0 ? ['Listed in allergens'] : result.glutenIngredients
                };
            }

            if ((allergens.includes('milk') || allergens.includes('lactose')) && !result.containsLactose) {
                result = {
                    ...result,
                    containsLactose: true,
                    lactoseIngredients: result.lactoseIngredients.length === 0 ? ['Listed in allergens'] : result.lactoseIngredients
                };
            }
        }

        // Check NOVA group for ultra-processed classification
        const isUltraProcessedByNova = (productDetails.nova_group || 0) >= 4;
        const finalIsUltraProcessed = result.isUltraProcessed || isUltraProcessedByNova;

        let finalUltraProcessedIndicators = result.ultraProcessedIndicators;
        if (isUltraProcessedByNova && result.ultraProcessedIndicators.length === 0) {
            finalUltraProcessedIndicators = ['NOVA Group 4 (Ultra-processed)'];
        }

        return {
            ...result,
            isUltraProcessed: finalIsUltraProcessed,
            ultraProcessedIndicators: finalUltraProcessedIndicators,
            novaScore: productDetails.nova_group
        };
    }

    findIngredients(text, ingredientList) {
        const found = [];

        for (const ingredient of ingredientList) {
            if (text.includes(ingredient.toLowerCase())) {
                // Capitalize first letter of each word
                const capitalized = ingredient.split(' ')
                    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                    .join(' ');
                found.push(capitalized);
            }
        }

        // Remove duplicates and sort
        return [...new Set(found)].sort();
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = IngredientDetector;
}