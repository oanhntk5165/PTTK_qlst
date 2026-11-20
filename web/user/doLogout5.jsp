<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    javax.servlet.http.HttpSession currentSession = request.getSession(false);
    if (currentSession != null) {
        currentSession.invalidate();
    }

    javax.servlet.http.HttpSession loggedOutSession = request.getSession(true);
    loggedOutSession.setAttribute("notice", "Bạn đã đăng xuất thành công.");

    response.sendRedirect(request.getContextPath() + "/user/FrmLogin5.jsp");
%>
