
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (session.getAttribute("userId")==null) {
        response.sendRedirect(request.getContextPath()+"/user/FrmLogin5.jsp");
        return;
    }
    boolean warehouse = "WAREHOUSE".equals(session.getAttribute("role"));
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Trang chủ nhân viên kho</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/warehousestaff/FrmWarehouseStaffMain5.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card centered-card">
                <%
                    if (!warehouse) {
                %>
                    <h1>Không có quyền truy cập</h1>
                    <div class="error">Tài khoản của bạn không được cấp quyền sử dụng chức năng kho.</div>
                    <a class="action button secondary" href="<%=request.getContextPath()%>/user/doLogout5.jsp">Đăng xuất</a>
                <%
                    }
                    else {
                %>
                    <h1>Trang chủ nhân viên kho</h1>
                    <div class="actions">
                        <a class="button" href="<%=request.getContextPath()%>/warehousestaff/FrmSearchSupplier5.jsp">Nhập hàng từ nhà cung cấp</a>
                    </div>
                <%
                    }
                %>
            </section>
        </main>
    </body>
</html>
