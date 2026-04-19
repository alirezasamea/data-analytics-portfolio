# Tableau Projects

This folder contains two Tableau dashboard projects, each built around a real Canadian policy topic using publicly available data. They are designed to be completed in order. Each one introduces new concepts that build on the previous.

---

## Recommended Order

### 1. Canadian Housing Market Intelligence Dashboard (Start Here)
**Difficulty:** Advanced
**Business Question:** Where have Canadian housing prices grown the fastest, which property types are leading, and what do the trends signal for buyers and policymakers?

A strong first Tableau project. The dataset covers 20 years of monthly data across 59 regional markets. You will learn how to reshape a messy multi-sheet Excel file into a clean flat CSV using Python, then build a two-dashboard system with parameters, LOD expressions, and dual-axis charts.

**What you will learn:**
- Reshaping multi-sheet Excel data into a flat CSV using Python and pandas
- Connecting Tableau to a cleaned CSV data source
- Building parameters to create dynamic user-driven views
- Writing LOD (Level of Detail) expressions to compute values independent of view filters
- Building dual-axis synchronized line charts
- Creating calculated fields for month-over-month change using table calculations
- Building dynamic titles that update with parameter selections
- Connecting two dashboards with navigation buttons

---

### 2. Canadian Labour Market Dashboard (Continue Here)
**Difficulty:** Advanced
**Business Question:** How has Canada's labour market evolved since 2000, which regions and industries lead, and how do age groups experience the market differently?

A step up in analytical scope. This project uses four separate Statistics Canada data sources that must be connected and managed independently. You will build a five-page workbook covering national trends, provincial comparisons, industry employment and wages, and demographic breakdowns -- and learn several reusable calculated field patterns that apply to many real-world dashboard problems.

**What you will learn:**
- Connecting and managing multiple data sources in one workbook
- Building context filters to control the base data universe
- Using the `Line Type` calculated field pattern to keep colors consistent regardless of parameter selection
- Using the `Province Filter` calculated field pattern to show a selected value and a fixed benchmark on the same chart simultaneously
- Building choropleth maps with province-level geographic data
- Adding dashboard actions to link map and bar chart clicks to trend line charts
- Excluding aggregate rows from a shown filter using a NULL calculated field
- Building a cover page with a background image, live KPI cards, and navigation buttons

---

More projects will be added to this folder as the portfolio grows.

---

## Skills Progression

| Skill | Housing Market | Labour Market |
|-------|---------------|---------------|
| Data preparation | Python + pandas pipeline | Multi-source CSV connection |
| Parameters | Single region parameter | Province parameter with dashboard actions |
| Calculated fields | LOD expressions, MoM change | Line Type, Province Filter, Industry Name |
| Map visualization | Province choropleth | Province choropleth with click actions |
| Dashboard navigation | Two-dashboard system | Five-page system with cover page |
| Interactivity | Parameter dropdown | Parameter + dashboard actions + multi-select filter |
