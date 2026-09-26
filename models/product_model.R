# ============================================
# PRODUCT SEGMENTATION
# Hierarchical Clustering using R
# ============================================


# Load product data
data <- read.csv("datasets/products.csv")


# Select features
product_features <- data[
    c(
        "Price",
        "SalesQuantity",
        "Rating",
        "PurchaseFrequency"
    )
]


# Scale the features
scaled_data <- scale(product_features)


# Calculate distance matrix
distance_matrix <- dist(
    scaled_data,
    method = "euclidean"
)


# Perform hierarchical clustering
hierarchical_model <- hclust(
    distance_matrix,
    method = "ward.D2"
)


# Create 3 clusters
clusters <- cutree(
    hierarchical_model,
    k = 3
)


# Add cluster information
data$Cluster <- clusters


# Count products in each cluster
cluster_counts <- table(
    data$Cluster
)


# Print results
cat("Product Segmentation Results\n\n")


for (i in 1:3) {

    count <- cluster_counts[
        as.character(i)
    ]

    cat(
        paste0(
            "Cluster ",
            i,
            ": ",
            count,
            " products\n"
        )
    )
}


cat("\n")


# Calculate cluster characteristics

for (i in 1:3) {

    cluster_data <- data[
        data$Cluster == i,
    ]


    avg_price <- round(
        mean(cluster_data$Price),
        2
    )


    avg_sales <- round(
        mean(cluster_data$SalesQuantity),
        2
    )


    avg_rating <- round(
        mean(cluster_data$Rating),
        2
    )


    avg_frequency <- round(
        mean(cluster_data$PurchaseFrequency),
        2
    )


    cat(
        paste0(
            "Cluster ",
            i,
            " | Price: ₹",
            avg_price,
            " | Sales: ",
            avg_sales,
            " | Rating: ",
            avg_rating,
            " | Frequency: ",
            avg_frequency,
            "\n"
        )
    )
}