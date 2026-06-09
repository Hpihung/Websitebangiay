<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<c:set var="displayYear" value="${selectedYear != null ? selectedYear : (latestYear != null ? latestYear : 2026)}" />

<style>
    .stat-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
    .stat-header h2 { font-weight: 800; font-size: 28px; color: var(--unity-black); margin: 0; }
    
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-bottom: 40px; }
    .stat-card {
        background: var(--white); padding: 32px; border-radius: 24px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.02); display: flex; flex-direction: column; gap: 12px;
    }
    .stat-label { font-size: 14px; font-weight: 600; color: var(--unity-gray); text-transform: uppercase; letter-spacing: 0.5px; }
    .stat-value { font-size: 32px; font-weight: 800; color: var(--unity-black); }

    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); margin-bottom: 32px; }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }

    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }

    .btn-unity {
        padding: 12px 24px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none;
    }
    .btn-primary { background: var(--unity-primary); color: white; }
    .btn-secondary { background: var(--white); color: var(--unity-gray); border: 1px solid var(--border-color); }

    .progress-item { margin-bottom: 24px; }
    .progress-label { display: flex; justify-content: space-between; margin-bottom: 8px; font-weight: 700; font-size: 14px; color: var(--unity-black); }
    .progress-bar-bg { width: 100%; height: 10px; background: var(--unity-bg); border-radius: 20px; overflow: hidden; }
    .progress-bar-fill { height: 100%; border-radius: 20px; }

    .filter-section { display: flex; align-items: center; gap: 12px; background: var(--white); padding: 12px 20px; border-radius: 16px; border: 1px solid var(--border-color); }
    .year-select { padding: 8px 16px; border-radius: 8px; border: 1px solid var(--border-color); font-weight: 600; color: var(--unity-black); outline: none; }
    
    .chart-container { height: 350px; width: 100%; margin-top: 20px; }
</style>

<div class="stat-header">
    <div>
        <h2>Báo cáo & Thống kê</h2>
        <p style="color: var(--unity-gray); font-weight: 500; margin-top: 8px;">Dữ liệu tài chính và hoạt động kinh doanh chi tiết</p>
    </div>
    <div style="display: flex; gap: 16px;">
        <form action="${pageContext.request.contextPath}/admin/statistics" method="get" class="filter-section">
            <label for="year" style="font-size: 14px; font-weight: 700; color: var(--unity-gray);">Năm:</label>
            <select name="year" id="year" class="year-select">
                <c:forEach var="y" begin="2020" end="2030">
                    <option value="${y}" ${y == displayYear ? 'selected' : ''}>${y}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn-unity btn-primary" style="padding: 8px 16px; border-radius: 8px;">
                Lọc
            </button>
        </form>
        <button onclick="window.print()" class="btn-unity btn-secondary">
            <i class="fa-solid fa-print"></i> Xuất Báo cáo
        </button>
    </div>
</div>

<div class="stats-grid">
    <a href="${pageContext.request.contextPath}/admin/orders?date=${displayYear}" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">Tổng doanh thu ${displayYear}</div>
        <div class="stat-value" style="color: var(--unity-blue);"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
        <div style="font-size: 12px; color: var(--unity-primary); font-weight: 700; margin-top: 8px;">Xem chi tiết <i class="fa-solid fa-arrow-right"></i></div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders?date=${displayYear}" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">Tổng đơn hàng ${displayYear}</div>
        <div class="stat-value">${totalOrders}</div>
        <div style="font-size: 12px; color: var(--unity-primary); font-weight: 700; margin-top: 8px;">Xem chi tiết <i class="fa-solid fa-arrow-right"></i></div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/accounts" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">Khách hàng mới ${displayYear}</div>
        <div class="stat-value">${totalUsers}</div>
        <div style="font-size: 12px; color: var(--unity-primary); font-weight: 700; margin-top: 8px;">Quản lý tài khoản <i class="fa-solid fa-arrow-right"></i></div>
    </a>
</div>

