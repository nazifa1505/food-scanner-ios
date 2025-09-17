import Foundation

class IngredientDetector {

    private let glutenIngredients = [
        "wheat", "barley", "rye", "oats", "spelt", "kamut", "triticale",
        "wheat flour", "wheat starch", "wheat protein", "wheat gluten",
        "barley malt", "barley extract", "malt extract", "malt flavoring",
        "rye flour", "graham flour", "durum wheat", "semolina",
        "bulgur", "couscous", "farro", "freekeh",
        "brewer's yeast", "wheat bran", "wheat germ",
        "modified wheat starch", "hydrolyzed wheat protein",
        "vital wheat gluten", "seitan", "fu",
        "atta flour", "maida flour", "sooji",
        "einkorn", "emmer", "dinkel"
    ]

    private let lactoseIngredients = [
        "milk", "lactose", "whey", "casein", "caseinate",
        "milk powder", "dried milk", "skim milk", "whole milk",
        "buttermilk", "cream", "butter", "ghee",
        "yogurt", "kefir", "cheese", "cottage cheese",
        "whey protein", "milk protein", "milk solids",
        "sodium caseinate", "calcium caseinate", "potassium caseinate",
        "lactalbumin", "lactoglobulin", "milk fat",
        "anhydrous milk fat", "curds", "custard",
        "half and half", "condensed milk", "evaporated milk",
        "milk chocolate", "malted milk", "acidophilus milk",
        "butterfat", "butter oil", "butter solids",
        "dairy", "galactose"
    ]

    private let ultraProcessedIndicators = [
        "high fructose corn syrup", "corn syrup", "glucose syrup",
        "hydrogenated", "partially hydrogenated", "trans fat",
        "monosodium glutamate", "msg", "aspartame", "sucralose",
        "acesulfame potassium", "sodium benzoate", "potassium sorbate",
        "bht", "bha", "tbhq", "artificial flavor", "artificial flavoring",
        "natural flavor", "modified corn starch", "modified food starch",
        "sodium nitrite", "sodium nitrate", "carrageenan",
        "xanthan gum", "guar gum", "locust bean gum",
        "polydextrose", "maltodextrin", "dextrose",
        "phosphoric acid", "citric acid", "malic acid",
        "calcium propionate", "sodium propionate",
        "artificial color", "fd&c", "yellow 5", "yellow 6",
        "red 40", "blue 1", "blue 2", "caramel color",
        "silicon dioxide", "titanium dioxide",
        "propylene glycol", "polyethylene glycol",
        "soy lecithin", "sunflower lecithin",
        "mono and diglycerides", "polysorbate"
    ]

    func analyzeIngredients(_ ingredientsText: String?) -> AnalysisResult {
        guard let ingredients = ingredientsText?.lowercased() else {
            return AnalysisResult(
                containsGluten: false,
                containsLactose: false,
                isUltraProcessed: false,
                glutenIngredients: [],
                lactoseIngredients: [],
                ultraProcessedIndicators: [],
                novaScore: nil,
                productDetails: nil
            )
        }

        let foundGlutenIngredients = findIngredients(in: ingredients, from: glutenIngredients)
        let foundLactoseIngredients = findIngredients(in: ingredients, from: lactoseIngredients)
        let foundUltraProcessedIndicators = findIngredients(in: ingredients, from: ultraProcessedIndicators)

        return AnalysisResult(
            containsGluten: !foundGlutenIngredients.isEmpty,
            containsLactose: !foundLactoseIngredients.isEmpty,
            isUltraProcessed: !foundUltraProcessedIndicators.isEmpty,
            glutenIngredients: foundGlutenIngredients,
            lactoseIngredients: foundLactoseIngredients,
            ultraProcessedIndicators: foundUltraProcessedIndicators,
            novaScore: nil,
            productDetails: nil
        )
    }

    func analyzeProduct(_ product: ProductDetails) -> AnalysisResult {
        var result = analyzeIngredients(product.ingredientsText)

        if let allergens = product.allergens?.lowercased() {
            if allergens.contains("gluten") || allergens.contains("wheat") {
                result = AnalysisResult(
                    containsGluten: true,
                    containsLactose: result.containsLactose,
                    isUltraProcessed: result.isUltraProcessed,
                    glutenIngredients: result.glutenIngredients.isEmpty ? ["Listed in allergens"] : result.glutenIngredients,
                    lactoseIngredients: result.lactoseIngredients,
                    ultraProcessedIndicators: result.ultraProcessedIndicators,
                    novaScore: product.novaGroup,
                    productDetails: product
                )
            }

            if allergens.contains("milk") || allergens.contains("lactose") {
                result = AnalysisResult(
                    containsGluten: result.containsGluten,
                    containsLactose: true,
                    isUltraProcessed: result.isUltraProcessed,
                    glutenIngredients: result.glutenIngredients,
                    lactoseIngredients: result.lactoseIngredients.isEmpty ? ["Listed in allergens"] : result.lactoseIngredients,
                    ultraProcessedIndicators: result.ultraProcessedIndicators,
                    novaScore: product.novaGroup,
                    productDetails: product
                )
            }
        }

        let isUltraProcessedByNova = (product.novaGroup ?? 0) >= 4
        let finalIsUltraProcessed = result.isUltraProcessed || isUltraProcessedByNova

        var finalUltraProcessedIndicators = result.ultraProcessedIndicators
        if isUltraProcessedByNova && result.ultraProcessedIndicators.isEmpty {
            finalUltraProcessedIndicators = ["NOVA Group 4 (Ultra-processed)"]
        }

        return AnalysisResult(
            containsGluten: result.containsGluten,
            containsLactose: result.containsLactose,
            isUltraProcessed: finalIsUltraProcessed,
            glutenIngredients: result.glutenIngredients,
            lactoseIngredients: result.lactoseIngredients,
            ultraProcessedIndicators: finalUltraProcessedIndicators,
            novaScore: product.novaGroup,
            productDetails: product
        )
    }

    private func findIngredients(in text: String, from ingredientList: [String]) -> [String] {
        var found: [String] = []

        for ingredient in ingredientList {
            if text.contains(ingredient.lowercased()) {
                found.append(ingredient.capitalized)
            }
        }

        return Array(Set(found)).sorted()
    }
}