data <- read.csv("datasets/products.csv")

product_features <- data[
    c("Price", "SalesQuantity", "Rating", "PurchaseFrequency")
]

scaled_data <- scale(product_features)

distance_matrix <- dist(
    scaled_data,
    method = "euclidean"
)

hierarchical_model <- hclust(
    distance_matrix,
    method = "ward.D2"
)

clusters <- cutree(
    hierarchical_model,
    k = 3
)

cluster_centers <- t(
    sapply(
        1:3,
        function(i) {
            colMeans(
                scaled_data[clusters == i, , drop = FALSE]
            )
        }
    )
)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 4) {
    cat("Please provide Price, SalesQuantity, Rating and PurchaseFrequency")
} else {

    price <- as.numeric(args[1])
    sales <- as.numeric(args[2])
    rating <- as.numeric(args[3])
    frequency <- as.numeric(args[4])

    new_product <- data.frame(
        Price = price,
        SalesQuantity = sales,
        Rating = rating,
        PurchaseFrequency = frequency
    )

    scaled_new <- scale(
        new_product,
        center = attr(scaled_data, "scaled:center"),
        scale = attr(scaled_data, "scaled:scale")
    )

    distances <- apply(
        cluster_centers,
        1,
        function(center) {
            sqrt(sum((as.numeric(scaled_new[1, ]) - center)^2))
        }
    )

    new_cluster <- which.min(distances)

    cat(new_cluster)
}