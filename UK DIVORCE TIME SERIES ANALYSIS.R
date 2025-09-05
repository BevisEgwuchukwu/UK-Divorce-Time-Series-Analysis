install.packages("readxl")
install.packages("forecast")
install.packages("ggplot2")
install.packages("TTR")

library(readxl)
library(forecast)
library(ggplot2)
library(TTR)
library(zoo)
library(dplyr)

# Load the divorce data
divorce_data <- read_excel('Clean Marriage data.xlsx') 

head(divorce_data)
summary(divorce_data)
str(divorce_data)

#check for missing data 
empty_cells <- sum(is.na(divorce_data))
print(paste('Empty cells in the dataset:', empty_cells))

#Check for missing values in each column
missing_columns <- colSums(is.na(divorce_data))
print(missing_columns)

# Replace missing values with column mean
divorce_data <- divorce_data %>%
  mutate(
    `England & Wales` = ifelse(is.na(`England & Wales`), 
                               mean(`England & Wales`, na.rm = TRUE), 
                               `England & Wales`),
    Scotland = ifelse(is.na(Scotland), 
                      mean(Scotland, na.rm = TRUE), 
                      Scotland),
    `Northern Ireland` = ifelse(is.na(`Northern Ireland`), 
                                mean(`Northern Ireland`, na.rm = TRUE), 
                                `Northern Ireland`)
  )

# Calculate New_UnitedKingdom column
divorce_data <- divorce_data %>%
  mutate(new_unitedkingdom = `England & Wales` + Scotland + `Northern Ireland`)

# Display the first few rows of the updated data
head(divorce_data)

#check for missing data 
empty_cells <- sum(is.na(divorce_data$new_unitedkingdom))
print(paste('Empty cells in the dataset:', empty_cells))

# Create a time series object (replace 'Divorces' with the actual column name)
divorce_ts <- ts(divorce_data$new_unitedkingdom, start = min(divorce_data$Year), frequency = 1)

# Plot the original time series
plot(divorce_ts, main = "Time Series of Divorces", xlab = "Year", ylab = "Number of Divorces")

# Apply simple moving average (with a window size of 3)
sma_divorce <- SMA(divorce_ts, n = 5)

# Plot the original time series and smoothed series
plot(divorce_ts, type = "l", col = "blue", lwd = 2, main = "Original and Smoothed Time Series",
     ylab = "Number of Divorces", xlab = "Year")
lines(sma_divorce, col = "red", lwd = 2)
legend("topright", legend = c("Original", "Smoothed (SMA)"), col = c("blue", "red"), lty = 1, lwd = 2)


#--------------------------------------------------------------------------------------------------------
# Forecast using Holt-Winters method (no seasonality)
hw_model <- HoltWinters(divorce_ts, beta = TRUE, gamma = FALSE, l.start=322414, b.start= 16910)
checkresiduals(hw_model)

#Plot fitted model
plot(hw_model)

# Generate forecasts for the next 5 years
forecast_hw <- forecast(hw_model, h = 5)
forecast_hw

# Plot the forecast
plot(forecast_hw, main = "Forecast Using Smoothing", xlab = "Year", ylab = "Number of Divorces")

# Calculate forecast errors
forecast_errors <- forecast_hw$residuals

# Remove NA values
forecast_errors <- na.omit(forecast_errors)

#Check for autocorrelation
Box.test(forecast_hw$residuals, lag=9, type = 'Ljung-Box')

# Create histogram with density plot
hist(forecast_errors, breaks = 20, probability = TRUE, col = "lightblue",
     main = "Histogram and Density Plot of HW Forecast Errors", xlab = "Forecast Errors")
lines(density(forecast_errors), col = "red", lwd = 2)

#--------------------------------------------------------------------------------------------------------
#ARIMA
# Fit an ARIMA model
arima_model <- auto.arima(divorce_ts)

# Summary of the ARIMA model
summary(arima_model)

# Plot the fitted model and residuals
checkresiduals(arima_model)

# Generate new forecasts
forecast_arima_refined <- forecast(arima_model, h = 5)
forecast_arima_refined
plot(forecast_arima_refined)

# Remove NA values from residuals
residuals_arima <- na.omit(forecast_arima_refined$residuals)

# Plot the ACF of the cleaned residuals
acf(residuals_arima, lag.max = 9, main = "ACF of Refined ARIMA Residuals (Cleaned)")

# Ensure residuals are available
residuals_arima <- na.omit(forecast_arima_refined$residuals)

# Calculate forecast errors
forecast_errors1 <- forecast_arima_refined$residuals

# Remove NA values
forecast_errors1 <- na.omit(forecast_errors)

# Create histogram with density plot
hist(forecast_errors1, breaks = 20, probability = TRUE, col = "lightblue",
     main = "Histogram and Density Plot of ARIMA Forecast Errors", xlab = "Forecast Errors")
lines(density(forecast_errors1), col = "red", lwd = 2)


#--------------------------------------------------------------------------------------------------------
#Exponential Smoothing Model
#Fit exponential smoothing model
esm_model <- ets(divorce_ts)

# Summary of the ARIMA model
summary(esm_model)

# Plot the fitted model and residuals
checkresiduals(esm_model)

# Generate new forecasts
forecast_esm_refined <- forecast(esm_model, h = 5)
forecast_esm_refined
plot(forecast_esm_refined)

# Remove NA values from residuals
residuals_esm <- na.omit(forecast_esm_refined$residuals)

# Plot the ACF of the cleaned residuals
acf(residuals_esm, lag.max = 9, main = "ACF of Refined ESM Residuals (Cleaned)")

# Ensure residuals are available
residuals_esm <- na.omit(forecast_esm_refined$residuals)

# Calculate forecast errors
forecast_errors2 <- forecast_esm_refined$residuals

# Remove NA values
forecast_errors2 <- na.omit(forecast_errors)

# Create histogram with density plot
hist(forecast_errors2, breaks = 20, probability = TRUE, col = "lightblue",
     main = "Histogram and Density Plot of ESM Forecast Errors", xlab = "Forecast Errors")
lines(density(forecast_errors2), col = "red", lwd = 2)

#--------------------------------------------------------------------------------------------------------
# Calculate RMSE for ARIMA
arima_fitted <- fitted(arima_model)
arima_rmse <- sqrt(mean((divorce_ts - arima_fitted)^2))
cat("ARIMA RMSE:", arima_rmse, "\n")

# Calculate RMSE for Holt-Winters
hw_fitted <- fitted(hw_model)
hw_rmse <- sqrt(mean((divorce_ts - hw_fitted)^2))
cat("Holt-Winters RMSE:", hw_rmse, "\n")

# Calculate RMSE for Exponential Smoothing Method
esm_fitted <- fitted(esm_model)
esm_rmse <- sqrt(mean((divorce_ts - esm_fitted)^2))
cat("Exponential Smoothing Method RMSE:", esm_rmse, "\n")
