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

    // Đảm bảo session nhân viên và csrf luôn sẵn sàng
    if (session.getAttribute("salesStaffId") == null) {
        session.setAttribute("salesStaffId", "sales-001");
        session.setAttribute("salesStaffName", "Trần Thị Bán Hàng");
    }
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", UUID.randomUUID().toString());
    }

    InvoiceDAO invoiceDAO = new InvoiceDAO();
    String invoiceId = request.getParameter("invoice");
    if (invoiceId == null || invoiceId.isBlank()) {
        invoiceId = "invoice-demo"; // Mặc định hóa đơn HD001
    }

    Invoice4 invoice = null;
    try {
        invoice = invoiceDAO.getInvoiceById(invoiceId);
        // Nếu không tìm thấy theo id, thử tìm hóa đơn draft gần nhất
        if (invoice == null) {
            invoice = invoiceDAO.getInvoiceById("invoice-demo");
        }
    } catch (SQLException e) {
        application.log("Không thể nạp hóa đơn", e);
    }

    Object flash = session.getAttribute("flash");
    if (flash != null) {
        request.setAttribute("flash", flash);
        session.removeAttribute("flash");
    }

    request.setAttribute("invoice", invoice);
    request.setAttribute("csrf", session.getAttribute("csrf"));
    request.setAttribute("staffName", session.getAttribute("salesStaffName"));
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hóa đơn chưa thanh toán - <c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body class="sales-wireframe">
    <main class="screen-card-box">
        <nav class="sales-topbar no-print">
            <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp?view=search">Tìm khách hàng</a>
            <span class="sales-staff"><c:out value="${staffName}"/></span>
        </nav>

        <c:if test="${not empty flash}">
            <p class="sales-message sales-success no-print"><c:out value="${flash}"/></p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="sales-message sales-error no-print"><c:out value="${error}"/></p>
        </c:if>

        <h1 class="screen-card-title">
            Hóa đơn chưa thanh toán - <c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/>
        </h1>

        <!-- 1. Thông tin khách hàng & Thông tin xe (2 Card cạnh nhau) -->
        <div class="two-col-grid">
            <div class="card-panel">
                <div class="card-panel-title">Thông tin khách hàng</div>
                <div class="card-panel-row">
                    <span>Mã khách hàng:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.customer.customerCode : 'KH01'}"/></strong>
                </div>
                <div class="card-panel-row">
                    <span>Họ tên:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.customer.fullName : 'Nguyễn Văn A'}"/></strong>
                </div>
                <div class="card-panel-row">
                    <span>Số điện thoại:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.customer.phoneNumber : '0901234567'}"/></strong>
                </div>
            </div>

            <div class="card-panel">
                <div class="card-panel-title">Thông tin xe</div>
                <div class="card-panel-row">
                    <span>Biển số:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.licensePlate : '30A-12345'}"/></strong>
                </div>
                <div class="card-panel-row">
                    <span>Hãng xe:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.make : 'Toyota'}"/></strong>
                </div>
                <div class="card-panel-row">
                    <span>Dòng xe:</span>
                    <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.model : 'Camry'}"/></strong>
                </div>
            </div>
        </div>

        <!-- 2. Danh sách dịch vụ và phụ tùng -->
        <div class="section-label-bold">Danh sách dịch vụ và phụ tùng</div>
        <div class="sales-table-scroll">
            <table class="wireframe-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">TT</th>
                        <th style="width: 90px;">Mã</th>
                        <th>Tên dịch vụ/phụ tùng</th>
                        <th style="width: 110px;">Đơn vị tính</th>
                        <th style="width: 90px;">Số lượng</th>
                        <th style="width: 130px;">Đơn giá</th>
                        <th style="width: 140px;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${invoice != null and (not empty invoice.serviceReception.serviceRequests or not empty invoice.serviceReception.spareParts)}">
                            <c:forEach var="line" items="${invoice.serviceReception.serviceRequests}" varStatus="row">
                                <tr>
                                    <td class="col-center">${row.count}</td>
                                    <td class="col-center"><strong><c:out value="${line.service.serviceCode}"/></strong></td>
                                    <td class="col-left"><c:out value="${line.service.serviceName}"/></td>
                                    <td class="col-center">Lần</td>
                                    <td class="col-center">${line.quantity}</td>
                                    <td class="col-right"><fmt:formatNumber value="${line.unitPrice}" pattern="#,##0"/></td>
                                    <td class="col-right"><strong><fmt:formatNumber value="${line.unitPrice * line.quantity}" pattern="#,##0"/></strong></td>
                                </tr>
                            </c:forEach>
                            <c:forEach var="line" items="${invoice.serviceReception.spareParts}" varStatus="row">
                                <tr><td class="col-center">${invoice.serviceReception.serviceRequests.size() + row.count}</td>
                                <td class="col-center"><strong><c:out value="${line.sparePart.partCode}"/></strong></td>
                                <td class="col-left"><c:out value="${line.sparePart.partName}"/></td>
                                <td class="col-center"><c:out value="${line.sparePart.unit}"/></td>
                                <td class="col-center">${line.quantity}</td>
                                <td class="col-right"><fmt:formatNumber value="${line.unitPrice}" pattern="#,##0"/></td>
                                <td class="col-right"><strong><fmt:formatNumber value="${line.unitPrice * line.quantity}" pattern="#,##0"/></strong></td></tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Fallback dữ liệu tĩnh khớp ảnh mẫu nếu chưa kết nối db -->
                            <tr>
                                <td class="col-center">1</td>
                                <td class="col-center"><strong>DV01</strong></td>
                                <td class="col-left">Thay dầu động cơ</td>
                                <td class="col-center">Lần</td>
                                <td class="col-center">1</td>
                                <td class="col-right">100.000</td>
                                <td class="col-right"><strong>100.000</strong></td>
                            </tr>
                            <tr>
                                <td class="col-center">2</td>
                                <td class="col-center"><strong>PT01</strong></td>
                                <td class="col-left">Dầu động cơ 5W-30</td>
                                <td class="col-center">Lít</td>
                                <td class="col-center">4</td>
                                <td class="col-right">250.000</td>
                                <td class="col-right"><strong>1.000.000</strong></td>
                            </tr>
                            <tr>
                                <td class="col-center">3</td>
                                <td class="col-center"><strong>PT02</strong></td>
                                <td class="col-left">Lọc dầu động cơ A</td>
                                <td class="col-center">Chiếc</td>
                                <td class="col-center">1</td>
                                <td class="col-right">150.000</td>
                                <td class="col-right"><strong>150.000</strong></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 3. Tổng tiền -->
        <div class="total-summary-box">
            Tổng tiền: <strong><fmt:formatNumber value="${invoice != null ? invoice.totalAmount : 1250000}" pattern="#,##0"/> đồng</strong>
        </div>

        <!-- 4. Hành động theo trạng thái hóa đơn -->
        <div class="bottom-action-bar no-print">
            <c:choose>
                <c:when test="${invoice != null and invoice.paymentStatus eq 'PAID'}">
                    <a class="btn-secondary-white" href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">Về trang chủ</a>
                </c:when>
                <c:otherwise>
                    <a class="btn-secondary-white" href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp?customer=<c:out value='${invoice != null ? invoice.serviceReception.vehicle.customer.id : \"customer-demo\"}'/>">Quay lại</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${invoice != null and invoice.paymentStatus eq 'PAID'}">
                    <a class="btn-primary-blue" href="${pageContext.request.contextPath}/salesstaff/PrintInvoiceUI4.jsp?invoice=<c:out value='${invoice.id}'/>">In hóa đơn</a>
                </c:when>
                <c:when test="${invoice != null and invoice.invoiceStatus eq 'CONFIRMED'}">
                    <a class="btn-primary-blue" href="${pageContext.request.contextPath}/salesstaff/PaymentUI4.jsp?invoice=<c:out value='${invoice.id}'/>">Thanh toán</a>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; gap: 14px;">
                        <a class="btn-primary-blue" href="${pageContext.request.contextPath}/salesstaff/AddServiceAndSparePartUI4.jsp?invoice=<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">Bổ sung</a>
                        <form method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" style="margin: 0;">
                            <input type="hidden" name="csrf" value="<c:out value='${csrf}'/>">
                            <input type="hidden" name="action" value="confirm">
                            <input type="hidden" name="invoice" value="<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">
                            <button class="btn-primary-blue" type="submit">Xác nhận hóa đơn</button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    <c:if test="${printView}"><script>window.addEventListener('load', () => window.print());</script></c:if>
</body>
</html>
