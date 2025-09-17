# Food Scanner iOS App

A comprehensive iOS app that scans food product barcodes and analyzes them for gluten, lactose, and ultra-processed ingredients.

## Features

- **Barcode Scanning**: Uses device camera to scan product barcodes
- **Gluten Detection**: Identifies gluten-containing ingredients like wheat, barley, rye, and their derivatives
- **Lactose Detection**: Detects dairy products and lactose-containing ingredients
- **Ultra-Processed Food Analysis**: Identifies ultra-processed ingredients and additives
- **NOVA Classification**: Shows food processing level (1-4 scale)
- **Detailed Results**: Lists specific problematic ingredients found in products

## Architecture

### Core Components

1. **BarcodeScannerView.swift**: Camera-based barcode scanning using AVFoundation
2. **NetworkService.swift**: Fetches product data from OpenFoodFacts API
3. **IngredientDetector.swift**: Core analysis engine with comprehensive ingredient databases
4. **ProductAnalyzer.swift**: Coordinates scanning and analysis workflow
5. **ResultView.swift**: Displays analysis results with clear visual indicators
6. **ContentView.swift**: Main app interface and navigation

### Data Models

- **Product**: OpenFoodFacts API response structure
- **ProductDetails**: Detailed product information including ingredients
- **AnalysisResult**: Analysis results with detected ingredients
- **ScanState**: App state management (idle, scanning, loading, success, error)

## Ingredient Detection

### Gluten Sources
- Wheat and wheat products (flour, starch, protein, gluten)
- Barley and barley derivatives (malt extract, malt flavoring)
- Rye products
- Ancient grains (spelt, kamut, triticale, einkorn, emmer)
- Processed wheat products (bulgur, couscous, semolina)

### Lactose Sources
- All dairy products (milk, cream, butter, cheese)
- Milk proteins (casein, whey, lactalbumin)
- Processed dairy (condensed milk, milk powder, buttermilk)
- Hidden dairy ingredients

### Ultra-Processed Indicators
- Artificial sweeteners (aspartame, sucralose, acesulfame potassium)
- Industrial additives (high fructose corn syrup, modified starches)
- Preservatives (sodium benzoate, BHT, BHA, TBHQ)
- Artificial colors and flavors
- Hydrogenated oils and trans fats
- Emulsifiers and stabilizers

## NOVA Classification

The app displays NOVA scores (1-4) indicating food processing levels:
- **Group 1**: Unprocessed or minimally processed foods
- **Group 2**: Processed culinary ingredients
- **Group 3**: Processed foods
- **Group 4**: Ultra-processed foods

## Usage

1. Open the app and tap "Start Scanning"
2. Point camera at product barcode
3. Wait for analysis results
4. Review detected ingredients and classifications
5. Tap "Scan Another Product" to continue

## Requirements

- iOS 17.0+
- Camera access for barcode scanning
- Internet connection for product lookup

## Setup

1. Open `FoodScanner.xcodeproj` in Xcode
2. Build and run on device (camera required for scanning)
3. Grant camera permissions when prompted

## Data Source

Product information is sourced from [OpenFoodFacts](https://world.openfoodfacts.org/), a collaborative food database with nutritional information for products worldwide.