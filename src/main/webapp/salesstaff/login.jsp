<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%-- Sales staff login view --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", java.util.UUID.randomUUID().toString());
    }
    Object flashMsg = session.getAttribute("flash");
    if (flashMsg != null) {
        request.setAttribute("flash", flashMsg);
        session.removeAttribute("flash");
    }
%>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Đăng nhập thanh toán</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"></head>
<body class="sales-wireframe"><main class="sales-login-card"><h1>Thanh toán</h1><p>Đăng nhập nhân viên bán hàng</p>
<c:if test="${not empty flash}"><p class="sales-message sales-success"><c:out value="${flash}"/></p></c:if>
<c:if test="${not empty error}"><p class="sales-message sales-error"><c:out value="${error}"/></p></c:if>
<form method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" class="sales-form-stack">
    <input type="hidden" name="csrf" value="<c:out value='${sessionScope.csrf}'/>">
    <input type="hidden" name="action" value="login">
    <label for="username">Tên đăng nhập</label>
    <input id="username" name="username" autocomplete="username" required maxlength="100">
    <label for="password">Mật khẩu</label>
    <input id="password" name="password" type="password" autocomplete="current-password" required>
    <button class="sales-button" type="submit">Đăng nhập</button>
</form>
<div style="margin-top: 16px; padding-top: 12px; border-top: 1px solid #d3e2ef; display: flex; justify-content: space-between; font-size: 0.88rem;">
    <a href="${pageContext.request.contextPath}/salesstaff/register.jsp" style="color: #193d63; text-decoration: none; font-weight: 500;">Đăng ký tài khoản</a>
    <a href="${pageContext.request.contextPath}/salesstaff/forgot-password.jsp" style="color: #60778e; text-decoration: none;">Quên mật khẩu?</a>
</div>
</main></body></html>
