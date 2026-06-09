<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>${product.productDTO.name}</title>

      <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chitietsanpham.css" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css" />

      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />

      <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
      <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

      <style>
        /* Ép style trực tiếp để tránh lỗi bộ nhớ đệm (Cache) của trình duyệt */
        .main-img-container {
          background-position: center !important;
          background-size: contain !important;
          background-repeat: no-repeat !important;
          cursor: crosshair !important;
        }
        .main-img-container.zoom-active {
          background-size: 250% !important;
        }
        .main-img-container.zoom-active img {
          opacity: 0 !important;
        }
        .main-img-container img {
          transition: opacity 0.2s !important;
          pointer-events: none !important;
          transform: none !important; /* Xóa transform cũ nếu bị dính cache */
        }
        .size-btn.out-of-stock {
          background: #f3f4f6 !important;
          color: #9ca3af !important;
          border-color: #e5e7eb !important;
          cursor: not-allowed !important;
          pointer-events: none !important;
          opacity: 0.6 !important;
          text-decoration: line-through !important;
        }
      </style>
    </head>

    <body id="top">
      <jsp:include page="header.jsp" />

      <main>
        <div class="container">

          <!-- BREADCRUMB -->
          <div class="breadcrumb-container">
            <ul class="breadcrumb">
              <li><a href="${pageContext.request.contextPath}/menu">Trang Chủ</a></li>
              <li><a href="${pageContext.request.contextPath}/products">Sản Phẩm</a></li>
              <li class="current-page">${product.productDTO.name}</li>
            </ul>
          </div>

          <!-- PRODUCT DETAIL -->
          <div class="product-detail-wrapper">

            <!-- IMAGE -->
            <div class="product-gallery-box">
              <div class="sub-img-container">
                <c:forEach var="img" items="${product.productImg}">
                  <c:choose>
                    <c:when test="${not empty img && img.startsWith('http')}">
                      <img src="${img}" onclick="changeImage(this)" />
                    </c:when>
                    <c:when test="${not empty img}">
                      <img src="${pageContext.request.contextPath}${img}" onclick="changeImage(this)" />
                    </c:when>
                    <c:otherwise>
                      <img src="https://placehold.co/300x300?text=No+Image" onclick="changeImage(this)" />
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </div>

              <c:choose>
                <c:when test="${not empty product.productImg[0] && product.productImg[0].startsWith('http')}">
                  <div class="main-img-container" id="img-zoom-container" style="background-image: url('${product.productImg[0]}');">
                    <img id="main-image" src="${product.productImg[0]}" alt="${product.productDTO.name}" />
                  </div>
                </c:when>
                <c:when test="${not empty product.productImg[0]}">
                  <div class="main-img-container" id="img-zoom-container" style="background-image: url('${pageContext.request.contextPath}${product.productImg[0]}');">
                    <img id="main-image" src="${pageContext.request.contextPath}${product.productImg[0]}" alt="${product.productDTO.name}" />
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="main-img-container" id="img-zoom-container" style="background-image: url('https://placehold.co/300x300?text=No+Image');">
                    <img id="main-image" src="https://placehold.co/300x300?text=No+Image" alt="${product.productDTO.name}" />
                  </div>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- INFO -->
            <div class="product-info-box">
              <h1 class="product-title">${product.productDTO.name}</h1>

              <div class="product-meta">
                <p class="brand-info">
                  Thương hiệu:
                  <strong>${product.brand.name}</strong>
                </p>
                <p class="stock-info">
                  Kho:
                  <strong data-stock="${product.stock}">
                    ${product.stock}
                  </strong>
                </p>
              </div>

              <!-- Compact Rating -->
              <c:if test="${reviewCount > 0}">
                <div style="display:flex; align-items:center; gap:8px; margin-bottom:10px;">
                  <span style="font-weight:bold; font-size:15px;"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></span>
                  <span style="color:#ffce3d; font-size:14px;">
                    <c:forEach begin="1" end="5" var="i">
                      <c:choose>
                        <c:when test="${i <= avgRating}">★</c:when>
                        <c:otherwise><span style="color:#ddd;">★</span></c:otherwise>
                      </c:choose>
                    </c:forEach>
                  </span>
                  <a href="#reviewContent" style="color:#888; font-size:13px; text-decoration:underline;">(${reviewCount})</a>
                </div>
              </c:if>

              <div class="price-row">
                <span class="current-price">
                  ${product.productDTO.finalPrice}
                </span>

                <c:if test="${not empty product.productDTO.discountValue}">
                  <del class="original-price">
                    ${product.productDTO.price}
                  </del>
                  <span class="discount-tag">
                    ${product.productDTO.discountValue}
                  </span>
                </c:if>
              </div>
              <!-- COLOR -->
              <div class="option-block">
                <label>Màu sắc:</label>
                <div class="filter-group-body">
                  <ul class="filter-list-color">
                    <c:forEach var="c" items="${product.productColorList}">
                      <c:url var="colorUrl" value="/product">
                        <c:param name="id" value="${product.productDTO.id}" />
                        <c:param name="colorId" value="${c.id}" />
                        <c:if test="${not empty param.sizeId}">
                          <c:param name="sizeId" value="${param.sizeId}" />
                        </c:if>
                      </c:url>
                      <li>
                        <a href="${colorUrl}">
                          <span class="color-dot ${product.currentColorId == c.id ? 'selected' : ''}"
                            style="background:${c.hexCode}" title="${c.name}">
                          </span>
                        </a>
                      </li>
                    </c:forEach>
                  </ul>
                </div>
              </div>
              <!-- SIZE -->
              <div class="option-block">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                  <label>Kích thước:</label>
                  <a href="#" onclick="event.preventDefault();document.getElementById('sizeGuideModal').style.display='flex'" style="font-size:13px; color:#333; text-decoration:underline;">Hướng dẫn chọn kích cỡ</a>
                </div>
                <div class="size-list">
                  <c:forEach var="s" items="${product.productSizeList}">
                    <c:url var="sizeUrl" value="/product">
                      <c:param name="id" value="${product.productDTO.id}" />
                      <c:param name="colorId" value="${product.currentColorId}" />
                      <c:param name="sizeId" value="${s.id}" />
                    </c:url>
                    <c:choose>
                      <c:when test="${s.stock <= 0}">
                        <a href="javascript:void(0);" class="size-btn out-of-stock" title="Hết hàng">
                          ${s.name}
                        </a>
                      </c:when>
                      <c:otherwise>
                        <a href="${sizeUrl}" class="size-btn ${product.currentSizeId == s.id ? 'selected' : ''}">
                          ${s.name}
                        </a>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
                </div>
              </div>
              <!-- ACTION -->
              <form action="${pageContext.request.contextPath}/cart/add" method="post" class="action-area">

                <input type="hidden" name="productId" value="${product.productDTO.id}" />
                <input type="hidden" name="colorId" value="${product.currentColorId}" />

                <c:if test="${not empty product.currentSizeId}">
                  <input type="hidden" name="sizeId" value="${product.currentSizeId}" />
                </c:if>

                <!-- QUANTITY -->
                <div class="qty-row">
                  <label>Số lượng:</label>
                  <div class="qty-input-group">
                    <button type="button" onclick="this.nextElementSibling.stepDown()">-</button>
                    <input type="number" name="quantity" value="1" min="1" />
                    <button type="button" onclick="this.previousElementSibling.stepUp()">+</button>
                  </div>
                </div>
                <!-- BUTTONS -->
                <div class="action-buttons">
                  <c:choose>
                    <c:when test="${!product.productDTO.isAvailable()}">
                      <button type="button" class="btn-main" disabled style="background:#555; color:#fff; border-color:#555; cursor:not-allowed; width: 100%; font-weight:bold;">
                        <ion-icon name="close-circle-outline"></ion-icon> SẢN PHẨM ĐÃ NGỪNG BÁN
                      </button>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${product.stock <= 0 and not empty product.currentSizeId}">
                          <button type="button" class="btn-main" disabled style="background:#555; color:#fff; border-color:#555; cursor:not-allowed; width: 100%; font-weight:bold;">
                            <ion-icon name="close-circle-outline"></ion-icon> HẾT HÀNG
                          </button>
                        </c:when>
                        <c:otherwise>
                          <button type="submit" class="btn-main btn-add-cart" <c:if test="${empty product.currentSizeId}">disabled</c:if>>
                            <ion-icon name="cart-outline"></ion-icon> THÊM VÀO GIỎ HÀNG
                          </button>

                          <button type="submit" formaction="${pageContext.request.contextPath}/buy-now"
                            class="btn-main btn-buy-now" <c:if test="${empty product.currentSizeId}">disabled</c:if>>
                            MUA NGAY
                          </button>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>

                  <!-- WISHLIST -->
                  <c:choose>
                    <c:when test="${isInWishlist}">
                      <button class="btn-wishlist active" disabled>
                        <ion-icon name="heart"></ion-icon>
                      </button>
                    </c:when>
                    <c:otherwise>
                      <button type="submit" formaction="${pageContext.request.contextPath}/wishlist"
                        class="btn-wishlist">
                        <ion-icon name="heart-outline"></ion-icon>
                      </button>
                    </c:otherwise>
                  </c:choose>
                </div>
              </form>
            </div>
          </div>

          <!-- DESCRIPTION -->
          <section class="product-desc-full">
            <h2 class="section-title-desc">Mô tả sản phẩm</h2>
            <div class="desc-content">
              ${product.productDes}
            </div>
          </section>

          <!-- SIZE GUIDE -->
          <section class="product-desc-full" style="cursor: pointer;" onclick="document.getElementById('sizeGuideModal').style.display='flex'">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <h2 class="section-title-desc" style="margin: 0;">Kích cỡ và độ vừa vặn</h2>
              <ion-icon name="chevron-forward-outline" style="font-size: 20px; color: #888;"></ion-icon>
            </div>
          </section>

          <!-- SIZE GUIDE MODAL -->
          <div id="sizeGuideModal" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.6); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:#fff; width:100%; max-width:900px; max-height:85vh; border-radius:8px; overflow-y:auto; position:relative; padding:30px;">
              <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                <div>
                  <h2 style="margin:0; font-size:22px; font-weight:bold; text-transform:uppercase;">HƯỚNG DẪN CHỌN KÍCH CỠ</h2>
                  <p style="color:#888; margin:4px 0 0 0; font-size:13px;">footwear sizing</p>
                </div>
                <span onclick="document.getElementById('sizeGuideModal').style.display='none'" style="cursor:pointer; font-size:28px; color:#888; line-height:1;">&times;</span>
              </div>

              <div style="margin-bottom:20px; overflow-x:auto;">
                <table style="width:100%; border-collapse:collapse; table-layout:fixed; min-width:650px;">
                  <tbody>
                    <tr style="background:#333; color:#fff;">
                      <td style="padding:10px 10px; font-weight:bold; font-size:13px;">cm</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">22.5</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">23</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">23.5</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">24</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">24.5</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">25</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">25.5</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">26</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">27</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">27.5</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">28</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">29</td>
                      <td style="padding:10px 10px; text-align:center; font-weight:bold; font-size:13px;">30</td>
                    </tr>
                    <tr style="border-bottom:1px solid #eee;">
                      <td style="padding:10px 10px; font-weight:bold; font-size:13px;">EU</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">35</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">36</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">37</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">38</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">39</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">40</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">41</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">42</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">43</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">44</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">45</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">46</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">47</td>
                    </tr>
                    <tr style="border-bottom:1px solid #eee;">
                      <td style="padding:10px 10px; font-weight:bold; font-size:13px;">UK</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">2.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">3.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">4</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">5.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">6</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">7</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">7.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">8.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">9.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">10</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">11</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">12</td>
                    </tr>
                    <tr style="border-bottom:1px solid #eee;">
                      <td style="padding:10px 10px; font-weight:bold; font-size:13px;">US<br>Men</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">3.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">4</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">4.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">5.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">6</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">7</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">8</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">8.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">9.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">10</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">11</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">12</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">13</td>
                    </tr>
                    <tr>
                      <td style="padding:10px 10px; font-weight:bold; font-size:13px;">US<br>Women</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">5.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">6</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">7</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">7.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">8</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">9</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">9.5</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">10</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">11</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">12</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">13</td>
                      <td style="padding:10px 10px; text-align:center; font-size:13px;">14</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <p style="font-size:12px; color:#888; margin-bottom:20px;">Cuộn theo chiều ngang để xem chi tiết.</p>

              <div style="background:#f9f9f9; border-radius:8px; padding:15px; margin-bottom:15px;">
                <h3 style="margin:0 0 8px 0; font-size:16px;">Bạn gần vừa với hai kích cỡ?</h3>
                <p style="margin:0; font-size:14px; color:#555; line-height:1.6;">Để có độ ôm sát, hãy giảm xuống một cỡ.<br/>Để rộng thoải mái, hãy tăng một cỡ.</p>
              </div>

              <div style="background:#f9f9f9; border-radius:8px; padding:15px;">
                <h3 style="margin:0 0 8px 0; font-size:16px;">Đúng kích cỡ</h3>
                <p style="margin:0; font-size:14px; color:#555;">ℹ️ Chúng tôi khuyên bạn nên đặt theo kích cỡ thông thường.</p>
              </div>
            </div>
          </div>

          <!-- REVIEWS SECTION -->
          <section class="product-desc-full">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; cursor:pointer;" onclick="document.getElementById('reviewContent').style.display = document.getElementById('reviewContent').style.display === 'none' ? 'block' : 'none'">
              <h2 class="section-title-desc" style="margin:0;">Đánh giá [${reviewCount}]</h2>
              <div style="display:flex; align-items:center; gap:8px;">
                <span style="color:#ffce3d; font-size:18px;">
                  <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                      <c:when test="${i <= avgRating}">★</c:when>
                      <c:when test="${i - avgRating < 1 && i - avgRating > 0}">★</c:when>
                      <c:otherwise><span style="color:#ddd;">★</span></c:otherwise>
                    </c:choose>
                  </c:forEach>
                </span>
                <ion-icon name="chevron-down-outline" style="font-size:18px; color:#888;"></ion-icon>
              </div>
            </div>

            <div id="reviewContent">
              <c:choose>
                <c:when test="${reviewCount == 0}">
                  <div style="text-align:center; padding:30px; color:#aaa;">
                    <ion-icon name="chatbubble-outline" style="font-size:40px; margin-bottom:10px;"></ion-icon>
                    <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <!-- Rating Summary -->
                  <div style="display:flex; gap:40px; margin-bottom:30px; padding:20px; background:#fafafa; border-radius:8px; flex-wrap:wrap;">
                    <!-- Left: Big score -->
                    <div style="text-align:center; min-width:120px;">
                      <div style="font-size:48px; font-weight:bold; line-height:1;">
                        <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                      </div>
                      <div style="color:#ffce3d; font-size:22px; margin:5px 0;">
                        <c:forEach begin="1" end="5" var="i">
                          <c:choose>
                            <c:when test="${i <= avgRating}">★</c:when>
                            <c:otherwise><span style="color:#ddd;">★</span></c:otherwise>
                          </c:choose>
                        </c:forEach>
                      </div>
                      <div style="font-size:13px; color:#888;">${reviewCount} đánh giá</div>
                    </div>
                    <!-- Right: Star distribution bars -->
                    <div style="flex:1; min-width:250px;">
                      <c:forEach begin="1" end="5" var="star">
                        <c:set var="idx" value="${6 - star}"/>
                        <c:set var="cnt" value="${ratingDist[idx - 1]}"/>
                        <c:set var="pct" value="${reviewCount > 0 ? (cnt * 100 / reviewCount) : 0}"/>
                        <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
                          <span style="font-size:13px; width:14px; text-align:right;">${idx}</span>
                          <span style="color:#ffce3d; font-size:14px;">★</span>
                          <div style="flex:1; height:8px; background:#eee; border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background:#333; border-radius:4px; width:${pct}%;"></div>
                          </div>
                          <span style="font-size:12px; color:#888; width:20px;">${cnt}</span>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- Filter & Sort -->
                  <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; flex-wrap:wrap; gap:10px;">
                    <div>
                      <div style="font-size:14px; font-weight:bold; margin-bottom:8px;">Lọc theo xếp loại sao</div>
                      <div style="display:flex; gap:6px; flex-wrap:wrap;">
                        <span class="rv-filter-btn active" onclick="filterReviews(this, 0)" style="padding:5px 12px; border:1px solid #ddd; border-radius:20px; font-size:13px; cursor:pointer; background:#333; color:#fff;">Tất cả</span>
                        <c:forEach begin="1" end="5" var="s">
                          <span class="rv-filter-btn" onclick="filterReviews(this, ${6 - s})" style="padding:5px 12px; border:1px solid #ddd; border-radius:20px; font-size:13px; cursor:pointer;">★ ${6 - s}</span>
                        </c:forEach>
                      </div>
                    </div>
                    <div style="position:relative;">
                      <div style="font-size:14px; font-weight:bold; margin-bottom:8px;">Sắp xếp theo</div>
                      <div id="sortDropdown" onclick="document.getElementById('sortMenu').style.display = document.getElementById('sortMenu').style.display === 'block' ? 'none' : 'block'" style="padding:8px 14px; border:1px solid #ddd; border-radius:4px; cursor:pointer; font-size:13px; display:flex; align-items:center; gap:6px; min-width:180px; justify-content:space-between;">
                        <span id="sortLabel">Mới nhất</span>
                        <ion-icon name="chevron-down-outline" style="font-size:14px;"></ion-icon>
                      </div>
                      <div id="sortMenu" style="display:none; position:absolute; top:100%; right:0; background:#fff; border:1px solid #ddd; border-radius:4px; box-shadow:0 4px 12px rgba(0,0,0,0.1); z-index:100; min-width:200px; margin-top:4px;">
                        <div onclick="sortReviews('newest')" style="padding:10px 16px; cursor:pointer; font-size:13px; border-bottom:1px solid #f0f0f0;" onmouseenter="this.style.background='#f5f5f5'" onmouseleave="this.style.background='#fff'">Mới nhất</div>
                        <div onclick="sortReviews('oldest')" style="padding:10px 16px; cursor:pointer; font-size:13px; border-bottom:1px solid #f0f0f0;" onmouseenter="this.style.background='#f5f5f5'" onmouseleave="this.style.background='#fff'">Cũ nhất</div>
                        <div onclick="sortReviews('highest')" style="padding:10px 16px; cursor:pointer; font-size:13px; border-bottom:1px solid #f0f0f0;" onmouseenter="this.style.background='#f5f5f5'" onmouseleave="this.style.background='#fff'">Được xếp hạng cao nhất</div>
                        <div onclick="sortReviews('lowest')" style="padding:10px 16px; cursor:pointer; font-size:13px;" onmouseenter="this.style.background='#f5f5f5'" onmouseleave="this.style.background='#fff'">Được xếp hạng thấp nhất</div>
                      </div>
                    </div>
                  </div>

                  <!-- Individual Reviews -->
                  <div id="reviewList" style="border-top:1px solid #eee;">
                    <c:forEach var="rev" items="${productReviews}">
                      <div class="review-item" data-rating="${rev.rating}" data-date="${rev.createdAtTimestamp.time}" style="padding:20px 0; border-bottom:1px solid #f0f0f0;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                          <div style="display:flex; align-items:center; gap:10px;">
                            <div style="width:36px; height:36px; border-radius:50%; background:#e0e0e0; display:flex; align-items:center; justify-content:center; font-weight:bold; color:#666; font-size:14px;">
                              ${rev.userName.substring(0,1).toUpperCase()}
                            </div>
                            <div>
                              <div style="font-weight:bold; font-size:14px;">${rev.userName}</div>
                              <div style="font-size:12px; color:#aaa;">
                                <fmt:formatDate value="${rev.createdAtTimestamp}" pattern="dd/MM/yyyy"/>
                              </div>
                            </div>
                          </div>
                          <div style="color:#ffce3d; font-size:16px;">
                            <c:forEach begin="1" end="${rev.rating}">★</c:forEach><c:forEach begin="${rev.rating + 1}" end="5"><span style="color:#ddd;">★</span></c:forEach>
                          </div>
                        </div>
                        <c:if test="${not empty rev.comment}">
                          <p style="margin:0; font-size:14px; color:#333; line-height:1.6;">${rev.comment}</p>
                        </c:if>
                        <c:if test="${not empty rev.imageUrl}">
                          <div style="margin-top:10px;">
                            <c:choose>
                              <c:when test="${fn:startsWith(rev.imageUrl, 'http')}">
                                <img src="${rev.imageUrl}" alt="Review image" style="max-width:120px; max-height:120px; border-radius:8px; object-fit:cover; border:1px solid #eee; cursor:pointer;" onclick="window.open(this.src,'_blank')"/>
                              </c:when>
                              <c:otherwise>
                                <img src="${pageContext.request.contextPath}${rev.imageUrl}" alt="Review image" style="max-width:120px; max-height:120px; border-radius:8px; object-fit:cover; border:1px solid #eee; cursor:pointer;" onclick="window.open(this.src,'_blank')"/>
                              </c:otherwise>
                            </c:choose>
                          </div>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </section>

          <!-- RELATED -->
          <section class="related-products section">
            <h2 class="h2 section-title" style="text-align: center; margin-bottom: 40px">
              Sản phẩm gợi ý
            </h2>
            <ul class="product-list" id="productList">
              <c:forEach items="${product.relatedProduct}" var="p">
                <li class="product-item">
                  <div class="product-card" tabindex="0">

                    <!-- IMAGE -->
                    <figure class="card-banner">
                      <c:choose>
                        <c:when test="${not empty p.mainImageUrl && p.mainImageUrl.startsWith('http')}">
                          <img src="${p.mainImageUrl}" loading="lazy" alt="${p.name}" class="image-contain" />
                        </c:when>
                        <c:when test="${not empty p.mainImageUrl}">
                          <img src="${pageContext.request.contextPath}${p.mainImageUrl}" loading="lazy" alt="${p.name}" class="image-contain" />
                        </c:when>
                        <c:otherwise>
                          <img src="https://placehold.co/300x300?text=No+Image" loading="lazy" alt="No image" class="image-contain" />
                        </c:otherwise>
                      </c:choose>
                      <!-- BADGE NEW -->
                      <c:if test="${p.isNew}">
                        <div class="card-badge">New</div>
                      </c:if>
                    </figure>

                    <!-- CONTENT -->
                    <div class="card-content">
                      <h3 class="h3 card-title">
                        <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                          ${p.name}
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
              </c:forEach>
            </ul>
          </section>

        </div>
        <div id="toast-message" class="toast-message">
          <i class="fas fa-check-circle"></i> <span></span>
        </div>
      </main>

      <jsp:include page="footer.jsp" />

      <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
      <script src="${pageContext.request.contextPath}/assets/script/chitietsanpham.js"></script>
      <script>
        // Hàm hiển thị toast
        function showToast(message) {
          const toast = document.getElementById("toast-message");
          toast.querySelector("span").textContent = message;
          toast.classList.add("show");
          setTimeout(() => toast.classList.remove("show"), 3000);
        }

        // Đổi ảnh khi click vào ảnh phụ
        window.changeImage = function(element) {
          const mainImage = document.getElementById('main-image');
          const container = document.getElementById('img-zoom-container');
          mainImage.src = element.src;
          if(container) {
             container.style.backgroundImage = "url('" + element.src + "')";
          }
        }

        // Kiểm tra tham số msg để hiển thị thông báo
        document.addEventListener("DOMContentLoaded", () => {
          const urlParams = new URLSearchParams(window.location.search);
          const msg = urlParams.get("msg");

          if (msg === "cart_added") {
            showToast("🛒 Đã thêm sản phẩm vào Giỏ hàng thành công!");
            // Xóa tham số msg khỏi URL để tránh hiển thị lại khi refresh
            urlParams.delete("msg");
            const newUrl = window.location.pathname + (urlParams.toString() ? "?" + urlParams.toString() : "");
            window.history.replaceState({}, document.title, newUrl);
          } else if (msg === "wishlist_added") {
            showToast("❤️ Đã thêm sản phẩm vào Yêu thích thành công!");
            urlParams.delete("msg");
            const newUrl = window.location.pathname + (urlParams.toString() ? "?" + urlParams.toString() : "");
            window.history.replaceState({}, document.title, newUrl);
          }

          // Image Zoom Effect (Sử dụng background-position để phóng nhiều góc siêu mượt)
          const mainImageContainer = document.getElementById('img-zoom-container');

          if (mainImageContainer) {
            mainImageContainer.addEventListener('mousemove', function(e) {
              const rect = mainImageContainer.getBoundingClientRect();
              const x = e.clientX - rect.left;
              const y = e.clientY - rect.top;
              
              const xPercent = (x / rect.width) * 100;
              const yPercent = (y / rect.height) * 100;
              
              mainImageContainer.style.backgroundPosition = `${xPercent}% ${yPercent}%`;
            });

            mainImageContainer.addEventListener('mouseenter', function() {
              mainImageContainer.classList.add('zoom-active');
            });

            mainImageContainer.addEventListener('mouseleave', function() {
              mainImageContainer.classList.remove('zoom-active');
              setTimeout(() => {
                mainImageContainer.style.backgroundPosition = 'center center';
              }, 200);
            });
          }
        });

        // Review filter by star
        function filterReviews(btn, star) {
          document.querySelectorAll('.rv-filter-btn').forEach(function(b) {
            b.style.background = '#fff';
            b.style.color = '#333';
          });
          btn.style.background = '#333';
          btn.style.color = '#fff';

          document.querySelectorAll('.review-item').forEach(function(item) {
            if (star === 0 || parseInt(item.dataset.rating) === star) {
              item.style.display = '';
            } else {
              item.style.display = 'none';
            }
          });
        }

        // Review sort
        function sortReviews(type) {
          var labels = { newest: 'Mới nhất', oldest: 'Cũ nhất', highest: 'Xếp hạng cao nhất', lowest: 'Xếp hạng thấp nhất' };
          document.getElementById('sortLabel').textContent = labels[type] || type;
          document.getElementById('sortMenu').style.display = 'none';

          var list = document.getElementById('reviewList');
          if (!list) return;
          var items = Array.from(list.querySelectorAll('.review-item'));
          items.sort(function(a, b) {
            if (type === 'newest') return parseInt(b.dataset.date) - parseInt(a.dataset.date);
            if (type === 'oldest') return parseInt(a.dataset.date) - parseInt(b.dataset.date);
            if (type === 'highest') return parseInt(b.dataset.rating) - parseInt(a.dataset.rating);
            if (type === 'lowest') return parseInt(a.dataset.rating) - parseInt(b.dataset.rating);
            return 0;
          });
          items.forEach(function(item) { list.appendChild(item); });
        }

        // Close sort menu when clicking outside
        document.addEventListener('click', function(e) {
          var dropdown = document.getElementById('sortDropdown');
          var menu = document.getElementById('sortMenu');
          if (dropdown && menu && !dropdown.contains(e.target) && !menu.contains(e.target)) {
            menu.style.display = 'none';
          }
        });
      </script>
    </body>

    </html>