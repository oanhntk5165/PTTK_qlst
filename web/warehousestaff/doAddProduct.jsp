
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Product5DAO,qlst.model.Product5,qlst.model.ProductDetail5,qlst.model.Category5" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String error = null;
    String supplierId = request.getParameter("supplierId");
    String staffId = request.getParameter("staffId");

    try {
        String name = request.getParameter("name");
        String unit = request.getParameter("unit");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String year = request.getParameter("year");
        String warranty = request.getParameter("warranty");

        if (name == null || name.trim().isEmpty() || unit == null || unit.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên mặt hàng và đơn vị tính là bắt buộc.");
        }

        for (String field : new String[]{"model", "brand", "origin", "color", "year", "warranty"}) {
            if (request.getParameter(field) == null || request.getParameter(field).trim().isEmpty()) throw new IllegalArgumentException("Chưa nhập đủ thông tin bắt buộc.");
        }
        if (Integer.parseInt(year) < 1900 || Integer.parseInt(year) > java.time.Year.now().getValue()) throw new IllegalArgumentException("Năm sản xuất không hợp lệ.");
        Product5 p = new Product5();
        p.setName(name.trim());
        p.setModel(request.getParameter("model"));
        p.setBrand(request.getParameter("brand"));
        p.setOrigin(request.getParameter("origin"));
        p.setUnit(unit.trim());
        p.setDescription(request.getParameter("description"));

        Category5 c = new Category5();
        c.setId(categoryId);
        p.setCategory(c);

        ProductDetail5 d = new ProductDetail5();
        // SKU được sinh tự động từ tên, hãng và đặc điểm sản phẩm trong Product5DAO.
        d.setSku(null);
        d.setColor(request.getParameter("color"));
        d.setPYear(year == null || year.trim().isEmpty() ? null : Integer.valueOf(year));
        d.setWarranty(warranty == null || warranty.isEmpty() ? 0 : Integer.parseInt(warranty));

        if (d.getWarranty() < 0) {
            throw new IllegalArgumentException("Thời gian bảo hành không hợp lệ.");
        }

        p.setDetails(java.util.Collections.singletonList(d));
        if (!new Product5DAO().addProduct(p)) {
            throw new IllegalArgumentException("Không thể lưu mặt hàng.");
        }
    }
    catch (IllegalArgumentException ex) {
        error = ex.getMessage();
    }
    catch (Exception ex) {
        application.log("Không thể thêm mặt hàng", ex);
        error = "Không thể lưu mặt hàng. Kiểm tra loại mặt hàng và cấu hình cơ sở dữ liệu.";
    }
    java.util.Map<String,String> values = new java.util.HashMap<String,String>();
    for (String field : request.getParameterMap().keySet()) {
        if (!field.toLowerCase(java.util.Locale.ROOT).contains("password")) values.put(field, request.getParameter(field));
    }
    if (error != null) {
        session.setAttribute("productValues", values);
        session.setAttribute("productError", error);
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmAddProduct5.jsp");
    } else {
        session.removeAttribute("productValues");
        session.setAttribute("notice", "Th?m m?i m?t h?ng th?nh c?ng.");
        response.sendRedirect(request.getContextPath()+"/warehousestaff/FrmImport5.jsp" + "?supplierId=" + java.net.URLEncoder.encode(supplierId == null ? "" : supplierId, "UTF-8"));
    }

%>