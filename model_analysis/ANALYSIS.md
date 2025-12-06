# Model Analysis Directory

This directory contains SQL scripts, CSV log extracts, analysis notebooks, and generated performance reports related to the combined firewall and login event dataset.

---

## 🔍 Core Files

### `selected_data.sql`
- Contains the *N* selected data points used for downstream analysis.

### `analysis.ipynb`
- Jupyter Notebook performing data analysis on the *N selected data points*, including confusion matrix and visualization steps.
- Reads the following CSV files (extracted from backup SQL logs):
  - `public_event_analyses.csv` (csv version of `selected_data.sql`)
- Creates the following CSV files:
  - `firewall_logs.csv`
  - `login_events.csv`
  - `event_analyses.csv`
  - `analysis_results.csv`
  - `performance_metrics.csv`
  - `risk_score_distribution_data.csv`

---

## 📂 Additional Files in This Directory

### SQL & Data Backups
- `backup_20251121.sql`

### Visualizations & Outputs
- `performance_analysis.png`
- `risk_score_distribution_custom.png`

### Documentation & Reports
- `ANALYSIS.md`
- `summary_report.txt`

## 📌 Summary

This directory consolidates the full analytical workflow:
1. **SQL extraction** of relevant data (`selected_data.sql`)
2. **CSV exports** from SQL backups
3. **Jupyter notebook analysis** (`analysis.ipynb`)
4. **Visual and statistical outputs** (PNG and CSV performance files)
5. **Supporting documentation** (`ANALYSIS.md`, `summary_report.txt`)