from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/sales")
def sales():
    return render_template("sales.html")


@app.route("/predict-sales", methods=["POST"])
def predict_sales():

    advertising = request.form.get("advertising")

    result = subprocess.run(
        ["Rscript", "models/sales_model.R", advertising],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        return f"<h2>R Model Error</h2><pre>{result.stderr}</pre>"

    prediction = result.stdout.strip()

    return render_template(
        "sales.html",
        prediction=prediction
    )


@app.route("/revenue")
def revenue():
    return render_template("revenue.html")


@app.route("/predict-revenue", methods=["POST"])
def predict_revenue():

    customers = request.form.get("customers")
    advertising = request.form.get("advertising")
    average_order_value = request.form.get("average_order_value")

    result = subprocess.run(
        [
            "Rscript",
            "models/revenue_model.R",
            customers,
            advertising,
            average_order_value
        ],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        return f"<h2>R Model Error</h2><pre>{result.stderr}</pre>"

    prediction = result.stdout.strip()

    return render_template(
        "revenue.html",
        prediction=prediction
    )


@app.route("/customer")
def customer():
    return render_template("customer.html")


@app.route("/segment-customers", methods=["POST"])
def segment_customers():

    age = request.form.get("age")
    income = request.form.get("income")
    spending = request.form.get("spending")
    frequency = request.form.get("frequency")

    result = subprocess.run(
        [
            "Rscript",
            "models/customer_model.R",
            age,
            income,
            spending,
            frequency
        ],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        return f"<h2>R Model Error</h2><pre>{result.stderr}</pre>"

    cluster = result.stdout.strip()

    return render_template(
        "customer.html",
        cluster=cluster
    )


@app.route("/product")
def product():
    return render_template("product.html")


@app.route("/segment-products", methods=["POST"])
def segment_products():

    price = request.form.get("price")
    sales = request.form.get("sales")
    rating = request.form.get("rating")
    frequency = request.form.get("frequency")

    result = subprocess.run(
        [
            "Rscript",
            "models/product_model.R",
            price,
            sales,
            rating,
            frequency
        ],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        return f"<h2>R Model Error</h2><pre>{result.stderr}</pre>"

    cluster = result.stdout.strip()

    return render_template(
        "product.html",
        cluster=cluster
    )


if __name__ == "__main__":
    app.run(debug=True)