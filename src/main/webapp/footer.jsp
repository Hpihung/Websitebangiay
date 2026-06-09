
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="footer">
    <div class="footer-top section">
        <div class="container">
            <div class="footer-brand">
                <a href="#" class="logo">
                    <img
                            src="${pageContext.request.contextPath}/assets/images/HM_LOGO.png"
                            width="110"
                            height="50"
                            alt="H&M"
                    />
                </a>

                <ul class="social-list">
                    <li>
                        <a
                                href="https://www.facebook.com/kcntt.nlu"
                                class="social-link"
                        >
                            <ion-icon name="logo-facebook"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.youtube.com/@NongLamUniversity/videos"
                                class="social-link"
                        >
                            <ion-icon name="logo-youtube"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.tiktok.com/@nonglam.university"
                                class="social-link"
                        >
                            <ion-icon name="logo-tiktok"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.instagram.com/daihocnonglamtphcm.hcmuaf1955/"
                                class="social-link"
                        >
                            <ion-icon name="logo-instagram"></ion-icon>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="footer-link-box">
                <ul class="footer-list">
                    <li>
                        <p class="footer-list-title">Thông tin liên hệ</p>
                    </li>

                    <li>
                        <address class="footer-link">
                            <ion-icon name="location"></ion-icon>
                            <span class="footer-link-text">
                    136 Kim Giang, Hoàng Mai, Hà Nội
                  </span>
                        </address>
                    </li>

                    <li>
                        <a href="#" class="footer-link">
                            <ion-icon name="call"></ion-icon>
                            <span class="footer-link-text">0367085888</span>
                        </a>
                    </li>

                    <li>
                        <a href="#" class="footer-link">
                            <ion-icon name="mail"></ion-icon>
                            <span class="footer-link-text">hm_sport@gmail.com</span>
                        </a>
                    </li>
                </ul>

                <ul class="footer-list">
                    <li><p class="footer-list-title">Tài khoản</p></li>
                    <li>
                        <a
                                href="${pageContext.request.contextPath}/account"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Tài khoản</span>
                        </a>
                    </li>
                    <li>
                        <a
                                href="${pageContext.request.contextPath}/cart"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>

                            <span class="footer-link-text">Xem giỏ hàng</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/wishlist"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>

                            <span class="footer-link-text">Yêu thích</span>
                        </a>
                    </li>
                </ul>

                <ul class="footer-list">
                    <li><p class="footer-list-title">Chính sách</p></li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/chinh-sach-bao-mat"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Chính sách bảo mật</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/chinh-sach-bao-hanh"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Chính sách bảo hành</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/huong-dan-mua-hang"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Hướng dẫn mua hàng</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/faq"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">FAQs</span>
                        </a>
                    </li>
                </ul>


                <div class="footer-list newsletter-box">
                    <div class="newsletter-header">
                        <span class="newsletter-badge">✦ Exclusive</span>
                        <p class="footer-list-title newsletter-title">Đăng Ký Nhận Tin</p>
                        <p class="newsletter-desc">Nhận ngay ưu đãi đặc biệt, bộ sưu tập mới nhất và tin tức thời trang độc quyền dành riêng cho bạn.</p>
                    </div>
                    <form
                            id="newsletter-form"
                            action=""
                            class="newsletter-form"
                            method="POST"
                    >
                        <div class="newsletter-input-wrapper">
                            <ion-icon name="mail-outline" class="newsletter-icon"></ion-icon>
                            <input
                                    type="email"
                                    name="email"
                                    required
                                    placeholder="Nhập địa chỉ email của bạn..."
                                    class="newsletter-input"
                            />
                        </div>
                        <button type="submit" class="newsletter-btn">
                            <span>Đăng Ký Ngay</span>
                            <ion-icon name="arrow-forward-outline"></ion-icon>
                        </button>
                    </form>
                    <p class="newsletter-privacy">
                        <ion-icon name="shield-checkmark-outline"></ion-icon>
                        Chúng tôi cam kết bảo mật thông tin của bạn
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="container">
            <p class="copyright">
                &copy; 2026
                <a href="#" class="copyright-link">H&M-SPORT SHOES</a>. Cùng bạn
                chinh phục mọi hành trình
            </p>
        </div>
    </div>
</footer>

<!-- AI Chat Assistant -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ai-chat.css">

<div class="ai-chat-launcher">
    <i class="fa-solid fa-robot"></i>
</div>

<div class="ai-chat-window">
    <div class="ai-chat-header">
        <div class="ai-avatar">
            <i class="fa-solid fa-bolt"></i>
        </div>
        <div class="ai-chat-info">
            <h3>H&M AI Assistant</h3>
            <p><span class="ai-status-dot"></span> Trực tuyến • Phản hồi ngay</p>
        </div>
        <div style="margin-left: auto; cursor: pointer;" onclick="document.querySelector('.ai-chat-window').classList.remove('active')">
            <i class="fa-solid fa-xmark"></i>
        </div>
    </div>
    
    <div class="ai-chat-messages">
        <!-- Messages will be injected here -->
    </div>
    
    <div class="ai-chat-input-area">
        <input type="text" class="ai-chat-input" placeholder="Hỏi tôi bất cứ điều gì...">
        <button class="ai-send-btn">
            <i class="fa-solid fa-paper-plane"></i>
        </button>
    </div>
