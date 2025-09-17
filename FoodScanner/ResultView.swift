import SwiftUI

struct ResultView: View {
    let result: AnalysisResult
    let onScanAgain: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 16) {
                    StatusCard(
                        title: "Gluten",
                        isPresent: result.containsGluten,
                        ingredients: result.glutenIngredients,
                        icon: "🌾"
                    )

                    StatusCard(
                        title: "Lactose",
                        isPresent: result.containsLactose,
                        ingredients: result.lactoseIngredients,
                        icon: "🥛"
                    )

                    StatusCard(
                        title: "Ultra-Processed",
                        isPresent: result.isUltraProcessed,
                        ingredients: result.ultraProcessedIndicators,
                        icon: "⚠️"
                    )

                    if let novaScore = result.novaScore {
                        NovaScoreCard(score: novaScore)
                    }

                    if let productDetails = result.productDetails,
                       let nutriments = productDetails.nutriments {
                        NavigationLink(destination: NutritionView(nutriments: nutriments, productName: productDetails.productName)) {
                            NutritionSummaryCard(nutriments: nutriments)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Button(action: onScanAgain) {
                    Text("Scan Another Product")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Analysis Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatusCard: View {
    let title: String
    let isPresent: Bool
    let ingredients: [String]
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: isPresent ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(isPresent ? .red : .green)
                    .font(.title2)
            }

            Text(isPresent ? "CONTAINS \(title.uppercased())" : "NO \(title.uppercased()) DETECTED")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isPresent ? .red : .green)

            if isPresent && !ingredients.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Found ingredients:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    ForEach(ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NovaScoreCard: View {
    let score: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📊")
                    .font(.title2)
                Text("NOVA Classification")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(score)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(novaColor)
            }

            Text(novaDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var novaColor: Color {
        switch score {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        default: return .gray
        }
    }

    private var novaDescription: String {
        switch score {
        case 1: return "Unprocessed or minimally processed foods"
        case 2: return "Processed culinary ingredients"
        case 3: return "Processed foods"
        case 4: return "Ultra-processed foods"
        default: return "Unknown processing level"
        }
    }
}

struct NutritionSummaryCard: View {
    let nutriments: Nutriments

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📊")
                    .font(.title2)
                Text("Nutrition Facts")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            HStack(spacing: 20) {
                if let energy = nutriments.energy {
                    NutritionSummaryItem(title: "Calories", value: "\(Int(energy))", unit: "kcal")
                }
                if let carbs = nutriments.carbohydrates {
                    NutritionSummaryItem(title: "Carbs", value: String(format: "%.1f", carbs), unit: "g")
                }
                if let proteins = nutriments.proteins {
                    NutritionSummaryItem(title: "Protein", value: String(format: "%.1f", proteins), unit: "g")
                }
                if let fat = nutriments.fat {
                    NutritionSummaryItem(title: "Fat", value: String(format: "%.1f", fat), unit: "g")
                }
            }

            Text("Tap for detailed nutrition information")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NutritionSummaryItem: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(value) \(unit)")
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationView {
        ResultView(
            result: AnalysisResult(
                containsGluten: true,
                containsLactose: false,
                isUltraProcessed: true,
                glutenIngredients: ["Wheat Flour", "Barley Malt"],
                lactoseIngredients: [],
                ultraProcessedIndicators: ["High Fructose Corn Syrup", "Artificial Flavor"],
                novaScore: 4,
                productDetails: ProductDetails(
                    productName: "Sample Product",
                    brands: "Sample Brand",
                    ingredientsText: "wheat flour, sugar, palm oil",
                    allergens: "gluten",
                    traces: nil,
                    nutriments: Nutriments(
                        energy: 500,
                        fat: 20,
                        saturatedFat: 8,
                        transFat: nil,
                        monounsaturatedFat: nil,
                        polyunsaturatedFat: nil,
                        cholesterol: nil,
                        carbohydrates: 65,
                        sugars: 25,
                        addedSugars: nil,
                        fiber: 3,
                        proteins: 8,
                        salt: 1.2,
                        sodium: 0.5,
                        vitaminA: nil,
                        vitaminB1: nil,
                        vitaminB2: nil,
                        vitaminB3: nil,
                        vitaminB6: nil,
                        vitaminB9: nil,
                        vitaminB12: nil,
                        vitaminC: nil,
                        vitaminD: nil,
                        vitaminE: nil,
                        vitaminK: nil,
                        calcium: nil,
                        iron: nil,
                        magnesium: nil,
                        phosphorus: nil,
                        potassium: nil,
                        zinc: nil,
                        copper: nil,
                        manganese: nil,
                        selenium: nil,
                        iodine: nil
                    ),
                    novaGroup: 4,
                    imageUrl: nil
                )
            ),
            onScanAgain: {}
        )
    }
}