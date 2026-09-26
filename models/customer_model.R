# ============================================
# CUSTOMER SEGMENTATION
# K-Means Clustering using R
# ============================================


# Load customer data
data <- read.csv("datasets/customers.csv")


# Select features for clustering
customer_features <- data[
    c(
        "Age",
        "AnnualIncome",
        "SpendingScore",
        "PurchaseFrequency"
    )
]


# Scale the data
scaled_data <- scale(customer_features)


# Apply K-Means
set.seed(123)

kmeans_model <- kmeans(
    scaled_data,
    centers = 3,
    nstart = 25
)


# Add cluster number
data$Cluster <- kmeans_model$cluster


# Get cluster information
cluster_counts <- table(data$Cluster)


# Print results
cat("Customer Segmentation Results\n\n")


for (i in 1:3) {

    count <- cluster_counts[as.character(i)]

    cat(
        paste0(
            "Cluster ",
            i,
            ": ",
            count,
            " customers\n"
        )
    )
}


cat("\n")


# Calculate cluster characteristics
for (i in 1:3) {

    cluster_data <- data[data$Cluster == i, ]

    avg_age <- round(mean(cluster_data$Age), 1)

    avg_income <- round(
        mean(cluster_data$AnnualIncome),
        0
    )

    avg_spending <- round(
        mean(cluster_data$SpendingScore),
        1
    )

    avg_frequency <- round(
        mean(cluster_data$PurchaseFrequency),
        1
    )


    cat(
        paste0(
            "Cluster ",
            i,
            " | Age: ",
            avg_age,
            " | Income: ₹",
            avg_income,
            " | Spending: ",
            avg_spending,
            " | Frequency: ",
            avg_frequency,
            "\n"
        )
    )
}