
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Supplier5DAO,qlst.model.Supplier5" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String error = null;
    String staffId = request.getParameter("staffId");

    try {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty() || address == null || address.trim().isEmpty()) throw new IllegalArgumentException("Chưa nhập đủ thông tin bắt buộc.");
        if (!phone.matches("0[0-9]{9}")) throw new IllegalArgumentException("Số điện thoại không hợp lệ.");
        if (email == null) email = "";
        if (!email.isEmpty() && !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) throw new IllegalArgumentException("Email không hợp lệ.");
        for (Supplier5 existing : new Supplier5DAO().searchSupplier(name.trim())) if (existing.getName().equalsIgnoreCase(name.trim()) || existing.getPhone().equals(phone)) throw new IllegalArgumentException("Nhà cung cấp đã tồn tại trong hệ thống.");
        Supplier5 s = new Supplier5();
        s.setName(name.trim());
        s.setPhone(phone.trim());
        s.setEmail(email.trim());
        s.setAddress(address.trim());

        if (!new Supplier5DAO().addSupplier(s)) {
            throw new IllegalArgumentException("Không thể lưu nhà cung cấp.");
        }
    }
    catch (IllegalArgumentException ex) {
        error = ex.getMessage();
    }
    catch (Exception ex) {
        application.log("Không thể thêm nhà cung cấp", ex);
        error = "Không thể lưu nhà cung cấp. Kiểm tra cấu hình cơ sở dữ liệu.";
    }
    java.util.Map<String,String> values = new java.util.HashMap<String,String>();
    for (String field : request.getParameterMap().keySet()) {
        if (!field.toLowerCase(java.util.Locale.ROOT).contains("password")) values.put(field, request.getParameter(field));
    }
    if (error != null) {
        session.setAttribute("supplierValues", values);
        session.setAttribute("supplierError", error);
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmAddSupplier5.jsp");
    } else {
        session.removeAttribute("supplierValues");
        session.setAttribute("notice", "Thêm nhà cung cấp thành công.");
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmSearchSupplier5.jsp");
    }

%>