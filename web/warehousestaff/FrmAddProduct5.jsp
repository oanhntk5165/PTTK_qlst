
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Product5DAO,qlst.model.Category5,java.util.List" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    @SuppressWarnings("unchecked")
    java.util.Map<String,String> savedValues = (java.util.Map<String,String>)session.getAttribute("productValues");
    if (savedValues == null) savedValues = new java.util.HashMap<String,String>();
    String formError = (String)session.getAttribute("productError");
    session.removeAttribute("productError");
%>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    List<Category5> categories = null;
    String error = null;
    String supplierId = request.getParameter("supplierId");
    if (supplierId == null) supplierId = savedValues.get("supplierId");
    String staffId = request.getParameter("staffId");

    try {
        categories = new Product5DAO().getCategories();
    }
    catch (Exception ex) {
        application.log("Không thể tải loại mặt hàng", ex);
        error = "Không thể tải danh mục. Hãy chạy qlst/database/qlst.sql trước.";
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm mặt hàng</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class = "logo" href="<%=request.getContextPath()%>/index.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
            <% if (formError != null) { %><div class="error"><%=h(formError)%></div><% } %>
                <%
                    if (error != null) {
                %>
                    <div class="error"><%=h(error)%></div>
                <%
                    }
                    else {
                %>
                    <form method="post" action="doAddProduct.jsp">
                        <input type="hidden" name="supplierId" value="<%=h(supplierId)%>">
                        <input type="hidden" name="staffId" value="<%=h(staffId)%>">
                        <div class="grid">
                            <div class="field">
                                <label>Tên mặt hàng *</label>
                                <input name="name" required maxlength="200" value="<%=h(savedValues.containsKey("name") ? savedValues.get("name") : "")%>">
                            </div>
                            <div class="field">
                                <label>Model *</label>
                                <input name="model" maxlength="120" value="<%=h(savedValues.containsKey("model") ? savedValues.get("model") : "")%>">
                            </div>
                            <div class="field">
                                <label>Thương hiệu *</label>
                                <input name="brand" maxlength="120" value="<%=h(savedValues.containsKey("brand") ? savedValues.get("brand") : "")%>">
                            </div>
                            <div class="field">
                                <label>Nơi sản xuất *</label>
                                <input name="origin" maxlength="120" value="<%=h(savedValues.containsKey("origin") ? savedValues.get("origin") : "")%>">
                            </div>
                            <div class="field">
                                <label>Đơn vị tính *</label>
                                <input name="unit" required maxlength="50" value="<%=h(savedValues.containsKey("unit") ? savedValues.get("unit") : "chiếc")%>">
                            </div>
<!--                            <div class="field">
                                <label>Loại mặt hàng *</label>
                                <select name="categoryId" required>
                                    <option value="">-- Chọn loại --</option>
                                    <%
                                        for (Category5 c : categories) {
                                    %>
                                        <option value="<%=c.getId()%>" <%=String.valueOf(c.getId()).equals(savedValues.get("categoryId")) ? "selected" : ""%>><%=h(c.getName())%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>-->
                            <div class="field">
                                <label>Màu sắc *</label>
                                <input name="color" maxlength="80" value="<%=h(savedValues.containsKey("color") ? savedValues.get("color") : "")%>">
                            </div>
                            <div class="field">
                                <label>Năm sản xuất *</label>
                                <input name="year" type="number" min="1900" max="2100" value="<%=h(savedValues.containsKey("year") ? savedValues.get("year") : "")%>">
                            </div>
                            <div class="field">
                                <label>Bảo hành (tháng) *</label>
                                <input name="warranty" type="number" min="0" value="<%=h(savedValues.containsKey("warranty") ? savedValues.get("warranty") : "0")%>">
                            </div>
                        </div>
                        <div class="field">
                            <label>Mô tả</label>
                            <textarea name="description"><%=h(savedValues.get("description"))%></textarea>
                        </div>
                        <div class="actions">
                            <button type="submit">Lưu</button>
                            <a class="button secondary" href="FrmImport5.jsp?supplierId=<%=h(supplierId)%>&amp;staffId=<%=h(staffId)%>">Hủy</a>
                        </div>
                    </form>
                <%
                    }
                %>
            </section>
        </main>
    </body>
</html>
