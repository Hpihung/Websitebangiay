<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Thanh toán</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-success.css"/>
  <style>
    .checkout-alert {
        background-color: #fff2f0;
        border: 1px solid #ffccc7;
        color: #ff4d4f;
        padding: 16px 24px;
        border-radius: 12px;
        margin-bottom: 24px;
        font-weight: 600;
        font-size: 15px;
        display: flex;
        align-items: center;
        gap: 12px;
        box-shadow: 0 4px 12px rgba(255, 77, 79, 0.05);
    }
  </style>
  <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>

<body>

<jsp:include page="header.jsp"/>

<c:if test="${not empty errorMessage}">
  <div class="checkout-alert">
  <strong>Không thể đặt hàng:</strong><br>
  ${errorMessage}
  </div>
</c:if>

<div class="checkout-container container">

  <form action="${pageContext.request.contextPath}/checkout"
        method="post"
        class="checkout-form">

    <div class="checkout-main-content">
      <div class="col-info">
        <h2>Thông tin nhận hàng</h2>
        <div class="form-group">
          <label>Email</label>
          <input type="text" name="email" value="${currentUser.email}"/>
        </div>
        <div class="form-group">
          <label>Họ và tên</label>
          <input type="text" name="fullName" value="${currentUser.fullName}"/>
        </div>
        <div class="form-group">
          <label>Số điện thoại</label>
          <input type="text" name="phone" value="${currentUser.phoneNumber}"/>
        </div>
        <c:if test="${not empty currentUser.address}">
          <div style="margin-bottom: 15px; padding: 12px 16px; background-color: #f6ffed; border: 1px solid #b7eb8f; border-radius: 8px; font-size: 14px; color: #389e0d; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-location-dot" style="font-size: 16px;"></i> 
            <span><strong>Địa chỉ đã lưu:</strong> ${currentUser.address}</span>
          </div>
        </c:if>
        <div class="form-group-location" style="display: flex; gap: 15px; margin-bottom: 20px;">
          <div class="form-group" style="flex: 1; margin-bottom: 0;">
            <label>Tỉnh / Thành phố</label>
            <select id="province" class="form-control">
              <option value="">Chọn Tỉnh / Thành phố</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1; margin-bottom: 0;">
            <label>Quận / Huyện</label>
            <select id="district" class="form-control">
              <option value="">Chọn Quận / Huyện</option>
            </select>
          </div>
        </div>
        <div class="form-group-location" style="display: flex; gap: 15px; margin-bottom: 20px;">
          <div class="form-group" style="flex: 1; margin-bottom: 0;">
            <label>Phường / Xã</label>
            <select id="ward" class="form-control">
              <option value="">Chọn Phường / Xã</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1; margin-bottom: 0;">
            <label>Số nhà, Tên đường</label>
            <input type="text" id="street" placeholder="VD: 123 Đường ABC"/>
          </div>
        </div>
        
        <!-- Input ẩn chứa địa chỉ đầy đủ sau khi ghép -->
        <input type="hidden" name="address" id="fullAddress" value="${currentUser.address}"/>
        <div class="form-group">
          <label>Ghi chú</label>
          <input type="text" name="note"/>
        </div>
      </div>

      <div class="col-products">
        <h3>Đơn hàng (${cart.size()} sản phẩm)</h3>
        <div class="order-items-list">
          <c:forEach var="item" items="${cart.values()}">
            <div class="order-item">
              <c:choose>
                <c:when test="${not empty item.image && item.image.startsWith('http')}">
                  <img src="${item.image}" class="item-image"/>
                </c:when>
                <c:when test="${not empty item.image}">
                  <img src="${pageContext.request.contextPath}${item.image}" class="item-image"/>
                </c:when>
                <c:otherwise>
                  <img src="https://placehold.co/300x300?text=No+Image" class="item-image"/>
                </c:otherwise>
              </c:choose>
              <div class="item-info">
                <p class="item-name">${item.name}</p>
                <p class="item-variant">${item.colorName} / ${item.sizeName}</p>
                <p class="item-qty">Số lượng: ${item.quantity}</p>
              </div>
              <div class="item-price">${item.finalPrice}</div>
            </div>
          </c:forEach>
        </div>
      </div>

      <div class="col-summary">
        <h3>Thanh toán</h3>
        <div class="payment-box">
          <div class="payment-methods">
            <label class="payment-method-card">
              <input type="radio" name="paymentMethod" value="COD" checked/>
              <div class="payment-content">
                <img src="${pageContext.request.contextPath}/assets/images/cod.png" alt="COD" onerror="this.src='https://cdn-icons-png.flaticon.com/512/1554/1554401.png'" class="payment-icon"/>
                <div class="payment-info">
                  <span class="payment-title">Thanh toán khi nhận hàng (COD)</span>
                  <span class="payment-desc">Thanh toán bằng tiền mặt khi giao hàng</span>
                </div>
              </div>
            </label>

            <label class="payment-method-card">
              <input type="radio" name="paymentMethod" value="VNPAY" />
              <div class="payment-content">
                <img src="${pageContext.request.contextPath}/assets/images/vnpay.png" alt="VNPAY" onerror="this.src='https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0oxhzjmxbksr1686814746087.png'" class="payment-icon"/>
                <div class="payment-info">
                  <span class="payment-title">Thanh toán qua VNPAY</span>
                  <span class="payment-desc">Thẻ ATM, thẻ tín dụng, quét mã QR</span>
                </div>
              </div>
            </label>
          </div>

          <%-- ===== VOUCHER SECTION (Shopee Style) ===== --%>
          <div style="margin-top: 20px; border-top: 1px dashed #ddd; border-bottom: 1px dashed #ddd; padding: 15px 0; margin-bottom: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; cursor: pointer;" onclick="document.getElementById('checkoutVoucherModal').style.display='flex';">
              <div style="display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-ticket" style="color: #ee4d2d; font-size: 18px;"></i>
                <span style="font-size: 15px; color: #333;">H&amp;M Voucher</span>
              </div>
              <div style="display: flex; align-items: center; gap: 8px;">
                <c:choose>
                  <c:when test="${not empty appliedCoupon}">
                    <span style="font-size: 14px; color: #00bfa5; font-weight: 500;">-${discountAmountStr}</span>
                    <span style="font-size: 13px; color: #007bff;">Sửa đổi</span>
                  </c:when>
                  <c:otherwise>
                    <span style="font-size: 14px; color: #007bff; font-weight: 500;">Chọn hoặc nhập mã</span>
                  </c:otherwise>
                </c:choose>
                <i class="fa-solid fa-chevron-right" style="color: #ccc; font-size: 12px;"></i>
              </div>
            </div>
            <c:if test="${not empty appliedCoupon}">
              <div style="font-size: 12px; color: #00bfa5; padding: 6px 10px; background: #e6fffb; border: 1px solid #87e8de; border-radius: 4px; margin-top: 12px; display: flex; justify-content: space-between; align-items: center;">
                <span>Đang áp dụng mã <strong>${appliedCoupon.code}</strong></span>
                <button type="button" id="removeCouponBtn" style="background:none; border:none; color:#f44336; cursor:pointer; font-size:12px; font-weight: bold;">Xóa mã</button>
              </div>
            </c:if>
            <div id="couponMessage" style="font-size: 14px; margin-top: 5px;"></div>
          </div>

          <div class="summary-details">
            <div class="summary-row">
              <span style="color: #555;">Tạm tính</span>
              <span style="color: #333;">${subTotal}</span>
            </div>
            <div class="summary-row">
              <span style="color: #555;">Phí vận chuyển</span>
              <span id="displayShippingFee" style="color: #333;">${shippingFee != '0₫' ? shippingFee : 'Chưa tính'}</span>
            </div>
            <c:if test="${not empty discountAmountStr}">
              <div class="summary-row discount">
                <span style="color: #555;">Giảm giá</span>
                <span style="color: #ee4d2d;">- ${discountAmountStr}</span>
              </div>
            </c:if>
            <div class="summary-row total" style="margin-top: 15px; border-top: 1px solid #f0f0f0; padding-top: 15px;">
              <strong style="font-size: 16px; color: #333;">Tổng cộng</strong>
              <strong id="displayGrandTotal" style="font-size: 22px; color: #ee4d2d;">${grandTotal}</strong>
            </div>
          </div>
          

          
          <button type="submit" class="btn-submit">ĐẶT HÀNG</button>
          <a href="${pageContext.request.contextPath}/menu" class="btn-link">Quay lại</a>
        </div>
      </div>
    </div>
  </form>
