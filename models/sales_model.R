# ============================================
# SALES PREDICTION
# Linear Regression using R
# ============================================


# Load dataset
data <- read.csv("datasets/sales_data.csv")


# Build Linear Regression model
model <- lm(Sales ~ Advertising, data = data)


# Get advertising value from Python
args <- commandArgs(trailingOnly = TRUE)


if (length(args) == 0) {

    cat("Please provide advertising expenditure")

} else {

    advertising <- as.numeric(args[1])


    # Create new data
    new_data <- data.frame(
        Advertising = advertising
    )


    # Predict sales
    prediction <- predict(
        model,
        newdata = new_data
    )


    # Print only prediction
    cat(round(prediction, 2))
}