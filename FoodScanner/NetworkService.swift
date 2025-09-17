import Foundation

class NetworkService: ObservableObject {
    private let baseURL = "https://world.openfoodfacts.org/api/v0/product/"

    func fetchProduct(barcode: String) async -> Result<Product, Error> {
        guard let url = URL(string: "\(baseURL)\(barcode).json") else {
            return .failure(NetworkError.invalidURL)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return .failure(NetworkError.invalidResponse)
            }

            let product = try JSONDecoder().decode(Product.self, from: data)
            return .success(product)
        } catch {
            return .failure(error)
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        }
    }
}