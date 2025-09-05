# UK Divorce Time Series Analysis

**Analyzing trends in UK divorce data using statistical forecasting and time series methods in R.**

---

## Table of Contents
- [Background](#background)
- [Data](#data)
- [Methodology](#methodology)
- [Setup & Requirements](#setup--requirements)
- [Results](#results)
- [Future Work](#future-work)
- [License](#license)

---

## Background
This project explores divorce trends in **England and Wales** using time series analysis in **R**.  
The aim is to identify long-term patterns, short-term fluctuations, and forecast future divorce rates.

Understanding divorce patterns is crucial for policymakers, sociologists, and researchers studying family dynamics.

---

## Data
- **Source:** UK Office for National Statistics (ONS) and related datasets  
  - [ONS Divorce Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/divorce/bulletins/divorcesinenglandandwales/2023)  
  - [Our World in Data: Marriages ending in divorce](https://ourworldindata.org/grapher/marriages-uk-ended-in-divorce)  

- **Format:** CSV/Excel files containing yearly divorce counts, demographic splits, and durations.  
- **Coverage:** Multiple decades of UK divorce data.  
- **Preprocessing:** Cleaned missing values, standardized formats, and prepared for time series modeling.  

---

## ⚙️ Methodology
The analysis was carried out in **R** with the following steps:
1. **Data Preprocessing** – Cleaning, handling missing values, and formatting for time series.
2. **Exploratory Data Analysis (EDA)** – Visualizing divorce trends over time.
3. **Time Series Modeling** – Applied ARIMA, decomposition, and forecasting techniques.
4. **Forecasting** – Predicting future divorce rates based on historical patterns.
5. **Visualization** – Trend plots, seasonal decomposition, and forecast graphs.

**R Packages Used:**
- `tidyverse`
- `lubridate`
- `forecast`
- `tseries`
- `ggplot2`
- `readr`

---

## 🖥️ Setup & Requirements

### Requirements
- R (version 4.0 or higher)
- RStudio (recommended)

### Installation
Open R or RStudio and install required packages:

install.packages(c("tidyverse", "lubridate", "forecast", "tseries", "ggplot2", "readr"))


## Results

Key findings:

- Divorce rates peaked around the early 2000s, followed by a steady decline.

- Marriages formed after 2000 show a lower likelihood of divorce within the first 10 years (Our World in Data
).

Forecasts suggest that divorce rates will continue to decline moderately over the next decade.

Example visualizations include:

- Trend plots of yearly divorce counts.

- Seasonal decomposition (trend + seasonality + residuals).

- Forecast projections using ARIMA.

(All graphs are stored in the results/ or images/ folder.)

## Future Work

- Add regional and demographic breakdowns (age, gender, socioeconomic factors).

- Extend forecasting through 2030 and beyond.

- Build an interactive dashboard using R Shiny or Plotly in R.

```r
