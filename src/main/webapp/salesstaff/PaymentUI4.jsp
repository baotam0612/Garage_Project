<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.InvoiceDAO" %>
<%@ page import="com.garage.model.Invoice4" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.UUID" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    if (session.getAttribute("salesStaffId") == null) {
        response.sendRedirect(request.getContextPath() + "/salesstaff/SalesHomeUI4.jsp");
        return;
    }
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", UUID.randomUUID().toString());
    }

    String invoiceId = request.getParameter("invoice");
    Invoice4 invoice = null;
    String loadError = null;
    try {
        if (invoiceId != null && !invoiceId.isBlank()) {
            invoice = new InvoiceDAO().getInvoiceById(invoiceId);
        }
    } catch (SQLException exception) {
        application.log("Không thể nạp hóa đơn thanh toán", exception);
        loadError = "Không thể đọc hóa đơn. Hãy kiểm tra kết nối dữ liệu.";
    }
    request.setAttribute("invoice", invoice);
    request.setAttribute("csrf", session.getAttribute("csrf"));
    request.setAttribute("staffName", session.getAttribute("salesStaffName"));
    request.setAttribute("error", loadError);
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán hóa đơn<c:if test="${invoice != null}"> - <c:out value="${invoice.invoiceNumber}"/></c:if></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body class="sales-wireframe">
<main class="screen-card-box">
    <nav class="sales-topbar no-print">
        <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/salesstaff/InvoiceDetailUI4.jsp?invoice=<c:out value='${param.invoice}'/>">Chi tiết hóa đơn</a>
        <span class="sales-staff"><c:out value="${staffName}"/></span>
    </nav>

    <c:choose>
        <c:when test="${not empty error}"><p class="sales-message sales-error"><c:out value="${error}"/></p></c:when>
        <c:when test="${invoice == null}"><p class="sales-message sales-error">Không tìm thấy hóa đơn cần thanh toán.</p></c:when>
        <c:when test="${invoice.paymentStatus eq 'PAID'}">
            <p class="sales-message sales-success">Hóa đơn này đã được thanh toán.</p>
            <a class="btn-primary-blue" href="${pageContext.request.contextPath}/salesstaff/PrintInvoiceUI4.jsp?invoice=<c:out value='${invoice.id}'/>">In hóa đơn</a>
        </c:when>
        <c:when test="${invoice.invoiceStatus ne 'CONFIRMED'}">
            <p class="sales-message sales-error">Hãy xác nhận hóa đơn trước khi thanh toán.</p>
            <a class="btn-secondary-white" href="${pageContext.request.contextPath}/salesstaff/InvoiceDetailUI4.jsp?invoice=<c:out value='${invoice.id}'/>">Quay lại hóa đơn</a>
        </c:when>
        <c:otherwise>
            <h1 class="screen-card-title">Thanh toán hóa đơn - <c:out value="${invoice.invoiceNumber}"/></h1>
            <form id="paymentForm" class="payment-workflow" method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" data-total="<fmt:formatNumber value='${invoice.totalAmount}' groupingUsed='false'/>">
                <input type="hidden" name="csrf" value="<c:out value='${csrf}'/>">
                <input type="hidden" name="action" value="pay">
                <input type="hidden" name="invoice" value="<c:out value='${invoice.id}'/>">
                <input type="hidden" id="paymentMethod" name="method" value="CASH">
                <input type="hidden" id="received" name="received" value="<fmt:formatNumber value='${invoice.totalAmount}' groupingUsed='false'/>">

                <div class="payment-layout">
                    <section class="payment-card">
                        <h2>Thông tin hóa đơn</h2>
                        <dl class="payment-summary">
                            <dt>Mã hóa đơn:</dt><dd><c:out value="${invoice.invoiceNumber}"/></dd>
                            <dt>Tổng tiền:</dt><dd><strong><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0"/> đồng</strong></dd>
                            <dt>Khách hàng:</dt><dd><c:out value="${invoice.serviceReception.vehicle.customer.fullName}"/></dd>
                            <dt>Biển số xe:</dt><dd><c:out value="${invoice.serviceReception.vehicle.licensePlate}"/></dd>
                        </dl>
                    </section>

                    <section class="payment-card payment-method-card">
                        <h2>Phương thức thanh toán</h2>
                        <div class="payment-methods" role="radiogroup" aria-label="Phương thức thanh toán">
                            <label><input type="radio" name="paymentMethodChoice" value="CASH" checked> Tiền mặt</label>
                            <label><input type="radio" name="paymentMethodChoice" value="BANK_TRANSFER"> Chuyển khoản</label>
                        </div>

                        <div id="cashFields" class="cash-fields">
                            <label for="tendered">Số tiền khách đưa</label>
                            <div class="money-input"><input id="tendered" type="text" inputmode="numeric" autocomplete="off" value="<fmt:formatNumber value='${invoice.totalAmount}' groupingUsed='false'/>"><span>đồng</span></div>
                            <div class="quick-amounts"><button type="button" data-extra="0">Đúng số tiền</button><button type="button" data-extra="50000">+50.000</button><button type="button" data-extra="100000">+100.000</button></div>
                            <label for="changeAmount">Tiền trả lại</label>
                            <div class="money-input money-readonly"><output id="changeAmount">0</output><span>đồng</span></div>
                            <p id="paymentWarning" class="payment-warning" aria-live="polite"></p>
                        </div>
                        <p id="transferNote" class="payment-note" hidden>Khách chuyển đúng <strong><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0"/> đồng</strong>. Hãy kiểm tra tiền đã vào tài khoản trước khi xác nhận.</p>
                    </section>
                </div>

                <div class="payment-actions no-print">
                    <a class="btn-secondary-white" href="${pageContext.request.contextPath}/salesstaff/InvoiceDetailUI4.jsp?invoice=<c:out value='${invoice.id}'/>">Quay lại</a>
                    <button id="confirmPayment" class="btn-primary-blue" type="submit">Xác nhận đã nhận thanh toán</button>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</main>

