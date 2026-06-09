<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .dash-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
    .dash-header h2 { font-weight: 800; font-size: 28px; margin: 0; color: var(--unity-black); }
    
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 40px; }
    .stat-card {
        background: var(--white); padding: 32px; border-radius: 24px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.02); display: flex; flex-direction: column; gap: 12px;
        transition: 0.3s;
    }
    .stat-card:hover { transform: translateY(-5px); box-shadow: 0 20px 50px rgba(0,0,0,0.05); }
    .stat-label { font-size: 14px; font-weight: 600; color: var(--unity-gray); text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; justify-content: space-between; }
    .stat-value { font-size: 28px; font-weight: 800; color: var(--unity-black); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; }

    .main-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 32px; margin-bottom: 32px; }
    .content-block { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    .block-title { font-weight: 700; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }

    .u-list-item { display: flex; align-items: center; gap: 16px; padding: 12px 0; border-bottom: 1px solid var(--border-color); }
    .u-list-item:last-child { border-bottom: none; }
    .u-avatar { width: 44px; height: 44px; border-radius: 12px; background: var(--unity-bg); display: flex; align-items: center; justify-content: center; color: var(--unity-gray); font-size: 18px; }

    .mini-table { width: 100%; border-collapse: collapse; }
    .mini-table th { text-align: left; padding: 12px; font-size: 12px; color: var(--unity-gray); font-weight: 600; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .mini-table td { padding: 16px 12px; font-size: 14px; border-bottom: 1px solid var(--border-color); }
    .mini-table tr:last-child td { border-bottom: none; }
</style>

<div class="dash-header">
    <div>
        <h2>Tổng quan hệ thống</h2>
        <p style="color: var(--unity-gray); font-weight: 500; margin-top: 8px;">Chào mừng trở lại, quản trị viên!</p>
    </div>
    <div style="display: flex; gap: 16px; align-items: center;">
        <div style="background: var(--white); padding: 12px 20px; border-radius: 14px; box-shadow: 0 4px 12px rgba(0,0,0,0.02); font-weight: 700; font-size: 14px; color: var(--unity-primary); display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-calendar-day"></i> Hôm nay: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" />
        </div>
        <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" style="display: flex; gap: 8px;">
            <select name="month" style="padding: 12px 16px; border-radius: 12px; border: 2px solid var(--border-color); font-weight: 700; outline: none;">
                <option value="">Tất cả các tháng</option>
                <c:forEach var="m" begin="1" end="12">
                    <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                </c:forEach>
            </select>
            <select name="year" style="padding: 12px 16px; border-radius: 12px; border: 2px solid var(--border-color); font-weight: 700; outline: none;">
                <c:forEach var="y" begin="2024" end="${latestYear}">
                    <option value="${y}" ${selectedYear == y ? 'selected' : ''}>Năm ${y}</option>
                </c:forEach>
            </select>
            <button type="submit" style="padding: 12px 20px; border-radius: 12px; border: none; background: var(--unity-primary); color: white; font-weight: 700; cursor: pointer;">Lọc</button>
        </form>
    </div>
</div>

<div class="stats-grid">
    <a href="${pageContext.request.contextPath}/admin/statistics" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">
            Doanh thu (<c:if test="${not empty selectedMonth}">Tháng ${selectedMonth}/</c:if>${selectedYear})
            <div class="stat-icon" style="background: rgba(63, 140, 255, 0.1); color: var(--unity-blue);"><i class="fa-solid fa-chart-line"></i></div>
        </div>
        <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">
            Tổng đơn hàng (<c:if test="${not empty selectedMonth}">Tháng ${selectedMonth}/</c:if>${selectedYear})
            <div class="stat-icon" style="background: rgba(108, 93, 211, 0.1); color: var(--unity-primary);"><i class="fa-solid fa-bag-shopping"></i></div>
        </div>
        <div class="stat-value">${totalOrders}</div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING_COD" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">
            Chưa thanh toán (Nhận hàng)
            <div class="stat-icon" style="background: rgba(243, 156, 18, 0.1); color: #f39c12;"><i class="fa-solid fa-hand-holding-dollar"></i></div>
        </div>
        <div class="stat-value">${pendingCodCount}</div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/accounts" class="stat-card" style="text-decoration: none;">
        <div class="stat-label">
            Khách hàng mới
            <div class="stat-icon" style="background: rgba(255, 117, 76, 0.1); color: #FF754C;"><i class="fa-solid fa-user-plus"></i></div>
        </div>
        <div class="stat-value">${newCustomers}</div>
    </a>
</div>

<div class="main-grid">
    <!-- Revenue Chart -->
    <div class="content-block">
        <div class="block-title"><i class="fa-solid fa-chart-area" style="color: var(--unity-primary);"></i> Biểu đồ doanh thu tháng (${selectedYear})</div>
        <div style="height: 350px;">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>

    <!-- Top Staff -->
    <div class="content-block">
        <div class="block-title"><i class="fa-solid fa-crown" style="color: #FFCE73;"></i> Top Nhân viên</div>
        <div style="display: flex; flex-direction: column; gap: 8px;">
            <c:forEach var="s" items="${topStaff}">
                <div class="u-list-item">
                    <div class="u-avatar"><i class="fa-solid fa-user"></i></div>
                    <div>
                        <div style="font-weight: 700; font-size: 14px; color: var(--unity-black);">${s.fullName}</div>
                        <div style="font-size: 12px; color: var(--unity-gray); font-weight: 500;">${s.email}</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="main-grid" style="grid-template-columns: 1fr 1fr;">
    <!-- Best Sellers -->
    <div class="content-block">
        <div class="block-title"><i class="fa-solid fa-fire" style="color: #FF754C;"></i> Sản phẩm bán chạy</div>
        <table class="mini-table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th style="text-align: center;">Đã bán</th>
                    <th style="text-align: right;">Doanh thu</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${topProducts}">
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <img src="${p.image}" style="width: 40px; height: 40px; border-radius: 10px; object-fit: cover;" onerror="this.src='https://placehold.co/100x100?text=Giay'">
                                <span style="font-weight: 700; color: var(--unity-black); max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${p.name}</span>
                            </div>
                        </td>
                        <td style="text-align: center; font-weight: 800;">${p.totalSold}</td>
                        <td style="text-align: right; font-weight: 700; color: var(--unity-blue);">
                            <fmt:formatNumber value="${p.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Loyal Customers -->
    <div class="content-block">
        <div class="block-title"><i class="fa-solid fa-gem" style="color: var(--unity-primary);"></i> Khách hàng thân thiết</div>
        <table class="mini-table">
            <thead>
                <tr>
                    <th>Khách hàng</th>
                    <th style="text-align: center;">Đơn hàng</th>
                    <th style="text-align: right;">Chi tiêu</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${topCustomers}">
                    <tr>
                        <td>
                            <div style="font-weight: 700; color: var(--unity-black);">${c.fullName}</div>
                            <div style="font-size: 12px; color: var(--unity-gray); font-weight: 500;">${c.email}</div>
                        </td>
                        <td style="text-align: center; font-weight: 800;">${c.orderCount}</td>
                        <td style="text-align: right; font-weight: 700; color: var(--unity-green);">
                            <fmt:formatNumber value="${c.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const months = [];
        const revenues = [];
        <c:forEach var="m" items="${monthlyRevenue}">
            months.push('Tháng ${m.month}');
            revenues.push(${m.totalRevenue});
        </c:forEach>

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: months,
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: revenues,
                    borderColor: '#6C5DD3',
                    backgroundColor: 'rgba(108, 93, 211, 0.05)',
                    borderWidth: 4,
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#6C5DD3',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [5, 5], color: '#E4E4E4' },
                        ticks: {
                            font: { family: 'Inter', weight: 600 },
                            callback: function(value) { return value.toLocaleString('vi-VN') + ' ₫'; }
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { font: { family: 'Inter', weight: 600 } }
                    }
                }
            }
        });
    });
</script>
