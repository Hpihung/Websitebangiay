<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>H&M Admin - SportShoes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=4.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>

<body>

    <div class="sidebar">
        <div class="admin-brand">
            <div class="brand-logo">
                <i class="fa-solid fa-shoe-prints"></i>
            </div>
            <span class="brand-name">H&M.</span>
        </div>

        <div class="menu-section-title">Công cụ quản trị</div>

        <ul class="menu">
            <li class="${active == 'admin/dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Tổng quan</span>
                </a>
            </li>

            <li class="${active == 'admin/products' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/products">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span>Sản phẩm</span>
                </a>
            </li>

            <li class="${active == 'admin/collections' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/collections">
                    <i class="fa-solid fa-chart-simple"></i>
                    <span>Bộ sưu tập</span>
                </a>
            </li>

            <li class="${active == 'admin/orders' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fa-regular fa-compass"></i>
                    <span>Đơn hàng</span>
                </a>
            </li>

            <li class="${active == 'admin/accounts' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/accounts">
                    <i class="fa-solid fa-users-gear"></i>
                    <span>Tài khoản</span>
                </a>
            </li>

            <li class="${active == 'admin/coupons' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/coupons">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Mã giảm giá</span>
                </a>
            </li>

            <li class="${active == 'admin/banners' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/banners">
                    <i class="fa-solid fa-images"></i>
                    <span>Banner</span>
                </a>
            </li>



            <li class="${active == 'admin/reviews' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/reviews">
                    <i class="fa-solid fa-star"></i>
                    <span>Đánh giá</span>
                </a>
            </li>

            <li class="${active == 'admin/warranty' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/warranty">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>Bảo hành</span>
                </a>
            </li>

            <li class="${active == 'admin/variants' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/variants">
                    <i class="fa-solid fa-layer-group"></i>
                    <span>Biến thể</span>
                </a>
            </li>

            <li class="${active == 'admin/promotions' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/promotions">
                    <i class="fa-solid fa-bolt"></i>
                    <span>Khuyến mãi</span>
                </a>
            </li>
        </ul>

        <div class="menu-section-title" style="margin-top: 32px;">Khác</div>
        <ul class="menu">
            <li class="${active == 'admin/contacts' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/contacts" style="position: relative;">
                    <i class="fa-solid fa-envelope"></i>
                    <span>Hộp thư</span>
                    <c:if test="${unreadCount > 0}">
                        <span class="badge-count">${unreadCount}</span>
                    </c:if>
                </a>
            </li>
            <li class="${active == 'admin/newsletter' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/newsletter">
                    <i class="fa-solid fa-paper-plane"></i>
                    <span>Bản tin</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/logout" style="color: #FF7675;">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    <span>Đăng xuất</span>
                </a>
            </li>
        </ul>
    </div>

    <div class="main">
        <jsp:include page="${contentPage}" />
    </div>

    <script>
        // Real-time badge fetch
        if (!document.querySelector('.badge-count')) {
            fetch('${pageContext.request.contextPath}/admin/contacts/count')
                .then(response => response.json())
                .then(data => {
                    if (data.count > 0) {
                        const inboxMenu = document.querySelector('a[href*="admin/contacts"]');
                        if (inboxMenu) {
                            const badge = document.createElement('span');
                            badge.className = 'badge-count';
                            badge.innerText = data.count;
                            inboxMenu.appendChild(badge);
                        }
                    }
                })
                .catch(err => console.log('Badge error:', err));
        }
    </script>
</body>

</html>