# Bank Marketing Classification
Python Machine Learning Series | Project 1: Classification

---

## About This Project

This is the first project in the Python Machine Learning series. It is designed as a starting point for anyone learning applied machine learning, covering the full workflow from raw data to model comparison and business recommendations.

This is a guided project built around a real bank marketing dataset. If you follow the notebook from start to finish, you will end up with a clean, well-documented classification analysis that compares five models and produces actionable business recommendations.

The central business question we are trying to answer is: **Can we predict whether a bank customer will subscribe to a term deposit, and which machine learning model does it best?**

This is one of the most common and practical use cases in banking and marketing analytics, making it a strong portfolio project for anyone learning applied machine learning with Python.

**Dataset:** [UCI Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing), publicly available from the UCI Machine Learning Repository. 41,188 customer records, 20 input features, binary target variable (yes/no subscription).

---

## What You Will Learn

After finishing this project you will be able to:

- Load and explore a real-world dataset using pandas
- Identify and handle data leakage before modeling
- Perform exploratory data analysis (EDA) on both numerical and categorical features
- Recognize and address class imbalance in a classification problem
- Encode categorical features using label encoding and one-hot encoding
- Build and evaluate five classification models using scikit-learn
- Use a preprocessing pipeline with ColumnTransformer to avoid data leakage
- Interpret precision, recall, and F1-score correctly for imbalanced datasets
- Compare model performance and make business recommendations

---

## Tools Required

- Python 3 with the following libraries: pandas, numpy, matplotlib, seaborn, scikit-learn
- VS Code with the Jupyter extension (or any Python environment)

To install the required libraries, run:

```
pip install pandas numpy matplotlib seaborn scikit-learn
```

---

## Project Structure

```
Bank-Marketing-Classification/
├── bank_marketing_classification.ipynb
├── README.md
└── data/
    └── bank-additional-full.csv
```

---

## Key Concepts Covered

Before diving in, it helps to understand a few concepts that come up throughout the project:

**Data Leakage:** When information that would not be available at prediction time is included during training. In this dataset, the `duration` column (length of the last phone call) is only known after the call ends, so including it would give the model an unfair advantage and produce misleadingly high accuracy.

**Class Imbalance:** When one class has far more samples than the other. In this dataset, only 11.3% of customers subscribed. A model that always predicts "no" would still be 88.7% accurate, making accuracy a misleading metric. We use precision, recall, and F1-score instead.

**Why Encode Categorical Features?** Sklearn models can only work with numbers. They perform mathematical operations such as calculating distances (kNN) and finding decision boundaries (SVM), which require numerical input. Every categorical column must be converted to numbers before training.

**Label Encoding vs One-Hot Encoding:** Label encoding assigns an integer to each category and is appropriate for binary columns. One-hot encoding creates a separate 0/1 column for each category and is appropriate for columns with 3 or more values. Using label encoding on a multi-category column would imply a ranking that does not exist.

**class_weight='balanced':** A technique that tells the model to give more importance to the minority class during training. This helps models better identify subscribers without requiring oversampling.

---

## Analysis Structure

### Section 1: Data Loading and Exploration
Load the dataset, inspect its shape, column names, and first rows.

### Section 2: Exploratory Data Analysis (EDA)
- Check for missing values, duplicates, and data leakage
- Analyze class distribution and confirm imbalance
- Plot distributions of numerical and categorical features
- Drop low-value features based on data evidence

### Section 3: Data Preprocessing
- Encode the target variable and binary features
- Separate features and target
- Split into training and testing sets using stratified sampling
- Build a preprocessing pipeline with scaling and one-hot encoding

### Section 4: Machine Learning Models
Five models are trained and evaluated, each in a standard and balanced version:

| Model | Key Characteristic |
|---|---|
| Logistic Regression | Linear baseline, highly interpretable |
| Decision Tree | Captures non-linear patterns, easy to visualize |
| Random Forest | Ensemble of trees, reduces overfitting |
| Support Vector Machine (SVM) | Finds optimal decision boundary |
| Neural Network (MLP) | Multi-layer perceptron, learns complex patterns |

### Section 5: Model Comparison and Recommendations
All models compared on accuracy, precision, recall, and F1-score for the minority class.

---

## Model Results

| Model | Accuracy | Precision (Yes) | Recall (Yes) | F1 (Yes) |
|---|---|---|---|---|
| Logistic Regression | 0.90 | 0.65 | 0.21 | 0.32 |
| Balanced Logistic Regression | 0.83 | 0.36 | 0.64 | 0.46 |
| Decision Tree | 0.84 | 0.32 | 0.35 | 0.34 |
| Balanced Decision Tree | 0.85 | 0.33 | 0.35 | 0.34 |
| Random Forest | 0.89 | 0.54 | 0.29 | 0.37 |
| Balanced Random Forest | 0.89 | 0.55 | 0.29 | 0.38 |
| SVM | 0.90 | 0.66 | 0.25 | 0.36 |
| Balanced SVM | 0.85 | 0.41 | 0.63 | 0.49 |
| Neural Network | 0.89 | 0.48 | 0.23 | 0.31 |

The Balanced SVM achieves the best balance between identifying subscribers and overall performance. The Balanced Logistic Regression is a strong alternative when interpretability matters more.

---

## Key Insights

| Finding | Value | Implication |
|---|---|---|
| Class imbalance | 88.7% no, 11.3% yes | Accuracy is misleading -- use F1-score |
| Best model for minority class | Balanced SVM | Recall of 0.63 for subscribers |
| Impact of class balancing | Recall doubles for Logistic Regression | Standard models miss most subscribers |
| Random Forest and balancing | Minimal improvement | Not all models benefit from class weighting |
| `duration` column | Dropped due to data leakage | Would inflate accuracy unrealistically |
| `default` column | Only 3 "yes" out of 41,176 | Near-zero predictive signal, dropped |

---

## How to Run

1. Download the dataset from the [UCI Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing) page
2. Extract the zip file and place `bank-additional-full.csv` inside the `data/` folder
3. Open `bank_marketing_classification.ipynb` in VS Code
4. Select your Python interpreter (Python 3 with required libraries installed)
5. Run all cells in order from top to bottom

---

## Notes and Limitations

- **Rule-based preprocessing.** The encoding and feature engineering decisions are based on domain knowledge and EDA findings, not automated feature selection.
- **class_weight approach.** We address class imbalance using class weighting rather than oversampling. Both are valid approaches and produce different trade-offs.
- **Neural Network convergence.** The MLP model may produce a convergence warning with default settings, indicating that more iterations could improve results.
- **This is Project 1 of the ML series.** We intentionally keep the workflow 
  straightforward to focus on core classification concepts. Techniques such as 
  cross-validation and random search for hyperparameter tuning will be covered 
  in the next project as we move toward more advanced modeling practices.

---

## About the Author

**Alireza Samea**
- Lecturer, Northeastern University Vancouver
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: a.samea@northeastern.edu

---

*Dataset: UCI Bank Marketing Dataset, publicly available from the UCI Machine Learning Repository. Original research: Moro et al., 2014.*
