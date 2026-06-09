<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="data-card" style="margin-bottom: 24px;">
    <div class="card-header" style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px;">
        <div>
            <h2 class="card-title" style="margin:0;">Quản lý đánh giá</h2>
            <p style="color:#8a8fa8; font-size:13px; margin:4px 0 0;">Duyệt, ẩn và phản hồi đánh giá từ khách hàng</p>
        </div>
    </div>

    <%-- STATS ROW --%>
    <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px;">
        <div style="background:linear-gradient(135deg,#667eea,#764ba2); border-radius:12px; padding:20px; color:#fff; text-align:center;">
            <div style="font-size:28px; font-weight:800;">${stats.total}</div>
            <div style="font-size:13px; opacity:.85; margin-top:4px;">Tổng đánh giá</div>
        </div>
        <div style="background:linear-gradient(135deg,#11998e,#38ef7d); border-radius:12px; padding:20px; color:#fff; text-align:center;">
            <div style="font-size:28px; font-weight:800;">${stats.visible}</div>
            <div style="font-size:13px; opacity:.85; margin-top:4px;">Đang hiển thị</div>
        </div>
        <div style="background:linear-gradient(135deg,#f093fb,#f5576c); border-radius:12px; padding:20px; color:#fff; text-align:center;">
            <div style="font-size:28px; font-weight:800;">${stats.hidden}</div>
            <div style="font-size:13px; opacity:.85; margin-top:4px;">Đang ẩn</div>
        </div>
        <div style="background:linear-gradient(135deg,#f7971e,#ffd200); border-radius:12px; padding:20px; color:#fff; text-align:center;">
            <div style="font-size:28px; font-weight:800;">${stats.avg} ⭐</div>
            <div style="font-size:13px; opacity:.85; margin-top:4px;">Điểm TB</div>
        </div>
    </div>

    <%-- FILTER BAR --%>
    <form method="get" action="${pageContext.request.contextPath}/admin/reviews"
          style="display:flex; gap:10px; flex-wrap:wrap; margin-bottom:20px; align-items:center;">
        <input type="text" name="q" value="${keyword}" placeholder="Tìm theo tên, sản phẩm, nội dung..."
               style="flex:1; min-width:200px; padding:10px 14px; border:1px solid #e0e0e0; border-radius:8px; font-size:14px;"/>
        <select name="star" style="padding:10px 14px; border:1px solid #e0e0e0; border-radius:8px; font-size:14px;">
            <option value="">⭐ Tất cả sao</option>
            <c:forEach begin="1" end="5" var="i">
                <c:set var="s" value="${6 - i}" />
                <option value="${s}" ${starFilter == s ? 'selected' : ''}>${s} sao</option>
            </c:forEach>
        </select>
        <select name="status" style="padding:10px 14px; border:1px solid #e0e0e0; border-radius:8px; font-size:14px;">
            <option value="">Tất cả trạng thái</option>
            <option value="VISIBLE" ${statusFilter == 'VISIBLE' ? 'selected' : ''}>Đang hiển thị</option>
            <option value="HIDDEN" ${statusFilter == 'HIDDEN' ? 'selected' : ''}>Đang ẩn</option>
        </select>
        <button type="submit" class="btn-unity btn-primary" style="padding:10px 20px;">
            <i class="fa-solid fa-magnifying-glass"></i> Lọc
        </button>
        <a href="${pageContext.request.contextPath}/admin/reviews" class="btn-unity btn-secondary" style="padding:10px 20px; text-decoration:none;">
            <i class="fa-solid fa-rotate-left"></i> Reset
        </a>
    </form>

    <%-- REVIEW LIST --%>
    <c:choose>
        <c:when test="${empty reviews}">
            <div style="text-align:center; padding:60px 20px; color:#aaa;">
                <i class="fa-solid fa-star-half-stroke" style="font-size:48px; margin-bottom:12px; display:block;"></i>
                <p>Không có đánh giá nào phù hợp</p>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display:flex; flex-direction:column; gap:16px;">
                <c:forEach var="r" items="${reviews}">
                    <div class="review-admin-card ${r.status == 'HIDDEN' ? 'review-hidden' : ''}"
                         style="background:${r.status == 'HIDDEN' ? '#fafafa' : '#fff'}; border:1px solid ${r.status == 'HIDDEN' ? '#e0e0e0' : '#eaedf3'}; border-radius:12px; padding:20px; position:relative;">

                        <%-- Status badge --%>
                        <c:if test="${r.status == 'HIDDEN'}">
                            <span style="position:absolute; top:14px; right:14px; background:#f5f5f5; color:#999; font-size:11px; padding:3px 10px; border-radius:20px; border:1px solid #ddd;">
                                <i class="fa-solid fa-eye-slash"></i> Đang ẩn
                            </span>
                        </c:if>
                        <c:if test="${r.status != 'HIDDEN'}">
                            <span style="position:absolute; top:14px; right:14px; background:rgba(17,153,142,0.1); color:#11998e; font-size:11px; padding:3px 10px; border-radius:20px; border:1px solid rgba(17,153,142,0.2);">
                                <i class="fa-solid fa-eye"></i> Đang hiện
                            </span>
                        </c:if>

                        <div style="display:flex; gap:14px; align-items:flex-start;">
                            <%-- Avatar --%>
                            <div style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#667eea,#764ba2); display:flex; align-items:center; justify-content:center; color:#fff; font-weight:700; flex-shrink:0;">
                                ${not empty r.userName ? r.userName.substring(0,1) : '?'}
                            </div>
                            <div style="flex:1; min-width:0;">
                                <%-- Row 1: User + Product --%>
                                <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:4px; padding-right:100px;">
                                    <span style="font-weight:700; color:#1a1a2e;">${not empty r.userName ? r.userName : 'Ẩn danh'}</span>
                                    <c:if test="${r.anonymous}">
                                        <span style="font-size:11px; background:#f0f0f0; padding:1px 7px; border-radius:10px; color:#888;">ẩn danh</span>
                                    </c:if>
                                    <span style="color:#aaa; font-size:12px;">→</span>
                                    <span style="font-size:13px; color:#555; background:#f5f5f5; padding:2px 10px; border-radius:20px;">
                                        <i class="fa-solid fa-shoe-prints" style="font-size:10px;"></i> ${not empty r.productName ? r.productName : 'Sản phẩm #'.concat(r.productId.toString())}
                                    </span>
                                    <span style="font-size:12px; color:#aaa; margin-left:auto;">
                                        #${r.id} &nbsp;|&nbsp; <fmt:formatDate value="${r.createdAtTimestamp}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>

                                <%-- Stars --%>
                                <div style="margin-bottom:8px; color:#f59e0b; font-size:16px;">
                                    <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5"><span style="color:#e0e0e0;">★</span></c:forEach>
                                    <span style="color:#888; font-size:13px; margin-left:6px;">${r.rating}/5</span>
                                </div>

                                <%-- Comment --%>
                                <p style="color:#333; font-size:14px; line-height:1.6; margin:0 0 8px;">
                                    <c:choose>
                                        <c:when test="${empty r.comment}"><em style="color:#aaa;">Không có nhận xét.</em></c:when>
                                        <c:otherwise><c:out value="${r.comment}"/></c:otherwise>
                                    </c:choose>
                                </p>

                                <%-- Image --%>
                                <c:if test="${not empty r.imageUrl}">
                                    <div style="margin-bottom:10px;">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(r.imageUrl, 'http')}">
                                                <img src="${r.imageUrl}" alt="Review image"
                                                     style="max-width:120px; max-height:120px; border-radius:8px; object-fit:cover; border:1px solid #eee; cursor:pointer;"
                                                     onclick="window.open(this.src,'_blank')"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}${r.imageUrl}" alt="Review image"
                                                     style="max-width:120px; max-height:120px; border-radius:8px; object-fit:cover; border:1px solid #eee; cursor:pointer;"
                                                     onclick="window.open(this.src,'_blank')"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>

                                <%-- Actions --%>
                                <div style="display:flex; gap:8px; flex-wrap:wrap; margin-top:10px;">
                                    <c:if test="${r.status == 'VISIBLE'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reviews" style="display:inline;">
                                            <input type="hidden" name="action" value="hide"/>
                                            <input type="hidden" name="reviewId" value="${r.id}"/>
                                            <input type="hidden" name="q" value="${keyword}"/>
                                            <input type="hidden" name="star" value="${starFilter}"/>
                                            <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                            <button type="submit" class="btn-unity btn-secondary" style="padding:6px 14px; font-size:12px;">
                                                <i class="fa-solid fa-eye-slash"></i> Ẩn
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${r.status == 'HIDDEN'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reviews" style="display:inline;">
                                            <input type="hidden" name="action" value="show"/>
                                            <input type="hidden" name="reviewId" value="${r.id}"/>
                                            <input type="hidden" name="q" value="${keyword}"/>
                                            <input type="hidden" name="star" value="${starFilter}"/>
                                            <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                            <button type="submit" class="btn-unity btn-primary" style="padding:6px 14px; font-size:12px;">
                                                <i class="fa-solid fa-eye"></i> Hiện lại
                                            </button>
                                        </form>
                                    </c:if>
                                    <button type="button" class="btn-unity btn-secondary" style="padding:6px 14px; font-size:12px; background:#e8f0fe; color:#3b5bdb; border-color:#c5d2f6;"
                                            onclick="toggleReply(${r.id})">
                                        <i class="fa-solid fa-reply"></i> Phản hồi
                                    </button>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/reviews" style="display:inline;"
                                          onsubmit="return confirm('Xóa đánh giá này vĩnh viễn?')">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="reviewId" value="${r.id}"/>
                                        <input type="hidden" name="q" value="${keyword}"/>
                                        <input type="hidden" name="star" value="${starFilter}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <button type="submit" style="padding:6px 14px; font-size:12px; background:#fff0f0; color:#cf1322; border:1px solid #ffccc7; border-radius:8px; cursor:pointer;">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </div>

                                <%-- Reply form (hidden by default) --%>
                                <div id="reply-form-${r.id}" style="display:none; margin-top:12px; background:#f8f9ff; border-radius:8px; padding:14px; border:1px solid #e8edfe;">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/reviews">
                                        <input type="hidden" name="action" value="reply"/>
                                        <input type="hidden" name="reviewId" value="${r.id}"/>
                                        <input type="hidden" name="q" value="${keyword}"/>
                                        <input type="hidden" name="star" value="${starFilter}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <label style="font-size:13px; font-weight:600; color:#3b5bdb; margin-bottom:6px; display:block;">
                                            <i class="fa-solid fa-shield-halved"></i> Phản hồi của Admin:
                                        </label>
                                        <textarea name="replyContent" rows="3" placeholder="Nhập phản hồi..."
                                                  style="width:100%; padding:10px; border:1px solid #c5d2f6; border-radius:8px; font-size:13px; resize:vertical; box-sizing:border-box;"></textarea>
                                        <div style="display:flex; gap:8px; margin-top:8px;">
                                            <button type="submit" class="btn-unity btn-primary" style="padding:7px 18px; font-size:13px;">
                                                <i class="fa-solid fa-paper-plane"></i> Gửi phản hồi
                                            </button>
                                            <button type="button" onclick="toggleReply(${r.id})"
                                                    class="btn-unity btn-secondary" style="padding:7px 14px; font-size:13px;">Hủy</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
function toggleReply(id) {
    const el = document.getElementById('reply-form-' + id);
    el.style.display = el.style.display === 'none' ? 'block' : 'none';
    if (el.style.display === 'block') el.querySelector('textarea').focus();
}
</script>
