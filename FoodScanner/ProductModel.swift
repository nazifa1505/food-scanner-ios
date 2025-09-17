import Foundation

struct Product: Codable {
    let code: String
    let product: ProductDetails?
    let statusVerbose: String?

    enum CodingKeys: String, CodingKey {
        case code
        case product
        case statusVerbose = "status_verbose"
    }
}

struct ProductDetails: Codable {
    let productName: String?
    let brands: String?
    let ingredientsText: String?
    let allergens: String?
    let traces: String?
    let nutriments: Nutriments?
    let novaGroup: Int?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case ingredientsText = "ingredients_text"
        case allergens
        case traces
        case nutriments
        case novaGroup = "nova_group"
        case imageUrl = "image_url"
    }
}

struct Nutriments: Codable {
    let energy: Double?
    let fat: Double?
    let saturatedFat: Double?
    let transFat: Double?
    let monounsaturatedFat: Double?
    let polyunsaturatedFat: Double?
    let cholesterol: Double?
    let carbohydrates: Double?
    let sugars: Double?
    let addedSugars: Double?
    let fiber: Double?
    let proteins: Double?
    let salt: Double?
    let sodium: Double?

    // Vitamins
    let vitaminA: Double?
    let vitaminB1: Double?
    let vitaminB2: Double?
    let vitaminB3: Double?
    let vitaminB6: Double?
    let vitaminB9: Double?
    let vitaminB12: Double?
    let vitaminC: Double?
    let vitaminD: Double?
    let vitaminE: Double?
    let vitaminK: Double?

    // Minerals
    let calcium: Double?
    let iron: Double?
    let magnesium: Double?
    let phosphorus: Double?
    let potassium: Double?
    let zinc: Double?
    let copper: Double?
    let manganese: Double?
    let selenium: Double?
    let iodine: Double?

    enum CodingKeys: String, CodingKey {
        case energy = "energy-kcal_100g"
        case fat = "fat_100g"
        case saturatedFat = "saturated-fat_100g"
        case transFat = "trans-fat_100g"
        case monounsaturatedFat = "monounsaturated-fat_100g"
        case polyunsaturatedFat = "polyunsaturated-fat_100g"
        case cholesterol = "cholesterol_100g"
        case carbohydrates = "carbohydrates_100g"
        case sugars = "sugars_100g"
        case addedSugars = "added-sugars_100g"
        case fiber = "fiber_100g"
        case proteins = "proteins_100g"
        case salt = "salt_100g"
        case sodium = "sodium_100g"

        // Vitamins
        case vitaminA = "vitamin-a_100g"
        case vitaminB1 = "vitamin-b1_100g"
        case vitaminB2 = "vitamin-b2_100g"
        case vitaminB3 = "vitamin-b3_100g"
        case vitaminB6 = "vitamin-b6_100g"
        case vitaminB9 = "vitamin-b9_100g"
        case vitaminB12 = "vitamin-b12_100g"
        case vitaminC = "vitamin-c_100g"
        case vitaminD = "vitamin-d_100g"
        case vitaminE = "vitamin-e_100g"
        case vitaminK = "vitamin-k_100g"

        // Minerals
        case calcium = "calcium_100g"
        case iron = "iron_100g"
        case magnesium = "magnesium_100g"
        case phosphorus = "phosphorus_100g"
        case potassium = "potassium_100g"
        case zinc = "zinc_100g"
        case copper = "copper_100g"
        case manganese = "manganese_100g"
        case selenium = "selenium_100g"
        case iodine = "iodine_100g"
    }
}

struct AnalysisResult {
    let containsGluten: Bool
    let containsLactose: Bool
    let isUltraProcessed: Bool
    let glutenIngredients: [String]
    let lactoseIngredients: [String]
    let ultraProcessedIndicators: [String]
    let novaScore: Int?
    let productDetails: ProductDetails?
}

enum ScanState {
    case idle
    case scanning
    case loading
    case success(AnalysisResult)
    case error(String)
}