import SwiftUI

struct NutritionView: View {
    let nutriments: Nutriments
    let productName: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let name = productName {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                }

                Text("Nutrition Facts")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Per 100g")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                VStack(spacing: 16) {
                    if let energy = nutriments.energy {
                        MacronutrientCard(
                            title: "Calories",
                            value: "\(Int(energy))",
                            unit: "kcal",
                            color: .orange,
                            icon: "flame.fill"
                        )
                    }

                    MacronutrientsSection(nutriments: nutriments)
                    VitaminsSection(nutriments: nutriments)
                    MineralsSection(nutriments: nutriments)
                }
            }
            .padding()
        }
        .navigationTitle("Nutrition Facts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MacronutrientCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("\(value) \(unit)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MacronutrientsSection: View {
    let nutriments: Nutriments

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Macronutrients", icon: "🍎")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                if let carbs = nutriments.carbohydrates {
                    NutrientItem(name: "Carbohydrates", value: carbs, unit: "g", color: .blue)
                }
                if let sugars = nutriments.sugars {
                    NutrientItem(name: "Sugars", value: sugars, unit: "g", color: .pink)
                }
                if let fiber = nutriments.fiber {
                    NutrientItem(name: "Fiber", value: fiber, unit: "g", color: .green)
                }
                if let proteins = nutriments.proteins {
                    NutrientItem(name: "Protein", value: proteins, unit: "g", color: .purple)
                }
                if let fat = nutriments.fat {
                    NutrientItem(name: "Total Fat", value: fat, unit: "g", color: .yellow)
                }
                if let saturatedFat = nutriments.saturatedFat {
                    NutrientItem(name: "Saturated Fat", value: saturatedFat, unit: "g", color: .orange)
                }
                if let transFat = nutriments.transFat {
                    NutrientItem(name: "Trans Fat", value: transFat, unit: "g", color: .red)
                }
                if let cholesterol = nutriments.cholesterol {
                    NutrientItem(name: "Cholesterol", value: cholesterol, unit: "mg", color: .red)
                }
                if let sodium = nutriments.sodium {
                    NutrientItem(name: "Sodium", value: sodium * 1000, unit: "mg", color: .gray)
                }
            }
        }
    }
}

struct VitaminsSection: View {
    let nutriments: Nutriments

    var body: some View {
        let vitamins = getVitamins()
        if !vitamins.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Vitamins", icon: "💊")

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(vitamins, id: \.name) { vitamin in
                        NutrientItem(
                            name: vitamin.name,
                            value: vitamin.value,
                            unit: vitamin.unit,
                            color: .mint
                        )
                    }
                }
            }
        }
    }

    private func getVitamins() -> [(name: String, value: Double, unit: String)] {
        var vitamins: [(name: String, value: Double, unit: String)] = []

        if let vitA = nutriments.vitaminA {
            vitamins.append(("Vitamin A", vitA * 1000000, "μg"))
        }
        if let vitB1 = nutriments.vitaminB1 {
            vitamins.append(("Vitamin B1", vitB1 * 1000, "mg"))
        }
        if let vitB2 = nutriments.vitaminB2 {
            vitamins.append(("Vitamin B2", vitB2 * 1000, "mg"))
        }
        if let vitB3 = nutriments.vitaminB3 {
            vitamins.append(("Vitamin B3", vitB3 * 1000, "mg"))
        }
        if let vitB6 = nutriments.vitaminB6 {
            vitamins.append(("Vitamin B6", vitB6 * 1000, "mg"))
        }
        if let vitB9 = nutriments.vitaminB9 {
            vitamins.append(("Folate (B9)", vitB9 * 1000000, "μg"))
        }
        if let vitB12 = nutriments.vitaminB12 {
            vitamins.append(("Vitamin B12", vitB12 * 1000000, "μg"))
        }
        if let vitC = nutriments.vitaminC {
            vitamins.append(("Vitamin C", vitC * 1000, "mg"))
        }
        if let vitD = nutriments.vitaminD {
            vitamins.append(("Vitamin D", vitD * 1000000, "μg"))
        }
        if let vitE = nutriments.vitaminE {
            vitamins.append(("Vitamin E", vitE * 1000, "mg"))
        }
        if let vitK = nutriments.vitaminK {
            vitamins.append(("Vitamin K", vitK * 1000000, "μg"))
        }

        return vitamins
    }
}

struct MineralsSection: View {
    let nutriments: Nutriments

    var body: some View {
        let minerals = getMinerals()
        if !minerals.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Minerals", icon: "⚡")

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(minerals, id: \.name) { mineral in
                        NutrientItem(
                            name: mineral.name,
                            value: mineral.value,
                            unit: mineral.unit,
                            color: .teal
                        )
                    }
                }
            }
        }
    }

    private func getMinerals() -> [(name: String, value: Double, unit: String)] {
        var minerals: [(name: String, value: Double, unit: String)] = []

        if let calcium = nutriments.calcium {
            minerals.append(("Calcium", calcium * 1000, "mg"))
        }
        if let iron = nutriments.iron {
            minerals.append(("Iron", iron * 1000, "mg"))
        }
        if let magnesium = nutriments.magnesium {
            minerals.append(("Magnesium", magnesium * 1000, "mg"))
        }
        if let phosphorus = nutriments.phosphorus {
            minerals.append(("Phosphorus", phosphorus * 1000, "mg"))
        }
        if let potassium = nutriments.potassium {
            minerals.append(("Potassium", potassium * 1000, "mg"))
        }
        if let zinc = nutriments.zinc {
            minerals.append(("Zinc", zinc * 1000, "mg"))
        }
        if let copper = nutriments.copper {
            minerals.append(("Copper", copper * 1000, "mg"))
        }
        if let manganese = nutriments.manganese {
            minerals.append(("Manganese", manganese * 1000, "mg"))
        }
        if let selenium = nutriments.selenium {
            minerals.append(("Selenium", selenium * 1000000, "μg"))
        }
        if let iodine = nutriments.iodine {
            minerals.append(("Iodine", iodine * 1000000, "μg"))
        }

        return minerals
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.top)
    }
}

struct NutrientItem: View {
    let name: String
    let value: Double
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text(formatValue(value))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private func formatValue(_ value: Double) -> String {
        if value < 0.01 && value > 0 {
            return String(format: "%.3f", value)
        } else if value < 1 {
            return String(format: "%.2f", value)
        } else if value < 10 {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }
}

#Preview {
    NavigationView {
        NutritionView(
            nutriments: Nutriments(
                energy: 250,
                fat: 15,
                saturatedFat: 5,
                transFat: 0,
                monounsaturatedFat: nil,
                polyunsaturatedFat: nil,
                cholesterol: 30,
                carbohydrates: 30,
                sugars: 10,
                addedSugars: nil,
                fiber: 5,
                proteins: 8,
                salt: 1.2,
                sodium: 0.5,
                vitaminA: 0.0008,
                vitaminB1: nil,
                vitaminB2: nil,
                vitaminB3: nil,
                vitaminB6: nil,
                vitaminB9: nil,
                vitaminB12: nil,
                vitaminC: 0.06,
                vitaminD: nil,
                vitaminE: nil,
                vitaminK: nil,
                calcium: 0.12,
                iron: 0.003,
                magnesium: nil,
                phosphorus: nil,
                potassium: nil,
                zinc: nil,
                copper: nil,
                manganese: nil,
                selenium: nil,
                iodine: nil
            ),
            productName: "Sample Product"
        )
    }
}