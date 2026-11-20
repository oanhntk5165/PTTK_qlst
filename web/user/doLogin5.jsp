
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Login5DAO,qlst.model.User5,qlst.model.WarehouseStaff5,qlst.model.Customer5" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        User5 user = new Login5DAO().authenticate(username, password);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/FrmLogin5.jsp?error=1");
            return;
        }

        String role;
        String destination;

        if (user instanceof WarehouseStaff5) {
            role = "WAREHOUSE";
            destination = "/warehousestaff/FrmWarehouseStaffMain5.jsp";
        }
        else if (user instanceof Customer5) {
            role = "CUSTOMER";
            destination = "/warehousestaff/FrmWarehouseStaffMain5.jsp";
        }
        else {
            response.sendRedirect(request.getContextPath() + "/user/FrmLogin5.jsp?error=3");
            return;
        }

        if (session != null) {
            session.invalidate();
        }

        javax.servlet.http.HttpSession authenticatedSession = request.getSession(true);

        authenticatedSession.setAttribute("userId", user.getId());
        authenticatedSession.setAttribute("fullName", user.getName());
        authenticatedSession.setAttribute("username", user.getUsername());
        authenticatedSession.setAttribute("role", role);

        response.sendRedirect(request.getContextPath() + destination);
    }
    catch (Exception ex) {
        application.log("Đăng nhập thất bại do lỗi hệ thống", ex);
        response.sendRedirect(request.getContextPath() + "/user/FrmLogin5.jsp?error=2");
    }
%>
