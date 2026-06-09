<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Quill Editor Removed -->

<style>
    /* Tabs Navigation */
    .newsletter-tabs {
        display: flex;
        gap: 8px;
        margin-bottom: 28px;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 8px;
    }
    .tab-trigger {
        background: none;
        border: none;
        padding: 10px 18px;
        font-size: 14px;
        font-weight: 700;
        color: var(--unity-gray);
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        border-radius: 10px;
        transition: all 0.25s;
    }
    .tab-trigger i {
        font-size: 15px;
    }
    .tab-trigger.active {
        color: var(--unity-primary);
        background: rgba(108, 93, 211, 0.08);
    }
    .tab-trigger:hover:not(.active) {
        color: var(--unity-black);
        background: rgba(0, 0, 0, 0.02);
    }
    .tab-panel {
        display: none;
    }
    .tab-panel.active {
        display: block;
        animation: tabFadeIn 0.3s ease;
    }
    @keyframes tabFadeIn {
        from { opacity: 0; transform: translateY(6px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Header styling */
    .news-header { margin-bottom: 32px; }
    .news-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }
    .news-header p { color: var(--unity-gray); font-weight: 500; margin-top: 8px; font-size: 14px; }

    /* Cards */
    .u-card { background: var(--white); border-radius: 24px; padding: 28px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); border: 1px solid rgba(0,0,0,0.015); }
    
    .filter-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 28px;
        flex-wrap: wrap;
        gap: 16px;
    }
    
    .search-wrapper {
        position: relative;
        display: flex;
        align-items: center;
    }
    .search-wrapper i {
        position: absolute;
        left: 16px;
        color: var(--unity-gray);
        font-size: 14px;
    }
    .search-input {
        background: var(--unity-bg);
        border: 1px solid transparent;
        padding: 12px 16px 12px 42px;
        border-radius: 14px;
        font-size: 13px;
        outline: none;
        width: 300px;
        transition: all 0.3s;
        color: var(--unity-black);
    }
    .search-input:focus {
        border-color: var(--unity-primary);
        background: var(--white);
        box-shadow: 0 4px 20px rgba(108, 93, 211, 0.08);
    }

    .pill-filters {
        display: flex;
        background: var(--unity-bg);
        padding: 4px;
        border-radius: 14px;
        gap: 4px;
    }
    .pill-btn {
        border: none;
        background: none;
        padding: 8px 18px;
        font-size: 13px;
        font-weight: 700;
        color: var(--unity-gray);
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.25s;
        text-decoration: none;
    }
    .pill-btn.active {
        background: var(--white);
        color: var(--unity-primary);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
    }

    /* Table styling */
    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 18px 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 10px;
        font-weight: 700;
        font-size: 11px;
        letter-spacing: 0.3px;
        text-transform: uppercase;
    }
    .status-badge.active-badge {
        background: rgba(46, 213, 115, 0.1);
        color: #2ed573;
    }
    .status-badge.inactive-badge {
        background: rgba(255, 71, 87, 0.1);
        color: #ff4757;
    }

    .btn-actions {
        display: flex;
        gap: 8px;
        justify-content: flex-end;
    }
    
    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: all 0.2s;
        font-size: 14px;
    }
    .btn-icon.btn-toggle-active:hover {
        background: rgba(108, 93, 211, 0.1);
        color: var(--unity-primary);
    }
    .btn-icon.btn-delete:hover {
        background: #FF7675;
        color: #fff;
        box-shadow: 0 4px 12px rgba(255, 118, 117, 0.2);
    }
    
    .stats-bar {
        display: flex;
        gap: 20px;
        margin-bottom: 24px;
    }
    .stat-pill {
        background: var(--white);
        padding: 12px 20px;
        border-radius: 16px;
        font-size: 13px;
        font-weight: 700;
        color: var(--unity-black);
        box-shadow: 0 8px 30px rgba(0,0,0,0.015);
        border: 1px solid rgba(0,0,0,0.01);
    }
    .stat-pill span {
        color: var(--unity-primary);
        font-size: 16px;
        font-weight: 800;
        margin-left: 6px;
    }

    /* 3-Column Layout from Screenshot */
    .compose-grid {
        display: grid;
        grid-template-columns: 310px 1fr 280px;
        gap: 24px;
        align-items: start;
    }
    @media (max-width: 1200px) {
        .compose-grid {
            grid-template-columns: 1fr 1fr;
        }
        .compose-grid > *:nth-child(2) {
            grid-column: span 2;
            order: -1;
        }
    }
    @media (max-width: 768px) {
        .compose-grid {
            grid-template-columns: 1fr;
        }
        .compose-grid > * {
            grid-column: span 1 !important;
        }
    }

    /* Column titles */
    .panel-section-title {
        font-size: 13px;
        font-weight: 800;
        color: var(--unity-black);
        margin: 0 0 16px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: flex;
        align-items: center;
        gap: 8px;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 8px;
    }

    /* Option Cards styling */
    .tpl-option-card {
        border: 1px solid var(--border-color);
        border-radius: 14px;
        padding: 14px 16px;
        margin-bottom: 12px;
        cursor: pointer;
        transition: all 0.25s;
        background: var(--white);
    }
    .tpl-option-card:hover {
        border-color: var(--unity-primary);
        transform: translateY(-2px);
    }
    .tpl-option-card.active {
        border-color: var(--unity-primary);
        background: rgba(108, 93, 211, 0.03);
        box-shadow: 0 4px 16px rgba(108, 93, 211, 0.06);
    }
    .tpl-option-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 6px;
    }
    .tpl-option-name {
        font-size: 12px;
        font-weight: 800;
        color: var(--unity-black);
    }
    .tpl-badge {
        font-size: 8px;
        font-weight: 800;
        padding: 2px 6px;
        border-radius: 6px;
        text-transform: uppercase;
    }
    .tpl-badge.hot { background: rgba(255, 71, 87, 0.1); color: #ff4757; }
    .tpl-badge.new { background: rgba(63, 140, 255, 0.1); color: var(--unity-blue); }
    .tpl-badge.warm { background: rgba(46, 213, 115, 0.1); color: #2ed573; }
    .tpl-option-desc {
        font-size: 11px;
        color: var(--unity-gray);
        line-height: 1.4;
        margin: 0;
    }

    .form-group {
        margin-bottom: 20px;
    }
    .form-label {
        display: block;
        font-size: 12px;
        font-weight: 800;
        color: var(--unity-black);
        margin-bottom: 8px;
        text-transform: uppercase;
    }
    .input-text {
        width: 100%;
        background: var(--unity-bg);
        border: 1px solid transparent;
        padding: 12px 14px;
        border-radius: 12px;
        font-size: 13px;
        outline: none;
        transition: all 0.3s;
        color: var(--unity-black);
        font-family: inherit;
    }
    .input-text:focus {
        border-color: var(--unity-primary);
        background: var(--white);
        box-shadow: 0 4px 20px rgba(108, 93, 211, 0.08);
    }

    /* Embedded Device Frames Layout */
    .preview-device-wrapper {
        margin: 20px auto 0;
        transition: all 0.3s ease;
    }
    
    /* Mobile Phone frame design */
    .preview-device-wrapper.mobile {
        width: 325px;
        height: 580px;
        border: 12px solid #11142D;
        border-radius: 36px;
        position: relative;
        background: #ffffff;
        box-shadow: 0 20px 40px rgba(0,0,0,0.08);
    }
    .preview-device-wrapper.mobile::before {
        content: '';
        position: absolute;
        top: -6px;
        left: 50%;
        transform: translateX(-50%);
        width: 60px;
        height: 4px;
        background: #11142D;
        border-radius: 2px;
        z-index: 10;
    }
    .preview-device-wrapper.mobile iframe {
        width: 100%;
        height: 100%;
        border: none;
        border-radius: 24px;
        background: #ffffff;
    }

    /* Desktop screen frame design */
    .preview-device-wrapper.desktop {
        width: 100%;
        height: 580px;
        border: 1px solid var(--border-color);
        border-radius: 16px;
        background: #ffffff;
        box-shadow: 0 10px 30px rgba(0,0,0,0.04);
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    .preview-device-wrapper.desktop .desktop-header {
        background: #11142D;
        padding: 10px 16px;
        display: flex;
        gap: 6px;
        align-items: center;
    }
    .preview-device-wrapper.desktop iframe {
        flex: 1;
        border: none;
        width: 100%;
        background: #ffffff;
    }

    /* Simulated macOS Email Client Envelope Wrapper for editing */
    .email-client-frame {
        border: 1px solid var(--border-color);
        border-radius: 18px;
        overflow: hidden;
        box-shadow: 0 15px 40px rgba(0,0,0,0.03);
        background: var(--white);
        margin-top: 14px;
    }
    .email-client-header {
        background: #11142D;
        padding: 12px 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .email-client-dots {
        display: flex;
        gap: 6px;
    }
    .mac-dot {
        width: 10px; height: 10px; border-radius: 50%;
    }
    .mac-dot.red { background: #ff4757; }
    .mac-dot.yellow { background: #ffa502; }
    .mac-dot.green { background: #2ed573; }
    
    .email-client-info {
        background: #fafafa;
        border-bottom: 1px solid var(--border-color);
        padding: 12px 18px;
        font-size: 12px;
        color: var(--unity-gray);
    }
    .email-client-row {
        display: flex;
        margin-bottom: 6px;
        align-items: center;
    }
    .email-client-label {
        width: 45px; font-weight: 700; color: var(--unity-black);
    }
    .email-client-val {
        flex: 1; color: var(--unity-gray); font-family: monospace; font-size: 11px;
    }

    .quill-editor-container {
        border: none;
    }
    .ql-toolbar.ql-snow {
        border: none;
        border-bottom: 1px solid var(--border-color);
        background: var(--unity-bg);
        padding: 10px 14px;
    }
    .ql-container.ql-snow {
        border: none;
        min-height: 420px;
        font-family: 'Inter', sans-serif;
        font-size: 14px;
    }

    /* Action buttons */
    .action-row {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 20px;
    }
    .btn-submit {
        background: #ff4757;
        color: var(--white);
        border: none;
        padding: 12px 24px;
        border-radius: 12px;
        font-size: 13px;
        font-weight: 700;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 10px 20px rgba(255, 71, 87, 0.2);
        transition: all 0.3s;
    }
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 24px rgba(255, 71, 87, 0.3);
    }
    .btn-submit:active {
        transform: translateY(0);
    }
    .btn-submit:disabled {
        background: var(--unity-gray);
        box-shadow: none;
        cursor: not-allowed;
        transform: none;
    }

    .view-mode-tabs {
        display: flex;
        background: var(--unity-bg);
        padding: 4px;
        border-radius: 10px;
        gap: 4px;
        align-self: center;
    }
    .view-mode-btn {
        border: none;
        background: none;
        padding: 6px 14px;
        font-size: 12px;
        font-weight: 700;
        color: var(--unity-gray);
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
    }
    .view-mode-btn.active {
        background: var(--white);
        color: var(--unity-primary);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* Schedules sidebar styling */
    .schedule-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .schedule-item {
        background: var(--unity-bg);
        border-radius: 12px;
        padding: 12px 14px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .schedule-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }
    .schedule-name {
        font-size: 12px;
        font-weight: 800;
        color: var(--unity-black);
    }
    .schedule-time {
        font-size: 11px;
        color: var(--unity-gray);
        font-weight: 600;
    }
    .schedule-badge {
        font-size: 8px;
        font-weight: 800;
        padding: 4px 8px;
        border-radius: 8px;
        text-transform: uppercase;
    }
    .schedule-badge.pending { background: rgba(255, 159, 67, 0.1); color: #ff9f43; }
    .schedule-badge.draft { background: rgba(128, 129, 145, 0.1); color: var(--unity-gray); }
    .schedule-badge.auto { background: rgba(46, 213, 115, 0.1); color: #2ed573; }
    .schedule-badge.scheduled { background: rgba(63, 140, 255, 0.1); color: var(--unity-blue); }

    .btn-dashed-add {
        width: 100%;
        background: none;
        border: 1px dashed var(--border-color);
        border-radius: 12px;
        padding: 10px;
        font-size: 12px;
        font-weight: 700;
        color: var(--unity-gray);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        transition: all 0.2s;
        margin-top: 6px;
    }
    .btn-dashed-add:hover {
        border-color: var(--unity-primary);
        color: var(--unity-primary);
        background: rgba(108, 93, 211, 0.02);
    }

    /* Spinner Animation */
    .spinner {
        animation: spin 1s linear infinite;
        font-size: 14px;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    /* Toast Notification */
    #toast-container {
        position: fixed;
        top: 24px;
        right: 24px;
        z-index: 9999;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .toast {
        background: var(--white);
        color: var(--unity-black);
        border-radius: 16px;
        padding: 16px 20px;
        box-shadow: 0 20px 40px rgba(17, 20, 45, 0.08);
        border-left: 5px solid var(--unity-primary);
        display: flex;
        align-items: center;
        gap: 14px;
        min-width: 320px;
        transform: translateX(120%);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    .toast.show {
        transform: translateX(0);
    }
    .toast-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
    }
    .toast-success { border-left-color: #2ed573; }
    .toast-success .toast-icon { background: rgba(46, 213, 115, 0.1); color: #2ed573; }
    .toast-error { border-left-color: #ff4757; }
    .toast-error .toast-icon { background: rgba(255, 71, 87, 0.1); color: #ff4757; }
    .toast-body {
        font-size: 13px;
        font-weight: 600;
        line-height: 1.4;
    }
    
    @keyframes modalZoom {
        from { transform: scale(0.95); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }
    .modal-overlay {
        animation: modalFadeIn 0.2s ease forwards;
    }
    @keyframes modalFadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
</style>

<div class="news-header">
    <h2>Bản tin & Đăng ký (Newsletter)</h2>
    <p>Quản lý danh sách khách hàng đã đăng ký nhận bản tin khuyến mãi và tin tức mới nhất từ H&M Sport.</p>
</div>

<!-- Tabs Trigger Navigation -->
<div class="newsletter-tabs">
    <button class="tab-trigger active" onclick="switchTab('subscribers')">
        <i class="fa-solid fa-users"></i>
        Danh sách đăng ký
    </button>
    <button class="tab-trigger" onclick="switchTab('compose')">
        <i class="fa-solid fa-pen-to-square"></i>
        Soạn & Gửi bản tin
    </button>
</div>

<!-- Tab 1: Subscribers list -->
<div id="subscribers-tab" class="tab-panel active">
    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-pill">Tổng số đăng ký: <span id="totalCount">${newsletters.size()}</span></div>
        <div class="stat-pill">Đang hoạt động: <span id="activeCount">0</span></div>
        <div class="stat-pill">Ngừng hoạt động: <span id="inactiveCount">0</span></div>
    </div>

    <div class="u-card">
        <div class="filter-section">
            <!-- Live search -->
            <div class="search-wrapper">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="emailFilter" class="search-input" placeholder="Tìm email khách hàng...">
            </div>
            
            <!-- Status Filters (tabs) -->
            <div class="pill-filters">
                <button class="pill-btn active" onclick="filterStatus('all')">Tất cả</button>
                <button class="pill-btn" onclick="filterStatus('active')">Đang hoạt động</button>
                <button class="pill-btn" onclick="filterStatus('inactive')">Ngừng nhận tin</button>
            </div>
        </div>

        <table class="u-table">
            <thead>
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th>Địa chỉ Email</th>
                    <th style="width: 200px;">Trạng thái</th>
                    <th style="width: 220px;">Ngày đăng ký</th>
                    <th style="text-align: right; width: 150px;">Thao tác</th>
                </tr>
            </thead>
            <tbody id="newsletterTableBody">
                <c:forEach var="n" items="${newsletters}">
                    <tr data-status="${n.isActive() ? 'active' : 'inactive'}" class="subscriber-row">
                        <td style="font-weight: 700; color: var(--unity-gray);">#${n.id}</td>
                        <td>
                            <div style="font-weight: 700; color: var(--unity-black); display: flex; align-items: center; gap: 8px;">
                                <i class="fa-regular fa-envelope" style="color: var(--unity-gray); font-size: 13px;"></i>
                                ${n.email}
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${n.isActive()}">
                                    <span class="status-badge active-badge">
                                        <i class="fa-solid fa-circle-check" style="font-size: 9px;"></i>
                                        Hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge inactive-badge">
                                        <i class="fa-solid fa-circle-xmark" style="font-size: 9px;"></i>
                                        Ngừng nhận
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="color: var(--unity-gray); font-weight: 600; font-size: 13px;">
                            ${n.subscribedAt.toString().replace('T', ' ')}
                        </td>
                        <td>
                            <div class="btn-actions">
                                <!-- Toggle Active/Inactive Status -->
                                <form action="${pageContext.request.contextPath}/admin/newsletter" method="post" style="display:inline;">
                                    <input type="hidden" name="toggleId" value="${n.id}">
                                    <button type="submit" class="btn-icon btn-toggle-active" title="Thay đổi trạng thái hoạt động">
                                        <c:choose>
                                            <c:when test="${n.isActive()}">
                                                <i class="fa-solid fa-ban" style="color: #ff9f43;" title="Vô hiệu hóa"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-unlock-keyhole" style="color: #2ed573;" title="Kích hoạt lại"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                                
                                <!-- Delete subscriber -->
                                <form action="${pageContext.request.contextPath}/admin/newsletter" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa vĩnh viễn email này khỏi danh sách nhận tin?')" style="display:inline;">
                                    <input type="hidden" name="deleteId" value="${n.id}">
                                    <button type="submit" class="btn-icon btn-delete" title="Xóa vĩnh viễn">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty newsletters}">
                    <tr><td colspan="5" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có khách hàng nào đăng ký nhận bản tin</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- Tab 2: Compose & Send Newsletter -->
<div id="compose-tab" class="tab-panel">
    <div class="compose-grid">
        
        <!-- Column 1: Configuration & Selector -->
        <div class="u-card">
            <!-- Choose template -->
            <h3 class="panel-section-title"><i class="fa-solid fa-wand-magic-sparkles"></i> Chọn mẫu bản tin</h3>
            
            <div id="template-card-promo" class="tpl-option-card active" onclick="loadTemplate('promo')">
                <div class="tpl-option-header">
                    <span class="tpl-option-name">Siêu Ưu Đãi / Khuyến Mãi</span>
                    <span class="tpl-badge hot">HOT</span>
                </div>
                <p class="tpl-option-desc">Thiết kế màu sắc nổi bật, đính kèm mã giảm giá để kích thích mua sắm.</p>
            </div>

            <div id="template-card-arrivals" class="tpl-option-card" onclick="loadTemplate('arrivals')">
                <div class="tpl-option-header">
                    <span class="tpl-option-name">Sản Phẩm Mới Về</span>
                    <span class="tpl-badge new">NEW</span>
                </div>
                <p class="tpl-option-desc">Bố cục lưới giới thiệu hình ảnh các dòng giày thể thao hot nhất.</p>
            </div>

            <div id="template-card-welcome" class="tpl-option-card" onclick="loadTemplate('welcome')">
                <div class="tpl-option-header">
                    <span class="tpl-option-name">Chào Mừng / Cảm Ơn</span>
                    <span class="tpl-badge warm">WARM</span>
                </div>
                <p class="tpl-option-desc">Thư chào mừng thân thiện khi khách hàng đăng ký theo dõi.</p>
            </div>

            <!-- Dynamic Product Selection Panel -->
            <div id="product-selection-panel" style="margin-top: 24px; border-top: 1px solid var(--border-color); padding-top: 20px;">
                <h3 class="panel-section-title" style="font-size: 13px; font-weight: 800; color: var(--unity-black); margin: 0 0 12px; display: flex; align-items: center; gap: 8px; text-transform: uppercase;"><i class="fa-solid fa-square-check" style="color: var(--unity-primary);"></i> Chọn sản phẩm</h3>
                <p style="font-size: 11px; color: var(--unity-gray); font-weight: 600; margin: 0 0 12px;" id="product-select-limit-info">Chọn tối đa 3 sản phẩm</p>
                <span style="font-size: 10px; color: var(--unity-gray); display: block; margin-top: -8px; margin-bottom: 12px; font-style: italic;">* Lưu ý: Chọn sản phẩm sẽ đặt lại nội dung soạn thảo.</span>
                
                <!-- Search input for products -->
                <div style="position: relative; margin-bottom: 12px;">
                    <input type="text" id="tplProductSearch" oninput="filterTemplateProducts(this.value)" placeholder="Tìm kiếm sản phẩm..." style="width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 12px; outline: none; background: var(--unity-bg); box-sizing: border-box; font-weight: 600;">
                </div>

                <!-- Product checklist -->
                <div style="max-height: 200px; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; padding-right: 4px;" id="tplProductsChecklist">
                    <!-- Javascript will render options here -->
                </div>
            </div>

            <!-- Recipient Information (Simplified as requested) -->
            <div style="margin-top: 24px; padding: 16px; background: rgba(108, 93, 211, 0.04); border-radius: 14px; border: 1px solid rgba(108, 93, 211, 0.1);">
                <span style="font-size: 11px; font-weight: 700; color: var(--unity-primary); text-transform: uppercase; display: block; margin-bottom: 6px;">Gửi đến người nhận</span>
                <div style="font-size: 13px; font-weight: 800; color: var(--unity-black); display: flex; align-items: center; gap: 8px;">
                    <i class="fa-regular fa-envelope" style="color: var(--unity-primary);"></i>
                    Tất cả thành viên đăng ký
                </div>
                <div style="font-size: 11px; color: var(--unity-gray); margin-top: 4px; font-weight: 600;">
                    Số lượng: ${newsletters.size()} địa chỉ email
                </div>
            </div>
        </div>

        <!-- Column 2: Live Embedded Preview or Rich-text Editor (Switchable) -->
        <div class="u-card" style="padding: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 14px;">
                <h3 style="font-size: 13px; font-weight: 800; color: var(--unity-black); margin: 0; text-transform: uppercase;">
                    XEM TRƯỚC MẪU EMAIL <span class="tpl-badge hot" style="margin-left: 6px;">HOT</span>
                </h3>
                
                <!-- View Mode: Preview Frame vs Editor Container -->
                <div class="view-mode-tabs">
                    <button type="button" id="btn-mode-preview" class="view-mode-btn active" onclick="setViewMode('preview')">
                        <i class="fa-solid fa-eye"></i> Xem trước
                    </button>
                    <button type="button" id="btn-mode-edit" class="view-mode-btn" onclick="setViewMode('edit')">
                        <i class="fa-solid fa-pen"></i> Sửa nội dung
                    </button>
                </div>
            </div>

            <form id="newsletterComposeForm" onsubmit="handleSendNews(event)">
                <input type="hidden" name="sendNews" value="true">
                <input type="hidden" name="ajax" value="true">
                <input type="hidden" id="newsletterContentHidden" name="content">

                <!-- Subject field input -->
                <div style="padding: 12px 14px; margin-bottom: 14px; border: 1px solid var(--border-color); border-radius: 12px; display: flex; align-items: center; background: var(--unity-bg);">
                    <span style="font-size: 12px; font-weight: 800; color: var(--unity-black); width: 80px; text-transform: uppercase;">Tiêu đề:</span>
                    <input type="text" id="newsletterSubject" name="subject" class="input-text" placeholder="Nhập tiêu đề email..." required autocomplete="off" style="padding: 4px 0; background: none; border-radius: 0; font-size: 13px; font-weight: 600; width: 100%; border: none;">
                </div>

                <!-- 1. LIVE EMBEDDED PREVIEW (Default, styled like device frames) -->
                <div id="preview-frame-wrapper">
                    <div style="display: flex; justify-content: center; gap: 8px; margin-bottom: 12px;">
                        <button type="button" id="btnDeviceDesktop" class="pill-btn active" onclick="setPreviewDevice('desktop')" style="padding: 6px 14px; font-size: 11px;">
                            <i class="fa-solid fa-desktop"></i> Desktop
                        </button>
                        <button type="button" id="btnDeviceMobile" class="pill-btn" onclick="setPreviewDevice('mobile')" style="padding: 6px 14px; font-size: 11px;">
                            <i class="fa-solid fa-mobile-screen"></i> Mobile
                        </button>
                    </div>

                    <div id="preview-device-wrapper" class="preview-device-wrapper desktop">
                        <div class="desktop-header">
                            <span class="mac-dot red"></span>
                            <span class="mac-dot yellow"></span>
                            <span class="mac-dot green"></span>
                        </div>
                        <iframe id="livePreviewIframe"></iframe>
                    </div>
                </div>

                <!-- 2. EDITING WORKSPACE CONTAINER (Hidden by default) -->
                <div id="editor-wrapper-container" style="display: none;">
                    <div class="email-client-frame">
                        <div class="email-client-header">
                            <div class="email-client-dots">
                                <span class="mac-dot red"></span>
                                <span class="mac-dot yellow"></span>
                                <span class="mac-dot green"></span>
                            </div>
                        </div>
                        <div class="email-client-info">
                            <div class="email-client-row">
                                <span class="email-client-label">Tới:</span>
                                <span class="email-client-val">Danh sách email đăng ký (${newsletters.size()} người nhận)</span>
                            </div>
                            <div class="email-client-row">
                                <span class="email-client-label">Từ:</span>
                                <span class="email-client-val">newsletter@hm-sport.vn - Ban quản trị H&M Sport</span>
                            </div>
                        </div>
                        <div style="padding: 12px 14px; background: var(--unity-bg); border-bottom: 1px solid var(--border-color); font-size: 11px; font-weight: 700; color: var(--unity-gray); text-transform: uppercase;">
                            <i class="fa-solid fa-code"></i> Mã nguồn HTML của bản tin (Tự động đồng bộ với bản xem trước)
                        </div>
                        <div class="quill-editor-container" style="padding: 0;">
                            <textarea id="rawHtmlEditor" style="font-family: monospace; font-size: 13px; min-height: 480px; line-height: 1.5; resize: vertical; display: block; border: none; width: 100%; box-sizing: border-box; background: var(--white); color: var(--unity-black); padding: 18px; outline: none;" placeholder="Nhập hoặc chỉnh sửa mã HTML tại đây..." oninput="handleRawHtmlInput()"></textarea>
                        </div>
                    </div>
                </div>

                <div class="action-row">
                    <button type="submit" id="submitNewsBtn" class="btn-submit">
                        <i class="fa-regular fa-paper-plane" id="btnIcon"></i>
                        Gửi bản tin ngay →
                    </button>
                </div>
            </form>
        </div>

        <!-- Column 3: Scheduled Campaigns -->
        <div class="u-card" style="padding: 24px;">
            <h3 class="panel-section-title"><i class="fa-regular fa-calendar-check"></i> Chiến dịch đã lên lịch</h3>
            <div class="schedule-list">
                <c:forEach var="s" items="${schedules}">
                    <div class="schedule-item" data-id="${s.id}">
                        <div class="schedule-info">
                            <span class="schedule-name" style="font-size: 12px; font-weight: 800; color: var(--unity-black);">${s.name}</span>
                            <span class="schedule-time" style="font-size: 11px; color: var(--unity-gray); font-weight: 600;">${s.scheduledAt}</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span class="schedule-badge ${s.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${s.status eq 'PENDING'}">Chờ gửi</c:when>
                                    <c:when test="${s.status eq 'DRAFT'}">Bản nháp</c:when>
                                    <c:when test="${s.status eq 'AUTO'}">Tự động</c:when>
                                    <c:when test="${s.status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                                    <c:otherwise>${s.status}</c:otherwise>
                                </c:choose>
                            </span>
                            <button type="button" class="btn-icon" onclick="openEditScheduleModal(${s.id}, '${s.name.replace('\'', '\\\'')}', '${s.scheduledAt.replace('\'', '\\\'')}', '${s.status}')" style="width: 24px; height: 24px; font-size: 10px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center;" title="Sửa">
                                <i class="fa-solid fa-pen"></i>
                            </button>
                            <button type="button" class="btn-icon btn-delete" onclick="deleteSchedule(${s.id})" style="width: 24px; height: 24px; font-size: 10px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center;" title="Xóa">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty schedules}">
                    <div style="text-align: center; font-size: 12px; color: var(--unity-gray); font-style: italic; padding: 12px 0;">Chưa có lịch chiến dịch nào</div>
                </c:if>
            </div>
            <button type="button" class="btn-dashed-add" onclick="openAddScheduleModal()">
                <i class="fa-solid fa-plus"></i> Thêm lịch mới
            </button>
        </div>

    </div>
</div>

<!-- Beautiful glassmorphism Modal for Adding/Editing Schedule -->
<div id="scheduleModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(17, 20, 45, 0.6); backdrop-filter: blur(8px); z-index: 10000; align-items: center; justify-content: center;">
    <div class="modal-content u-card" style="width: 480px; padding: 32px; border: 1px solid rgba(255,255,255,0.25); box-shadow: 0 25px 50px rgba(0,0,0,0.15); animation: modalZoom 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; border-bottom: 1px solid var(--border-color); padding-bottom: 12px;">
            <h3 id="modalTitle" style="margin: 0; font-size: 15px; font-weight: 800; color: var(--unity-black); text-transform: uppercase;">Thêm Lịch Chiến Dịch</h3>
            <button type="button" class="btn-icon" onclick="closeScheduleModal()" style="background: none; border: none; font-size: 16px; color: var(--unity-gray); cursor: pointer;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form id="scheduleForm" action="${pageContext.request.contextPath}/admin/newsletter" method="post">
            <input type="hidden" name="scheduleAction" value="save">
            <input type="hidden" id="modalScheduleId" name="scheduleId" value="0">
            
            <div class="form-group">
                <label class="form-label">Tên Chiến Dịch / Lịch</label>
                <input type="text" id="modalScheduleName" name="scheduleName" class="input-text" placeholder="Ví dụ: Flash Sale Tháng 6" required autocomplete="off">
            </div>
            
            <div class="form-group">
                <label class="form-label">Thời Gian Gửi (Hàng ngày hoặc Ngày cụ thể)</label>
                <input type="text" id="modalScheduleTime" name="scheduleTime" class="input-text" placeholder="Ví dụ: 15/06 - 09:00 SA hoặc Hàng ngày - 10:00 SA" required autocomplete="off">
            </div>
            
            <div class="form-group">
                <label class="form-label">Trạng Thái</label>
                <select id="modalScheduleStatus" name="scheduleStatus" class="input-text" style="background-image: none; cursor: pointer; background: var(--unity-bg); border-radius: 12px; border: 1px solid transparent; width: 100%; padding: 12px 14px; font-size: 13px; color: var(--unity-black);">
                    <option value="PENDING">Chờ gửi (Pending)</option>
                    <option value="DRAFT">Bản nháp (Draft)</option>
                    <option value="AUTO">Tự động (Auto)</option>
                    <option value="SCHEDULED">Đã lên lịch (Scheduled)</option>
                </select>
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 28px;">
                <button type="button" class="pill-btn" onclick="closeScheduleModal()" style="background: var(--unity-bg); color: var(--unity-gray);">Hủy</button>
                <button type="submit" class="btn-submit" style="margin-top: 0; background: var(--unity-primary); box-shadow: 0 8px 16px rgba(108, 93, 211, 0.2); height: 42px; display: inline-flex; align-items: center; justify-content: center;">Lưu Thay Đổi</button>
            </div>
        </form>
    </div>
</div>

<!-- Floating Toast Container -->
<div id="toast-container"></div>

<script>
    function formatVND(value) {
        if (!value) return "";
        if (typeof value === 'string' && (value.includes('đ') || value.includes('₫') || value.includes('.'))) {
            return value;
        }
        const num = parseFloat(value);
        if (isNaN(num)) return value;
        return num.toLocaleString('vi-VN') + '₫';
    }

    // Real dynamic data injected from JSP / Database
    const realPromoProducts = [
        <c:forEach var="p" items="${promoProducts}" varStatus="status">
        {
            id: ${p.id},
            name: `${p.name.replace('`','\\`').replace('$','\\$')}`,
            price: "${p.price}",
            finalPrice: "${p.finalPrice}",
            <c:choose>
                <c:when test="${empty p.mainImageUrl}">
                    mainImageUrl: "",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('http')}">
                    mainImageUrl: "${p.mainImageUrl}",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('/')}">
                    mainImageUrl: "${pageContext.request.contextPath}${p.mainImageUrl}",
                </c:when>
                <c:otherwise>
                    mainImageUrl: "${pageContext.request.contextPath}/${p.mainImageUrl}",
                </c:otherwise>
            </c:choose>
            discountValue: "${p.discountValue}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    const realNewProducts = [
        <c:forEach var="p" items="${newProducts}" varStatus="status">
        {
            id: ${p.id},
            name: `${p.name.replace('`','\\`').replace('$','\\$')}`,
            price: "${p.price}",
            finalPrice: "${p.finalPrice}",
            <c:choose>
                <c:when test="${empty p.mainImageUrl}">
                    mainImageUrl: "",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('http')}">
                    mainImageUrl: "${p.mainImageUrl}",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('/')}">
                    mainImageUrl: "${pageContext.request.contextPath}${p.mainImageUrl}",
                </c:when>
                <c:otherwise>
                    mainImageUrl: "${pageContext.request.contextPath}/${p.mainImageUrl}",
                </c:otherwise>
            </c:choose>
            discountValue: "${p.discountValue}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    const realCoupons = [
        <c:forEach var="c" items="${activeCoupons}" varStatus="status">
        {
            id: ${c.id},
            code: "${c.code}",
            discountType: "${c.discountType}",
            discountValue: ${c.discountValue != null ? c.discountValue : 0},
            minOrderValue: ${c.minOrderValue != null ? c.minOrderValue : 0},
            maxDiscountAmount: ${c.maxDiscountAmount != null ? c.maxDiscountAmount : 0},
            endDateStr: "${c.getEndDateStr()}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    const allActiveProducts = [
        <c:forEach var="p" items="${allActiveProducts}" varStatus="status">
        {
            id: ${p.id},
            name: `${p.name.replace('`','\\`').replace('$','\\$')}`,
            price: "${p.price}",
            finalPrice: "${p.finalPrice}",
            <c:choose>
                <c:when test="${empty p.mainImageUrl}">
                    mainImageUrl: "",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('http')}">
                    mainImageUrl: "${p.mainImageUrl}",
                </c:when>
                <c:when test="${p.mainImageUrl.startsWith('/')}">
                    mainImageUrl: "${pageContext.request.contextPath}${p.mainImageUrl}",
                </c:when>
                <c:otherwise>
                    mainImageUrl: "${pageContext.request.contextPath}/${p.mainImageUrl}",
                </c:otherwise>
            </c:choose>
            discountValue: "${p.discountValue}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    let selectedPromoProductIds = realPromoProducts.map(p => p.id);
    let selectedNewProductIds = realNewProducts.map(p => p.id);
    let currentTemplateKey = 'promo';

    function renderProductChecklist() {
        const container = document.getElementById('tplProductsChecklist');
        const limitInfo = document.getElementById('product-select-limit-info');
        const searchInput = document.getElementById('tplProductSearch');
        const selectionPanel = document.getElementById('product-selection-panel');

        if (!container || !limitInfo || !searchInput || !selectionPanel) return;

        if (currentTemplateKey === 'welcome') {
            selectionPanel.style.display = 'none';
            return;
        } else {
            selectionPanel.style.display = 'block';
        }

        const limit = currentTemplateKey === 'promo' ? 3 : 4;
        const selectedIds = currentTemplateKey === 'promo' ? selectedPromoProductIds : selectedNewProductIds;
        limitInfo.innerText = `Chọn tối đa \${limit} sản phẩm (Đã chọn: \${selectedIds.length}/\${limit})`;

        const keyword = searchInput.value.toLowerCase().trim();

        let html = '';
        allActiveProducts.forEach(p => {
            if (keyword && !p.name.toLowerCase().includes(keyword)) {
                return;
            }
            const isChecked = selectedIds.includes(p.id) ? 'checked' : '';
            
            html += `
                <label style="display: flex; align-items: center; gap: 10px; padding: 8px 12px; background: var(--unity-bg); border-radius: 10px; cursor: pointer; transition: background 0.2s; border: 1px solid rgba(0,0,0,0.02); width: 100%; box-sizing: border-box;" class="tpl-prod-item">
                    <input type="checkbox" value="\${p.id}" \${isChecked} onchange="handleProductSelect(this, \${p.id})" style="width: 16px; height: 16px; accent-color: var(--unity-primary); cursor: pointer;">
                    <div style="display: flex; align-items: center; gap: 8px; flex: 1; min-width: 0;">
                        <img src="\${p.mainImageUrl}" style="width: 28px; height: 28px; object-fit: contain; border-radius: 4px; background: white; border: 1px solid #eee;" onerror="this.src='https://placehold.co/40/40?text=Shoe'">
                        <span style="font-size: 12px; font-weight: 700; color: var(--unity-black); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1;" title="\${p.name}">\${p.name}</span>
                    </div>
                </label>
            `;
        });

        if (html === '') {
            html = `<div style="text-align: center; color: var(--unity-gray); font-style: italic; font-size: 11px; padding: 12px;">Không tìm thấy sản phẩm</div>`;
        }
        container.innerHTML = html;
    }

    function handleProductSelect(checkbox, id) {
        const limit = currentTemplateKey === 'promo' ? 3 : 4;
        let selectedIds = currentTemplateKey === 'promo' ? selectedPromoProductIds : selectedNewProductIds;

        if (checkbox.checked) {
            if (selectedIds.length >= limit) {
                checkbox.checked = false;
                showToast(`Bạn chỉ được chọn tối đa \${limit} sản phẩm cho mẫu này!`, "error");
                return;
            }
            if (!selectedIds.includes(id)) {
                selectedIds.push(id);
            }
        } else {
            const index = selectedIds.indexOf(id);
            if (index > -1) {
                selectedIds.splice(index, 1);
            }
        }

        if (currentTemplateKey === 'promo') {
            selectedPromoProductIds = selectedIds;
        } else {
            selectedNewProductIds = selectedIds;
        }

        // Regenerate and update editor
        document.getElementById('rawHtmlEditor').value = templates[currentTemplateKey];
        document.getElementById('newsletterContentHidden').value = templates[currentTemplateKey];
        updatePreviewIframe();
        
        // Update label count
        const limitInfo = document.getElementById('product-select-limit-info');
        limitInfo.innerText = `Chọn tối đa \${limit} sản phẩm (Đã chọn: \${selectedIds.length}/\${limit})`;
    }

    function filterTemplateProducts(val) {
        renderProductChecklist();
    }

    // Interactive Calendar Scheduling functions
    function openAddScheduleModal() {
        document.getElementById('modalTitle').innerText = 'Thêm Lịch Chiến Dịch';
        document.getElementById('modalScheduleId').value = '0';
        document.getElementById('modalScheduleName').value = '';
        document.getElementById('modalScheduleTime').value = '';
        document.getElementById('modalScheduleStatus').value = 'PENDING';
        
        document.getElementById('scheduleModal').style.display = 'flex';
    }

    function openEditScheduleModal(id, name, time, status) {
        document.getElementById('modalTitle').innerText = 'Chỉnh Sửa Lịch Chiến Dịch';
        document.getElementById('modalScheduleId').value = id;
        document.getElementById('modalScheduleName').value = name;
        document.getElementById('modalScheduleTime').value = time;
        document.getElementById('modalScheduleStatus').value = status;
        
        document.getElementById('scheduleModal').style.display = 'flex';
    }

    function closeScheduleModal() {
        document.getElementById('scheduleModal').style.display = 'none';
    }

    function deleteSchedule(id) {
        if (confirm('Bạn có chắc chắn muốn xóa lịch chiến dịch này khỏi hệ thống?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/newsletter';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'scheduleAction';
            actionInput.value = 'delete';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'scheduleId';
            idInput.value = id;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Dynamic Email Template HTML Generators
    function getPromoTemplateHtml() {
        const shopUrl = window.location.origin + '${pageContext.request.contextPath}';
        
        // Determine products to show
        let displayProducts = [];
        if (selectedPromoProductIds && selectedPromoProductIds.length > 0) {
            displayProducts = selectedPromoProductIds.map(id => allActiveProducts.find(p => p.id === id)).filter(Boolean);
        } else if (realPromoProducts && realPromoProducts.length > 0) {
            displayProducts = realPromoProducts.slice(0, 3);
        } else {
            // Fallback mock products if database has no promo products
            displayProducts = [
                { name: "Air Runner X1", price: "1.700.000đ", finalPrice: "890.000đ", mainImageUrl: "", isFallback: true, emoji: "👟" },
                { name: "Sport Elite", price: "2.100.000đ", finalPrice: "1.190.000đ", mainImageUrl: "", isFallback: true, emoji: "🏃‍♂️" },
                { name: "Urban Flex", price: "1.400.000đ", finalPrice: "740.000đ", mainImageUrl: "", isFallback: true, emoji: "🚶" }
            ];
        }

        // Determine coupon to show
        let couponCode = "SPORT50";
        let couponDesc = "Nhận thêm ưu đãi đặc biệt";
        let couponExpiry = "Hết hạn: 30/06/2026";
        if (realCoupons && realCoupons.length > 0) {
            const c = realCoupons[0];
            couponCode = c.code;
            if (c.discountType === 'PERCENTAGE') {
                couponDesc = `Giảm giá \${c.discountValue}% cho mọi đơn hàng!`;
            } else {
                // Format currency
                const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
                couponDesc = `Giảm giá \${formatter.format(c.discountValue)} cho mọi đơn hàng!`;
            }
            if (c.endDateStr) {
                const dateParts = c.endDateStr.split('T');
                const date = dateParts[0].split('-').reverse().join('/');
                const time = dateParts[1] ? dateParts[1] : '';
                couponExpiry = `Hết hạn: \${date} \${time}`;
            } else {
                couponExpiry = "Ưu đãi có hạn!";
            }
        }

        let productsHtml = '';
        displayProducts.forEach(p => {
            let imgTag = `<div style="font-size: 36px; height: 80px; line-height: 80px; text-align: center; margin-bottom: 8px;">👟</div>`;
            if (p.mainImageUrl && !p.isFallback) {
                imgTag = `<div style="height: 80px; line-height: 80px; text-align: center; margin-bottom: 8px;"><img src="\${p.mainImageUrl}" style="max-height: 80px; max-width: 90px; vertical-align: middle;" alt="\${p.name}"></div>`;
            } else if (p.emoji) {
                imgTag = `<div style="font-size: 36px; height: 80px; line-height: 80px; text-align: center; margin-bottom: 8px;">\${p.emoji}</div>`;
            }

            // Format prices
            const formattedPrice = formatVND(p.price);
            const formattedFinalPrice = formatVND(p.finalPrice);
            let origPriceHtml = '';
            if (p.price && p.price !== p.finalPrice) {
                origPriceHtml = `<span style="font-size: 11px; color: #808191; text-decoration: line-through; margin-left: 4px;">\${formattedPrice}</span>`;
            }

            productsHtml += `
                <td style="width: 33%; padding: 4px; vertical-align: top;">
                    <a href="\${shopUrl}/product?id=\${p.id}" style="display: block; text-decoration: none; background: #fcfbfa; border: 1px solid #f1f0ee; border-radius: 12px; padding: 12px; text-align: center; min-height: 150px; box-sizing: border-box; color: #11142D;">
                        \${imgTag}
                        <div style="font-size: 12px; font-weight: 700; color: #11142D; margin-top: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="\${p.name}">\${p.name}</div>
                        <div style="margin-top: 6px;">
                            <span style="font-size: 13px; font-weight: 800; color: #ff4757; display: inline-block;">\${formattedFinalPrice}</span>
                            \${origPriceHtml}
                        </div>
                    </a>
                </td>
            `;
        });

        return `
<div style="max-width: 600px; margin: 0 auto; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; border: 1px solid #e4e4e4; border-radius: 16px; overflow: hidden; background: #ffffff;">
    <div style="background: #ff4757; padding: 30px 20px; text-align: center; color: white;">
        <div style="font-size: 20px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">H&M. SPORT</div>
        <div style="font-size: 11px; letter-spacing: 1px; opacity: 0.8; margin-top: 4px;">Official Newsletter</div>
    </div>
    <div style="padding: 30px; text-align: center;">
        <span style="background: #ffe0e6; color: #ff4757; padding: 6px 14px; border-radius: 20px; font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; display: inline-block;">✦ FLASH SALE - 48 GIỜ ✦</span>
        <h1 style="color: #11142D; font-size: 32px; font-weight: 800; margin: 20px 0 10px;">GIẢM ĐẾN 50%</h1>
        <p style="color: #808191; font-size: 15px; margin: 0 0 24px;">Cho toàn bộ dòng giày thể thao hot nhất trong tháng</p>
        
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 24px; text-align: center; table-layout: fixed;">
            <tr>
                \${productsHtml}
            </tr>
        </table>
        
        <div style="border: 2px dashed #ff4757; border-radius: 12px; padding: 16px; background: #fffcfc; margin: 0 auto 24px; max-width: 400px; box-sizing: border-box;">
            <div style="font-size: 12px; color: #808191; text-transform: uppercase; letter-spacing: 1px;">\${couponDesc}</div>
            <div style="font-size: 24px; font-weight: 800; color: #ff4757; margin: 8px 0; letter-spacing: 2px;">\${couponCode}</div>
            <div style="font-size: 11px; color: #808191;">\${couponExpiry}</div>
        </div>
        
        <a href="\${shopUrl}" style="background: #ff4757; color: white; padding: 14px 28px; text-decoration: none; border-radius: 30px; font-weight: bold; display: inline-block; box-shadow: 0 8px 20px rgba(255, 71, 87, 0.25);">MUA NGAY →</a>
    </div>
    <div style="background: #F4F4F4; padding: 20px; text-align: center; color: #808191; font-size: 12px; border-top: 1px solid #e4e4e4;">
        <p style="margin: 0;">© 2026 H&M Sport Vietnam - Hãy đăng ký nhận tin của chúng tôi để không bỏ lỡ các ưu đãi.</p>
    </div>
</div>
        `.trim();
    }

    function getArrivalsTemplateHtml() {
        const shopUrl = window.location.origin + '${pageContext.request.contextPath}';
        
        // Determine new products to show
        let displayProducts = [];
        if (selectedNewProductIds && selectedNewProductIds.length > 0) {
            displayProducts = selectedNewProductIds.map(id => allActiveProducts.find(p => p.id === id)).filter(Boolean);
        } else if (realNewProducts && realNewProducts.length > 0) {
            displayProducts = realNewProducts.slice(0, 4);
        } else {
            // Fallback mock new products
            displayProducts = [
                { name: "CloudRun Pro", price: "2.500.000đ", finalPrice: "2.500.000đ", mainImageUrl: "", isFallback: true, emoji: "🏃‍♂️" },
                { name: "CourtKing V3", price: "1.950.000đ", finalPrice: "1.950.000đ", mainImageUrl: "", isFallback: true, emoji: "🏀" },
                { name: "TurfBlazer X", price: "1.800.000đ", finalPrice: "1.800.000đ", mainImageUrl: "", isFallback: true, emoji: "⚽" },
                { name: "ZenWalk Elite", price: "1.600.000đ", finalPrice: "1.600.000đ", mainImageUrl: "", isFallback: true, emoji: "🚶" }
            ];
        }

        let productsGridHtml = '';
        // Build a 2x2 grid
        for (let i = 0; i < displayProducts.length; i += 2) {
            productsGridHtml += '<tr>';
            for (let j = 0; j < 2; j++) {
                const idx = i + j;
                if (idx < displayProducts.length) {
                    const p = displayProducts[idx];
                    let imgTag = `<div style="font-size: 40px; height: 100px; line-height: 100px; text-align: center; margin-bottom: 8px;">👟</div>`;
                    if (p.mainImageUrl && !p.isFallback) {
                        imgTag = `<div style="height: 100px; line-height: 100px; text-align: center; margin-bottom: 8px;"><img src="\${p.mainImageUrl}" style="max-height: 100px; max-width: 120px; vertical-align: middle;" alt="\${p.name}"></div>`;
                    } else if (p.emoji) {
                        imgTag = `<div style="font-size: 40px; height: 100px; line-height: 100px; text-align: center; margin-bottom: 8px;">\${p.emoji}</div>`;
                    }

                    const formattedFinalPrice = formatVND(p.finalPrice);

                    productsGridHtml += `
                        <td style="width: 50%; padding: 8px; vertical-align: top;">
                            <a href="\${shopUrl}/product?id=\${p.id}" style="display: block; text-decoration: none; background: #F4F4F4; border-radius: 14px; padding: 20px; text-align: center; min-height: 190px; box-sizing: border-box; color: #11142D;">
                                \${imgTag}
                                <div style="font-size: 13px; font-weight: 800; color: #11142D; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 8px;" title="\${p.name}">\${p.name}</div>
                                <div style="font-size: 12px; color: #6C5DD3; font-weight: 700; margin-top: 6px;">\${formattedFinalPrice}</div>
                            </a>
                        </td>
                    `;
                } else {
                    productsGridHtml += '<td style="width: 50%;"></td>';
                }
            }
            productsGridHtml += '</tr>';
        }

        return `
<div style="max-width: 600px; margin: 0 auto; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; border: 1px solid #e4e4e4; border-radius: 16px; overflow: hidden; background: #ffffff;">
    <div style="background: #11142D; padding: 30px 20px; text-align: center; color: white;">
        <div style="font-size: 20px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">H&M. SPORT</div>
        <div style="font-size: 11px; letter-spacing: 1px; color: #808191; text-transform: uppercase; margin-top: 4px;">NEW ARRIVALS</div>
    </div>
    <div style="padding: 30px; text-align: center;">
        <h1 style="color: #11142D; font-size: 28px; font-weight: 800; margin: 10px 0;">BỘ SƯU TẬP MỚI 2026</h1>
        <p style="color: #808191; font-size: 16px; margin: 0 0 28px;">Vừa cập bến - Kiểu dáng đón đầu xu hướng thể thao năng động</p>
        
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 28px; table-layout: fixed;">
            \${productsGridHtml}
        </table>
        
        <a href="\${shopUrl}" style="background: #11142D; color: white; padding: 14px 28px; text-decoration: none; border-radius: 30px; font-weight: bold; display: inline-block; box-shadow: 0 8px 20px rgba(17, 20, 45, 0.25);">KHÁM PHÁ BỘ SƯU TẬP →</a>
    </div>
    <div style="background: #F4F4F4; padding: 20px; text-align: center; color: #808191; font-size: 12px; border-top: 1px solid #e4e4e4;">
        <p style="margin: 0;">© 2026 H&M Sport Vietnam - Hãy đăng ký nhận tin của chúng tôi để không bỏ lỡ các ưu đãi.</p>
    </div>
</div>
        `.trim();
    }

    function getWelcomeTemplateHtml() {
        const shopUrl = window.location.origin + '${pageContext.request.contextPath}';

        // Find first active coupon or use WELCOME10
        let couponCode = "WELCOME10";
        let couponVal = "10%";
        let couponDesc = "Giảm 10% cho đơn hàng đầu tiên";
        
        if (realCoupons && realCoupons.length > 0) {
            // Find one coupon or just use first one
            const c = realCoupons[0];
            couponCode = c.code;
            if (c.discountType === 'PERCENTAGE') {
                couponVal = `\${c.discountValue}%`;
                couponDesc = `Giảm ngay \${c.discountValue}% cho tất cả sản phẩm!`;
            } else {
                const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
                couponVal = formatter.format(c.discountValue);
                couponDesc = `Giảm ngay \${couponVal} cho đơn hàng tiếp theo!`;
            }
        }

        return `
<div style="max-width: 600px; margin: 0 auto; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; border: 1px solid #e4e4e4; border-radius: 16px; overflow: hidden; background: #ffffff;">
    <div style="background: #2ed573; padding: 30px 20px; text-align: center; color: white;">
        <div style="font-size: 32px; margin-bottom: 10px;">🎉</div>
        <h1 style="margin: 0; font-size: 24px; font-weight: 800;">Chào mừng bạn!</h1>
        <p style="margin: 4px 0 0; font-size: 16px; font-weight: 700;">đến với đại gia đình H&M Sport</p>
    </div>
    <div style="padding: 30px; text-align: center;">
        <p style="color: #11142D; font-size: 15px; line-height: 1.6; margin: 0 0 24px;">Cảm ơn bạn đã đăng ký nhận bản tin từ H&M Sport. Từ nay bạn sẽ luôn là người đầu tiên nhận được tin tức về các đợt phát hành giày thể thao độc quyền, tin khuyến mãi thành viên cực hot!</p>
        
        <div style="border: 2px dashed #2ed573; border-radius: 12px; padding: 16px; background: #f7fdf9; margin: 0 auto 24px; max-width: 400px; box-sizing: border-box;">
            <div style="font-size: 12px; color: #808191; text-transform: uppercase; letter-spacing: 1px;">🎁 QUÀ TẶNG THÀNH VIÊN MỚI</div>
            <div style="font-size: 24px; font-weight: 800; color: #2ed573; margin: 8px 0; letter-spacing: 2px;">\${couponCode}</div>
            <div style="font-size: 11px; color: #808191;">\${couponDesc}</div>
        </div>
        
        <div style="text-align: left; display: inline-block; margin-bottom: 28px; width: 100%; max-width: 380px;">
            <div style="margin-bottom: 10px; font-size: 14px; color: #11142D;"><span style="color: #2ed573; margin-right: 8px;">⚡</span> Nhận thông báo sớm nhất về các đợt giảm giá</div>
            <div style="margin-bottom: 10px; font-size: 14px; color: #11142D;"><span style="color: #2ed573; margin-right: 8px;">💖</span> Ưu đãi độc quyền chỉ dành riêng cho bạn</div>
            <div style="font-size: 14px; color: #11142D;"><span style="color: #2ed573; margin-right: 8px;">🚚</span> Miễn phí vận chuyển cho đơn hàng đầu tiên áp dụng mã thành viên</div>
        </div>
        
        <div>
            <a href="\${shopUrl}" style="background: #2ed573; color: white; padding: 14px 28px; text-decoration: none; border-radius: 30px; font-weight: bold; display: inline-block; box-shadow: 0 8px 20px rgba(46, 213, 115, 0.25);">MUA SẮM NGAY →</a>
        </div>
    </div>
    <div style="background: #F4F4F4; padding: 20px; text-align: center; color: #808191; font-size: 12px; border-top: 1px solid #e4e4e4;">
        <p style="margin: 0;">© 2026 H&M Sport Vietnam - Hãy đăng ký nhận tin của chúng tôi để không bỏ lỡ các ưu đãi.</p>
    </div>
</div>
        `.trim();
    }

    // Tab switching logic
    function switchTab(tabName) {
        // Toggle tab triggers
        const triggers = document.querySelectorAll('.tab-trigger');
        triggers.forEach(btn => {
            if (btn.innerText.includes('Danh sách') && tabName === 'subscribers') {
                btn.classList.add('active');
            } else if (btn.innerText.includes('Soạn') && tabName === 'compose') {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Toggle tab panels
        const panels = document.querySelectorAll('.tab-panel');
        panels.forEach(panel => {
            if (panel.id === tabName + '-tab') {
                panel.classList.add('active');
            } else {
                panel.classList.remove('active');
            }
        });
        
        // Sync preview when opening compose tab
        if (tabName === 'compose') {
            setTimeout(updatePreviewIframe, 50);
        }
    }

    // Preset HTML templates definition using dynamic ES6 getters linking to generator functions
    const templates = {
        get promo() { return getPromoTemplateHtml(); },
        get arrivals() { return getArrivalsTemplateHtml(); },
        get welcome() { return getWelcomeTemplateHtml(); }
    };

    // Mode trigger: Switch between Preview and Editor
    function setViewMode(mode) {
        const previewContainer = document.getElementById('preview-frame-wrapper');
        const editorContainer = document.getElementById('editor-wrapper-container');
        const btnPreview = document.getElementById('btn-mode-preview');
        const btnEdit = document.getElementById('btn-mode-edit');

        if (mode === 'preview') {
            updatePreviewIframe();
            
            previewContainer.style.display = 'block';
            editorContainer.style.display = 'none';
            btnPreview.classList.add('active');
            btnEdit.classList.remove('active');
        } else {
            // Sync from iframe preview back to Raw HTML editor
            const iframe = document.getElementById('livePreviewIframe');
            if (iframe && iframe.contentWindow && iframe.contentWindow.document && iframe.contentWindow.document.body) {
                document.getElementById('rawHtmlEditor').value = iframe.contentWindow.document.body.innerHTML;
            }
            
            previewContainer.style.display = 'none';
            editorContainer.style.display = 'block';
            btnEdit.classList.add('active');
            btnPreview.classList.remove('active');
        }
    }

    function handleRawHtmlInput() {
        const val = document.getElementById('rawHtmlEditor').value;
        document.getElementById('newsletterContentHidden').value = val;
    }

    // Dynamic Live Preview updates
    function updatePreviewIframe() {
        const content = document.getElementById('rawHtmlEditor').value;
        const iframe = document.getElementById('livePreviewIframe');
        if (iframe) {
            const doc = iframe.contentWindow.document;
            doc.open();
            doc.write(
                '<!DOCTYPE html>' +
                '<html>' +
                '<head>' +
                    '<meta charset="utf-8">' +
                    '<base href="' + window.location.origin + '${pageContext.request.contextPath}/">' +
                    '<style>' +
                        'body { margin: 10px; font-family: \'Inter\', sans-serif; background: #ffffff; overflow-x: hidden; }' +
                        'img { max-width: 100%; height: auto; }' +
                        '[contenteditable="true"] { outline: none; transition: all 0.2s; }' +
                        '[contenteditable="true"]:hover { outline: 1px dashed #6C5DD3; cursor: pointer; }' +
                        '[contenteditable="true"]:focus { outline: 2px solid #6C5DD3; background: rgba(108, 93, 211, 0.02); }' +
                    '</style>' +
                '</head>' +
                '<body>' +
                    content +
                '</body>' +
                '</html>'
            );
            doc.close();
            doc.body.contentEditable = "true";
            doc.body.addEventListener('input', function() {
                document.getElementById('rawHtmlEditor').value = doc.body.innerHTML;
                document.getElementById('newsletterContentHidden').value = doc.body.innerHTML;
            });
        }
    }

    function loadTemplate(key, silent) {
        currentTemplateKey = key;
        if (templates[key]) {
            document.getElementById('rawHtmlEditor').value = templates[key];
            document.getElementById('newsletterContentHidden').value = templates[key];
            if (!silent) {
                showToast("Đã tải mẫu thiết kế thành công!", "success");
            }

            // Highlight selection
            document.querySelectorAll('.tpl-option-card').forEach(card => card.classList.remove('active'));
            const selectedCard = document.getElementById('template-card-' + key);
            if (selectedCard) {
                selectedCard.classList.add('active');
            }

            // Set corresponding subject
            const subjectInput = document.getElementById('newsletterSubject');
            if (key === 'promo') {
                subjectInput.value = "[Khuyến Mãi] H&M Sport - Bùng nổ ưu đãi thành viên cực khủng!";
            } else if (key === 'arrivals') {
                subjectInput.value = "[Mới Về] Bộ sưu tập giày thể thao phiên bản giới hạn hot nhất!";
            } else if (key === 'welcome') {
                subjectInput.value = "Chào mừng bạn đến với cộng đồng H&M Sport!";
            }
            
            // Sync on template select
            updatePreviewIframe();

            // Render product checklist for current template
            renderProductChecklist();
        }
    }

    // Device Preview Frames Toggle
    function setPreviewDevice(device) {
        const wrapper = document.getElementById('preview-device-wrapper');
        const btnDesktop = document.getElementById('btnDeviceDesktop');
        const btnMobile = document.getElementById('btnDeviceMobile');
        
        if (device === 'desktop') {
            wrapper.className = "preview-device-wrapper desktop";
            btnDesktop.classList.add('active');
            btnMobile.classList.remove('active');
        } else {
            wrapper.className = "preview-device-wrapper mobile";
            btnMobile.classList.add('active');
            btnDesktop.classList.remove('active');
        }
    }

    // Ajax Form Submission Handler
    function handleSendNews(e) {
        e.preventDefault();
        
        const subject = document.getElementById('newsletterSubject').value.trim();
        
        let content = "";
        const iframe = document.getElementById('livePreviewIframe');
        if (iframe && iframe.contentWindow && iframe.contentWindow.document && iframe.contentWindow.document.body) {
            content = iframe.contentWindow.document.body.innerHTML.trim();
        } else {
            content = document.getElementById('rawHtmlEditor').value.trim();
        }
        
        if (!subject) {
            showToast("Vui lòng nhập tiêu đề email bản tin!", "error");
            return;
        }
        
        // Extract plain text to validate content length
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = content;
        const plainText = (tempDiv.textContent || tempDiv.innerText || "").replace(/\s+/g, ' ').trim();
        
        if (plainText.length === 0 && !content.includes("<img")) {
            showToast("Vui lòng nhập nội dung bản tin!", "error");
            return;
        }

        // Set hidden input value
        document.getElementById('newsletterContentHidden').value = content;
        
        const submitBtn = document.getElementById('submitNewsBtn');
        const btnIcon = document.getElementById('btnIcon');
        
        // UI states (Loading)
        submitBtn.disabled = true;
        btnIcon.className = "fa-solid fa-spinner spinner";
        submitBtn.innerHTML = '<i class="fa-solid fa-spinner spinner"></i> Đang gửi...';

        // Prepare Form Data
        const formData = new URLSearchParams(new FormData(document.getElementById('newsletterComposeForm')));

        fetch(window.location.origin + '${pageContext.request.contextPath}/admin/newsletter', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast(data.message, "success");
                // Clear form
                document.getElementById('newsletterSubject').value = '';
                document.getElementById('rawHtmlEditor').value = '';
                document.getElementById('newsletterContentHidden').value = '';
                updatePreviewIframe();
            } else {
                showToast("Gặp lỗi trong quá trình gửi bản tin!", "error");
            }
        })
        .catch(err => {
            console.error(err);
            showToast("Không thể kết nối đến máy chủ!", "error");
        })
        .finally(() => {
            // Restore UI states
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fa-regular fa-paper-plane" id="btnIcon"></i> Gửi bản tin ngay →';
        });
    }

    // Toast notifications helper
    function showToast(message, type) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        
        const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
        
        toast.innerHTML = 
            '<div class="toast-icon">' +
                '<i class="fa-solid ' + icon + '"></i>' +
            '</div>' +
            '<div class="toast-body">' +
                message +
            '</div>';
        
        container.appendChild(toast);
        
        // Trigger show animation
        setTimeout(function() { toast.classList.add('show'); }, 50);
        
        // Auto remove
        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() { toast.remove(); }, 300);
        }, 4000);
    }

    // Existing subscribers filtering scripts (enhanced)
    let currentStatusFilter = 'all';

    function calculateStats() {
        let rows = document.querySelectorAll('.subscriber-row');
        let active = 0;
        let inactive = 0;
        
        rows.forEach(row => {
            if (row.getAttribute('data-status') === 'active') {
                active++;
            } else {
                inactive++;
            }
        });
        
        document.getElementById('activeCount').innerText = active;
        document.getElementById('inactiveCount').innerText = inactive;
    }

    function filterStatus(status) {
        currentStatusFilter = status;
        
        // Update active tab button style
        let buttons = document.querySelectorAll('.pill-btn');
        buttons.forEach(btn => {
            let matches = false;
            if (status === 'all' && btn.innerText.includes('Tất cả')) matches = true;
            if (status === 'active' && btn.innerText.includes('Đang hoạt động')) matches = true;
            if (status === 'inactive' && btn.innerText.includes('Ngừng nhận tin')) matches = true;
            
            if (matches) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
        
        applyFilters();
    }

    function applyFilters() {
        let val = document.getElementById('emailFilter').value.toLowerCase().trim();
        let rows = document.querySelectorAll('.subscriber-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            let emailText = row.querySelector('td:nth-child(2)').innerText.toLowerCase();
            let rowStatus = row.getAttribute('data-status');
            
            let matchesSearch = emailText.includes(val);
            let matchesStatus = (currentStatusFilter === 'all') || (rowStatus === currentStatusFilter);
            
            if (matchesSearch && matchesStatus) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        document.getElementById('totalCount').innerText = visibleCount;
    }

    document.getElementById('emailFilter').addEventListener('keyup', applyFilters);

    // Initial setup
    calculateStats();

    // Load default template on start (silent - no toast)
    setTimeout(function() {
        loadTemplate('promo', true);
    }, 200);

    // Check for successMessage from redirect session
    <c:if test="${not empty sessionScope.successMessage}">
        showToast("${sessionScope.successMessage}", "success");
        <% request.getSession().removeAttribute("successMessage"); %>
    </c:if>
</script>
