class NutritionAnalyzer {
    constructor() {
        this.vitaminLabels = {
            'vitamin-a_100g': { name: 'Vitamin A', unit: 'μg', multiplier: 1000000 },
            'vitamin-b1_100g': { name: 'Vitamin B1', unit: 'mg', multiplier: 1000 },
            'vitamin-b2_100g': { name: 'Vitamin B2', unit: 'mg', multiplier: 1000 },
            'vitamin-b3_100g': { name: 'Vitamin B3', unit: 'mg', multiplier: 1000 },
            'vitamin-b6_100g': { name: 'Vitamin B6', unit: 'mg', multiplier: 1000 },
            'vitamin-b9_100g': { name: 'Folate (B9)', unit: 'μg', multiplier: 1000000 },
            'vitamin-b12_100g': { name: 'Vitamin B12', unit: 'μg', multiplier: 1000000 },
            'vitamin-c_100g': { name: 'Vitamin C', unit: 'mg', multiplier: 1000 },
            'vitamin-d_100g': { name: 'Vitamin D', unit: 'μg', multiplier: 1000000 },
            'vitamin-e_100g': { name: 'Vitamin E', unit: 'mg', multiplier: 1000 },
            'vitamin-k_100g': { name: 'Vitamin K', unit: 'μg', multiplier: 1000000 }
        };

        this.mineralLabels = {
            'calcium_100g': { name: 'Calcium', unit: 'mg', multiplier: 1000 },
            'iron_100g': { name: 'Iron', unit: 'mg', multiplier: 1000 },
            'magnesium_100g': { name: 'Magnesium', unit: 'mg', multiplier: 1000 },
            'phosphorus_100g': { name: 'Phosphorus', unit: 'mg', multiplier: 1000 },
            'potassium_100g': { name: 'Potassium', unit: 'mg', multiplier: 1000 },
            'zinc_100g': { name: 'Zinc', unit: 'mg', multiplier: 1000 },
            'copper_100g': { name: 'Copper', unit: 'mg', multiplier: 1000 },
            'manganese_100g': { name: 'Manganese', unit: 'mg', multiplier: 1000 },
            'selenium_100g': { name: 'Selenium', unit: 'μg', multiplier: 1000000 },
            'iodine_100g': { name: 'Iodine', unit: 'μg', multiplier: 1000000 }
        };
    }

    formatNutritionSummary(nutriments) {
        if (!nutriments) return null;

        const summary = [];

        if (nutriments['energy-kcal_100g']) {
            summary.push({
                label: 'Calories',
                value: Math.round(nutriments['energy-kcal_100g']),
                unit: 'kcal'
            });
        }

        if (nutriments.carbohydrates_100g) {
            summary.push({
                label: 'Carbs',
                value: this.formatValue(nutriments.carbohydrates_100g),
                unit: 'g'
            });
        }

        if (nutriments.proteins_100g) {
            summary.push({
                label: 'Protein',
                value: this.formatValue(nutriments.proteins_100g),
                unit: 'g'
            });
        }

        if (nutriments.fat_100g) {
            summary.push({
                label: 'Fat',
                value: this.formatValue(nutriments.fat_100g),
                unit: 'g'
            });
        }

        return summary.length > 0 ? summary : null;
    }

    formatDetailedNutrition(nutriments) {
        if (!nutriments) return null;

        const nutrition = {
            macronutrients: [],
            vitamins: [],
            minerals: []
        };

        // Macronutrients
        const macros = [
            { key: 'energy-kcal_100g', label: 'Calories', unit: 'kcal', multiplier: 1 },
            { key: 'carbohydrates_100g', label: 'Carbohydrates', unit: 'g', multiplier: 1 },
            { key: 'sugars_100g', label: 'Sugars', unit: 'g', multiplier: 1 },
            { key: 'fiber_100g', label: 'Fiber', unit: 'g', multiplier: 1 },
            { key: 'proteins_100g', label: 'Protein', unit: 'g', multiplier: 1 },
            { key: 'fat_100g', label: 'Total Fat', unit: 'g', multiplier: 1 },
            { key: 'saturated-fat_100g', label: 'Saturated Fat', unit: 'g', multiplier: 1 },
            { key: 'trans-fat_100g', label: 'Trans Fat', unit: 'g', multiplier: 1 },
            { key: 'cholesterol_100g', label: 'Cholesterol', unit: 'mg', multiplier: 1000 },
            { key: 'sodium_100g', label: 'Sodium', unit: 'mg', multiplier: 1000 }
        ];

        macros.forEach(macro => {
            const value = nutriments[macro.key];
            if (value !== undefined && value !== null) {
                nutrition.macronutrients.push({
                    label: macro.label,
                    value: this.formatValue(value * macro.multiplier),
                    unit: macro.unit
                });
            }
        });

        // Vitamins
        Object.entries(this.vitaminLabels).forEach(([key, info]) => {
            const value = nutriments[key];
            if (value !== undefined && value !== null) {
                nutrition.vitamins.push({
                    label: info.name,
                    value: this.formatValue(value * info.multiplier),
                    unit: info.unit
                });
            }
        });

        // Minerals
        Object.entries(this.mineralLabels).forEach(([key, info]) => {
            const value = nutriments[key];
            if (value !== undefined && value !== null) {
                nutrition.minerals.push({
                    label: info.name,
                    value: this.formatValue(value * info.multiplier),
                    unit: info.unit
                });
            }
        });

        return nutrition;
    }

    formatValue(value) {
        if (value < 0.01 && value > 0) {
            return parseFloat(value.toFixed(3));
        } else if (value < 1) {
            return parseFloat(value.toFixed(2));
        } else if (value < 10) {
            return parseFloat(value.toFixed(1));
        } else {
            return Math.round(value);
        }
    }

    getNovaDescription(novaGroup) {
        switch (novaGroup) {
            case 1:
                return 'Unprocessed or minimally processed foods';
            case 2:
                return 'Processed culinary ingredients';
            case 3:
                return 'Processed foods';
            case 4:
                return 'Ultra-processed foods';
            default:
                return 'Unknown processing level';
        }
    }

    getNovaColor(novaGroup) {
        switch (novaGroup) {
            case 1:
                return '#28a745'; // Green
            case 2:
                return '#ffc107'; // Yellow
            case 3:
                return '#fd7e14'; // Orange
            case 4:
                return '#dc3545'; // Red
            default:
                return '#6c757d'; // Gray
        }
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = NutritionAnalyzer;
}