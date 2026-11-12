<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%-- Sales staff module entry point --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.garage.dao.InvoiceDAO" %>
<%@ page import="com.garage.model.SalesStaff4" %>
<%@ page import="com.garage.model.Invoice4" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    InvoiceDAO invoiceDAO = new InvoiceDAO();
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", UUID.randomUUID().toString());
        session.setMaxInactiveInterval(30 * 60);
    }
    String error = null;
    String action = request.getParameter("action");
    String staffId = (String) session.getAttribute("salesStaffId");
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            if (!session.getAttribute("csrf").equals(request.getParameter("csrf"))) {
                throw new IllegalArgumentException("Phiên làm việc không hợp lệ. Hãy tải lại trang.");
            }
            if ("login".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                SalesStaff4 identity = username == null || password == null || username.isBlank() || password.isBlank()
                        ? null : invoiceDAO.findSalesStaffByUsername(username.trim());
                if (identity == null || !InvoiceDAO.verifyPassword(password, identity.getAccount().getPasswordHash())) {
                    throw new IllegalArgumentException("Tên đăng nhập hoặc mật khẩu không đúng.");
                }
                session.invalidate();
                session = request.getSession(true);
                session.setAttribute("salesStaffId", identity.getId());
                session.setAttribute("salesStaffName", identity.getFullName());
                session.setAttribute("csrf", UUID.randomUUID().toString());
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/salesstaff/SalesHomeUI4.jsp");
                return;
            }
            if ("register".equals(action)) {
                String username = request.getParameter("username");
                String fullName = request.getParameter("fullName");
                String staffCode = request.getParameter("staffCode");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                if (password == null || !password.equals(confirmPassword)) {
                    throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
                }
                invoiceDAO.registerSalesStaff(username, password, fullName, staffCode);
                session.setAttribute("flash", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/salesstaff/login.jsp");
                return;
            }
            if ("forgot_password".equals(action)) {
                String username = request.getParameter("username");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                if (newPassword == null || !newPassword.equals(confirmPassword)) {
                    throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
                }
                invoiceDAO.resetPassword(username, newPassword);
                session.setAttribute("flash", "Đổi mật khẩu thành công! Hãy đăng nhập lại bằng mật khẩu mới.");
                response.sendRedirect(request.getContextPath() + "/salesstaff/login.jsp");
                return;
            }
            if (staffId == null) { throw new IllegalStateException("Hãy đăng nhập để tiếp tục."); }
            if ("logout".equals(action)) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/salesstaff/SalesHomeUI4.jsp");
                return;
            }
            String invoiceId = request.getParameter("invoice");
            if ("add".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity < 1 || quantity > 999) throw new IllegalArgumentException("Số lượng phải từ 1 đến 999.");
                invoiceDAO.addItem(invoiceId, request.getParameter("type"), request.getParameter("itemId"), quantity);
            } else if ("confirm".equals(action)) {
                invoiceDAO.confirm(invoiceId, staffId);
                session.setAttribute("flash", "Đã xác nhận hóa đơn. Vui lòng ghi nhận thanh toán.");
                response.sendRedirect(request.getContextPath() + "/salesstaff/PaymentUI4.jsp?invoice="
                        + URLEncoder.encode(invoiceId, StandardCharsets.UTF_8));
                return;
            } else if ("pay".equals(action)) {
                String receivedText = request.getParameter("received");
                if (receivedText == null || receivedText.isBlank()) {
                    throw new IllegalArgumentException("Hãy nhập số tiền đã nhận.");
                }
                BigDecimal received = new BigDecimal(receivedText);
                if (received.signum() < 0) throw new IllegalArgumentException("Số tiền nhận không hợp lệ.");
                invoiceDAO.pay(invoiceId, staffId, request.getParameter("method"), received);
                session.setAttribute("flash", "Thanh toán thành công. Hóa đơn đã được cập nhật.");
                response.sendRedirect(request.getContextPath() + "/salesstaff/PrintInvoiceUI4.jsp?invoice="
                        + URLEncoder.encode(invoiceId, StandardCharsets.UTF_8));
                return;
            } else {
                throw new IllegalArgumentException("Thao tác không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/salesstaff/InvoiceDetailUI4.jsp?invoice="
                    + URLEncoder.encode(invoiceId, StandardCharsets.UTF_8));
            return;
        } catch (IllegalArgumentException | IllegalStateException exception) {
            error = exception.getMessage();
            if ("register".equals(action)) {
                request.setAttribute("error", error);
                request.getRequestDispatcher("/salesstaff/register.jsp").forward(request, response);
                return;
            }
            if ("forgot_password".equals(action)) {
                request.setAttribute("error", error);
                request.getRequestDispatcher("/salesstaff/forgot-password.jsp").forward(request, response);
                return;
            }
        } catch (SQLException exception) {
            error = "Không thể lưu dữ liệu (" + exception.getMessage() + "). Hãy kiểm tra kết nối MySQL và thử lại.";
            application.log("Payment operation failed", exception);
            if ("register".equals(action)) {
                request.setAttribute("error", error);
                request.getRequestDispatcher("/salesstaff/register.jsp").forward(request, response);
                return;
            }
            if ("forgot_password".equals(action)) {
                request.setAttribute("error", error);
                request.getRequestDispatcher("/salesstaff/forgot-password.jsp").forward(request, response);
                return;
            }
        }
    }
    request.setAttribute("error", error);
    request.setAttribute("csrf", session.getAttribute("csrf"));
    request.setAttribute("staffName", session.getAttribute("salesStaffName"));
    Object flash = session.getAttribute("flash");
    if (flash != null) { request.setAttribute("flash", flash); session.removeAttribute("flash"); }
    staffId = (String) session.getAttribute("salesStaffId");
    if (staffId == null) {
        request.getRequestDispatcher("/salesstaff/login.jsp").forward(request, response);
        return;
    }
    try {
        String invoiceId = request.getParameter("invoice");
        String customerId = request.getParameter("customer");
        if (invoiceId != null && !invoiceId.isBlank()) {
            Invoice4 invoice = invoiceDAO.getInvoiceById(invoiceId);
            if (invoice == null) { response.sendError(404); return; }
            request.setAttribute("invoice", invoice);
            request.setAttribute("printView", "1".equals(request.getParameter("print")));
            request.getRequestDispatcher("/salesstaff/InvoiceDetailUI4.jsp").forward(request, response);
            return;
        } else if (customerId != null && !customerId.isBlank()) {
            Invoice4 invoice = invoiceDAO.getUnpaidInvoiceByCustomer(customerId);
            if (invoice != null) {
                response.sendRedirect(request.getContextPath() + "/salesstaff/InvoiceDetailUI4.jsp?invoice="
                        + URLEncoder.encode(invoice.getId(), StandardCharsets.UTF_8));
                return;
            }
            request.setAttribute("searchView", true);
            request.setAttribute("q", "");
            request.setAttribute("searched", false);
            request.setAttribute("customers", List.of());
            request.setAttribute("error", "Khách hàng này không có hóa đơn chưa thanh toán.");
        } else {
            String q = request.getParameter("q");
            request.setAttribute("searchView", "search".equalsIgnoreCase(request.getParameter("view")) || q != null);
            request.setAttribute("q", q == null ? "" : q);
            request.setAttribute("searched", q != null && !q.isBlank());
            request.setAttribute("customers", q == null || q.isBlank() ? List.of() : invoiceDAO.searchCustomers(q.trim().length() > 100 ? q.trim().substring(0, 100) : q.trim()));
        }
    } catch (SQLException exception) {
        application.log("Payment data load failed", exception);
        request.setAttribute("error", "Không đọc được dữ liệu. Hãy kiểm tra kết nối MySQL.");
    }
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:choose><c:when test="${searchView}">Tìm khách hàng</c:when><c:otherwise>Trang chủ nhân viên bán hàng</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body class="sales-wireframe">
<main class="sales-screen">
    <nav class="sales-topbar">
        <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">Trang chủ</a>
        <span class="sales-staff"><c:out value="${staffName}"/></span>
        <form method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">
            <input type="hidden" name="csrf" value="<c:out value='${csrf}'/>">
            <input type="hidden" name="action" value="logout">
            <button class="sales-link-button" type="submit">Đăng xuất</button>
        </form>
    </nav>

    <c:if test="${not empty flash}"><p class="sales-message sales-success"><c:out value="${flash}"/></p></c:if>
    <c:if test="${not empty error}"><p class="sales-message sales-error"><c:out value="${error}"/></p></c:if>

    <c:choose>
        <c:when test="${searchView}">
            <h1>Tìm khách hàng</h1>
            <section class="sales-search-page">
                <form class="sales-search-form" method="get" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">
                    <input type="hidden" name="view" value="search">
                    <label for="q">Tên khách hàng:</label>
                    <input id="q" name="q" type="search" maxlength="100" required value="<c:out value='${q}'/>" placeholder="Nhập tên khách hàng">
                    <button class="sales-button" type="submit">Tìm kiếm</button>
                </form>

                <c:choose>
                    <c:when test="${searched and empty customers}"><p class="sales-message">Không tìm thấy khách hàng. Hãy nhập lại từ khóa.</p></c:when>
                    <c:when test="${not empty customers}">
                        <div class="sales-table-scroll"><table class="sales-table"><thead><tr><th>TT</th><th>Mã khách hàng</th><th>Thông tin xe</th><th>Họ tên</th><th>Số điện thoại</th><th>Thao tác</th></tr></thead><tbody>
                        <c:forEach var="row" items="${customers}" varStatus="loop"><c:url var="url" value="/salesstaff/SalesHomeUI4.jsp"><c:param name="customer" value="${row.id}"/></c:url><tr><td>${loop.count}</td><td><c:out value="${row.customerCode}"/></td><td><c:forEach var="vehicle" items="${row.vehicles}" varStatus="vehicleStatus"><c:if test="${not vehicleStatus.first}">; </c:if><c:out value="${vehicle.licensePlate}"/> · <c:out value="${vehicle.make}"/> <c:out value="${vehicle.model}"/></c:forEach></td><td><c:out value="${row.fullName}"/></td><td><c:out value="${row.phoneNumber}"/></td><td><a class="sales-button sales-small-button" href="${url}">Chọn</a></td></tr></c:forEach>
                        </tbody></table></div>
                    </c:when>
                </c:choose>
            </section>
        </c:when>

        <c:otherwise>
            <h1>Trang chủ</h1>
            <section class="sales-home-grid" aria-label="Chức năng nhân viên bán hàng">
                <span class="sales-home-tile sales-home-tile-disabled" aria-disabled="true"><b aria-hidden="true">▱</b><span>Tiếp nhận xe</span></span>
                <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp?view=search" class="sales-home-tile sales-home-tile-active"><b aria-hidden="true">▣</b><span>Thanh toán</span></a>
                <span class="sales-home-tile sales-home-tile-disabled" aria-disabled="true"><b aria-hidden="true">▤</b><span>Quản lý dịch vụ</span></span>
                <span class="sales-home-tile sales-home-tile-disabled" aria-disabled="true"><b aria-hidden="true">▧</b><span>Quản lý phụ tùng</span></span>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
