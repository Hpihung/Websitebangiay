<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>H&M - SPORT SHOES</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

      <!--
    - favicon
  -->
      <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

      <!--
    -  css link
  -->
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
      <link rel="stylesheet" href="https://unpkg.com/swiper@8/swiper-bundle.min.css" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/hero-slider.css" />
      <!--
    - google font link
  -->
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
        rel="stylesheet" />
    </head>

    <body id="top">
      <!--
- #HEADER
-->
      <jsp:include page="header.jsp" />
      <main>
        <article>
          <!-- HERO SLIDER  -->
          <section class="banner-slide hero-slider">
            <div class="swiper-container hero-swiper">
              <div class="swiper-wrapper">
                <c:forEach var="slide" items="${menu.bannerSlider}">
                  <div class="swiper-slide">
                    <div class="hero-slide-content" style="background-image: url('${slide.imgUrl}');">
                      <div class="hero-slide-overlay">
                        <div class="container">
                          <h2 class="h1 hero-title">${slide.title}</h2>
                          <c:if test="${not empty slide.slogan}">
                            <p class="hero-text">${slide.slogan}</p>
                          </c:if>
                          <a href="${pageContext.request.contextPath}${slide.linkUrl}" class="btn btn-primary">
                            <span>Mua ngay</span>
                            <ion-icon name="arrow-forward-outline" aria-hidden="true"></ion-icon>
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
              <!-- Navigation buttons -->
              <div class="swiper-button-prev"></div>
              <div class="swiper-button-next"></div>
              <!-- Pagination dots -->
              <div class="swiper-pagination"></div>
            </div>
          </section>

          <!--
        - #Bo suu tap
      -->

          <section class="section collection">
            <div class="container">
              <ul class="collection-list has-scrollbar">

                <c:forEach var="banner" items="${menu.bannerCollection}">
                  <li>
                    <div class="collection-card" style="
                                  background-image: url('${banner.imgUrl}');
                                  ">
                      <h3 class="h4 card-title">
                        ${banner.title}
                      </h3>

                      <a href="${pageContext.request.contextPath}${banner.linkUrl}" class="btn btn-secondary">
                        <span>Khám phá ngay</span>
                        <ion-icon name="arrow-forward-outline" aria-hidden="true"></ion-icon>
                      </a>
                    </div>
                  </li>
                </c:forEach>

              </ul>
            </div>
          </section>


          <!-- FLASH SALE SECTION -->
          <c:if test="${not empty menu.flashSaleProducts}">
            <section class="section flashsale" style="background: linear-gradient(135deg, #8b0000 0%, #d80000 50%, #8b0000 100%); padding: 60px 0; color: #fff; margin-bottom: 40px; border-radius: 12px; overflow: hidden; position: relative;">
              <div class="container">
                <div class="flashsale-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; margin-bottom: 30px; border-bottom: 2px solid rgba(255,255,255,0.2); padding-bottom: 15px;">
                  <div class="header-title-wrapper" style="display: flex; align-items: center; gap: 15px;">
                    <span class="flash-icon" style="font-size: 3rem; animation: pulse 1.2s infinite; display: inline-block;">⚡</span>
                    <h2 class="h2" style="font-family: 'Josefin Sans', sans-serif; font-size: 2.5rem; font-weight: 800; color: #fff; text-shadow: 0 2px 10px rgba(0,0,0,0.5); letter-spacing: 1px; margin: 0; text-transform: uppercase;">Siêu Khuyến Mãi</h2>
                  </div>
                  <!-- General Countdown Timer (for the nearest ending sale) -->
                  <div id="general-countdown" style="display: flex; align-items: center; gap: 10px; background: rgba(0,0,0,0.4); padding: 10px 20px; border-radius: 50px; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); margin-top: 10px;">
                    <span style="font-weight: 600; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px; color: #ffeb3b;">Kết thúc sau:</span>
                    <div class="timer-digits" style="display: flex; gap: 5px; font-weight: 700; font-family: monospace; font-size: 1.2rem;">
                      <span id="gen-days" style="background: #fff; color: #d80000; padding: 4px 8px; border-radius: 4px;">00</span> :
                      <span id="gen-hours" style="background: #fff; color: #d80000; padding: 4px 8px; border-radius: 4px;">00</span> :
                      <span id="gen-mins" style="background: #fff; color: #d80000; padding: 4px 8px; border-radius: 4px;">00</span> :
                      <span id="gen-secs" style="background: #fff; color: #d80000; padding: 4px 8px; border-radius: 4px;">00</span>
                    </div>
                  </div>
                </div>

                <div class="flashsale-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px;">
                  <c:forEach items="${menu.flashSaleProducts}" var="fs">
                    <div class="flashsale-card" data-endtime="${fs.endDateStr}" style="background: rgba(255, 255, 255, 0.08); border-radius: 16px; border: 1px solid rgba(255,255,255,0.15); box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3); backdrop-filter: blur(12px); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.3s ease, box-shadow 0.3s ease; position: relative;">
                      
                      <!-- DISCOUNT BADGE -->
                      <span style="position: absolute; top: 15px; left: 15px; background: #ffeb3b; color: #000; font-weight: 800; padding: 6px 12px; border-radius: 8px; font-size: 1rem; box-shadow: 0 4px 10px rgba(0,0,0,0.3); z-index: 10;">
                        ${fs.discountValue}
                      </span>

                      <!-- CARD IMAGE -->
                      <div class="card-img-wrapper" style="width: 100%; height: 260px; background: #fff; display: flex; align-items: center; justify-content: center; overflow: hidden; padding: 20px;">
                        <a href="${pageContext.request.contextPath}/product?id=${fs.id}" style="display: block; width: 100%; height: 100%;">
                          <c:choose>
                            <c:when test="${not empty fs.mainImageUrl && fs.mainImageUrl.startsWith('http')}">
                              <img src="${fs.mainImageUrl}" loading="lazy" alt="${fs.name}" style="width: 100%; height: 100%; object-fit: contain; transition: transform 0.5s ease;" class="flash-prod-img" />
                            </c:when>
                            <c:when test="${not empty fs.mainImageUrl}">
                              <img src="${pageContext.request.contextPath}${fs.mainImageUrl}" loading="lazy" alt="${fs.name}" style="width: 100%; height: 100%; object-fit: contain; transition: transform 0.5s ease;" class="flash-prod-img" />
                            </c:when>
                            <c:otherwise>
                              <img src="https://placehold.co/300x300?text=No+Image" loading="lazy" alt="No image" style="width: 100%; height: 100%; object-fit: contain;" />
                            </c:otherwise>
                          </c:choose>
                        </a>
                      </div>

                      <!-- CARD BODY -->
                      <div class="card-body" style="padding: 20px; display: flex; flex-direction: column; flex-grow: 1;">
                        <h3 style="font-size: 1.2rem; font-weight: 600; margin-bottom: 10px; min-height: 48px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                          <a href="${pageContext.request.contextPath}/product?id=${fs.id}" style="color: #fff; text-decoration: none; transition: color 0.2s;">
                            ${fs.name}
                          </a>
                        </h3>

                        <!-- OPTIONS (COLORS / SIZES) -->
                        <div style="margin-bottom: 15px; font-size: 0.85rem; color: rgba(255,255,255,0.7); display: flex; flex-direction: column; gap: 4px;">
                          <div><strong>Màu sắc:</strong> ${fs.colors}</div>
                          <div><strong>Kích thước:</strong> ${fs.sizes}</div>
                        </div>

                        <!-- PRICE MATRIX -->
                        <div style="margin-bottom: 15px; display: flex; flex-direction: column; gap: 2px;">
                          <div style="display: flex; align-items: baseline; gap: 8px;">
                            <span style="font-size: 1.4rem; font-weight: 800; color: #ffeb3b;">${fs.finalPrice}</span>
                            <span style="font-size: 0.95rem; text-decoration: line-through; color: rgba(255,255,255,0.5);">${fs.price}</span>
                          </div>
                          <div style="font-size: 0.8rem; font-weight: 600; color: #4caf50;">
                            ${fs.savings}
                          </div>
                        </div>

                        <!-- PROGRESS BAR FOR STOCK -->
                        <div style="margin-top: auto; margin-bottom: 15px;">
                          <div style="display: flex; justify-content: space-between; font-size: 0.8rem; margin-bottom: 6px; font-weight: 600;">
                            <span>Đã bán: ${fs.totalStock - fs.stock}</span>
                            <span>Còn lại: ${fs.stock}</span>
                          </div>
                          <div class="progress-bar-bg" style="width: 100%; height: 10px; background: rgba(255,255,255,0.2); border-radius: 50px; overflow: hidden; border: 1px solid rgba(255,255,255,0.1);">
                            <div class="progress-bar-fill" style="width: ${fs.totalStock > 0 ? (fs.totalStock - fs.stock) * 100 / fs.totalStock : 0}%; height: 100%; background: linear-gradient(90deg, #ffeb3b, #ff9800); border-radius: 50px; transition: width 0.5s ease-out;"></div>
                          </div>
                        </div>

                        <!-- CTA BUTTON -->
                        <a href="${pageContext.request.contextPath}/product?id=${fs.id}" style="display: block; width: 100%; text-align: center; background: #fff; color: #d80000; font-weight: 700; padding: 10px 15px; border-radius: 8px; text-transform: uppercase; text-decoration: none; font-size: 0.9rem; transition: background-color 0.2s, transform 0.2s;" class="flash-cta-btn">
                          Sở Hữu Ngay
                        </a>
                      </div>

                    </div>
                  </c:forEach>
                </div>
              </div>
            </section>
            
            <style>
              @keyframes pulse {
                0% { transform: scale(1); filter: drop-shadow(0 0 2px rgba(255,255,255,0.5)); }
                50% { transform: scale(1.15); filter: drop-shadow(0 0 15px #ffeb3b); }
                100% { transform: scale(1); filter: drop-shadow(0 0 2px rgba(255,255,255,0.5)); }
              }
              .flashsale-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 40px rgba(0,0,0,0.5);
                border-color: rgba(255,255,255,0.3);
              }
              .flashsale-card:hover .flash-prod-img {
                transform: scale(1.08);
              }
              .flash-cta-btn:hover {
                background: #ffeb3b !important;
                color: #000 !important;
                transform: translateY(-2px);
              }
              .flashsale-card a:hover {
                color: #ffeb3b !important;
              }
            </style>

            <script>
              document.addEventListener("DOMContentLoaded", function() {
                const cards = document.querySelectorAll(".flashsale-card");
                let nearestEndTime = null;

                cards.forEach(card => {
                  const endStr = card.getAttribute("data-endtime");
                  if (endStr) {
                    // Replace space with T if needed to make it compliant with cross-browser Date parsing
                    let formattedStr = endStr.replace(" ", "T");
                    const t = new Date(formattedStr).getTime();
                    if (!isNaN(t)) {
                      if (!nearestEndTime || t < nearestEndTime) {
                        nearestEndTime = t;
                      }
                    }
                  }
                });

                if (nearestEndTime) {
                  const genDaysEl = document.getElementById("gen-days");
                  const genHoursEl = document.getElementById("gen-hours");
                  const genMinsEl = document.getElementById("gen-mins");
                  const genSecsEl = document.getElementById("gen-secs");

                  function updateTimer() {
                    const now = new Date().getTime();
                    const diff = nearestEndTime - now;

                    if (diff <= 0) {
                      if (genDaysEl) genDaysEl.innerText = "00";
                      if (genHoursEl) genHoursEl.innerText = "00";
                      if (genMinsEl) genMinsEl.innerText = "00";
                      if (genSecsEl) genSecsEl.innerText = "00";
                      clearInterval(timerInterval);
                      return;
                    }

                    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
                    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const mins = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                    const secs = Math.floor((diff % (1000 * 60)) / 1000);

                    if (genDaysEl) genDaysEl.innerText = String(days).padStart(2, '0');
                    if (genHoursEl) genHoursEl.innerText = String(hours).padStart(2, '0');
                    if (genMinsEl) genMinsEl.innerText = String(mins).padStart(2, '0');
                    if (genSecsEl) genSecsEl.innerText = String(secs).padStart(2, '0');
                  }

                  updateTimer();
                  const timerInterval = setInterval(updateTimer, 1000);
                }
              });
            </script>
          </c:if>


          <!--
        - #PRODUCT
      -->
          <section class="section product">
            <div class="container">
              <h2 class="h2 section-title">Sản phẩm mới</h2>

              <ul class="filter-list">
                <li>
                  <a href="${pageContext.request.contextPath}/menufilter?brandId=all"
                    class="filter-btn ${param.brandId == 'all' || empty param.brandId ? 'active' : ''}">
                    All
                  </a>
                </li>

                <c:forEach items="${menu.brandList}" var="b">
                  <li>
                    <a href="${pageContext.request.contextPath}/menufilter?brandId=${b.id}"
                      class="filter-btn ${param.brandId == b.id.toString() ? 'active' : ''}">
                      ${b.name}
                    </a>
                  </li>
                </c:forEach>
              </ul>

              <ul class="product-list" id="productList">
                <c:forEach items="${menu.newestProduct}" var="p">
                  <c:if test="${not empty p.name && not empty p.mainImageUrl}">
                  <li class="product-item">
                    <div class="product-card" tabindex="0">

                      <!-- IMAGE -->
                      <figure class="card-banner">
                        <c:choose>
                          <c:when test="${not empty p.mainImageUrl && p.mainImageUrl.startsWith('http')}">
                            <img src="${p.mainImageUrl}" loading="lazy" alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
                          </c:when>
                          <c:when test="${not empty p.mainImageUrl}">
                            <img src="${pageContext.request.contextPath}${p.mainImageUrl}" loading="lazy" alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
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
                                  <span class="discount-value">
                                    Giảm: ${p.discountValue}
                                  </span>
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

              <%-- Pagination bar - only visible when brand filter is "All" (no brandId param) --%>
              <c:if test="${empty param.brandId || param.brandId == 'all'}">
                <c:if test="${totalPages > 1}">
                  <div style="display: flex; gap: 8px; justify-content: center; flex-wrap: wrap; margin-top: 32px; margin-bottom: 8px;">
                    <c:if test="${currentPage > 1}">
                      <a href="${pageContext.request.contextPath}/menu?page=${currentPage - 1}"
                         style="padding: 10px 18px; border: 1px solid #ddd; border-radius: 8px; background: #fff; font-weight: 600; text-decoration: none; color: #333; transition: 0.2s;">&#8592; Trước</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                      <c:choose>
                        <c:when test="${i == currentPage}">
                          <a style="padding: 10px 16px; border-radius: 8px; background: #d90429; color: #fff; font-weight: 700; text-decoration: none; min-width: 42px; text-align: center;">${i}</a>
                        </c:when>
                        <c:otherwise>
                          <a href="${pageContext.request.contextPath}/menu?page=${i}"
                             style="padding: 10px 16px; border: 1px solid #ddd; border-radius: 8px; background: #fff; font-weight: 600; text-decoration: none; color: #333; min-width: 42px; text-align: center; transition: 0.2s;">${i}</a>
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                      <a href="${pageContext.request.contextPath}/menu?page=${currentPage + 1}"
                         style="padding: 10px 18px; border: 1px solid #ddd; border-radius: 8px; background: #fff; font-weight: 600; text-decoration: none; color: #333; transition: 0.2s;">Sau &#8594;</a>
                    </c:if>
                  </div>
                </c:if>
              </c:if>

            </div>
          </section>
          <!--
        - #SPECIAL
      -->
          <section class="section special">
            <div class="container">
              <div class="special-banner" style="
                background-image: url('./assets/images/special-banner.jpg');
              ">
                <h2 class="h3 banner-title">${menu.bannerSpecialP.slogan}</h2>

                <a href="${menu.bannerSpecialP.linkUrl}" class="btn btn-link">
                  <span>Khám phá ngay</span>

                  <ion-icon name="arrow-forward-outline" aria-hidden="true"></ion-icon>
                </a>
              </div>

              <div class="special-product">
                <h2 class="h2 section-title">
                  <span class="text">${menu.bannerSpecialP.title}</span>

                  <span class="line"></span>
                </h2>

                <ul class="has-scrollbar">

                  <c:forEach items="${menu.specialProduct}" var="p">
                    <c:if test="${not empty p.name && not empty p.mainImageUrl}">
                    <li class="product-item">
                      <div class="product-card" tabindex="0">

                        <!-- IMAGE -->
                        <figure class="card-banner">
                          <c:choose>
                            <c:when test="${not empty p.mainImageUrl && p.mainImageUrl.startsWith('http')}">
                              <img src="${p.mainImageUrl}" width="312" height="350" loading="lazy" alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
                            </c:when>
                            <c:when test="${not empty p.mainImageUrl}">
                              <img src="${pageContext.request.contextPath}${p.mainImageUrl}" width="312" height="350" loading="lazy" alt="${not empty p.name ? p.name : 'Sản phẩm'}" class="image-contain" />
                            </c:when>
                            <c:otherwise>
                              <img src="https://placehold.co/312x350?text=No+Image" width="312" height="350" loading="lazy" alt="No image" class="image-contain" />
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
                                    <span class="discount-value">
                                      Giảm: ${p.discountValue}
                                    </span>
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
              </div>
            </div>
          </section>
        </article>
      </main>
      <!--
- #FOOTER
-->
      <jsp:include page="footer.jsp" />
      <!--
- ionicon link
-->
      <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
      <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>


      <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
      <script src="https://unpkg.com/swiper@8/swiper-bundle.min.js"></script>

      <!-- Hero Slider Initialization -->
      <script>
        document.addEventListener('DOMContentLoaded', function () {
          new Swiper('.hero-swiper', {
            slidesPerView: 1,
            spaceBetween: 0,
            loop: true,
            autoplay: {
              delay: 4000,
              disableOnInteraction: false,
            },
            effect: 'fade',
            fadeEffect: {
              crossFade: true
            },
            speed: 800,
            pagination: {
              el: '.swiper-pagination',
              clickable: true,
            },
            navigation: {
              nextEl: '.swiper-button-next',
              prevEl: '.swiper-button-prev',
            },
          });
        });
      </script>

      <script src="${pageContext.request.contextPath}/assets/script/product-popup.js"></script>

      <!-- AJAX Filter Script -->
      <script>
        document.addEventListener('DOMContentLoaded', function () {
          const filterLinks = document.querySelectorAll('.filter-list .filter-btn');
          const productListContainer = document.getElementById('productList');

          filterLinks.forEach(link => {
            link.addEventListener('click', function (e) {
              e.preventDefault();

              // Update active class
              filterLinks.forEach(btn => btn.classList.remove('active'));
              this.classList.add('active');

              const url = this.getAttribute('href');

              // Fetch the new page and extract the product list
              fetch(url)
                .then(response => response.text())
                .then(html => {
                  const parser = new DOMParser();
                  const doc = parser.parseFromString(html, 'text/html');
                  const newProductList = doc.getElementById('productList');
                  if (newProductList) {
                    productListContainer.innerHTML = newProductList.innerHTML;
                  }
                })
                .catch(err => console.error('Error fetching filtered products:', err));
            });
          });
        });
      </script>

    </body>

    </html>