import Foundation

@MainActor
class ProductAnalyzer: ObservableObject {
    @Published var scanState: ScanState = .idle

    private let networkService = NetworkService()
    private let ingredientDetector = IngredientDetector()

    func analyzeProduct(barcode: String) async {
        scanState = .loading

        let result = await networkService.fetchProduct(barcode: barcode)

        switch result {
        case .success(let product):
            if let productDetails = product.product {
                let analysis = ingredientDetector.analyzeProduct(productDetails)
                scanState = .success(analysis)
            } else {
                scanState = .error("Product not found in database")
            }
        case .failure(let error):
            scanState = .error(error.localizedDescription)
        }
    }

    func reset() {
        scanState = .idle
    }
}