<div class="u-card">
    <div class="card-title">
        <i class="fa-solid fa-chart-line" style="color: var(--unity-primary);"></i>
        Biến động doanh thu ${displayYear}
    </div>
    
    <div class="chart-container">
        <canvas id="revenueChart"></canvas>
    </div>

    <table class="u-table" style="margin-top: 40px;">
        <thead>
            <tr>
                <th>Thời gian (Tháng/Năm)</th>
                <th style="text-align: center;">Số lượng đơn</th>
                <th style="text-align: right;">Doanh thu</th>
                <th style="text-align: right;">Trung bình / đơn</th>
                <th style="text-align: center;">Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="m" items="${monthlyRevenue}">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-black);">Tháng ${m.month} / ${m.year}</td>
                    <td style="text-align: center; font-weight: 700;">${m.orderCount}</td>
                    <td style="text-align: right; font-weight: 800; color: var(--unity-blue);">
                        <fmt:formatNumber value="${m.totalRevenue}" maxFractionDigits="0"/>₫
                    </td>
                    <td style="text-align: right; color: var(--unity-gray); font-weight: 600;">
                        <c:if test="${m.orderCount > 0}">
                            <fmt:formatNumber value="${m.totalRevenue / m.orderCount}" maxFractionDigits="0"/>₫
                        </c:if>
                        <c:if test="${m.orderCount == 0}">0₫</c:if>
                    </td>
                    <td style="text-align: center;">
                        <span style="color: var(--unity-green); font-weight: 800; font-size: 12px; text-transform: uppercase;">● Đã chốt</span>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty monthlyRevenue}">
                <tr><td colspan="5" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Không có dữ liệu báo cáo</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 32px;">
    <div class="u-card">
        <div class="card-title">Phân tích kênh bán hàng</div>
        <div class="progress-item">
            <div class="progress-label"><span>Trực tiếp (Website)</span><span>85%</span></div>
            <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 85%; background: var(--unity-primary);"></div></div>
        </div>
        <div class="progress-item">
            <div class="progress-label"><span>Social Media</span><span>10%</span></div>
            <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 10%; background: var(--unity-blue);"></div></div>
        </div>
        <div class="progress-item" style="margin-bottom: 0;">
            <div class="progress-label"><span>Khác</span><span>5%</span></div>
            <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 5%; background: #FF754C;"></div></div>
        </div>
    </div>

    <div class="u-card" style="background: linear-gradient(135deg, #6C5DD3, #5a4cb3); color: white;">
        <div class="card-title" style="color: white; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 16px;">Ghi chú báo cáo</div>
        <p style="font-size: 14px; line-height: 1.8; color: rgba(255,255,255,0.8); font-weight: 500;">
            Báo cáo này được tự động tổng hợp từ dữ liệu đơn hàng hợp lệ. Doanh thu bao gồm giá trị sản phẩm sau chiết khấu. 
            Mọi sai sót vui lòng đối soát lại với dữ liệu log tại mục Đơn hàng.
        </p>
        <div style="margin-top: 32px; font-size: 12px; font-weight: 700; color: rgba(255,255,255,0.6);">
            Cập nhật lần cuối: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm dd/MM/yyyy" />
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        
        // Chuẩn bị dữ liệu từ JSTL sang JS
        const labels = [];
        const data = [];
        
        // Khởi tạo mảng 12 tháng với giá trị 0
        for(let i=1; i<=12; i++) {
            labels.push('Tháng ' + i);
            data.push(0);
        }
        
        // Điền dữ liệu thực tế
        <c:forEach var="m" items="${monthlyRevenue}">
            data[${m.month - 1}] = ${m.totalRevenue};
        </c:forEach>
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: data,
                    borderColor: '#6C5DD3',
                    backgroundColor: 'rgba(108, 93, 211, 0.1)',
                    borderWidth: 4,
                    pointBackgroundColor: '#6C5DD3',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0,0,0,0.05)' },
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + '₫';
                            }
                        }
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });
    });
</script>
