
    document.addEventListener("DOMContentLoaded", () => {
    // ================== Sản phẩm gợi ý ==================
    document.querySelectorAll(".product-card .card-action-btn").forEach((btn) => {
        btn.addEventListener("click", (e) => {
            e.preventDefault();
            const icon = btn.querySelector("ion-icon");
            const iconName = icon ? icon.getAttribute("name") : null;

            if (iconName === "cart-outline") {
                showToast(`Đã thêm sản phẩm vào Giỏ Hàng!`);
            } else if (iconName === "heart-outline") {
                showToast(`Đã thêm sản phẩm vào mục Yêu thích!`);
            }
        });
    });

    // ================== Popup màu & size & số lượng ==================
    const colorItems = document.querySelectorAll("#popupColors .popup-color-item");
    colorItems.forEach(item => item.addEventListener("click", () => {
    colorItems.forEach(i => i.classList.remove("selected"));
    item.classList.add("selected");
}));

    const sizeItems = document.querySelectorAll("#popupSizes .popup-size-item");
    sizeItems.forEach(item => item.addEventListener("click", () => {
    sizeItems.forEach(i => i.classList.remove("selected"));
    item.classList.add("selected");
}));

    const qtyInput = document.getElementById("popupQty");
    document.querySelector(".qty-btn.minus").addEventListener("click", () => {
    let val = parseInt(qtyInput.value);
    if (val > 1) qtyInput.value = val - 1;
});
    document.querySelector(".qty-btn.plus").addEventListener("click", () => {
    qtyInput.value = parseInt(qtyInput.value) + 1;
});
    qtyInput.addEventListener("input", () => { if (qtyInput.value < 1) qtyInput.value = 1; });

    // ================== Hàm toast & popup ==================
    window.showToast = (message) => {
        const toast = document.getElementById("toast-message");
        if (toast) {
            const span = toast.querySelector("span");
            if (span) span.textContent = message;
            toast.classList.add("show");
            setTimeout(() => toast.classList.remove("show"), 3000);
        }
    };

    // ================== Mobile menu, chọn size chi tiết sản phẩm ==================
    const navOpenBtn = document.querySelector(".nav-open-btn");
    const navCloseBtn = document.querySelector(".nav-close-btn");
    const navbar = document.querySelector(".navbar");
    const overlay = document.querySelector(".overlay");
    const toggleNav = () => { navbar.classList.toggle("active"); overlay.classList.toggle("active"); };
    if (navOpenBtn) navOpenBtn.addEventListener("click", toggleNav);
    if (navCloseBtn) navCloseBtn.addEventListener("click", toggleNav);
    if (overlay) overlay.addEventListener("click", toggleNav);

    const sizeBtns = document.querySelectorAll(".size-btn");
    sizeBtns.forEach(btn => btn.addEventListener("click", () => {
    sizeBtns.forEach(b => b.classList.remove("selected"));
    btn.classList.add("selected");
}));

    // Checkbox màu chi tiết sản phẩm chỉ chọn 1
    const checkboxes = document.querySelectorAll('.filter-list-color input[type="checkbox"]');
    checkboxes.forEach(checkbox => checkbox.addEventListener("change", function () {
    if (this.checked) {
    checkboxes.forEach(other => { if (other !== this) other.checked = false; });
}
}));
        document.addEventListener("DOMContentLoaded", () => {
            const actionButtons = document.querySelectorAll("[data-require-size]");
            const sizeButtons = document.querySelectorAll(".size-btn");
            const warning = document.querySelector(".size-warning");

            function triggerSizeError() {
                sizeButtons.forEach(btn => {
                    btn.classList.add("size-error");
                });

                if (warning) warning.classList.add("show");

                setTimeout(() => {
                    sizeButtons.forEach(btn => btn.classList.remove("size-error"));
                }, 900);
            }

            actionButtons.forEach(btn => {
                btn.addEventListener("click", e => {
                    const selectedSize = document.querySelector(".size-btn.selected");

                    if (!selectedSize) {
                        e.preventDefault();
                        triggerSizeError();
                    }
                });
            });
        });

    });
