data <- read.csv("datasets/customers.csv")

customer_features <- data[
    c("Age", "AnnualIncome", "SpendingScore", "PurchaseFrequency")
]

scaled_data <- scale(customer_features)

set.seed(123)

kmeans_model <- kmeans(
    scaled_data,
    centers = 3,
    nstart = 25
)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 4) {
    cat("Please provide Age, AnnualIncome, SpendingScore and PurchaseFrequency")
} else {

    age <- as.numeric(args[1])
    income <- as.numeric(args[2])
    spending <- as.numeric(args[3])
    frequency <- as.numeric(args[4])

    new_customer <- data.frame(
        Age = age,
        AnnualIncome = income,
        SpendingScore = spending,
        PurchaseFrequency = frequency
    )

    scaled_new <- scale(
        new_customer,
        center = attr(scaled_data, "scaled:center"),
        scale = attr(scaled_data, "scaled:scale")
    )

    distances <- apply(
        kmeans_model$centers,
        1,
        function(center) {
            sqrt(sum((as.numeric(scaled_new[1, ]) - center)^2))
        }
    )

    new_cluster <- which.min(distances)

    cat(new_cluster)
}