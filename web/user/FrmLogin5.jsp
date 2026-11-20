
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    String role = (String) session.getAttribute("role");

    if ("WAREHOUSE".equals(role)) {
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmWarehouseStaffMain5.jsp");
        return;
    }

    if ("CUSTOMER".equals(role)) {
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmWarehouseStaffMain5.jsp");
        return;
    }

    String error = request.getParameter("error");
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body class="login-page">
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Siêu thị điện máy</a>
        </header>
        <main class="login-main">
            <section class="card login-card">
                <% if (session.getAttribute("notice") != null) { %>
                    <div class="notice"><%=h(session.getAttribute("notice"))%></div>
                <% session.removeAttribute("notice"); } %>
                <%
                    if ("1".equals(error)) {
                %>
                    <div class="error">Tên đăng nhập hoặc mật khẩu không đúng.</div>
                <%
                    }
                    else if ("2".equals(error)) {
                %>
                    <div class="error">Không thể kết nối hệ thống. Kiểm tra lại.</div>
                <%
                    }
                    else if ("3".equals(error)) {
                %>
                    <div class="error">Tài khoản nhân viên này chưa được cấp quyền vào.</div>
                <%
                    }
                %>
                <form method="post" action="<%=request.getContextPath()%>/user/doLogin5.jsp">
                    <div class="field">
                        <label for="username">Tên đăng nhập</label>
                        <input id="username" name="username" required maxlength="80" autocomplete="username">
                    </div>
                    <div class="field">
                        <label for="password">Mật khẩu</label>
                        <input id="password" name="password" type="password" required autocomplete="current-password">
                    </div>
                    <div class="actions">
                        <button type="submit">Đăng nhập</button>
                        <a class="button secondary" href="<%=request.getContextPath()%>/customer/FrmRegister5.jsp">Đăng ký</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
