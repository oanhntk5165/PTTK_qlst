
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    @SuppressWarnings("unchecked")
    java.util.Map<String,String> savedValues = (java.util.Map<String,String>)session.getAttribute("registerValues");
    if (savedValues == null) savedValues = new java.util.HashMap<String,String>();
    String formError = (String)session.getAttribute("registerError");
    session.removeAttribute("registerError");
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Đăng ký</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/index.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
<% if (session.getAttribute("notice") != null) { %><div class="notice"><%=h(session.getAttribute("notice"))%></div><% session.removeAttribute("notice"); } %>
<% if (formError != null) { %><div class="error"><%=h(formError)%></div><% } %>
                <form method="post" action="<%=request.getContextPath()%>/customer/doInsertCustomer.jsp">
                    <div class="grid">
                        <div class="field">
                            <label for="inName">Họ tên *</label>
                            <input id="inName" name="inName" required maxlength="150" value="<%=h(savedValues.containsKey("inName") ? savedValues.get("inName") : "")%>">
                        </div>
                        <div class="field">
                            <label for="inPhone">Số điện thoại *</label>
                            <input id="inPhone" name="inPhone" type="tel" required maxlength="30" value="<%=h(savedValues.containsKey("inPhone") ? savedValues.get("inPhone") : "")%>">
                        </div>
                        <div class="field">
                            <label for="inDob">Ngày sinh *</label>
                            <input id="inDob" name="inDob" type="date" value="<%=h(savedValues.containsKey("inDob") ? savedValues.get("inDob") : "")%>">
                        </div>
                        <div class="field">
                            <label for="inEmail">Email</label>
                            <input id="inEmail" name="inEmail" type="email" maxlength="254" value="<%=h(savedValues.containsKey("inEmail") ? savedValues.get("inEmail") : "")%>">
                        </div>
                        <div class="field">
                            <label for="inUsername">Tên đăng nhập *</label>
                            <input id="inUsername" name="inUsername" required minlength="4" maxlength="80" autocomplete="username" value="<%=h(savedValues.containsKey("inUsername") ? savedValues.get("inUsername") : "")%>">
                        </div>
                        <div class="field">
                            <label for="inPassword">Mật khẩu *</label>
                            <input id="inPassword" name="inPassword" type="password" required minlength="6" autocomplete="new-password">
                        </div>
                        <div class="field">
                            <label for="inConfirmPassword">Xác nhận mật khẩu *</label>
                            <input id="inConfirmPassword" name="inConfirmPassword" type="password" required minlength="6" autocomplete="new-password">
                        </div>
                    </div>
                    <div class="actions">
                        <a class="button secondary" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Quay lại</a>
                        <button type="submit" name="subRegister">Đăng ký</button>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
