# ============================================
# REVENUE PREDICTION
# Multiple Linear Regression using R
# ============================================


# Load dataset
data <- read.csv("datasets/revenue_data.csv")


# Build Multiple Linear Regression model
model <- lm(
    Revenue ~ Customers + Advertising + AverageOrderValue,
    data = data
)


# Get values from Python
args <- commandArgs(trailingOnly = TRUE)


if (length(args) < 3) {

    cat("Please provide Customers, Advertising and AverageOrderValue")

} else {

    customers <- as.numeric(args[1])

    advertising <- as.numeric(args[2])

    average_order_value <- as.numeric(args[3])


    # Create new data
    new_data <- data.frame(
        Customers = customers,
        Advertising = advertising,
        AverageOrderValue = average_order_value
    )


    # Predict revenue
    prediction <- predict(
        model,
        newdata = new_data
    )


    # Print only prediction
    cat(round(prediction, 2))
}