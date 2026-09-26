from flask import Flask, render_template, request, send_from_directory
import subprocess

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/static/css/style.css")
def style_css():
    return send_from_directory("static/css", "style.css")

@app.route("/static/js/script.js")
def script_js():
    return send_from_directory("static/js", "script.js")



@app.route("/sales")
def sales():
    return render_template("sales.html")


# ============================================
# SALES PREDICTION
# ============================================

@app.route("/predict-sales", methods=["POST"])
def predict_sales():

    advertising = request.form.get("advertising")

    try:

        # Run R model
        result = subprocess.run(
            [
                "Rscript",
                "models/sales_model.R",
                advertising
            ],
            capture_output=True,
            text=True
        )


        # Get R output
        prediction = result.stdout.strip()


        # Check R error
        if result.returncode != 0:

            return f"""
            <h2>R Model Error</h2>
            <pre>{result.stderr}</pre>
            """


        return render_template(
            "sales.html",
            prediction=prediction
        )


    except Exception as e:

        return f"""
        <h2>Connection Error</h2>
        <p>{e}</p>
        """


# ============================================
# OTHER PAGES
# ============================================

@app.route("/revenue")
def revenue():

    return render_template("revenue.html")
@app.route("/predict-revenue", methods=["POST"])
def predict_revenue():

    customers = request.form.get("customers")

    advertising = request.form.get("advertising")

    average_order_value = request.form.get("average_order_value")


    try:

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


        prediction = result.stdout.strip()


        if result.returncode != 0:

            return f"""
            <h2>R Model Error</h2>
            <pre>{result.stderr}</pre>
            """


        return render_template(
            "revenue.html",
            prediction=prediction
        )


    except Exception as e:

        return f"""
        <h2>Connection Error</h2>
        <p>{e}</p>
        """

@app.route("/customer")
def customer():

    return render_template("customer.html")
@app.route("/segment-customers", methods=["POST"])
def segment_customers():

    try:

        result = subprocess.run(
            [
                "Rscript",
                "models/customer_model.R"
            ],
            capture_output=True,
            text=True
        )


        if result.returncode != 0:

            return f"""
            <h2>R Model Error</h2>
            <pre>{result.stderr}</pre>
            """


        output = result.stdout


        # Create three cluster results
        clusters = []

        for i in range(1, 4):

            search_text = f"Cluster {i}:"

            count = 0

            for line in output.splitlines():

                if line.startswith(search_text):

                    count = line.split(":")[1].strip()

                    count = int(count.split()[0])

                    break


            clusters.append({
                "number": i,
                "count": count
            })


        return render_template(
            "customer.html",
            clusters=clusters
        )


    except Exception as e:

        return f"""
        <h2>Connection Error</h2>
        <p>{e}</p>
        """
    

@app.route("/product")
def product():

    return render_template("product.html")

@app.route("/segment-products", methods=["POST"])
def segment_products():

    try:

        result = subprocess.run(
            [
                "Rscript",
                "models/product_model.R"
            ],
            capture_output=True,
            text=True
        )


        if result.returncode != 0:

            return f"""
            <h2>R Model Error</h2>
            <pre>{result.stderr}</pre>
            """


        output = result.stdout


        clusters = []


        for i in range(1, 4):

            search_text = f"Cluster {i}:"

            count = 0


            for line in output.splitlines():

                if line.startswith(search_text):

                    count = line.split(":")[1].strip()

                    count = int(
                        count.split()[0]
                    )

                    break


            clusters.append({
                "number": i,
                "count": count
            })


        return render_template(
            "product.html",
            clusters=clusters
        )


    except Exception as e:

        return f"""
        <h2>Connection Error</h2>
        <p>{e}</p>
        """
# ============================================
# RUN APPLICATION
# ============================================

if __name__ == "__main__":

    app.run(debug=True)