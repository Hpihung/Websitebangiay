<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.warranty.WarrantyRequest" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .aw-header { margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; }
    .aw-title { font-size: 22px; font-weight: 700; color: #1e293b; margin: 0; display: flex; align-items: center; gap: 10px; }
    .aw-title i { color: #3b82f6; }
    .aw-stats { display: flex; gap: 12px; }
    .aw-stat { background: #fff; border: 1px solid #e2e8f0; border-radius: 10px; padding: 10px 16px; text-align: center; min-width: 80px; }
    .aw-stat-num { font-size: 20px; font-weight: 700; }
    .aw-stat-label { font-size: 11px; color: #64748b; }

    .aw-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border: 1px solid #e2e8f0; overflow: hidden; }
    .aw-table { width: 100%; border-collapse: collapse; }
    .aw-table th { background: #f8fafc; padding: 14px 16px; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid #e2e8f0; text-align: left; white-space: nowrap; }
    .aw-table td { padding: 14px 16px; font-size: 13px; color: #334155; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
    .aw-table tbody tr:hover { background: #f8fafc; }
    .aw-table tbody tr:last-child td { border-bottom: none; }

    .aw-product-cell { display: flex; align-items: center; gap: 10px; }
    .aw-product-img { width: 44px; height: 44px; border-radius: 8px; object-fit: cover; border: 1px solid #e2e8f0; flex-shrink: 0; }
    .aw-product-name { font-weight: 600; font-size: 13px; color: #1e293b; margin-bottom: 2px; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .aw-product-sub { font-size: 11px; color: #94a3b8; }

    .aw-id { font-family: monospace; font-size: 12px; background: #f1f5f9; color: #475569; padding: 3px 8px; border-radius: 4px; }
    .aw-reason { background: #ede9fe; color: #6d28d9; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; }
    .aw-email { font-size: 12px; color: #475569; }

    .badge { padding: 5px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; white-space: nowrap; }
    .badge-pending { background: #fffbeb; color: #d97706; border: 1px solid #fcd34d; }
    .badge-processing { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; }
    .badge-completed { background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; }
    .badge-rejected { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

    .aw-btn-view { background: transparent; border: 1px solid #cbd5e1; color: #64748b; cursor: pointer; border-radius: 6px; padding: 6px 10px; transition: all 0.2s; font-size: 13px; }
    .aw-btn-view:hover { background: #eff6ff; border-color: #3b82f6; color: #3b82f6; }

    .aw-empty { text-align: center; padding: 60px 20px; color: #94a3b8; }
    .aw-empty i { font-size: 48px; margin-bottom: 12px; display: block; }

    /* MODAL */
    .aw-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15,23,42,0.55); z-index: 1000; justify-content: center; align-items: center; backdrop-filter: blur(4px); }
    .aw-modal { background: #fff; border-radius: 16px; width: 92%; max-width: 760px; max-height: 92vh; overflow-y: auto; box-shadow: 0 20px 40px rgba(0,0,0,0.15); animation: awSlideIn 0.25s ease; }
    @keyframes awSlideIn { from { opacity:0; transform: translateY(16px); } to { opacity:1; transform: none; } }
    .aw-modal-header { padding: 20px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; background: #fff; z-index: 10; border-radius: 16px 16px 0 0; }
    .aw-modal-title { font-size: 17px; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 8px; }
    .aw-modal-close { background: #f1f5f9; border: none; border-radius: 50%; width: 32px; height: 32px; cursor: pointer; font-size: 18px; color: #64748b; display: flex; align-items: center; justify-content: center; transition: all 0.2s; }
    .aw-modal-close:hover { background: #fee2e2; color: #dc2626; }
    .aw-modal-body { padding: 24px; }
    .aw-modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; background: #f8fafc; border-radius: 0 0 16px 16px; position: sticky; bottom: 0; }

    .aw-info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
    .aw-info-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; }
    .aw-info-box-title { font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 14px; display: flex; align-items: center; gap: 6px; }
    .aw-info-row { display: flex; margin-bottom: 8px; font-size: 13px; }
    .aw-info-row:last-child { margin-bottom: 0; }
    .aw-info-key { width: 110px; color: #64748b; flex-shrink: 0; font-size: 12px; }
    .aw-info-val { color: #1e293b; font-weight: 500; font-size: 13px; }

    .aw-product-preview { display: flex; gap: 14px; align-items: center; }
    .aw-product-preview img { width: 56px; height: 56px; border-radius: 8px; object-fit: cover; border: 1px solid #e2e8f0; }

    .aw-detail-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; margin-bottom: 16px; }
    .aw-detail-box-title { font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; display: flex; align-items: center; gap: 6px; }
    .aw-desc-text { background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px; font-size: 13px; color: #334155; line-height: 1.6; }
    .aw-evidence-img { width: 120px; height: 120px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0; cursor: zoom-in; }

    .aw-status-select { padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; color: #1e293b; outline: none; background: #fff; }
    .aw-btn-save { background: #3b82f6; color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: background 0.2s; display: flex; align-items: center; gap: 6px; }
    .aw-btn-save:hover { background: #2563eb; }
    .aw-btn-close { background: transparent; border: 1px solid #cbd5e1; color: #64748b; padding: 9px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .aw-btn-close:hover { background: #f1f5f9; }

    @media (max-width: 640px) {
        .aw-info-grid { grid-template-columns: 1fr; }
        .aw-stats { display: none; }
    }
</style>

<%-- Flash message --%>
<c:if test="${not empty flashMsg}">
    <div style="background:#dcfce7;color:#166534;padding:12px 18px;border-radius:10px;margin-bottom:20px;border:1px solid #bbf7d0;display:flex;align-items:center;gap:8px;">
        <i class="fa-solid fa-circle-check"></i> ${flashMsg}
    </div>
    <c:remove var="flashMsg" scope="session"/>
</c:if>

<%-- Header --%>
<div class="aw-header">
    <h1 class="aw-title"><i class="fa-solid fa-shield-halved"></i> Quản lý bảo hành</h1>
    <div class="aw-stats">
        <div class="aw-stat">
            <div class="aw-stat-num" style="color:#d97706;">${fn:length(requests)}</div>
            <div class="aw-stat-label">Tổng yêu cầu</div>
        </div>
        <div class="aw-stat">
            <div class="aw-stat-num" style="color:#2563eb;">
                <c:set var="pendingCount" value="0"/>
                <c:forEach var="r" items="${requests}"><c:if test="${r.status == 'PENDING' || r.status == 'PROCESSING'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if></c:forEach>
                ${pendingCount}
            </div>
            <div class="aw-stat-label">Đang xử lý</div>
        </div>
        <div class="aw-stat">
            <div class="aw-stat-num" style="color:#16a34a;">
                <c:set var="doneCount" value="0"/>
                <c:forEach var="r" items="${requests}"><c:if test="${r.status == 'COMPLETED'}"><c:set var="doneCount" value="${doneCount + 1}"/></c:if></c:forEach>
                ${doneCount}
            </div>
            <div class="aw-stat-label">Hoàn thành</div>
        </div>
    </div>
</div>

<%-- Table --%>
<div class="aw-card" id="awCardContainer">
    <table class="aw-table">
        <thead>
            <tr>
                <th>Mã yêu cầu</th>
                <th>Sản phẩm</th>
                <th>Khách hàng</th>
                <th>Phân loại</th>
                <th>Lý do</th>
                <th>Ngày yêu cầu</th>
                <th>Trạng thái</th>
                <th style="text-align:center;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="req" items="${requests}">
                <tr>
                    <td><span class="aw-id">#${req.id}</span></td>
                    <td>
                        <div class="aw-product-cell">
                            <img class="aw-product-img" src="${req.productImageUrl}" alt="${req.productName}"
                                 onerror="this.src='https://placehold.co/44x44/f1f5f9/94a3b8?text=img'">
                            <div>
                                <div class="aw-product-name">${req.productName}</div>
                                <div class="aw-product-sub">ID: #${req.productId}</div>
                            </div>
                        </div>
                    </td>
                    <td class="aw-email"><i class="fa-regular fa-envelope" style="margin-right:4px;color:#94a3b8;"></i>${req.customerEmail}</td>
                    <td>
                        <c:choose>
                            <c:when test="${req.requestType == 'EXCHANGE'}">
                                <span style="background: #e0f2fe; color: #0369a1; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; white-space: nowrap;" title="Đổi size sang: ${req.exchangeSize}"><i class="fa-solid fa-arrows-rotate"></i> Đổi size (${req.exchangeSize})</span>
                            </c:when>
                            <c:when test="${req.requestType == 'REFUND'}">
                                <span style="background: #fee2e2; color: #b91c1c; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; white-space: nowrap;" title="Hoàn tiền qua: ${req.refundBankName}"><i class="fa-solid fa-building-columns"></i> Trả hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #e0f2fe; color: #0369a1; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; white-space: nowrap;"><i class="fa-solid fa-arrows-rotate"></i> Đổi size</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><span class="aw-reason">${req.reason}</span></td>
                    <td style="color:#64748b;font-size:12px;">
                        <i class="fa-regular fa-calendar" style="margin-right:4px;"></i>
                        <fmt:formatDate value="${req.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${req.status == 'PENDING'}"><span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Đang chờ</span></c:when>
                            <c:when test="${req.status == 'PROCESSING'}"><span class="badge badge-processing"><i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý</span></c:when>
                            <c:when test="${req.status == 'COMPLETED'}"><span class="badge badge-completed"><i class="fa-solid fa-check"></i> Hoàn thành</span></c:when>
                            <c:when test="${req.status == 'REJECTED'}"><span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Từ chối</span></c:when>
                        </c:choose>
                    </td>
                    <td style="text-align:center;">
                        <%
                            WarrantyRequest _wr = (WarrantyRequest) pageContext.getAttribute("req");
                            String _wpName = _wr.getProductName() == null ? "" : _wr.getProductName().replace("'", "\\'").replace("\"", "&quot;");
                            String _wcName = _wr.getCustomerName() == null ? "" : _wr.getCustomerName().replace("'", "\\'").replace("\"", "&quot;");
                            String _wdesc  = _wr.getDescription() == null ? "" : _wr.getDescription().replace("'", "\\'").replace("\"", "&quot;").replace("\n"," ").replace("\r","");
                            String _wimg   = _wr.getImageUrl() == null ? "" : _wr.getImageUrl().replace("'", "\\'");
                            String _wreason = _wr.getReason() == null ? "" : _wr.getReason().replace("'", "\\'").replace("\"", "&quot;").replace("\n"," ").replace("\r","");
                            String _pImg = _wr.getProductImageUrl() == null ? "" : _wr.getProductImageUrl().replace("'", "\\'");
                            String _cEmail = _wr.getCustomerEmail() == null ? "" : _wr.getCustomerEmail().replace("'", "\\'");
                            
                            String _reqType = _wr.getRequestType() == null ? "EXCHANGE" : _wr.getRequestType().replace("'", "\\'");
                            String _exSize = _wr.getExchangeSize() == null ? "" : _wr.getExchangeSize().replace("'", "\\'").replace("\"", "&quot;");
                            String _bName = _wr.getRefundBankName() == null ? "" : _wr.getRefundBankName().replace("'", "\\'").replace("\"", "&quot;");
                            String _bAcc = _wr.getRefundAccountNumber() == null ? "" : _wr.getRefundAccountNumber().replace("'", "\\'").replace("\"", "&quot;");
                            String _bHolder = _wr.getRefundAccountHolder() == null ? "" : _wr.getRefundAccountHolder().replace("'", "\\'").replace("\"", "&quot;");
                            
                            String _retMethod = _wr.getReturnMethod() == null ? "PICKUP" : _wr.getReturnMethod().replace("'", "\\'");
                            String _pickAddr = _wr.getPickupAddress() == null ? "" : _wr.getPickupAddress().replace("'", "\\'").replace("\"", "&quot;").replace("\n"," ").replace("\r","");
                            String _pickPhone = _wr.getPickupPhone() == null ? "" : _wr.getPickupPhone().replace("'", "\\'");

                            pageContext.setAttribute("_wpName", _wpName);
                            pageContext.setAttribute("_wcName", _wcName);
                            pageContext.setAttribute("_wdesc",  _wdesc);
                            pageContext.setAttribute("_wimg",   _wimg);
                            pageContext.setAttribute("_wreason", _wreason);
                            pageContext.setAttribute("_pImg", _pImg);
                            pageContext.setAttribute("_cEmail", _cEmail);
                            pageContext.setAttribute("_reqType", _reqType);
                            pageContext.setAttribute("_exSize", _exSize);
                            pageContext.setAttribute("_bName", _bName);
                            pageContext.setAttribute("_bAcc", _bAcc);
                            pageContext.setAttribute("_bHolder", _bHolder);
                            pageContext.setAttribute("_retMethod", _retMethod);
                            pageContext.setAttribute("_pickAddr", _pickAddr);
                            pageContext.setAttribute("_pickPhone", _pickPhone);
                        %>
                        <button class="aw-btn-view" onclick="openModal(
                            '${req.id}',
                            '${_wpName}',
                            '${_pImg}',
                            '${req.productId}',
                            '${req.orderId}',
                            '${_wcName}',
                            '${_cEmail}',
                            '<fmt:formatDate value="${req.createdAt}" pattern="HH:mm dd/MM/yyyy"/>',
                            '<fmt:formatDate value="${req.orderDeliveredAt}" pattern="dd/MM/yyyy"/>',
                            '${_wreason}',
                            '${req.status}',
                            '${_wdesc}',
                            '${_wimg}',
                            '${_reqType}',
                            '${_exSize}',
                            '${_bName}',
                            '${_bAcc}',
                            '${_bHolder}',
                            '${_retMethod}',
                            '${_pickAddr}',
                            '${_pickPhone}'
                        )">
                            <i class="fa-solid fa-eye"></i> Chi tiết
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requests}">
                <tr><td colspan="7">
                    <div class="aw-empty">
                        <i class="fa-solid fa-shield-halved"></i>
                        <p>Chưa có yêu cầu bảo hành / đổi trả nào.</p>
                    </div>
                </td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%-- DETAIL MODAL --%>
<div class="aw-modal-overlay" id="awModal">
    <div class="aw-modal">
        <div class="aw-modal-header">
            <div class="aw-modal-title">
                <i class="fa-regular fa-file-lines" style="color:#3b82f6;"></i>
                Chi tiết yêu cầu bảo hành
            </div>
            <button class="aw-modal-close" onclick="closeModal()">✕</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/warranty" method="post">
            <input type="hidden" name="action" value="update_status"/>
            <input type="hidden" name="requestId" id="m-req-id"/>

            <div class="aw-modal-body">
                <%-- Top: Product & Request info --%>
                <div class="aw-info-grid">
                    <div class="aw-info-box">
                        <div class="aw-info-box-title"><i class="fa-solid fa-box"></i> Thông tin sản phẩm</div>
                        <div class="aw-product-preview">
                            <img id="m-prod-img" src="" alt="">
                            <div>
                                <div style="font-weight:700;font-size:14px;color:#1e293b;" id="m-prod-name"></div>
                                <div style="font-size:12px;color:#94a3b8;margin-top:4px;">ID: <span id="m-prod-id"></span></div>
                            </div>
                        </div>
                    </div>
                    <div class="aw-info-box">
                        <div class="aw-info-box-title"><i class="fa-regular fa-file-lines"></i> Thông tin yêu cầu</div>
                        <div class="aw-info-row"><div class="aw-info-key">Mã yêu cầu:</div><div class="aw-info-val" id="m-id-display" style="font-family:monospace;color:#475569;"></div></div>
                        <div class="aw-info-row"><div class="aw-info-key">Khách hàng:</div><div class="aw-info-val" id="m-customer"></div></div>
                        <div class="aw-info-row"><div class="aw-info-key">Ngày yêu cầu:</div><div class="aw-info-val" id="m-date"></div></div>
                        <div class="aw-info-row"><div class="aw-info-key">Hạn đổi trả:</div><div class="aw-info-val" id="m-deadline" style="color:#dc2626;font-weight:700;"></div></div>
                    </div>
                </div>

                <%-- Detail section --%>
                <div class="aw-detail-box">
                    <div class="aw-detail-box-title"><i class="fa-solid fa-list-check"></i> Chi tiết yêu cầu</div>
                    <div class="aw-info-row" style="margin-bottom:12px;">
                        <div class="aw-info-key">Phân loại:</div>
                        <div class="aw-info-val" id="m-type-badge"></div>
                    </div>
                    <div class="aw-info-row" style="margin-bottom:12px;">
                        <div class="aw-info-key">Phương thức trả:</div>
                        <div class="aw-info-val" id="m-return-method-badge"></div>
                    </div>
                    <div class="aw-info-row" id="m-pickup-address-row" style="margin-bottom:12px; display:none;">
                        <div class="aw-info-key">Địa chỉ lấy hàng:</div>
                        <div class="aw-info-val" id="m-pickup-address-val" style="font-weight:600;"></div>
                    </div>
                    <div class="aw-info-row" style="margin-bottom:12px;">
                        <div class="aw-info-key">Lý do:</div>
                        <div class="aw-info-val"><span id="m-reason" style="background:#ede9fe;color:#6d28d9;padding:4px 8px;border-radius:4px;font-size:12px;font-weight:600;"></span></div>
                    </div>
                    <div class="aw-info-row" style="margin-bottom:12px;">
                        <div class="aw-info-key">Trạng thái hiện tại:</div>
                        <div class="aw-info-val" id="m-status-badge"></div>
                    </div>
                    
                    <%-- Exchange Details --%>
                    <div class="aw-info-row" id="m-exchange-row" style="margin-bottom:12px; display:none;">
                        <div class="aw-info-key">Size cần đổi:</div>
                        <div class="aw-info-val"><span id="m-exchange-size-val" style="background:#e0f2fe;color:#0369a1;padding:4px 8px;border-radius:4px;font-size:12px;font-weight:700;"></span></div>
                    </div>

                    <%-- Refund Details --%>
                    <div id="m-refund-section" style="display:none; margin-bottom:12px; border-top:1px dashed #e2e8f0; padding-top:12px;">
                        <div style="font-size:11px; font-weight:700; color:#64748b; margin-bottom:8px; text-transform:uppercase;"><i class="fa-solid fa-building-columns"></i> Thông tin nhận tiền hoàn</div>
                        <div class="aw-info-row" style="margin-bottom:8px;">
                            <div class="aw-info-key">Ngân hàng:</div>
                            <div class="aw-info-val" id="m-refund-bank-val" style="font-weight:600;"></div>
                        </div>
                        <div class="aw-info-row" style="margin-bottom:8px;">
                            <div class="aw-info-key">Số tài khoản:</div>
                            <div class="aw-info-val" id="m-refund-acc-val" style="font-family:monospace; font-weight:600;"></div>
                        </div>
                        <div class="aw-info-row" style="margin-bottom:8px;">
                            <div class="aw-info-key">Chủ tài khoản:</div>
                            <div class="aw-info-val" id="m-refund-holder-val" style="text-transform:uppercase; font-weight:600;"></div>
                        </div>
                    </div>

                    <div class="aw-info-key" style="margin-bottom:6px; border-top:1px dashed #e2e8f0; padding-top:12px;">Mô tả chi tiết:</div>
                    <div class="aw-desc-text" id="m-desc"></div>
                </div>

                <%-- Evidence image --%>
                <div class="aw-detail-box" id="m-evidence-box">
                    <div class="aw-detail-box-title"><i class="fa-regular fa-image"></i> Hình ảnh minh chứng</div>
                    <img id="m-evidence-img" src="" class="aw-evidence-img"
                         onerror="document.getElementById('m-evidence-box').style.display='none'"
                         onload="document.getElementById('m-evidence-box').style.display='block'"
                         onclick="window.open(this.src,'_blank')">
                </div>
            </div>

            <div class="aw-modal-footer">
                <div style="display:flex;align-items:center;gap:10px;">
                    <span style="font-size:13px;font-weight:600;color:#64748b;">Cập nhật trạng thái:</span>
                    <select name="status" id="m-status-select" class="aw-status-select">
                        <option value="PENDING">Đang chờ xử lý</option>
                        <option value="PROCESSING">Đang xử lý</option>
                        <option value="COMPLETED">Hoàn thành (Đã đổi trả)</option>
                        <option value="REJECTED">Từ chối</option>
                    </select>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="button" class="aw-btn-close" onclick="closeModal()">Đóng</button>
                    <button type="submit" class="aw-btn-save"><i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id, pName, pImg, pId, orderId, custName, custEmail, date, deliveredDate, reason, status, desc, evImg, reqType, exSize, bName, bAcc, bHolder, retMethod, pickAddr, pickPhone) {
    document.getElementById('m-req-id').value = id;
    document.getElementById('m-id-display').innerText = '#' + id;
    document.getElementById('m-prod-name').innerText = pName;
    document.getElementById('m-prod-img').src = pImg;
    document.getElementById('m-prod-id').innerText = pId;
    document.getElementById('m-customer').innerText = custName + ' (' + custEmail + ')';
    document.getElementById('m-date').innerText = date;
    document.getElementById('m-reason').innerText = reason;
    document.getElementById('m-desc').innerText = desc.replace(/\\n/g, '\n');

    // Deadline: 7 days from delivery
    var dl = deliveredDate ? deliveredDate : '—';
    document.getElementById('m-deadline').innerText = 'lúc ' + (deliveredDate ? deliveredDate : '—') + ' + 7 ngày';

    // Status badge
    var badges = {
        'PENDING': '<span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Đang chờ xử lý</span>',
        'PROCESSING': '<span class="badge badge-processing"><i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý</span>',
        'COMPLETED': '<span class="badge badge-completed"><i class="fa-solid fa-check"></i> Hoàn thành</span>',
        'REJECTED': '<span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Từ chối</span>'
    };
    document.getElementById('m-status-badge').innerHTML = badges[status] || status;

    document.getElementById('m-status-select').value = status;

    // Return Method and Pickup details
    var retBadge = document.getElementById('m-return-method-badge');
    var pickupAddrRow = document.getElementById('m-pickup-address-row');
    if (retMethod === 'SELF_SEND') {
        retBadge.innerHTML = '<span style="background: #f1f5f9; color: #475569; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600;"><i class="fa-solid fa-paper-plane"></i> Tự gửi về shop (136 Kim Giang)</span>';
        pickupAddrRow.style.display = 'none';
    } else {
        retBadge.innerHTML = '<span style="background: #e6f7ff; color: #1890ff; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600;"><i class="fa-solid fa-truck-pickup"></i> Shipper đến lấy</span>';
        pickupAddrRow.style.display = 'flex';
        document.getElementById('m-pickup-address-val').innerText = (pickAddr || '—') + (pickPhone ? ' (SĐT: ' + pickPhone + ')' : '');
    }

    // Type Badge and Conditional Fields
    var typeBadge = document.getElementById('m-type-badge');
    var exRow = document.getElementById('m-exchange-row');
    var refSec = document.getElementById('m-refund-section');

    if (reqType === 'REFUND') {
        typeBadge.innerHTML = '<span style="background: #fee2e2; color: #b91c1c; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600;"><i class="fa-solid fa-building-columns"></i> Trả hàng hoàn tiền</span>';
        exRow.style.display = 'none';
        refSec.style.display = 'block';
        document.getElementById('m-refund-bank-val').innerText = bName || '—';
        document.getElementById('m-refund-acc-val').innerText = bAcc || '—';
        document.getElementById('m-refund-holder-val').innerText = bHolder || '—';
    } else {
        typeBadge.innerHTML = '<span style="background: #e0f2fe; color: #0369a1; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600;"><i class="fa-solid fa-arrows-rotate"></i> Đổi size</span>';
        exRow.style.display = 'flex';
        refSec.style.display = 'none';
        document.getElementById('m-exchange-size-val').innerText = exSize || '—';
    }

    // Evidence image
    var evEl = document.getElementById('m-evidence-img');
    var evBox = document.getElementById('m-evidence-box');
    if (evImg && evImg.trim() !== '') {
        evEl.src = evImg;
        evBox.style.display = 'block';
    } else {
        evBox.style.display = 'none';
    }

    document.getElementById('awModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    document.getElementById('awModal').style.display = 'none';
    document.body.style.overflow = '';
}

document.getElementById('awModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

// Intercept status update form for AJAX on the admin warranty page
document.querySelectorAll('form[action*="/admin/warranty"]').forEach(form => {
    form.addEventListener('submit', async function(e) {
        if (form.dataset.skipAjax === "true") return;
        
        const actionInput = form.querySelector('input[name="action"]');
        if (!actionInput || actionInput.value !== 'update_status') return;
        
        e.preventDefault();
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalBtnHtml = submitBtn ? submitBtn.innerHTML : '';
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';
        }
        
        try {
            const formData = new URLSearchParams(new FormData(form));
            const response = await fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData.toString()
            });
            
            if (response.ok) {
                const htmlText = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');
                
                // Swap the stats cards
                const newStats = doc.querySelector('.aw-stats');
                if (newStats) {
                    document.querySelector('.aw-stats').innerHTML = newStats.innerHTML;
                }
                
                // Swap the table card
                const newCard = doc.querySelector('#awCardContainer');
                if (newCard) {
                    document.getElementById('awCardContainer').innerHTML = newCard.innerHTML;
                }
                
                // Show flash alert from new HTML if it exists
                const newFlash = doc.querySelector('[style*="background:#dcfce7"]');
                let flashEl = document.querySelector('[style*="background:#dcfce7"]');
                if (newFlash) {
                    if (!flashEl) {
                        flashEl = document.createElement('div');
                        flashEl.style.cssText = newFlash.style.cssText;
                        // Insert after header
                        document.querySelector('.aw-header').after(flashEl);
                    }
                    flashEl.innerHTML = newFlash.innerHTML;
                    flashEl.style.display = 'flex';
                } else if (flashEl) {
                    flashEl.style.display = 'none';
                }
                
                closeModal();
            } else {
                console.warn('AJAX failed, falling back to standard submit. Status:', response.status);
                form.dataset.skipAjax = "true";
                form.submit();
            }
        } catch (error) {
            console.error('Error updating status via AJAX, falling back to standard submit:', error);
            form.dataset.skipAjax = "true";
            form.submit();
        } finally {
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnHtml;
            }
        }
    });
});

// Scroll position memory to prevent scroll resets during full-page reloads/fallbacks
window.addEventListener('beforeunload', function() {
    localStorage.setItem('adminScrollPos', window.scrollY);
});

window.addEventListener('load', function() {
    const pos = localStorage.getItem('adminScrollPos');
    if (pos !== null) {
        window.scrollTo(0, parseInt(pos, 10));
        localStorage.removeItem('adminScrollPos');
    }
});
</script>
