<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Liên Hệ - H&M SPORT SHOES</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/lienhe.css" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
            href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
            rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="breadcrumb-container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/menu">Trang Chủ</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
                    </ol>
                </nav>
            </div>
        </div>

        <main class="ContactPage">
            <div class="container" style="padding-bottom: 60px;">
                <!-- TIÊU ĐỀ CHÍNH -->
                <div class="contact-header" style="text-align: center; margin-bottom: 60px;">
                    <h1 class="h2 faq-title" style="color: var(--rich-black-fogra-29); text-transform: uppercase; letter-spacing: 1px;">
                        LIÊN HỆ VỚI CHÚNG TÔI
                    </h1>
                    <div style="width: 80px; height: 3px; background: var(--bittersweet); margin: 15px auto;"></div>
                    <p class="faq-subtitle" style="color: var(--onyx); max-width: 700px; margin: 0 auto; font-size: 1.7rem; line-height: 1.6;">
                        Bạn có thắc mắc về đơn hàng, sản phẩm hay cần hợp tác kinh doanh? 
                        Đội ngũ H&M - SPORT SHOES luôn sẵn lòng hỗ trợ bạn 24/7.
                    </p>
                </div>

                <!-- SECTION 1: QUY TRÌNH HỖ TRỢ (TÍNH LOGIC) -->
                <div class="support-process" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 70px; text-align: center;">
                    <div class="process-item" style="padding: 20px; background: var(--cultured); border-radius: 15px; transition: 0.3s;">
                        <ion-icon name="paper-plane-outline" style="font-size: 40px; color: var(--bittersweet); margin-bottom: 15px;"></ion-icon>
                        <h4 class="h4" style="margin-bottom: 10px;">1. Gửi Yêu Cầu</h4>
                        <p style="font-size: 1.4rem; color: var(--onyx);">Điền thông tin vào form bên dưới hoặc gọi hotline trực tiếp.</p>
                    </div>
                    <div class="process-item" style="padding: 20px; background: var(--cultured); border-radius: 15px; transition: 0.3s;">
                        <ion-icon name="time-outline" style="font-size: 40px; color: var(--bittersweet); margin-bottom: 15px;"></ion-icon>
                        <h4 class="h4" style="margin-bottom: 10px;">2. Tiếp Nhận</h4>
                        <p style="font-size: 1.4rem; color: var(--onyx);">Hệ thống phân loại và chuyển đến bộ phận chuyên trách trong 15 phút.</p>
                    </div>
                    <div class="process-item" style="padding: 20px; background: var(--cultured); border-radius: 15px; transition: 0.3s;">
                        <ion-icon name="checkmark-done-circle-outline" style="font-size: 40px; color: var(--bittersweet); margin-bottom: 15px;"></ion-icon>
                        <h4 class="h4" style="margin-bottom: 10px;">3. Giải Quyết</h4>
                        <p style="font-size: 1.4rem; color: var(--onyx);">Bạn sẽ nhận được phản hồi chi tiết qua Email hoặc Điện thoại trong 24h.</p>
                    </div>
                </div>

                <!-- HIỂN THỊ THÔNG BÁO THÀNH CÔNG/THẤT BẠI -->
                <% 
                   String msg = (String) session.getAttribute("msg");
                   String msgType = (String) session.getAttribute("msgType");
                   if (msg != null) {
                %>
                    <div style="padding: 15px; margin-bottom: 30px; border-radius: 10px; text-align: center; font-weight: 600; 
                                background: <%= "success".equals(msgType) ? "#d4edda" : "#f8d7da" %>; 
                                color: <%= "success".equals(msgType) ? "#155724" : "#721c24" %>;
                                border: 1px solid <%= "success".equals(msgType) ? "#c3e6cb" : "#f5c6cb" %>;">
                        <%= msg %>
                    </div>
                <% 
                    session.removeAttribute("msg");
                    session.removeAttribute("msgType");
                   } 
                %>

                <div class="contact-grid" style="display: grid; grid-template-columns: 1fr 1.2fr; gap: 50px;">
                    
                    <!-- CỘT TRÁI: THÔNG TIN HỆ THỐNG -->
                    <div class="contact-left">
                        <section class="faq-category" style="margin-bottom: 40px;">
                            <h3 class="h3 category-title" style="margin-bottom: 30px; border-bottom: 2px solid var(--gainsboro); padding-bottom: 10px;">
                                <ion-icon name="map-outline"></ion-icon> THÔNG TIN HỆ THỐNG
                            </h3>
                            
                            <div class="info-details">
                                <!-- Địa chỉ -->
                                <div style="display: flex; gap: 20px; margin-bottom: 25px;">
                                    <div style="width: 50px; height: 50px; background: var(--maximum-blue-green_10); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <ion-icon name="location" style="color: var(--bittersweet); font-size: 24px;"></ion-icon>
                                    </div>
                                    <div>
                                        <h4 class="h4" style="font-size: 1.6rem; margin-bottom: 5px;">Văn Phòng & Showroom</h4>
                                        <p style="color: var(--onyx); font-size: 1.5rem;">136 Kim Giang, P. Đại Kim, Q. Hoàng Mai, Hà Nội</p>
                                        <a href="https://maps.app.goo.gl/..." target="_blank" style="color: var(--bittersweet); font-size: 1.3rem; font-weight: 600; text-decoration: underline;">Tìm đường đi</a>
                                    </div>
                                </div>

                                <!-- Hotline -->
                                <div style="display: flex; gap: 20px; margin-bottom: 25px;">
                                    <div style="width: 50px; height: 50px; background: var(--maximum-blue-green_10); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <ion-icon name="call" style="color: var(--bittersweet); font-size: 24px;"></ion-icon>
                                    </div>
                                    <div>
                                        <h4 class="h4" style="font-size: 1.6rem; margin-bottom: 5px;">Hỗ Trợ Khách Hàng</h4>
                                        <p style="color: var(--bittersweet); font-size: 2rem; font-weight: 700;">0367085888</p>
                                        <p style="color: var(--onyx); font-size: 1.3rem;">Thứ 2 - CN (07:30 - 22:00)</p>
                                    </div>
                                </div>

                                <!-- Email -->
                                <div style="display: flex; gap: 20px; margin-bottom: 25px;">
                                    <div style="width: 50px; height: 50px; background: var(--maximum-blue-green_10); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <ion-icon name="mail" style="color: var(--bittersweet); font-size: 24px;"></ion-icon>
                                    </div>
                                    <div>
                                        <h4 class="h4" style="font-size: 1.6rem; margin-bottom: 5px;">Email Phản Hồi</h4>
                                        <p style="color: var(--onyx); font-size: 1.5rem;">hm_sport@gmail.com</p>
                                        <p style="color: var(--onyx); font-size: 1.3rem;">Chúng tôi sẽ phản hồi trong vòng 24h.</p>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- BẢN ĐỒ -->
                        <div class="map-wrap" style="border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                            <iframe
                                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.7431105436155!2d105.8118029759039!3d20.999553780617578!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac8523c14175%3A0x6339031c62359416!2zMTM2IFAuIEtpbSBHaWFuZywgxJDhuqFpIEtpbSwgSG_DoG5nIE1haSwgSMOgIE7hu5lpLCBWaeG7h3QgTmFt!5e0!3m2!1svi!2s!4v1715074000000!5m2!1svi!2s"
                                width="100%" height="300" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                        </div>
                    </div>

                    <!-- CỘT PHẢI: FORM GỬI YÊU CẦU -->
                    <div class="contact-right">
                        <section class="faq-category" style="background: var(--white); padding: 40px; border-radius: 20px; box-shadow: 0 15px 40px rgba(0,0,0,0.05); border: 1px solid var(--gainsboro);">
                            <h3 class="h3 category-title" style="margin-bottom: 30px; text-align: center; color: var(--rich-black-fogra-29);">
                                <ion-icon name="chatbubbles-outline" style="vertical-align: middle; margin-right: 10px; color: var(--bittersweet);"></ion-icon> GỬI LỜI NHẮN CHI TIẾT
                            </h3>
                            
                            <form id="contactForm" method="post" action="${pageContext.request.contextPath}/lien-he" onsubmit="return validateContactForm();">
                                <!-- Họ tên -->
                                <div style="margin-bottom: 22px;">
                                    <label style="display: flex; align-items: center; gap: 4px; margin-bottom: 8px; color: var(--rich-black-fogra-29); font-weight: 600; font-size: 1.4rem;">
                                        Họ và tên khách hàng <span style="color: var(--bittersweet);">*</span>
                                    </label>
                                    <div style="position: relative;">
                                        <ion-icon name="person-outline" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #777; font-size: 1.8rem;"></ion-icon>
                                        <input type="text" id="name" name="name" placeholder="Ví dụ: Nguyễn Văn A" required 
                                            style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gainsboro); border-radius: 10px; background: var(--white); font-size: 1.5rem; transition: 0.3s;">
                                    </div>
                                </div>

                                <!-- Email & Phone -->
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 22px;">
                                    <div>
                                        <label style="display: flex; align-items: center; gap: 4px; margin-bottom: 8px; color: var(--rich-black-fogra-29); font-weight: 600; font-size: 1.4rem;">
                                            Địa chỉ Email <span style="color: var(--bittersweet);">*</span>
                                        </label>
                                        <div style="position: relative;">
                                            <ion-icon name="mail-outline" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #777; font-size: 1.8rem;"></ion-icon>
                                            <input type="email" id="email" name="email" placeholder="email@example.com" required 
                                                style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gainsboro); border-radius: 10px; background: var(--white); font-size: 1.5rem;">
                                        </div>
                                    </div>
                                    <div>
                                        <label style="display: flex; align-items: center; gap: 4px; margin-bottom: 8px; color: var(--rich-black-fogra-29); font-weight: 600; font-size: 1.4rem;">
                                            Số điện thoại <span style="color: var(--bittersweet);">*</span>
                                        </label>
                                        <div style="position: relative;">
                                            <ion-icon name="call-outline" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #777; font-size: 1.8rem;"></ion-icon>
                                            <input type="tel" id="phone" name="phone" placeholder="03xxxxxxxx" pattern="[0-9]{10,11}" required 
                                                style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gainsboro); border-radius: 10px; background: var(--white); font-size: 1.5rem;">
                                        </div>
                                    </div>
                                </div>

                                <!-- Chủ đề -->
                                <div style="margin-bottom: 22px;">
                                    <label style="display: flex; align-items: center; gap: 4px; margin-bottom: 8px; color: var(--rich-black-fogra-29); font-weight: 600; font-size: 1.4rem;">
                                        Chủ đề bạn cần hỗ trợ <span style="color: var(--bittersweet);">*</span>
                                    </label>
                                    <div style="position: relative;">
                                        <ion-icon name="list-outline" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #777; font-size: 1.8rem; pointer-events: none;"></ion-icon>
                                        <select id="subject" name="subject" required 
                                            style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gainsboro); border-radius: 10px; background: var(--white); font-size: 1.5rem; cursor: pointer; appearance: none;">
                                            <option value="">-- Chọn vấn đề bạn đang gặp phải --</option>
                                            <option value="Tư vấn sản phẩm">Tư vấn chọn mẫu giày & chọn size chuẩn</option>
                                            <option value="Hỗ trợ đơn hàng">Tra cứu trạng thái đơn hàng & Thay đổi địa chỉ</option>
                                            <option value="Hủy đơn hàng">Yêu cầu hủy đơn hàng (Trạng thái PENDING)</option>
                                            <option value="Chính sách bảo hành">Yêu cầu bảo hành / Sửa chữa sản phẩm</option>
                                            <option value="Đổi trả hàng">Thủ tục đổi size hoặc hoàn trả hàng</option>
                                            <option value="Hợp tác kinh doanh">Liên hệ hợp tác đại lý / Nhập sỉ số lượng lớn</option>
                                            <option value="Khiếu nại dịch vụ">Khiếu nại thái độ nhân viên / Dịch vụ vận chuyển</option>
                                        </select>
                                        <ion-icon name="chevron-down-outline" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #777; pointer-events: none;"></ion-icon>
                                    </div>
                                    <p style="font-size: 1.2rem; color: #777; margin-top: 8px; font-style: italic; display: flex; align-items: center; gap: 5px;">
                                        <ion-icon name="information-circle-outline" style="font-size: 1.6rem; color: var(--bittersweet);"></ion-icon>
                                        Mẹo: Bạn có thể tự hủy đơn PENDING tại <a href="${pageContext.request.contextPath}/account" style="color: var(--bittersweet); text-decoration: underline; font-weight: 600;">Lịch sử mua hàng</a>.
                                    </p>
                                </div>

                                <!-- Nội dung -->
                                <div style="margin-bottom: 30px;">
                                    <label style="display: flex; align-items: center; gap: 4px; margin-bottom: 8px; color: var(--rich-black-fogra-29); font-weight: 600; font-size: 1.4rem;">
                                        Nội dung chi tiết lời nhắn <span style="color: var(--bittersweet);">*</span>
                                    </label>
                                    <textarea id="message" name="message" rows="5" placeholder="Hãy mô tả chi tiết vấn đề để chúng tôi hỗ trợ bạn tốt nhất (Ví dụ: Mã đơn hàng, size cần đổi...)" required 
                                        style="width: 100%; padding: 15px; border: 1.5px solid var(--gainsboro); border-radius: 10px; background: var(--white); font-size: 1.5rem; resize: vertical; min-height: 120px;"></textarea>
                                </div>

                                <!-- Nút gửi -->
                                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; padding: 18px; border-radius: 10px; font-weight: 700; text-transform: uppercase; font-size: 1.6rem; letter-spacing: 1px; box-shadow: 0 8px 20px rgba(255,87,51,0.2);">
                                    GỬI YÊU CẦU NGAY
                                </button>
                                
                                <div style="margin-top: 20px; text-align: center; color: #777; font-size: 1.2rem; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                    <ion-icon name="shield-checkmark-outline" style="color: #28a745; font-size: 1.6rem;"></ion-icon>
                                    H&M Sport cam kết bảo mật 100% thông tin cá nhân của bạn.
                                </div>
                            </form>
                        </section>

                        <!-- QUICK LINKS -->
                        <div style="margin-top: 30px; display: flex; justify-content: space-between; align-items: center; padding: 15px 25px; background: var(--maximum-blue-green_10); border-radius: 15px;">
                            <p style="font-weight: 600; color: var(--onyx); font-size: 1.4rem;">Bạn muốn câu trả lời tức thì?</p>
                            <a href="${pageContext.request.contextPath}/faq" style="color: var(--bittersweet); font-weight: 700; font-size: 1.4rem; display: flex; align-items: center; gap: 5px;">
                                Xem FAQ ngay <ion-icon name="arrow-forward-outline"></ion-icon>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="footer.jsp" />

        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

        <script>
            function validateContactForm() {
                const form = document.getElementById('contactForm');
                const name = document.getElementById('name').value.trim();
                const email = document.getElementById('email').value.trim();
                const phone = document.getElementById('phone').value.trim();
                const subject = document.getElementById('subject').value.trim();
                const message = document.getElementById('message').value.trim();
                
                if (!name || !email || !phone || !subject || !message) {
                    alert('Vui lòng hoàn thành tất cả các trường thông tin bắt buộc (*).');
                    return false;
                }
                
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(email)) {
                    alert('Địa chỉ Email không đúng định dạng. Vui lòng kiểm tra lại.');
                    return false;
                }
                
                const phonePattern = /^[0-9]{10,11}$/;
                if (!phonePattern.test(phone)) {
                    alert('Số điện thoại không hợp lệ (yêu cầu 10-11 chữ số).');
                    return false;
                }

                // REAL AJAX SUBMISSION
                // Show loading state on button
                const btn = form.querySelector('button[type="submit"]');
                const originalText = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = '<ion-icon name="sync-outline" class="rotate" style="animation: spin 1s linear infinite;"></ion-icon> Đang gửi...';

                const formData = new FormData(form);
                const params = new URLSearchParams(formData);

                fetch('${pageContext.request.contextPath}/lien-he', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                })
                .then(async response => {
                    const data = await response.json();
                    if (!response.ok) {
                        throw new Error(data.message || 'Lỗi server');
                    }
                    return data;
                })
                .then(data => {
                    if(data.status === 'success') {
                        // Hide the form section and show a beautiful success message
                        const formSection = form.closest('.faq-category');
                        formSection.style.transition = 'opacity 0.5s';
                        formSection.style.opacity = '0';
                        
                        setTimeout(() => {
                            formSection.innerHTML = `
                                <div style="text-align: center; padding: 40px 20px; background: var(--white); border-radius: 20px; border: 1px solid var(--gainsboro); box-shadow: 0 15px 40px rgba(0,0,0,0.05);">
                                    <div style="width: 80px; height: 80px; background: #d4edda; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                                        <ion-icon name="checkmark-outline" style="color: #28a745; font-size: 40px;"></ion-icon>
                                    </div>
                                    <h3 class="h3" style="color: #155724; margin-bottom: 15px;">GỬI YÊU CẦU THÀNH CÔNG!</h3>
                                    <p style="color: #155724; font-size: 1.6rem; line-height: 1.6; margin-bottom: 25px;">
                                        Cảm ơn bạn <strong>` + name + `</strong> đã liên hệ với H&M Sport Shoes.<br>
                                        Yêu cầu về <strong>"` + subject + `"</strong> của bạn đã được chuyên trách xử lý. 
                                        Thông tin này đã được lưu vào hệ thống.
                                    </p>
                                    <button onclick="window.location.reload()" class="btn" style="background: var(--bittersweet); color: white; padding: 10px 25px; border-radius: 8px; margin: 0 auto; display: inline-flex;">
                                        Gửi thêm yêu cầu khác
                                    </button>
                                </div>
                            `;
                            formSection.style.opacity = '1';
                            formSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }, 500);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Lỗi: ' + error.message + '\n\nLưu ý: Bạn cần chạy file SQL migration_contact.sql và khởi động lại Server để tính năng này hoạt động.');
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                });

                return false; // Prevent actual form submission
            }
        </script>
        <style>
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
        </style>
        <script src="\${pageContext.request.contextPath}/assets/script/reponsive.js"></script>

    </body>

    </html>