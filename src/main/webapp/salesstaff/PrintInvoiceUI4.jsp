<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    String invoice = request.getParameter("invoice");
    String target = invoice == null || invoice.isBlank()
            ? "/salesstaff/SalesHomeUI4.jsp"
            : "/salesstaff/SalesHomeUI4.jsp?invoice="
                    + URLEncoder.encode(invoice, StandardCharsets.UTF_8) + "&print=1";
    request.getRequestDispatcher(target).forward(request, response);
%>
