# Replication of "An Econometric Analysis of Inventory Turnover Performance in Retail Services"

This project is part of the *Empirical Approach for Business Analytics* course in the MSBA program at Korea University Business School.  
We replicate the empirical analysis of Gaur et al. (2005) using STATA and firm-level financial data extracted from the Compustat database.

---

## 📄 Reference Paper

- **Title**: An Econometric Analysis of Inventory Turnover Performance in Retail Services  
- **Authors**: Vishal Gaur, Marshall L. Fisher, Ananth Raman  
- **Journal**: *Management Science*, Vol. 51, No. 2, pp. 181–194  
- **DOI**: [10.1287/mnsc.1040.0298](https://doi.org/10.1287/mnsc.1040.0298)

---

## 📁 Project Files

| Filename                       | Description |
|--------------------------------|-------------|
| `Replication_HW.do`            | Main STATA code for replication |
| `Guar et al. (2005)....pdf`    | Original academic paper |
| `Q1985.dta`, `Q2001.dta`       | Quarterly Compustat financials (1985, 2001) |
| `A1985.dta`, `A2001.dta`       | Annual Compustat financials (1985, 2001) |

---

## 🔧 Methodology and Tools

- **Software**: STATA 17
- **Data Source**: WRDS / Compustat
- **Analysis Period**: 1985–2001 (subset of years used for sample)
- **Main Techniques**:
  - Panel regression (`xtreg`)
  - Firm and year fixed effects
  - Log-linear transformation
  - Year-specific fixed effect visualization (error bar plots)
  - Replication of Models (1) and (2) from the paper

---

## 📈 Key Variables

- **Dependent Variable**: Inventory Turnover (IT)
- **Explanatory Variables**:
  - Gross Margin (GM)
  - Capital Intensity (CI)
  - Sales Surprise (SS)

All variables are constructed following the methodology described in the paper, including Holt's linear exponential smoothing to compute sales forecasts.

---

## 📊 Data Preparation Summary

- **Quarterly data (`Q*.dta`)**: Used for computing average inventory, total assets, and fixed assets per year
- **Annual data (`A*.dta`)**: Used for sales, cost of goods sold, and actual vs forecasted sales
- Datasets are merged by `gvkey` and `fyear` to create a balanced panel

---

## 🚀 How to Run

1. Open the file `Replication_HW.do` in STATA
2. Execute the entire script or step-by-step using the provided comments
3. Regression results and plots will be generated as output

> 📌 Note: Compustat data must be extracted and cleaned to match the structure expected by the code (variable names, formats, etc.).

---

## 📝 Notes

- This code is developed solely for academic and educational use.
- Please cite the original paper when using this replication or its results.
- Some simplifications or assumptions may have been made to reflect classroom data availability.

---

## 📄 License

MIT License — for non-commercial academic and research use.