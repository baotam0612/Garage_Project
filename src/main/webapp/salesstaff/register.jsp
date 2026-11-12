<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%-- Sales staff register view --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("csrf") == null) {
        session.setAttribute("csrf", java.util.UUID.randomUUID().toString());
    }
%>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Đăng ký tài khoản</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"></head>
<body class="sales-wireframe"><main class="sales-login-card"><h1>Đăng ký</h1><p>Tạo tài khoản nhân viên bán hàng mới</p>
<c:if test="${not empty error}"><p class="sales-message sales-error"><c:out value="${error}"/></p></c:if>
<form method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" class="sales-form-stack">
    <input type="hidden" name="csrf" value="<c:out value='${sessionScope.csrf}'/>">
    <input type="hidden" name="action" value="register">
    
    <label for="username">Tên đăng nhập *</label>
    <input id="username" name="username" required maxlength="100" placeholder="Ví dụ: sales2">
    
    <label for="fullName">Họ và tên *</label>
    <input id="fullName" name="fullName" required maxlength="160" placeholder="Ví dụ: Nguyễn Văn B">
    
    <label for="staffCode">Mã nhân viên (tùy chọn)</label>
    <input id="staffCode" name="staffCode" maxlength="40" placeholder="Ví dụ: NV002 (để trống tự sinh)">
    
    <label for="password">Mật khẩu *</label>
    <input id="password" name="password" type="password" required placeholder="Nhập mật khẩu">
    
    <label for="confirmPassword">Xác nhận mật khẩu *</label>
    <input id="confirmPassword" name="confirmPassword" type="password" required placeholder="Nhập lại mật khẩu">
    
    <button class="sales-button" type="submit" style="margin-top: 12px;">Đăng ký</button>
</form>
<div style="margin-top: 16px; padding-top: 12px; border-top: 1px solid #d3e2ef; text-align: center; font-size: 0.88rem;">
    <span>Đã có tài khoản? </span>
    <a href="${pageContext.request.contextPath}/salesstaff/login.jsp" style="color: #193d63; font-weight: 600; text-decoration: none;">Đăng nhập</a>
</div>
</main></body></html>