</div>

<script>
    var ctx = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/ai-chat.js"></script>

<!-- Newsletter Premium Glass Toast Styles & Script -->
<style>
    .glass-toast-container {
        position: fixed;
        top: 24px;
        right: 24px;
        z-index: 999999;
        display: flex;
        flex-direction: column;
        gap: 12px;
        pointer-events: none;
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }
    .glass-toast {
        pointer-events: auto;
        min-width: 320px;
        max-width: 420px;
        padding: 16px 20px;
        border-radius: 16px;
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(20px) saturate(180%);
        -webkit-backdrop-filter: blur(20px) saturate(180%);
        border: 1px solid rgba(255, 255, 255, 0.45);
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.06), 
                    inset 0 1px 0 rgba(255, 255, 255, 0.7);
        display: flex;
        align-items: center;
        gap: 16px;
        transform: translateX(120%);
        opacity: 0;
        transition: all 0.45s cubic-bezier(0.175, 0.885, 0.32, 1.2);
    }
    .glass-toast.show {
        transform: translateX(0);
        opacity: 1;
    }
    .glass-toast-icon {
        width: 38px;
        height: 38px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    .glass-toast-success .glass-toast-icon {
        background: rgba(46, 213, 115, 0.15);
        color: #2ed573;
        box-shadow: 0 4px 12px rgba(46, 213, 115, 0.15);
    }
    .glass-toast-error .glass-toast-icon {
        background: rgba(255, 71, 87, 0.15);
        color: #ff4757;
        box-shadow: 0 4px 12px rgba(255, 71, 87, 0.15);
    }
    .glass-toast-info .glass-toast-icon {
        background: rgba(108, 93, 211, 0.15);
        color: #6c5dd3;
        box-shadow: 0 4px 12px rgba(108, 93, 211, 0.15);
    }
    .glass-toast-content {
        flex-grow: 1;
    }
    .glass-toast-title {
        font-size: 14px;
        font-weight: 700;
        color: #1e272e;
        margin: 0 0 3px 0;
    }
    .glass-toast-message {
        font-size: 12px;
        color: #57606f;
        margin: 0;
        line-height: 1.4;
    }
    .glass-toast-close {
        background: none;
        border: none;
        color: #a4b0be;
        cursor: pointer;
        font-size: 20px;
        padding: 4px;
        transition: color 0.2s;
        line-height: 1;
    }
    .glass-toast-close:hover {
        color: #57606f;
    }
</style>

<script>
    function showGlassToast(type, title, message) {
        let container = document.querySelector('.glass-toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'glass-toast-container';
            document.body.appendChild(container);
        }
        
        const toast = document.createElement('div');
        toast.className = 'glass-toast glass-toast-' + type;
        
        let iconHTML = '';
        if (type === 'success') {
            iconHTML = '<i class="fa-solid fa-circle-check"></i>';
        } else if (type === 'error') {
            iconHTML = '<i class="fa-solid fa-circle-xmark"></i>';
        } else {
            iconHTML = '<i class="fa-solid fa-circle-info"></i>';
        }
        
        toast.innerHTML = 
            '<div class="glass-toast-icon">' + iconHTML + '</div>' +
            '<div class="glass-toast-content">' +
                '<h4 class="glass-toast-title">' + title + '</h4>' +
                '<p class="glass-toast-message">' + message + '</p>' +
            '</div>' +
            '<button class="glass-toast-close" onclick="this.parentElement.remove()">&times;</button>';
        
        container.appendChild(toast);
        
        // Trigger slide-in animation
        setTimeout(function() {
            toast.classList.add('show');
        }, 20);
        
        // Auto-dismiss after 4 seconds
        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() {
                toast.remove();
            }, 500);
        }, 4000);
    }

    document.addEventListener("DOMContentLoaded", function() {
        const newsletterForm = document.getElementById("newsletter-form");
        if (newsletterForm) {
            newsletterForm.addEventListener("submit", function(e) {
                e.preventDefault();
                const emailInput = newsletterForm.querySelector(".newsletter-input");
                const email = emailInput.value.trim();
                
                if (!email) {
                    showGlassToast('error', 'Lỗi nhập liệu', 'Vui lòng nhập địa chỉ email của bạn.');
                    return;
                }
                
                const submitBtn = newsletterForm.querySelector("button[type='submit']");
                const originalText = submitBtn.innerHTML;
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span>Đang gửi...</span>';
                
                const params = new URLSearchParams();
                params.append("email", email);
                
                fetch(ctx + '/newsletter', {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: params
                })
                .then(function(res) {
                    return res.json();
                })
                .then(function(data) {
                    if (data.success) {
                        showGlassToast('success', 'Đăng ký thành công', data.message);
                        emailInput.value = '';
                    } else {
                        showGlassToast('error', 'Đăng ký thất bại', data.message);
                    }
                })
                .catch(function(err) {
                    console.error("Newsletter subscription error:", err);
                    showGlassToast('error', 'Lỗi kết nối', 'Không thể gửi yêu cầu. Vui lòng thử lại sau.');
                })
                .finally(function() {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                });
            });
        }
    });
</script>