document.addEventListener("click", function (e) {
    const btn = e.target.closest(".page-btn");

    if (btn && !btn.classList.contains("disabled") && !btn.classList.contains("active")) {
        const page = parseInt(btn.dataset.page);
        if (isNaN(page)) return;

        const filterForm = document.getElementById("filter-form");
        const sortSelect = document.getElementById("sort-select");
        const isLoadMore = btn.classList.contains("load-more-btn");

        let queryString = "";
        if (filterForm) {
            const formData = new FormData(filterForm);
            if (sortSelect) formData.append("sort", sortSelect.value);
            formData.append("page", page);
            formData.append("ajax", "1");
            const params = new URLSearchParams(formData);
            queryString = "?" + params.toString();
        } else {
            queryString = `?page=${page}&ajax=1`;
        }

        const productsContainer = document.getElementById("productsContainer");
        const productGrid = document.getElementById("productGrid");

        if (isLoadMore && btn) {
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tải...';
            btn.disabled = true;
        } else if (productsContainer) {
            productsContainer.style.opacity = "0.5";
        }

        fetch(`${CONTEXT_PATH}/products${queryString}`)
            .then(res => res.text())
            .then(html => {
                if (isLoadMore) {
                    // Append new product items
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, "text/html");
                    const newItems = doc.querySelectorAll(".product-item");
                    if (productGrid && newItems.length > 0) {
                        newItems.forEach(item => productGrid.appendChild(item));
                    }
                    // Replace pagination container
                    const newLoadMoreContainer = doc.getElementById("loadMoreContainer");
                    const oldContainer = document.getElementById("loadMoreContainer");
                    if (oldContainer && newLoadMoreContainer) {
                        oldContainer.innerHTML = newLoadMoreContainer.innerHTML;
                    }
                } else {
                    // Replace entire products container (numbered page navigation)
                    if (productsContainer) {
                        productsContainer.innerHTML = html;
                        productsContainer.style.opacity = "1";
                        productsContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }

                const cleanQuery = queryString.replace("&ajax=1", "").replace("?ajax=1&", "?").replace("?ajax=1", "");
                const newUrl = CONTEXT_PATH + "/products" + cleanQuery;
                window.history.pushState({}, '', newUrl);
            })
            .catch(err => {
                console.error(err);
                if (productsContainer) productsContainer.style.opacity = "1";
                if (isLoadMore && btn) {
                    btn.innerHTML = 'LOAD MORE';
                    btn.disabled = false;
                }
            });
    }
});