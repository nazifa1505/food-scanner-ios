import SwiftUI

struct ContentView: View {
    @StateObject private var productAnalyzer = ProductAnalyzer()
    @State private var scannedCode = ""
    @State private var isScanning = false
    @State private var showingScanner = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                switch productAnalyzer.scanState {
                case .idle:
                    welcomeView

                case .scanning:
                    Text("Position the barcode in the camera viewfinder")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()

                case .loading:
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Analyzing product...")
                            .font(.headline)
                    }

                case .success(let result):
                    ResultView(result: result) {
                        resetAndScanAgain()
                    }

                case .error(let message):
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)

                        Text("Error")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(message)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Try Again") {
                            resetAndScanAgain()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
            }
            .padding()
            .navigationTitle("Food Scanner")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingScanner) {
                NavigationView {
                    ZStack {
                        BarcodeScannerView(scannedCode: $scannedCode, isScanning: $isScanning)
                            .ignoresSafeArea()

                        VStack {
                            Spacer()

                            VStack(spacing: 16) {
                                Text("Scan Product Barcode")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Position the barcode within the viewfinder")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(.black.opacity(0.7))
                            .cornerRadius(12)
                            .padding()

                            Spacer()

                            Button("Cancel") {
                                showingScanner = false
                                productAnalyzer.reset()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(.black.opacity(0.7))
                            .cornerRadius(8)
                            .padding()
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
            .onChange(of: scannedCode) { newValue in
                if !newValue.isEmpty {
                    showingScanner = false
                    Task {
                        await productAnalyzer.analyzeProduct(barcode: newValue)
                    }
                }
            }
        }
    }

    private var welcomeView: some View {
        VStack(spacing: 30) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            VStack(spacing: 16) {
                Text("Food Scanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Scan food products to check for:")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "🌾", text: "Gluten")
                    FeatureRow(icon: "🥛", text: "Lactose")
                    FeatureRow(icon: "⚠️", text: "Ultra-processed ingredients")
                }
                .padding(.top)
            }

            Button(action: {
                productAnalyzer.scanState = .scanning
                showingScanner = true
            }) {
                Text("Start Scanning")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }

    private func resetAndScanAgain() {
        scannedCode = ""
        productAnalyzer.reset()
        showingScanner = true
        productAnalyzer.scanState = .scanning
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}