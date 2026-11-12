<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    String invoice = request.getParameter("invoice");
    String target = "/salesstaff/AddServiceAndSparePartUI4.jsp" + (invoice == null || invoice.isBlank() ? "" : "?invoice=" + URLEncoder.encode(invoice, StandardCharsets.UTF_8));
    request.getRequestDispatcher(target).forward(request, response);
%>
