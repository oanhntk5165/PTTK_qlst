
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Supplier5DAO,qlst.model.Supplier5,java.util.List" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    if (request.getParameter("keyword") != null) session.setAttribute("supplierKeyword", request.getParameter("keyword"));
    String keyword = (String)session.getAttribute("supplierKeyword");
    if (keyword == null) {
        keyword = "";
    }
    String staffId = String.valueOf(session.getAttribute("userId"));
    List<Supplier5> suppliers = null;
    String error = null;
    try {
        suppliers = new Supplier5DAO().searchSupplier(keyword);
    }
    catch (Exception ex) {
        application.log("Không thể tìm nhà cung cấp", ex);
        error = "Không thể kết nối cơ sở dữ liệu.";
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Tìm nhà cung cấp</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
            <% if (session.getAttribute("notice") != null) { %><div class="notice"><%=h(session.getAttribute("notice"))%></div><% session.removeAttribute("notice"); } %>
                <form method="get" action="FrmSearchSupplier5.jsp" class="grid">
                    <input type="hidden" name="staffId" value="<%=h(staffId)%>">
                    <div class="field">
                        <label for="keyword">Tên nhà cung cấp</label>
                        <input id="keyword" name="keyword" value="<%=h(keyword)%>" placeholder="Nhập tên cần tìm">
                    </div>
                    <div class="actions">
                        <button type="submit">Tìm</button>
                        <a class="button secondary" href="FrmAddSupplier5.jsp?staffId=<%=h(staffId)%>">Thêm nhà cung cấp</a>
                    </div>
                </form>
                <%
                    if (error != null) {
                %>
                    <div class="error"><%=h(error)%></div>
                <%
                    }
                    else {
                %>
                    <table>
                        <thead>
                            <tr>
                                <th>Tên nhà cung cấp</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Supplier5 s : suppliers) {
                            %>
                                <tr>
                                    <td><%=h(s.getName())%></td>
                                    <td><%=h(s.getPhone())%></td>
                                    <td><%=h(s.getAddress())%></td>
                                    <td><a class="button" href="FrmImport5.jsp?supplierId=<%=s.getId()%>&amp;staffId=<%=h(staffId)%>">Chọn</a></td>
                                </tr>
                            <%
                                }
                                if (suppliers.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="4" class="muted">Không tìm thấy nhà cung cấp.</td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                <%
                    }
                %>
                <div class="actions">
                    <a class="button secondary" href="FrmWarehouseStaffMain5.jsp">Quay lại</a>
                </div>
            </section>
        </main>
    </body>
</html>
