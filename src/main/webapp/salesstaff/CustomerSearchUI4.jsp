<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    String customerName = request.getParameter("txtCustomerName");
    String target = "/salesstaff/SalesHomeUI4.jsp?view=search";
    if (customerName != null && !customerName.isBlank()) {
        target += "&q=" + URLEncoder.encode(customerName, StandardCharsets.UTF_8);
    }
    request.getRequestDispatcher(target).forward(request, response);
%>
