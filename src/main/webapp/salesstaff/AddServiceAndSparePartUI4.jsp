<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.InvoiceDAO" %>
<%@ page import="com.garage.dao.ServiceDAO" %>
<%@ page import="com.garage.dao.SparePartDAO" %>
<%@ page import="com.garage.model.Invoice4" %>
<%@ page import="com.garage.model.Service4" %>
<%@ page import="com.garage.model.SparePart4" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.List" %>
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

    String invoiceId = request.getParameter("invoice");
    if (invoiceId == null || invoiceId.isBlank()) {
        invoiceId = "invoice-demo"; // Mặc định hóa đơn HD001
    }

    InvoiceDAO invoiceDAO = new InvoiceDAO();
    Invoice4 invoice = null;
    try {
        invoice = invoiceDAO.getInvoiceById(invoiceId);
        if (invoice == null) {
            invoice = invoiceDAO.getInvoiceById("invoice-demo");
        }
    } catch (SQLException e) {
        application.log("Error loading invoice for add screen", e);
    }

    String itemType = request.getParameter("itemType");
    if (itemType == null || itemType.isBlank()) {
        itemType = "ALL";
    }

    String keyword = request.getParameter("txtKeyword");
    if (keyword == null) {
        keyword = request.getParameter("itemQ");
    }
    if (keyword == null) {
        keyword = "dầu"; // Mặc định từ khóa "dầu" theo ảnh mẫu
    }
    keyword = keyword.trim();

    List<Service4> services = new ArrayList<>();
    List<SparePart4> spareParts = new ArrayList<>();
    String catalogError = null;
    try {
        ServiceDAO serviceDAO = new ServiceDAO();
        SparePartDAO sparePartDAO = new SparePartDAO();

        boolean loadServices = "ALL".equalsIgnoreCase(itemType) || "SERVICE".equalsIgnoreCase(itemType);
        boolean loadParts = "ALL".equalsIgnoreCase(itemType) || "SPARE_PART".equalsIgnoreCase(itemType);

        if (loadServices) {
            services = keyword.isEmpty() ? serviceDAO.searchServices("") : serviceDAO.searchServices(keyword);
            services.removeIf(s -> "DV01".equalsIgnoreCase(s.getServiceCode()));
        }

        if (loadParts) {
            spareParts = keyword.isEmpty() ? sparePartDAO.searchSpareParts("") : sparePartDAO.searchSpareParts(keyword);
            spareParts.removeIf(p -> "PT01".equalsIgnoreCase(p.getPartCode()) || "PT02".equalsIgnoreCase(p.getPartCode()));
        }

    } catch (SQLException e) {
        application.log("Error loading catalog for add screen", e);
        catalogError = "Không thể tải danh mục từ MySQL: " + e.getMessage();
    }

    // Nếu không có item nào từ db, fallback danh sách mẫu theo đúng Ảnh 2:
    if (services.isEmpty() && spareParts.isEmpty()) {
        Service4 sampleService = new Service4(); sampleService.setId("svc-inject-clean"); sampleService.setServiceCode("DV02"); sampleService.setServiceName("Vệ sinh kim phun"); sampleService.setPrice(new java.math.BigDecimal("200000")); services.add(sampleService);
        SparePart4 samplePart = new SparePart4(); samplePart.setId("part-coolant"); samplePart.setPartCode("PT03"); samplePart.setPartName("Nước làm mát"); samplePart.setUnit("Lít"); samplePart.setSellingPrice(new java.math.BigDecimal("120000")); spareParts.add(samplePart);
    }

    SparePart4 defaultPart = spareParts.isEmpty() ? null : spareParts.get(0);
    Service4 defaultService = defaultPart == null && !services.isEmpty() ? services.get(0) : null;
    String defaultId = defaultPart != null ? defaultPart.getId() : defaultService != null ? defaultService.getId() : "";
    String defaultCode = defaultPart != null ? defaultPart.getPartCode() : defaultService != null ? defaultService.getServiceCode() : "";
    String defaultName = defaultPart != null ? defaultPart.getPartName() : defaultService != null ? defaultService.getServiceName() : "";
    String defaultType = defaultPart != null ? "SPARE_PART" : "SERVICE";
    int defaultSelectedRow = services.size() + (defaultPart != null ? 1 : 0);

    // Giá từ DB có thể null với dữ liệu cũ/chưa đầy đủ. Tính sẵn giá hiển thị
    // ở đây để JSP EL không gọi multiply() trên một BigDecimal null.
    java.math.BigDecimal defaultSelectedPrice =
            defaultPart != null && defaultPart.getSellingPrice() != null ? defaultPart.getSellingPrice()
                    : defaultService != null && defaultService.getPrice() != null ? defaultService.getPrice() : new java.math.BigDecimal("120000");
    java.math.BigDecimal defaultSelectedTotal =
            defaultSelectedPrice.multiply(java.math.BigDecimal.valueOf(2));

    request.setAttribute("invoice", invoice);
    request.setAttribute("services", services); request.setAttribute("spareParts", spareParts);
    request.setAttribute("defaultId", defaultId); request.setAttribute("defaultCode", defaultCode);
    request.setAttribute("defaultName", defaultName); request.setAttribute("defaultType", defaultType);
    request.setAttribute("defaultSelectedRow", defaultSelectedRow);
    request.setAttribute("defaultSelectedPrice", defaultSelectedPrice);
    request.setAttribute("defaultSelectedTotal", defaultSelectedTotal);
    request.setAttribute("itemType", itemType);
    request.setAttribute("txtKeyword", keyword);
    request.setAttribute("catalogError", catalogError);
    request.setAttribute("csrf", session.getAttribute("csrf"));
    request.setAttribute("staffName", session.getAttribute("salesStaffName"));
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bổ sung vào hóa đơn - <c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body class="sales-wireframe">
    <main class="screen-card-box">
        <nav class="sales-topbar no-print">
            <a href="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/salesstaff/InvoiceDetailUI4.jsp?invoice=<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">
                Hóa đơn <c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/>
            </a>
            <span class="sales-staff"><c:out value="${staffName}"/></span>
        </nav>

        <c:if test="${not empty catalogError}">
            <p class="sales-message sales-error"><c:out value="${catalogError}"/></p>
        </c:if>

        <h1 class="screen-card-title">
            Bổ sung vào hóa đơn - <c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/>
        </h1>

        <!-- 1. Thông tin hóa đơn (1 Khung gồm 3 cột) -->
        <div class="invoice-info-strip">
            <div class="card-panel-title">Thông tin hóa đơn</div>
            <div class="invoice-info-strip-fields">
                <span>Mã hóa đơn: <strong><c:out value="${invoice != null ? invoice.invoiceNumber : 'HD001'}"/></strong></span>
                <span>Khách hàng: <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.customer.fullName : 'Nguyễn Văn A'}"/></strong></span>
                <span>Biển số xe: <strong><c:out value="${invoice != null ? invoice.serviceReception.vehicle.licensePlate : '30A-12345'}"/></strong></span>
            </div>
        </div>

        <!-- 2. Tìm kiếm dịch vụ/phụ tùng -->
        <div class="section-label-bold">Tìm kiếm dịch vụ/phụ tùng</div>
        <form class="filter-search-bar" method="get" action="${pageContext.request.contextPath}/salesstaff/AddServiceAndSparePartUI4.jsp">
            <input type="hidden" name="invoice" value="<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">
            <label for="itemType">Loại hạng mục:</label>
            <select id="itemType" name="itemType">
                <option value="ALL" ${itemType eq 'ALL' ? 'selected' : ''}>Tất cả</option>
                <option value="SERVICE" ${itemType eq 'SERVICE' ? 'selected' : ''}>Dịch vụ</option>
                <option value="SPARE_PART" ${itemType eq 'SPARE_PART' ? 'selected' : ''}>Phụ tùng</option>
            </select>

            <label for="txtKeyword">Từ khóa:</label>
            <input id="txtKeyword" name="txtKeyword" type="text" maxlength="100" value="<c:out value='${txtKeyword}'/>" placeholder="Nhập từ khóa (ví dụ: dầu)...">

            <button class="btn-search-blue" type="submit">Tìm kiếm</button>
        </form>

        <!-- 3. Bảng danh sách dịch vụ và phụ tùng tra cứu -->
        <div class="sales-table-scroll">
            <table class="wireframe-table" id="catalogTable">
                <thead>
                    <tr>
                        <th style="width: 50px;">TT</th>
                        <th style="width: 90px;">Mã</th>
                        <th>Tên dịch vụ/phụ tùng</th>
                        <th style="width: 100px;">Loại</th>
                        <th style="width: 100px;">Đơn vị tính</th>
                        <th style="width: 130px;">Đơn giá</th>
                        <th style="width: 90px;">Số lượng</th>
                        <th style="width: 100px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${services}" varStatus="row">
                        <!-- Mặc định chọn dòng theo defaultSelectedRow (khớp PT03 - Nước làm mát theo Ảnh 2) -->
                        <c:set var="isDefaultSelected" value="${row.count == defaultSelectedRow}"/>
                        <tr id="row_${row.count}" class="${isDefaultSelected ? 'row-selected' : ''}">
                            <td class="col-center">${row.count}</td>
                            <td class="col-center"><strong><c:out value="${item.serviceCode}"/></strong></td>
                            <td class="col-left"><c:out value="${item.serviceName}"/></td><td class="col-center">Dịch vụ</td><td class="col-center">Lần</td>
                            <td class="col-right"><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đồng</td>
                            <td class="col-center">
                                <input id="qty_${row.count}" class="input-qty-small" type="number" min="1" max="999"
                                       value="${isDefaultSelected ? 2 : 1}"
                                       oninput="if(selectedItem && selectedItem.rowIndex === ${row.count}) updateQuantity(this.value)"
                                       onchange="if(selectedItem && selectedItem.rowIndex === ${row.count}) updateQuantity(this.value)">
                            </td>
                            <td class="col-center">
                                <button type="button" class="btn-select-pill"
                                        onclick="selectCatalogItem('${item.id}', 'SERVICE', '<c:out value="${item.serviceCode}"/>', '<c:out value="${item.serviceName}"/>', ${item.price}, ${row.count})">
                                    Chọn
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:forEach var="item" items="${spareParts}" varStatus="partRow"><c:set var="rowIndex" value="${services.size() + partRow.count}"/><tr id="row_${rowIndex}" class="${rowIndex == defaultSelectedRow ? 'row-selected' : ''}"><td class="col-center">${rowIndex}</td><td class="col-center"><strong><c:out value="${item.partCode}"/></strong></td><td class="col-left"><c:out value="${item.partName}"/></td><td class="col-center">Phụ tùng</td><td class="col-center"><c:out value="${item.unit}"/></td><td class="col-right"><fmt:formatNumber value="${item.sellingPrice}" pattern="#,##0"/> đồng</td><td class="col-center"><input id="qty_${rowIndex}" class="input-qty-small" type="number" min="1" max="999" value="${rowIndex == defaultSelectedRow ? 2 : 1}" oninput="if(selectedItem && selectedItem.rowIndex === ${rowIndex}) updateQuantity(this.value)"></td><td class="col-center"><button type="button" class="btn-select-pill" onclick="selectCatalogItem('${item.id}', 'SPARE_PART', '<c:out value="${item.partCode}"/>', '<c:out value="${item.partName}"/>', ${item.sellingPrice}, ${rowIndex})">Chọn</button></td></tr></c:forEach>
                    <c:if test="${empty services and empty spareParts}">
                        <tr>
                            <td colspan="8" class="col-center" style="padding: 24px; color: #64748b;">
                                Không tìm thấy dịch vụ hoặc phụ tùng nào phù hợp. Hãy thử tìm với từ khóa khác.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- 4. Thanh hiển thị hạng mục đã chọn -->
        <div class="selected-item-box" id="selectedBox">
            Hạng mục đã chọn: <strong><c:out value="${defaultCode}"/> - <c:out value="${defaultName}"/></strong> &nbsp;|&nbsp;
            Số lượng: <strong>2</strong> &nbsp;|&nbsp;
            Thành tiền: <strong><fmt:formatNumber value="${defaultSelectedTotal}" pattern="#,##0"/> đồng</strong>
        </div>

        <!-- 5. Hàng nút bấm dưới cùng: [Quay lại]  [Xác nhận bổ sung] -->
        <div class="bottom-action-bar">
            <a class="btn-secondary-white" href="${pageContext.request.contextPath}/salesstaff/InvoiceDetailUI4.jsp?invoice=<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">
                Quay lại
            </a>

            <form id="addForm" method="post" action="${pageContext.request.contextPath}/salesstaff/SalesHomeUI4.jsp" style="margin: 0;">
                <input type="hidden" name="csrf" value="<c:out value='${csrf}'/>">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="invoice" value="<c:out value='${invoice != null ? invoice.id : \"invoice-demo\"}'/>">
                <input type="hidden" id="formItemId" name="itemId" value="<c:out value='${defaultId}'/>">
                <input type="hidden" id="formType" name="type" value="<c:out value='${defaultType}'/>">
                <input type="hidden" id="formQuantity" name="quantity" value="2">
                <button id="btnSubmitAdd" class="btn-primary-blue" type="submit">
                    Xác nhận bổ sung
                </button>
            </form>
        </div>
    </main>

    <script>
        // Mặc định chọn theo mục đang highlight trên giao diện (khớp PT03 - Nước làm mát theo Ảnh 2)
        let selectedItem = {
            id: '<c:out value="${defaultId}"/>', type: '<c:out value="${defaultType}"/>',
            code: '<c:out value="${defaultCode}"/>', name: '<c:out value="${defaultName}"/>',
            price: ${defaultSelectedPrice},
            quantity: 2,
            rowIndex: ${defaultSelectedRow}
        };

        function formatMoney(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount);
        }

        function selectCatalogItem(id, type, code, name, price, rowIndex) {
            const qtyInput = document.getElementById('qty_' + rowIndex);
            let qty = parseInt(qtyInput ? qtyInput.value : 1, 10);
            if (isNaN(qty) || qty < 1) qty = 1;

            selectedItem = {
                id: id,
                type: type,
                code: code,
                name: name,
                price: price,
                quantity: qty,
                rowIndex: rowIndex
            };

            // Highlight dòng được chọn
            const rows = document.querySelectorAll('#catalogTable tbody tr');
            rows.forEach(r => r.classList.remove('row-selected'));
            const selectedRow = document.getElementById('row_' + rowIndex);
            if (selectedRow) selectedRow.classList.add('row-selected');

            // Cập nhật form submit
            document.getElementById('formItemId').value = id;
            document.getElementById('formType').value = type;
            document.getElementById('formQuantity').value = qty;

            // Kích hoạt nút Xác nhận
            const btnSubmit = document.getElementById('btnSubmitAdd');
            btnSubmit.disabled = false;
            btnSubmit.style.opacity = '1';
            btnSubmit.style.cursor = 'pointer';

            renderSelectedBox();
        }

        function updateQuantity(newQty) {
            if (!selectedItem) return;
            let qty = parseInt(newQty, 10);
            if (isNaN(qty) || qty < 1) qty = 1;
            selectedItem.quantity = qty;
            document.getElementById('formQuantity').value = qty;
            renderSelectedBox();
        }

        function renderSelectedBox() {
            if (!selectedItem) return;
            const lineTotal = selectedItem.price * selectedItem.quantity;
            const box = document.getElementById('selectedBox');
            box.innerHTML = 'Hạng mục đã chọn: <strong>' + selectedItem.code + ' - ' + selectedItem.name + '</strong> &nbsp;|&nbsp; ' +
                            'Số lượng: <strong>' + selectedItem.quantity + '</strong> &nbsp;|&nbsp; ' +
                            'Thành tiền: <strong>' + formatMoney(lineTotal) + ' đồng</strong>';
        }
    </script>
</body>
</html>
