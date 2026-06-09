<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <ul class="product-list grid-list" id="productGrid">
            <c:forEach items="${productList}" var="p">
                <c:if test="${not empty p.name && not empty p.mainImageUrl}">
                <li class="product-item">
                    <div class="product-card" tabindex="0">
                        <figure class="card-banner">

                            <c:choose>
                                <c:when test="${not empty p.mainImageUrl && p.mainImageUrl.startsWith('http')}">
                                    <img src="${p.mainImageUrl}" loading="lazy" alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
                                </c:when>
                                <c:when test="${not empty p.mainImageUrl}">
                                    <img src="${pageContext.request.contextPath}${p.mainImageUrl}" loading="lazy"
                                        alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
                                </c:when>
                                <c:otherwise>
                                    <img src="https://placehold.co/300x300?text=No+Image" loading="lazy" alt="No image" class="image-contain" />
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${p.isNew}">
                                <div class="card-badge">New</div>
                            </c:if>
                            <c:if test="${!p.isAvailable()}">
                                <div class="card-badge" style="background: #333; left: 15px; right: auto; color: #fff;">Ngừng bán</div>
                            </c:if>
                        </figure>

                        <div class="card-content">
                            <h3 class="h3 card-title">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                    ${not empty p.name ? p.name : 'Sản phẩm đang cập nhật'}
                                </a>
                            </h3>

                            <div class="product-card-price">
                                <c:choose>
                                    <c:when test="${p.price eq p.finalPrice}">
                                        <span class="discounted-price">${p.price}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="price-row">
                                            <span class="discounted-price">${p.finalPrice}</span>
                                            <span class="original-price">${p.price}</span>
                                        </div>

                                        <c:if test="${not empty p.discountValue}">
                                            <div class="discount-badge-wrapper">
                                                <span class="discount-value">Giảm: ${p.discountValue}</span>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </li>
                </c:if>
            </c:forEach>
        </ul>

        <div id="loadMoreContainer" style="text-align: center; margin-top: 40px; margin-bottom: 20px;">
            <c:set var="currentPageNum" value="${empty requestScope.page ? (empty param.page ? 1 : param.page) : requestScope.page}" />

            <%-- Numbered Pagination --%>
            <c:if test="${totalPages > 1}">
                <div class="pagination" id="paginationBar">
                    <c:if test="${currentPageNum > 1}">
                        <button class="page-btn page-nav-btn" data-page="${currentPageNum - 1}">&#8592; Trước</button>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPageNum}">
                                <button class="page-btn page-number-btn active" data-page="${i}">${i}</button>
                            </c:when>
                            <c:otherwise>
                                <button class="page-btn page-number-btn" data-page="${i}">${i}</button>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPageNum < totalPages}">
                        <button class="page-btn page-nav-btn" data-page="${currentPageNum + 1}">Sau &#8594;</button>
                    </c:if>
                </div>
            </c:if>
        </div>

        <style>
            .pagination { display: flex; gap: 8px; justify-content: center; flex-wrap: wrap; }
            .page-nav-btn { padding: 10px 18px; border: 1px solid #ddd; background: #fff; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s; }
            .page-number-btn { padding: 10px 16px; border: 1px solid #ddd; background: #fff; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s; min-width: 42px; }
            .page-number-btn.active { background: #d90429; color: #fff; border-color: #d90429; }
            .page-nav-btn:hover, .page-number-btn:hover:not(.active) { background: #f5f5f5; }
        </style>