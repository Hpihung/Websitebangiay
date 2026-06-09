
document.addEventListener("DOMContentLoaded", function () {
    var navLinks    = document.querySelectorAll(".account-nav-list a");
    var tabContents = document.querySelectorAll(".tab-content");

    navLinks.forEach(function (link) {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            var targetTab = this.getAttribute("data-tab");

            navLinks.forEach(function (nav) { nav.closest("li").classList.remove("active"); });
            tabContents.forEach(function (content) { content.classList.remove("active"); });

            this.closest("li").classList.add("active");

            var activeContent = document.querySelector('[data-content="' + targetTab + '"]');
            if (activeContent) activeContent.classList.add("active");
        });
    });

    // Determine correct tab on page load (hash or default)
    var hash = window.location.hash;
    var tabMap = {
        '#order-history'        : 'orders',
        '#voucher-wallet'       : 'vouchers',
        '#personal-info'        : 'info',
        '#change-password'      : 'password',
        '#warranty'             : 'warranty',
        '#warranty-management'  : 'warranty'
    };
    var initialTab  = (hash && tabMap[hash]) ? tabMap[hash] : 'info';
    var initialLink = document.querySelector('.account-nav-list a[data-tab="' + initialTab + '"]');
    if (initialLink) {
        initialLink.closest("li").classList.add("active");
        var initialContent = document.querySelector('[data-content="' + initialTab + '"]');
        if (initialContent) initialContent.classList.add("active");
    }

});
