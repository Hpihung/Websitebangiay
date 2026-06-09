<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giỏ hàng — H&M Sport Shoes</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
      /* ── Cart Table Header ─────────────────────── */
      .cart-table-header {
        display: flex; align-items: center; background: #fff;
        border: 1px solid #e8e8e8; border-radius: 4px;
        padding: 15px 20px; margin-bottom: 15px; gap: 15px;
        font-size: 14px; color: #888;
      }
      .cart-table-header .col-check { width: 40px; flex-shrink: 0; }
      .cart-table-header .col-product { flex: 1; }
      .cart-table-header .col-price { width: 120px; text-align: center; }
      .cart-table-header .col-qty { width: 130px; text-align: center; }
      .cart-table-header .col-total { width: 120px; text-align: center; }
      .cart-table-header .col-action { width: 80px; text-align: center; }

      /* ── Cart Item Row ─────────────────────── */
      .cart-item-row {
        display: flex; align-items: center; background: #fff;
        border: 1px solid #e8e8e8; border-radius: 4px;
        padding: 15px 20px; margin-bottom: 10px; gap: 15px;
        transition: box-shadow 0.2s;
      }
      .cart-item-row:hover { box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
      .cart-item-row .col-check { width: 40px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
      .cart-item-row .col-check input[type="checkbox"] { width: 18px; height: 18px; accent-color: #ee4d2d; cursor: pointer; }
      .cart-item-row .col-product { flex: 1; display: flex; align-items: center; gap: 12px; }
      .cart-item-row .col-product img { width: 80px; height: 80px; object-fit: contain; border-radius: 4px; border: 1px solid #f0f0f0; }
      .cart-item-row .product-info { flex: 1; }
      .cart-item-row .product-info .p-name { font-size: 14px; color: #333; font-weight: 500; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-decoration: none; }
      .cart-item-row .product-info .p-name:hover { color: #ee4d2d; }
      .cart-item-row .product-info .p-variant { font-size: 12px; color: #999; margin-top: 4px; }
      .cart-item-row .col-price { width: 120px; text-align: center; }
      .cart-item-row .col-price .final-price { font-size: 14px; color: #333; font-weight: 500; }
      .cart-item-row .col-price .orig-price { font-size: 12px; color: #bbb; text-decoration: line-through; }
      .cart-item-row .col-qty { width: 130px; display: flex; align-items: center; justify-content: center; }
      .cart-item-row .col-total { width: 120px; text-align: center; font-size: 14px; color: #ee4d2d; font-weight: 600; }
      .cart-item-row .col-action { width: 80px; text-align: center; }

      /* Quantity control */
      .qty-group { display: flex; align-items: center; border: 1px solid #ccc; border-radius: 2px; }
      .qty-group button { width: 30px; height: 30px; border: none; background: #fff; cursor: pointer; font-size: 16px; display: flex; align-items: center; justify-content: center; color: #555; }
      .qty-group button:hover { background: #f5f5f5; }
      .qty-group input { width: 40px; height: 30px; text-align: center; border: none; border-left: 1px solid #ccc; border-right: 1px solid #ccc; font-size: 14px; }

      /* Voucher hint row */
      .voucher-hint {
        display: flex; align-items: center; gap: 8px;
        padding: 8px 20px 8px 75px; margin-bottom: 10px;
        font-size: 13px; color: #ee4d2d;
      }
      .voucher-hint a { color: #007bff; text-decoration: none; font-weight: 500; }
      .voucher-hint a:hover { text-decoration: underline; }

      /* Action buttons */
      .cart-delete-btn { background: none; border: none; color: #999; font-size: 13px; cursor: pointer; }
      .cart-delete-btn:hover { color: #ee4d2d; }

      /* ── Cart Footer ─────────────────────── */
      .cart-footer {
        position: sticky; bottom: 0; z-index: 10;
        display: flex; align-items: center; background: #fff;
        border: 1px solid #e8e8e8; border-radius: 4px;
        padding: 15px 20px; margin-top: 20px;
        box-shadow: 0 -2px 8px rgba(0,0,0,0.06);
      }
      .cart-footer span { display: inline !important; }
      .cart-footer .footer-left { display: flex; align-items: center; gap: 15px; }
      .cart-footer .footer-left input[type="checkbox"] { width: 18px; height: 18px; accent-color: #ee4d2d; cursor: pointer; }
      .cart-footer .footer-left label { font-size: 14px; color: #333; cursor: pointer; }
      .cart-footer .footer-left .delete-selected { background: none; border: none; color: #555; font-size: 13px; cursor: pointer; margin-left: 15px; }
      .cart-footer .footer-left .delete-selected:hover { color: #ee4d2d; }
      .cart-footer .footer-right { margin-left: auto; display: flex; align-items: center; gap: 20px; }
      .cart-footer .total-info { display: flex; align-items: center; gap: 8px; white-space: nowrap; }
      .cart-footer .total-info .total-label { font-size: 14px; color: #333; }
      .cart-footer .total-info .total-price { font-size: 22px; color: #ee4d2d; font-weight: 700; }
      .cart-footer .total-info .total-count { font-size: 13px; color: #555; }
      .cart-footer .btn-checkout {
        background: #ee4d2d; color: #fff; border: none;
        padding: 12px 40px; border-radius: 2px; font-size: 14px;
        font-weight: 600; cursor: pointer; text-transform: uppercase;
        transition: background 0.2s;
        white-space: nowrap;
      }
      .cart-footer .btn-checkout:hover { background: #d73211; }
      .cart-footer .btn-checkout:disabled { background: #ccc; cursor: not-allowed; }

      /* Empty cart */
      .cart-empty { text-align: center; padding: 80px 0; color: #888; }
      .cart-empty i { font-size: 60px; color: #ddd; margin-bottom: 15px; }
      .cart-empty p { font-size: 16px; margin-bottom: 20px; }
      .cart-empty a { color: #ee4d2d; font-weight: 600; text-decoration: none; }

      /* ── Voucher Modal ────────────── */
      .voucher-modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;
      }
      .voucher-modal {
        background: #fff; border-radius: 3px; max-width: 500px; width: 90%;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1); display: flex; flex-direction: column; max-height: 70vh;
      }
      .voucher-modal-header { display: flex; justify-content: space-between; align-items: center; padding: 18px 20px; border-bottom: 1px solid #f0f0f0; }
      .voucher-modal-header h3 { margin: 0; font-size: 18px; font-weight: 500; color: #333; }
      .voucher-modal-header .close-vm { cursor: pointer; font-size: 22px; color: #999; background: none; border: none; }
      .voucher-list { flex: 1; overflow-y: auto; padding: 15px 20px; background: #fafafa; }
      .v-card { display: flex; background: #fff; border: 1px solid #e8e8e8; border-radius: 2px; margin-bottom: 10px; box-shadow: 0 1px 1px rgba(0,0,0,.05); }
      .v-card-left { width: 80px; background: #26aa99; display: flex; flex-direction: column; justify-content: center; align-items: center; color: white; }
      .v-card-left i { font-size: 20px; margin-bottom: 3px; }
      .v-card-left span { font-size: 10px; }
      .v-card-right { flex: 1; padding: 10px 14px; }
      .v-card-right .v-title { font-size: 14px; color: #333; margin-bottom: 3px; }
      .v-card-right .v-min { font-size: 11px; color: #ee4d2d; }
      .v-card-right .v-exp { font-size: 10px; color: #999; margin-top: 3px; }

      /* Cart summary box */
      .cart-summary-box {
        background: #f9f9f9; border: 1px solid #e2e2e2;
        border-radius: 10px; padding: 24px 28px; margin-top: 24px;
      }
      .cart-summary-box .summary-row {
        display: flex; justify-content: space-between; align-items: center;
        padding: 8px 0; font-size: 15px; color: #444;
        border-bottom: 1px dashed #e0e0e0;
      }
      .cart-summary-box .summary-row:last-of-type { border-bottom: none; }
      .cart-summary-box .summary-row.grand {
        font-size: 18px; font-weight: 700; color: #111;
        padding-top: 14px; margin-top: 4px;
        border-top: 2px solid #d63031; border-bottom: none;
      }
      .cart-summary-box .grand .price-value { color: #d63031; font-size: 20px; }
      .cart-summary-note { font-size: 12px; color: #999; margin-top: 8px; }

      @media (max-width: 768px) {
        .cart-table-header { display: none; }
        .cart-item-row { flex-wrap: wrap; gap: 10px; }
        .cart-item-row .col-product { min-width: 60%; }
        .cart-item-row .col-price, .cart-item-row .col-qty, .cart-item-row .col-total, .cart-item-row .col-action { width: auto; }
        .cart-footer { flex-wrap: wrap; gap: 10px; }
        .cart-footer .footer-right { width: 100%; justify-content: space-between; }
      }
    </style>
  </head>

  <body id="top">
    <jsp:include page="header.jsp" />

    <div class="container">
      <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a href="${pageContext.request.contextPath}/menu">Trang Chủ</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
          </ol>
        </nav>
      </div>
    </div>

    <main class="cart-page-content">
      <div class="container">

        <c:if test="${empty cartItems}">
          <div class="cart-empty">
            <i class="fa-solid fa-cart-shopping"></i>
            <p>Giỏ hàng của bạn đang trống</p>
            <a href="${pageContext.request.contextPath}/menu">← Tiếp tục mua sắm</a>
          </div>
        </c:if>

        <c:if test="${not empty cartItems}">
          <%-- Table Header --%>
          <div class="cart-table-header">
            <div class="col-check"><input type="checkbox" id="selectAll" title="Chọn tất cả"></div>
            <div class="col-product">Sản Phẩm</div>
            <div class="col-price">Đơn Giá</div>
            <div class="col-qty">Số Lượng</div>
            <div class="col-total">Số Tiền</div>
            <div class="col-action">Thao Tác</div>
          </div>

          <%-- Cart Items --%>
          <c:forEach var="item" items="${cartItems}">
            <div class="cart-item-row" data-key="${item.productId}-${item.colorId}-${item.sizeId}">
              <div class="col-check">
                <input type="checkbox" class="item-check" name="selectedItems"
                       value="${item.productId}-${item.colorId}-${item.sizeId}"
                       data-final-price="${item.finalPrice}" data-qty="${item.quantity}">
              </div>
              <div class="col-product">
                <c:choose>
                  <c:when test="${not empty item.image && item.image.startsWith('http')}">
                    <img src="${item.image}" alt="${item.name}" />
                  </c:when>
                  <c:when test="${not empty item.image}">
                    <img src="${pageContext.request.contextPath}${item.image}" alt="${item.name}" />
                  </c:when>
                  <c:otherwise>
                    <img src="https://placehold.co/300x300?text=No+Image" alt="${item.name}" />
                  </c:otherwise>
                </c:choose>
                <div class="product-info">
                  <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="p-name">${item.name}</a>
                  <div class="p-variant">${item.colorName} / ${item.sizeName}</div>
                </div>
              </div>
              <div class="col-price">
                <div class="final-price">${item.finalPrice}</div>
                <c:if test="${not empty item.discountValue}">
                  <div class="orig-price">${item.originalPrice}</div>
                </c:if>
              </div>
              <div class="col-qty">
                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="qty-group">
                  <input type="hidden" name="key" value="${item.productId}-${item.colorId}-${item.sizeId}" />
                  <button type="submit" name="action" value="minus">−</button>
                  <input type="number" value="${item.quantity}" min="1" readonly />
                  <button type="submit" name="action" value="plus">+</button>
                </form>
              </div>
              <div class="col-total">${item.finalPrice}</div>
              <div class="col-action">
                <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                  <input type="hidden" name="key" value="${item.productId}-${item.colorId}-${item.sizeId}" />
                  <button class="cart-delete-btn">Xóa</button>
                </form>
              </div>
            </div>
            <%-- Voucher hint under each product --%>
            <div class="voucher-hint">
              <i class="fa-solid fa-ticket" style="color:#ee4d2d;"></i>
              <span>Voucher giảm giá</span>
              <a href="javascript:void(0);" onclick="openVoucherModal(${item.productId});">Xem thêm voucher</a>
            </div>
          </c:forEach>

          <%-- Cart Footer (Sticky) --%>
          <div class="cart-footer">
            <div class="footer-left">
              <input type="checkbox" id="selectAllBottom">
              <label for="selectAllBottom">Chọn Tất Cả (<span id="totalItemCount">${cartItems.size()}</span>)</label>
              <button class="delete-selected" onclick="deleteSelected()">Xóa</button>
            </div>
            <div class="footer-right">
              <div class="total-info">
                <span class="total-label">Tổng thanh toán (<span id="selectedCount">0</span> Sản phẩm): </span>
                <span class="total-price" id="selectedTotal">0₫</span>
              </div>
              <button class="btn-checkout" id="btnCheckout" disabled onclick="checkoutSelected()">Mua Hàng</button>
            </div>
          </div>

        </c:if>

      </div>
    </main>

    <%-- Voucher View Modal --%>
    <div class="voucher-modal-overlay" id="voucherViewModal">
      <div class="voucher-modal">
        <div class="voucher-modal-header">
          <h3>Voucher dành cho sản phẩm</h3>
          <button class="close-vm" onclick="document.getElementById('voucherViewModal').style.display='none';">&times;</button>
        </div>
        <div class="voucher-list" id="voucherListContent">
          <div style="text-align: center; padding: 30px 0; color: #999;">Đang tải...</div>
        </div>
      </div>
    </div>

    <jsp:include page="footer.jsp"/>

    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>

    <script>
      // ========== Checkbox Logic ==========
      const selectAll = document.getElementById('selectAll');
      const selectAllBottom = document.getElementById('selectAllBottom');
      const itemChecks = document.querySelectorAll('.item-check');
      const selectedCountEl = document.getElementById('selectedCount');
      const selectedTotalEl = document.getElementById('selectedTotal');
      const btnCheckout = document.getElementById('btnCheckout');

      function getCheckedItems() {
        return document.querySelectorAll('.item-check:checked');
      }

      function parseVND(str) {
        // "2,700,000₫" -> 2700000
        return parseInt(str.replace(/[^\d]/g, '')) || 0;
      }

      function formatVND(num) {
        return num.toLocaleString('vi-VN') + '₫';
      }

      function updateSummary() {
        const checked = getCheckedItems();
        const count = checked.length;
        selectedCountEl.textContent = count;
        btnCheckout.disabled = count === 0;

        let total = 0;
        checked.forEach(cb => {
          const price = parseVND(cb.getAttribute('data-final-price'));
          const qty = parseInt(cb.getAttribute('data-qty')) || 1;
          total += price * qty;
        });
        selectedTotalEl.textContent = count === 0 ? '0₫' : formatVND(total);
      }

      function syncSelectAll() {
        const allChecked = itemChecks.length > 0 && getCheckedItems().length === itemChecks.length;
        if (selectAll) selectAll.checked = allChecked;
        if (selectAllBottom) selectAllBottom.checked = allChecked;
      }

      if (selectAll) {
        selectAll.addEventListener('change', function() {
          itemChecks.forEach(c => c.checked = this.checked);
          if (selectAllBottom) selectAllBottom.checked = this.checked;
          updateSummary();
        });
      }
      if (selectAllBottom) {
        selectAllBottom.addEventListener('change', function() {
          itemChecks.forEach(c => c.checked = this.checked);
          if (selectAll) selectAll.checked = this.checked;
          updateSummary();
        });
      }
      itemChecks.forEach(cb => {
        cb.addEventListener('change', function() {
          syncSelectAll();
          updateSummary();
        });
      });

      // ========== Checkout Selected Items ==========
      function checkoutSelected() {
        const checked = getCheckedItems();
        if (checked.length === 0) return;

        const keys = [];
        checked.forEach(c => keys.push(c.value));

        // Create a form and submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/checkout-selected';
        keys.forEach(k => {
          const input = document.createElement('input');
          input.type = 'hidden';
          input.name = 'selectedKeys';
          input.value = k;
          form.appendChild(input);
        });
        document.body.appendChild(form);
        form.submit();
      }

      // ========== Delete Selected ==========
      function deleteSelected() {
        const checked = getCheckedItems();
        if (checked.length === 0) {
          alert('Vui lòng chọn sản phẩm cần xóa.');
          return;
        }
        if (!confirm('Bạn có chắc muốn xóa ' + checked.length + ' sản phẩm đã chọn?')) return;

        checked.forEach(c => {
          const row = c.closest('.cart-item-row');
          const removeForm = row.querySelector('.col-action form');
          if (removeForm) removeForm.submit();
        });
      }

      // ========== Voucher Modal ==========
      function openVoucherModal(productId) {
        const modal = document.getElementById('voucherViewModal');
        const content = document.getElementById('voucherListContent');
        content.innerHTML = '<div style="text-align:center;padding:30px 0;color:#999;">Đang tải...</div>';
        modal.style.display = 'flex';

        fetch('${pageContext.request.contextPath}/api/vouchers?productId=' + productId)
          .then(r => r.json())
          .then(data => {
            if (!data || data.length === 0) {
              content.innerHTML = '<div style="text-align:center;padding:30px 0;color:#999;">Chưa có voucher nào cho sản phẩm này.</div>';
              return;
            }
            let html = '';
            data.forEach(v => {
              html += '<div class="v-card">' +
                '<div class="v-card-left"><i class="fa-solid fa-ticket"></i><span>H&M</span></div>' +
                '<div class="v-card-right">' +
                  '<div class="v-title">' + v.description + '</div>' +
                  '<div class="v-min">Đơn Tối Thiểu ' + Number(v.minOrderValue).toLocaleString('vi-VN') + '₫</div>' +
                  '<div class="v-exp">Mã: <strong>' + v.code + '</strong></div>' +
                '</div></div>';
            });
            content.innerHTML = html;
          })
          .catch(err => {
            content.innerHTML = '<div style="text-align:center;padding:30px 0;color:#999;">Không thể tải voucher.</div>';
          });
      }

      // Close modal when clicking outside
      document.getElementById('voucherViewModal')?.addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
      });
    </script>
  </body>
</html>
