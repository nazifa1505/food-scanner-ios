class FoodScannerApp {
    constructor() {
        this.ingredientDetector = new IngredientDetector();
        this.nutritionAnalyzer = new NutritionAnalyzer();
        this.currentScreen = 'welcome-screen';
        this.scannerActive = false;
        this.currentProduct = null;

        this.initializeEventListeners();
    }

    initializeEventListeners() {
        // Welcome screen
        document.getElementById('start-scan-btn').addEventListener('click', () => {
            this.startScanning();
        });

        document.getElementById('manual-submit-btn').addEventListener('click', () => {
            const barcode = document.getElementById('manual-barcode').value.trim();
            if (barcode) {
                this.analyzeBarcode(barcode);
            }
        });

        document.getElementById('manual-barcode').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                const barcode = e.target.value.trim();
                if (barcode) {
                    this.analyzeBarcode(barcode);
                }
            }
        });

        // Scanner screen
        document.getElementById('stop-scan-btn').addEventListener('click', () => {
            this.stopScanning();
            this.showScreen('welcome-screen');
        });

        // Results screen
        document.getElementById('scan-again-btn').addEventListener('click', () => {
            this.showScreen('welcome-screen');
        });

        document.getElementById('nutrition-details-btn').addEventListener('click', () => {
            this.showNutritionDetails();
        });

        // Nutrition screen
        document.getElementById('back-to-results-btn').addEventListener('click', () => {
            this.showScreen('results-screen');
        });

        // Error screen
        document.getElementById('try-again-btn').addEventListener('click', () => {
            this.showScreen('welcome-screen');
        });
    }

    showScreen(screenId) {
        // Hide all screens
        document.querySelectorAll('.screen').forEach(screen => {
            screen.classList.remove('active');
        });

        // Show target screen
        document.getElementById(screenId).classList.add('active');
        this.currentScreen = screenId;
    }

    async startScanning() {
        try {
            this.showScreen('scanner-screen');
            await this.initializeCamera();
        } catch (error) {
            console.error('Camera error:', error);
            this.showError('Camera access denied or not available. Please use manual barcode entry.');
        }
    }

    async initializeCamera() {
        return new Promise((resolve, reject) => {
            Quagga.init({
                inputStream: {
                    name: "Live",
                    type: "LiveStream",
                    target: document.querySelector('#scanner'),
                    constraints: {
                        width: 640,
                        height: 480,
                        facingMode: "environment"
                    }
                },
                decoder: {
                    readers: [
                        "code_128_reader",
                        "ean_reader",
                        "ean_8_reader",
                        "code_39_reader"
                    ]
                },
                locate: true,
                locator: {
                    halfSample: true,
                    patchSize: "medium"
                }
            }, (err) => {
                if (err) {
                    console.error('Quagga initialization error:', err);
                    reject(err);
                    return;
                }

                console.log("Quagga initialization finished. Ready to start");
                Quagga.start();
                this.scannerActive = true;

                // Set up barcode detection
                Quagga.onDetected((data) => {
                    if (this.scannerActive) {
                        const barcode = data.codeResult.code;
                        console.log('Barcode detected:', barcode);
                        this.stopScanning();
                        this.analyzeBarcode(barcode);
                    }
                });

                resolve();
            });
        });
    }

    stopScanning() {
        if (this.scannerActive) {
            Quagga.stop();
            this.scannerActive = false;
        }
    }

    async analyzeBarcode(barcode) {
        try {
            this.stopScanning();
            this.showScreen('loading-screen');

            console.log('Analyzing barcode:', barcode);

            // Fetch product data from OpenFoodFacts
            const response = await fetch(`https://world.openfoodfacts.org/api/v0/product/${barcode}.json`);

            if (!response.ok) {
                throw new Error('Failed to fetch product data');
            }

            const data = await response.json();
            console.log('API Response:', data);

            if (!data.product) {
                throw new Error('Product not found in database');
            }

            this.currentProduct = data.product;
            const analysis = this.ingredientDetector.analyzeProduct(data.product);

            console.log('Analysis result:', analysis);

            this.displayResults(data.product, analysis);

        } catch (error) {
            console.error('Analysis error:', error);
            this.showError(error.message || 'Failed to analyze product. Please try again.');
        }
    }

    displayResults(product, analysis) {
        // Display product info
        this.displayProductInfo(product);

        // Display analysis results
        this.displayAnalysisResults(analysis);

        // Display nutrition summary
        this.displayNutritionSummary(product.nutriments);

        // Show nutrition details button if nutrition data is available
        const nutritionBtn = document.getElementById('nutrition-details-btn');
        if (product.nutriments && Object.keys(product.nutriments).length > 0) {
            nutritionBtn.style.display = 'inline-block';
        } else {
            nutritionBtn.style.display = 'none';
        }

        this.showScreen('results-screen');
    }

    displayProductInfo(product) {
        const productInfoDiv = document.getElementById('product-info');
        productInfoDiv.innerHTML = `
            <div class="product-name">${product.product_name || 'Unknown Product'}</div>
            ${product.brands ? `<div class="product-brand">${product.brands}</div>` : ''}
        `;
    }

    displayAnalysisResults(analysis) {
        const resultsDiv = document.getElementById('analysis-results');

        const cards = [
            {
                title: 'Gluten',
                icon: '🌾',
                isPresent: analysis.containsGluten,
                ingredients: analysis.glutenIngredients
            },
            {
                title: 'Lactose',
                icon: '🥛',
                isPresent: analysis.containsLactose,
                ingredients: analysis.lactoseIngredients
            },
            {
                title: 'Ultra-Processed',
                icon: '⚠️',
                isPresent: analysis.isUltraProcessed,
                ingredients: analysis.ultraProcessedIndicators
            }
        ];

        let html = '';
        cards.forEach(card => {
            html += this.createStatusCard(card);
        });

        // Add NOVA score if available
        if (analysis.novaScore) {
            html += this.createNovaCard(analysis.novaScore);
        }

        resultsDiv.innerHTML = html;
    }

    createStatusCard(card) {
        const statusClass = card.isPresent ? 'positive' : 'negative';
        const statusText = card.isPresent ? `CONTAINS ${card.title.toUpperCase()}` : `NO ${card.title.toUpperCase()} DETECTED`;
        const statusSymbol = card.isPresent ? '✕' : '✓';

        let ingredientsHtml = '';
        if (card.isPresent && card.ingredients.length > 0) {
            ingredientsHtml = `
                <div class="ingredients-found">
                    <h4>Found ingredients:</h4>
                    <ul>
                        ${card.ingredients.map(ingredient => `<li>${ingredient}</li>`).join('')}
                    </ul>
                </div>
            `;
        }

        return `
            <div class="status-card">
                <div class="status-header">
                    <div class="status-title">
                        <span class="status-icon">${card.icon}</span>
                        <span>${card.title}</span>
                    </div>
                    <div class="status-indicator ${statusClass}">${statusSymbol}</div>
                </div>
                <div class="status-result ${statusClass}">${statusText}</div>
                ${ingredientsHtml}
            </div>
        `;
    }

    createNovaCard(novaScore) {
        const description = this.nutritionAnalyzer.getNovaDescription(novaScore);
        const color = this.nutritionAnalyzer.getNovaColor(novaScore);

        return `
            <div class="nova-card" style="background: linear-gradient(135deg, ${color} 0%, ${color}dd 100%);">
                <div class="nova-header">
                    <div class="nova-title">
                        <span class="status-icon">📊</span>
                        <span>NOVA Classification</span>
                    </div>
                    <div class="nova-score">${novaScore}</div>
                </div>
                <div class="nova-description">${description}</div>
            </div>
        `;
    }

    displayNutritionSummary(nutriments) {
        const summaryDiv = document.getElementById('nutrition-summary');

        if (!nutriments) {
            summaryDiv.innerHTML = '';
            return;
        }

        const summary = this.nutritionAnalyzer.formatNutritionSummary(nutriments);

        if (!summary || summary.length === 0) {
            summaryDiv.innerHTML = '';
            return;
        }

        const gridHtml = summary.map(item => `
            <div class="nutrition-item">
                <div class="label">${item.label}</div>
                <div class="value">${item.value} ${item.unit}</div>
            </div>
        `).join('');

        summaryDiv.innerHTML = `
            <h3>📊 Nutrition Facts (per 100g)</h3>
            <div class="nutrition-grid">
                ${gridHtml}
            </div>
            <p style="margin-top: 1rem; color: #666; font-size: 0.9rem;">Tap "View Detailed Nutrition" for complete breakdown</p>
        `;
    }

    showNutritionDetails() {
        if (!this.currentProduct || !this.currentProduct.nutriments) {
            return;
        }

        const nutrition = this.nutritionAnalyzer.formatDetailedNutrition(this.currentProduct.nutriments);
        const detailsDiv = document.getElementById('nutrition-details');

        let html = `
            <div class="product-info mb-3">
                <div class="product-name">${this.currentProduct.product_name || 'Unknown Product'}</div>
                <p style="color: #666; margin-top: 0.5rem;">Nutrition Facts per 100g</p>
            </div>
        `;

        // Macronutrients
        if (nutrition.macronutrients.length > 0) {
            html += `
                <div class="nutrition-section">
                    <h3>🍎 Macronutrients</h3>
                    <div class="nutrition-grid-detailed">
                        ${nutrition.macronutrients.map(item => `
                            <div class="nutrition-item-detailed">
                                <div class="label">${item.label}</div>
                                <div class="value">${item.value}</div>
                                <div class="unit">${item.unit}</div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }

        // Vitamins
        if (nutrition.vitamins.length > 0) {
            html += `
                <div class="nutrition-section">
                    <h3>💊 Vitamins</h3>
                    <div class="nutrition-grid-detailed">
                        ${nutrition.vitamins.map(item => `
                            <div class="nutrition-item-detailed">
                                <div class="label">${item.label}</div>
                                <div class="value">${item.value}</div>
                                <div class="unit">${item.unit}</div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }

        // Minerals
        if (nutrition.minerals.length > 0) {
            html += `
                <div class="nutrition-section">
                    <h3>⚡ Minerals</h3>
                    <div class="nutrition-grid-detailed">
                        ${nutrition.minerals.map(item => `
                            <div class="nutrition-item-detailed">
                                <div class="label">${item.label}</div>
                                <div class="value">${item.value}</div>
                                <div class="unit">${item.unit}</div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }

        detailsDiv.innerHTML = html;
        this.showScreen('nutrition-screen');
    }

    showError(message) {
        document.getElementById('error-message').textContent = message;
        this.showScreen('error-screen');
    }
}

// Initialize the app when the page loads
document.addEventListener('DOMContentLoaded', () => {
    console.log('Initializing Food Scanner App...');
    new FoodScannerApp();
});