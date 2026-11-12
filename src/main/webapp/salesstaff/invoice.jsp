<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String invoice = request.getParameter("invoice");
    String target = "/salesstaff/InvoiceDetailUI4.jsp" + (invoice == null || invoice.isBlank() ? "" : "?invoice=" + java.net.URLEncoder.encode(invoice, java.nio.charset.StandardCharsets.UTF_8));
    request.getRequestDispatcher(target).forward(request, response);
%>
