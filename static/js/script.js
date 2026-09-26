// Smooth navigation

document.querySelectorAll('a[href^="#"]').forEach(link => {

    link.addEventListener("click", function (event) {

        const target = document.querySelector(this.getAttribute("href"));

        if (target) {

            event.preventDefault();

            target.scrollIntoView({
                behavior: "smooth"
            });

        }

    });

});


// Small scroll effect for navbar

const navbar = document.querySelector(".navbar");

window.addEventListener("scroll", () => {

    if (window.scrollY > 30) {

        navbar.style.boxShadow =
            "0 8px 30px rgba(30, 30, 60, 0.08)";

    } else {

        navbar.style.boxShadow = "none";

    }

});