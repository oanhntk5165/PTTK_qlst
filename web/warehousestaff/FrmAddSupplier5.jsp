
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    @SuppressWarnings("unchecked")
    java.util.Map<String,String> savedValues = (java.util.Map<String,String>)session.getAttribute("supplierValues");
    if (savedValues == null) savedValues = new java.util.HashMap<String,String>();
    String formError = (String)session.getAttribute("supplierError");
    session.removeAttribute("supplierError");
%>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    String staffId = request.getParameter("staffId");
    if (staffId == null) {
        staffId = "";
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm nhà cung cấp</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class = "logo" href="<%=request.getContextPath()%>/index.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
            <% if (formError != null) { %><div class="error"><%=h(formError)%></div><% } %>
                <form method="post" action="doAddSupplier.jsp">
                    <input type="hidden" name="staffId" value="<%=h(staffId)%>">
                    <div class="grid">
                        <div class="field">
                            <label>Tên nhà cung cấp *</label>
                            <input name="name" required maxlength="180" value="<%=h(savedValues.containsKey("name") ? savedValues.get("name") : "")%>">
                        </div>
                        <div class="field">
                            <label>Số điện thoại *</label>
                            <input name="phone" required maxlength="30" value="<%=h(savedValues.containsKey("phone") ? savedValues.get("phone") : "")%>">
                        </div>
                        <div class="field">
                            <label>Email</label>
                            <input name="email" type="email" maxlength="254" value="<%=h(savedValues.containsKey("email") ? savedValues.get("email") : "")%>">
                        </div>
                        <div class="field">
                            <label>Địa chỉ *</label>
                            <input name="address" required maxlength="500" value="<%=h(savedValues.containsKey("address") ? savedValues.get("address") : "")%>">
                        </div>
                    </div>
                    <div class="actions">
                        <button type="submit">Lưu</button>
                        <a class="button secondary" href="FrmSearchSupplier5.jsp?staffId=<%=h(staffId)%>">Hủy</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
