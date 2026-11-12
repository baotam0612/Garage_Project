<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%-- Sales staff forgot password view --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", java.util.UUID.randomUUID().toString());
    }
%>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Quên mật khẩu</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"></head>
<body class="sales-wireframe"><main class="sales-login-card"><h1>Quên mật khẩu</h1><p>Đặt lại mật khẩu trực tiếp cho tài khoản</p>
<c:if test="${not empty error}"><p class="sales-message sales-error"><c:out value="${error}"/></p></c:if>
<form method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" class="sales-form-stack">
    <input type="hidden" name="csrf" value="<c:out value='${sessionScope.csrf}'/>">
    <input type="hidden" name="action" value="forgot_password">
    
    <label for="username">Tên đăng nhập *</label>
    <input id="username" name="username" required maxlength="100" placeholder="Nhập tên đăng nhập của bạn">
    
    <label for="newPassword">Mật khẩu mới *</label>
    <input id="newPassword" name="newPassword" type="password" required placeholder="Nhập mật khẩu mới">
    
    <label for="confirmPassword">Nhập lại mật khẩu mới *</label>
    <input id="confirmPassword" name="confirmPassword" type="password" required placeholder="Xác nhận mật khẩu mới">
    
    <button class="sales-button" type="submit" style="margin-top: 12px;">Đổi mật khẩu</button>
</form>
<div style="margin-top: 16px; padding-top: 12px; border-top: 1px solid #d3e2ef; text-align: center; font-size: 0.88rem;">
    <a href="${pageContext.request.contextPath}/salesstaff/login.jsp" style="color: #193d63; text-decoration: none;">Quay lại đăng nhập</a>
</div>
</main></body></html>