<c:if test="${invoice != null and invoice.invoiceStatus eq 'CONFIRMED' and invoice.paymentStatus eq 'UNPAID'}">
<script>
(() => {
    const form = document.getElementById('paymentForm');
    const total = Number(form.dataset.total);
    const tendered = document.getElementById('tendered');
    const received = document.getElementById('received');
    const method = document.getElementById('paymentMethod');
    const cashFields = document.getElementById('cashFields');
    const transferNote = document.getElementById('transferNote');
    const change = document.getElementById('changeAmount');
    const warning = document.getElementById('paymentWarning');
    const submit = document.getElementById('confirmPayment');
    const format = amount => new Intl.NumberFormat('vi-VN').format(amount);
    const parse = value => Number(String(value).replace(/\D/g, '')) || 0;

    function updateCash() {
        const paid = parse(tendered.value);
        const difference = paid - total;
        received.value = paid;
        change.textContent = difference >= 0 ? format(difference) : '0';
        warning.textContent = difference < 0 ? 'Còn thiếu ' + format(Math.abs(difference)) + ' đồng.' : '';
        submit.disabled = difference < 0;
    }
    function updateMethod(choice) {
        method.value = choice;
        const cash = choice === 'CASH';
        cashFields.hidden = !cash;
        transferNote.hidden = cash;
        received.value = cash ? parse(tendered.value) : total;
        submit.disabled = false;
        if (cash) updateCash();
    }
    tendered.addEventListener('input', updateCash);
    tendered.addEventListener('blur', () => { tendered.value = format(parse(tendered.value)); updateCash(); });
    document.querySelectorAll('input[name="paymentMethodChoice"]').forEach(input => input.addEventListener('change', () => updateMethod(input.value)));
    document.querySelectorAll('[data-extra]').forEach(button => button.addEventListener('click', () => { tendered.value = format(total + Number(button.dataset.extra)); updateCash(); }));
    form.addEventListener('submit', event => { if (method.value === 'CASH' && parse(tendered.value) < total) event.preventDefault(); });
    updateCash();
})();
</script>
</c:if>
</body>
</html>
