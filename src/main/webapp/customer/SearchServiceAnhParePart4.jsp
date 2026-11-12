<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.ServiceDAO,com.garage.dao.SparePartDAO,com.garage.model.Service4,com.garage.model.SparePart4,java.util.ArrayList,java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String rawKeyword = request.getParameter("txtKeyword");
    String keyword = rawKeyword == null ? "" : rawKeyword.trim();
    if (keyword.length() > 100) keyword = keyword.substring(0, 100);
    String type = request.getParameter("cboType");
    if (!"SERVICE".equals(type) && !"SPARE_PART".equals(type)) type = "ALL";

    List<Service4> services = new ArrayList<>();
    List<SparePart4> spareParts = new ArrayList<>();
    String error = null;
    if (!keyword.isEmpty()) {
        try {
            if ("ALL".equals(type) || "SERVICE".equals(type)) {
                services = new ServiceDAO().searchServices(keyword);
            }
            if ("ALL".equals(type) || "SPARE_PART".equals(type)) {
                spareParts = new SparePartDAO().searchSpareParts(keyword);
            }
        } catch (java.sql.SQLException exception) {
            application.log("Không đọc được danh mục", exception);
            error = "Không đọc được dữ liệu. Hãy kiểm tra kết nối MySQL và thử lại.";
        }
    }
    request.setAttribute("searched", rawKeyword != null);
    request.setAttribute("keyword", keyword);
    request.setAttribute("type", type);
    request.setAttribute("services", services);
    request.setAttribute("spareParts", spareParts);
    request.setAttribute("error", error);
%>
<!doctype html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Tìm kiếm dịch vụ và phụ tùng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"></head>
<body class="customer-wireframe"><main class="customer-screen customer-search-screen">
<nav class="customer-breadcrumb"><a href="${pageContext.request.contextPath}/customer/CustomerHome4.jsp">Trang chủ khách hàng</a><span>/</span><span>Tìm kiếm</span></nav>
<h1>Tìm kiếm dịch vụ và phụ tùng</h1>
<form class="customer-search-form" action="${pageContext.request.contextPath}/customer/SearchServiceAnhParePart4.jsp" method="get">
    <label class="visually-hidden" for="txtKeyword">Từ khóa tìm kiếm</label><input id="txtKeyword" name="txtKeyword" type="search" maxlength="100" required value="<c:out value='${keyword}'/>" placeholder="Nhập tên dịch vụ hoặc phụ tùng">
    <label class="visually-hidden" for="cboType">Loại hạng mục</label><select id="cboType" name="cboType"><option value="ALL" ${type eq 'ALL' ? 'selected' : ''}>Tất cả</option><option value="SERVICE" ${type eq 'SERVICE' ? 'selected' : ''}>Dịch vụ</option><option value="SPARE_PART" ${type eq 'SPARE_PART' ? 'selected' : ''}>Phụ tùng</option></select>
    <button id="btnSearch" type="submit">Tìm kiếm</button>
</form>
<c:choose><c:when test="${not empty error}"><p class="customer-message customer-error" role="alert"><c:out value="${error}"/></p></c:when><c:when test="${searched and empty services and empty spareParts}"><p class="customer-message">Không tìm thấy kết quả phù hợp.</p></c:when><c:when test="${not empty services or not empty spareParts}"><div class="customer-table-scroll"><table id="tblResult" class="customer-result-table"><thead><tr><th>TT</th><th>Mã</th><th>Ảnh minh họa</th><th>Tên dịch vụ/phụ tùng</th><th>Loại</th><th>Đơn giá</th><th>Mô tả</th><th>Thao tác</th></tr></thead><tbody>
<c:forEach var="item" items="${services}" varStatus="row"><tr><td>${row.count}</td><td><c:out value="${item.serviceCode}"/></td><td><div class="customer-thumb">Ảnh <c:out value="${item.serviceCode}"/></div></td><td><c:out value="${item.serviceName}"/></td><td>Dịch vụ</td><td><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đồng</td><td><c:out value="${item.description}"/></td><td><c:url var="detailUrl" value="/customer/ServiceDetail4.jsp"><c:param name="id" value="${item.id}"/><c:param name="txtKeyword" value="${keyword}"/><c:param name="cboType" value="${type}"/></c:url><a class="customer-action-button" href="${detailUrl}">Xem chi tiết</a></td></tr></c:forEach>
<c:forEach var="item" items="${spareParts}" varStatus="row"><tr><td>${services.size() + row.count}</td><td><c:out value="${item.partCode}"/></td><td><div class="customer-thumb">Ảnh <c:out value="${item.partCode}"/></div></td><td><c:out value="${item.partName}"/></td><td>Phụ tùng</td><td><fmt:formatNumber value="${item.sellingPrice}" pattern="#,##0"/> đồng</td><td><c:out value="${item.description}"/></td><td><c:url var="detailUrl" value="/customer/SparePartDetail4.jsp"><c:param name="id" value="${item.id}"/><c:param name="txtKeyword" value="${keyword}"/><c:param name="cboType" value="${type}"/></c:url><a class="customer-action-button" href="${detailUrl}">Xem chi tiết</a></td></tr></c:forEach>
</tbody></table></div></c:when></c:choose>
</main></body></html>