</div>

<%-- ===== CHECKOUT VOUCHER MODAL ===== --%>
<div id="checkoutVoucherModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; justify-content:center; align-items:center;">
  <div style="background:#fff; border-radius:3px; max-width:500px; width:90%; box-shadow:0 2px 10px rgba(0,0,0,0.1); display:flex; flex-direction:column; max-height:80vh;">
    <%-- Header --%>
    <div style="display:flex; justify-content:space-between; align-items:center; padding:18px 20px; border-bottom:1px solid #f0f0f0;">
      <h3 style="margin:0; font-size:18px; font-weight:500; color:#333;">Chọn H&amp;M Voucher</h3>
      <span style="cursor:pointer; font-size:14px; color:#007bff;">Hỗ trợ <i class="fa-regular fa-circle-question"></i></span>
    </div>
    <%-- Input Code --%>
    <div style="padding:15px 20px; background:#fafafa; border-bottom:1px solid #f0f0f0;">
      <div style="display:flex; gap:10px;">
        <div style="flex:1; display:flex; align-items:center; border:1px solid #e0e0e0; border-radius:2px; background:#fff; padding:0 10px;">
          <input type="text" id="couponCode" placeholder="Nhập mã voucher" style="flex:1; padding:10px 0; border:none; outline:none; font-size:14px;">
        </div>
        <button type="button" id="applyCouponBtn" style="padding:0 20px; background:#ee4d2d; color:white; border:none; border-radius:2px; cursor:pointer; font-size:14px;">ÁP DỤNG</button>
      </div>
      <div id="modalCouponMsg" style="font-size:12px; margin-top:5px;"></div>
    </div>
    <%-- Voucher List --%>
    <div style="flex:1; overflow-y:auto; padding:15px 20px; background:#f5f5f5;">
      <p style="font-size:14px; color:#555; margin-bottom:10px;">Mã Giảm Giá</p>
      <c:choose>
        <c:when test="${empty activeCoupons}">
          <div style="text-align:center; padding:30px 0; color:#999;">Chưa có mã giảm giá nào</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="coupon" items="${activeCoupons}">
            <div class="ck-voucher-item" data-code="${coupon.code}" style="display:flex; background:#fff; border:1px solid #e8e8e8; border-radius:2px; box-shadow:0 1px 1px rgba(0,0,0,.05); margin-bottom:10px; cursor:pointer; transition: border-color 0.2s;"
                 onclick="selectCkVoucher(this, '${coupon.code}');">
              <div style="width:80px; background:#26aa99; display:flex; flex-direction:column; justify-content:center; align-items:center; color:white; position:relative;">
                <i class="fa-solid fa-ticket" style="font-size:20px; margin-bottom:3px;"></i>
                <span style="font-size:10px;">H&amp;M</span>
                <div style="position:absolute; left:-4px; top:0; bottom:0; width:4px; background-image:radial-gradient(#f5f5f5 2px, transparent 0); background-size:8px 8px; background-position:-2px 0;"></div>
              </div>
              <div style="flex:1; padding:10px 14px; display:flex; align-items:center; justify-content:space-between;">
                <div>
                  <div style="font-size:14px; color:#333; margin-bottom:3px;">
                    <c:choose>
                      <c:when test="${coupon.discountType == 'PERCENTAGE'}">
                        Giảm <fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true"/>%
                        <c:if test="${coupon.maxDiscountAmount != null && coupon.maxDiscountAmount > 0}">
                          tối đa <fmt:formatNumber value="${coupon.maxDiscountAmount}" type="number" groupingUsed="true"/>₫
                        </c:if>
                      </c:when>
                      <c:otherwise>
                        Giảm <fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true"/>₫
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div style="font-size:11px; color:#ee4d2d;">Đơn Tối Thiểu <fmt:formatNumber value="${coupon.minOrderValue}" type="number" groupingUsed="true"/>₫</div>
                  <div style="font-size:10px; color:#999; margin-top:3px;">Mã: <strong>${coupon.code}</strong></div>
                </div>
                <div style="margin-left:10px;">
                  <input type="radio" name="ckSelectedVoucher" value="${coupon.code}" style="width:18px; height:18px; accent-color:#ee4d2d; cursor:pointer;" ${not empty appliedCoupon && appliedCoupon.code == coupon.code ? 'checked' : ''}>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
    <%-- Footer --%>
    <div style="display:flex; justify-content:flex-end; gap:10px; padding:15px 20px; border-top:1px solid #f0f0f0; background:#fff;">
      <button type="button" style="background:transparent; color:#555; border:1px solid #ccc; padding:8px 25px; border-radius:2px; cursor:pointer; font-size:14px;" onclick="document.getElementById('checkoutVoucherModal').style.display='none';">TRỞ LẠI</button>
      <button type="button" id="confirmCkVoucher" style="background:#ee4d2d; color:white; border:none; padding:8px 25px; border-radius:2px; cursor:pointer; font-size:14px;">ĐỒNG Ý</button>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>

<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.21.1/axios.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");
    const streetInput = document.getElementById("street");
    const fullAddressInput = document.getElementById("fullAddress");

    let provincesData = [];

    // Lấy dữ liệu tỉnh thành
    axios.get('https://provinces.open-api.vn/api/?depth=3')
    .then(function(response) {
        provincesData = response.data;
        renderProvinces(provincesData);
        restoreFormState();
    })
    .catch(function(error) {
        console.error("Lỗi khi gọi API tỉnh thành:", error);
    });

    function renderProvinces(data) {
        provinceSelect.innerHTML = '<option value="">Chọn Tỉnh / Thành phố</option>';
        data.forEach(p => {
            provinceSelect.innerHTML += '<option value="' + p.code + '">' + p.name + '</option>';
        });
    }

    function saveFormState() {
        const state = {
            email: document.querySelector('input[name="email"]')?.value || '',
            fullName: document.querySelector('input[name="fullName"]')?.value || '',
            phone: document.querySelector('input[name="phone"]')?.value || '',
            province: provinceSelect.value,
            district: districtSelect.value,
            ward: wardSelect.value,
            street: streetInput.value,
            note: document.querySelector('input[name="note"]')?.value || '',
            paymentMethod: document.querySelector('input[name="paymentMethod"]:checked')?.value || ''
        };
        sessionStorage.setItem('checkoutFormState', JSON.stringify(state));
    }

    function restoreFormState() {
        const savedStateStr = sessionStorage.getItem('checkoutFormState');
        if (savedStateStr) {
            try {
                const state = JSON.parse(savedStateStr);
                if (state.email) document.querySelector('input[name="email"]').value = state.email;
                if (state.fullName) document.querySelector('input[name="fullName"]').value = state.fullName;
                if (state.phone) document.querySelector('input[name="phone"]').value = state.phone;
                if (state.note) document.querySelector('input[name="note"]').value = state.note;
                if (state.street) streetInput.value = state.street;
                if (state.paymentMethod) {
                    const pm = document.querySelector(`input[name="paymentMethod"][value="${state.paymentMethod}"]`);
                    if (pm) pm.checked = true;
                }
                
                if (state.province) {
                    provinceSelect.value = state.province;
                    districtSelect.innerHTML = '<option value="">Chọn Quận / Huyện</option>';
                    wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';
                    const province = provincesData.find(p => p.code == state.province);
                    if(province && province.districts) {
                        province.districts.forEach(d => {
                            districtSelect.innerHTML += '<option value="' + d.code + '">' + d.name + '</option>';
                        });
                        
                        if (state.district) {
                            districtSelect.value = state.district;
                            const district = province.districts.find(d => d.code == state.district);
                            if(district && district.wards) {
                                district.wards.forEach(w => {
                                    wardSelect.innerHTML += '<option value="' + w.code + '">' + w.name + '</option>';
                                });
                            }
                            if (state.ward) {
                                wardSelect.value = state.ward;
                            }
                        }
                    }
                }
                updateFullAddress();
            } catch (e) { console.error("Error parsing checkout state", e); }
            sessionStorage.removeItem('checkoutFormState');
        }
    }

    provinceSelect.addEventListener("change", function() {
        const provinceCode = this.value;
        districtSelect.innerHTML = '<option value="">Chọn Quận / Huyện</option>';
        wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';
        
        if(provinceCode) {
            const province = provincesData.find(p => p.code == provinceCode);
            if(province && province.districts) {
                province.districts.forEach(d => {
                    districtSelect.innerHTML += '<option value="' + d.code + '">' + d.name + '</option>';
                });
            }
        }
        updateFullAddress();
    });

    districtSelect.addEventListener("change", function() {
        const provinceCode = provinceSelect.value;
        const districtCode = this.value;
        wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';
        
        if(provinceCode && districtCode) {
            const province = provincesData.find(p => p.code == provinceCode);
            const district = province.districts.find(d => d.code == districtCode);
            if(district && district.wards) {
                district.wards.forEach(w => {
                    wardSelect.innerHTML += '<option value="' + w.code + '">' + w.name + '</option>';
                });
            }
        }
        updateFullAddress();
    });

    wardSelect.addEventListener("change", updateFullAddress);
    streetInput.addEventListener("input", updateFullAddress);

    function updateFullAddress() {
        const pText = provinceSelect.options[provinceSelect.selectedIndex]?.text || '';
        const dText = districtSelect.options[districtSelect.selectedIndex]?.text || '';
        const wText = wardSelect.options[wardSelect.selectedIndex]?.text || '';
        const street = streetInput.value.trim();

        let addressParts = [];
        if(street) addressParts.push(street);
        if(wText && wText !== 'Chọn Phường / Xã') addressParts.push(wText);
        if(dText && dText !== 'Chọn Quận / Huyện') addressParts.push(dText);
        if(pText && pText !== 'Chọn Tỉnh / Thành phố') addressParts.push(pText);

        fullAddressInput.value = addressParts.join(", ");
        
        // Cập nhật phí vận chuyển
        let fee = 0;
        if (pText && pText !== 'Chọn Tỉnh / Thành phố') {
            const pTextLower = pText.toLowerCase();
            if (pTextLower.includes("hà nội") || pTextLower.includes("ha noi")) {
                const dTextLower = dText.toLowerCase();
                if (dTextLower.includes("hoàng mai") || dTextLower.includes("hoang mai")) {
                    fee = 15000;
                } else {
                    fee = 30000;
                }
            } else {
                fee = 50000;
            }
        }
        
        // Update DOM
        const displayShippingFee = document.getElementById('displayShippingFee');
        const displayGrandTotal = document.getElementById('displayGrandTotal');
        
        const subTotal = parseFloat('${subTotalRaw}') || 0;
        const discountAmount = parseFloat('${discountAmountRaw}') || 0;
        
        if (fee === 0) {
            displayShippingFee.innerText = 'Chưa tính';
        } else {
            displayShippingFee.innerText = new Intl.NumberFormat('vi-VN').format(fee) + '₫';
        }
        
        const grandTotal = subTotal + fee - discountAmount;
        displayGrandTotal.innerText = new Intl.NumberFormat('vi-VN').format(grandTotal) + '₫';
    }

    // ===== Voucher Modal Logic =====
    window.selectCkVoucher = function(el, code) {
        const radio = el.querySelector('input[type="radio"]');
        if (radio) radio.checked = true;
    };

    // Close modal on overlay click
    document.getElementById('checkoutVoucherModal')?.addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });

    function applyCouponAndReload(code) {
        const msgEl = document.getElementById('modalCouponMsg') || document.getElementById('couponMessage');
        axios.post('${pageContext.request.contextPath}/coupon/apply', 'code=' + code, {
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(function(response) {
            const data = response.data;
            if (data.success) {
                if (msgEl) msgEl.innerHTML = '<span style="color: #00bfa5;">' + data.message + '</span>';
                saveFormState();
                setTimeout(() => location.reload(), 500);
            } else {
                if (msgEl) msgEl.innerHTML = '<span style="color: #ee4d2d;">' + data.message + '</span>';
            }
        })
        .catch(function(error) {
            console.error("Lỗi áp dụng mã giảm giá:", error);
            if (msgEl) msgEl.innerHTML = '<span style="color: #ee4d2d;">Lỗi kết nối máy chủ.</span>';
        });
    }

    // Coupon Apply from input
    const applyCouponBtn = document.getElementById("applyCouponBtn");
    const couponCodeInput = document.getElementById("couponCode");

    if (applyCouponBtn) {
        applyCouponBtn.addEventListener("click", function() {
            const code = couponCodeInput.value.trim();
            if (!code) return;
            applyCouponAndReload(code);
        });
    }

    // Confirm voucher from modal list
    document.getElementById('confirmCkVoucher')?.addEventListener('click', function() {
        const selected = document.querySelector('input[name="ckSelectedVoucher"]:checked');
        if (selected) {
            applyCouponAndReload(selected.value);
        } else {
            document.getElementById('checkoutVoucherModal').style.display = 'none';
        }
    });

    // Coupon Remove Logic
    const removeCouponBtn = document.getElementById("removeCouponBtn");
    if (removeCouponBtn) {
        removeCouponBtn.addEventListener("click", function() {
            axios.post('${pageContext.request.contextPath}/coupon/remove')
            .then(function(response) {
                if (response.data.success) {
                    saveFormState();
                    location.reload();
                } else {
                    alert(response.data.message);
                }
            })
            .catch(function(error) {
                console.error("Lỗi xóa mã giảm giá:", error);
            });
        });
    }

    // Form Submit validation
    const checkoutForm = document.querySelector(".checkout-form");
    if (checkoutForm) {
        checkoutForm.addEventListener("submit", function(e) {
            const fullAddress = fullAddressInput.value.trim();
            if (!fullAddress) {
                e.preventDefault();
                alert("Vui lòng nhập đầy đủ thông tin địa chỉ nhận hàng.");
                return;
            }
        });
    }
});
</script>
</body>
</html>
