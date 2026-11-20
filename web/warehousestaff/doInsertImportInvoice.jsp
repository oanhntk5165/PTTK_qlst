
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.ImportInvoice5DAO,qlst.dao.Supplier5DAO,qlst.model.ImportInvoice5,qlst.model.ImportInvoiceDetail5,qlst.model.Product5,qlst.model.Supplier5,qlst.model.WarehouseStaff5,java.util.List" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String error = null;

    try {
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        int staffId = ((Integer)session.getAttribute("userId")).intValue();

        Supplier5 supplier = new Supplier5DAO().getSupplier(supplierId);

        if (supplier == null) {
            throw new IllegalArgumentException("Nhà cung cấp không tồn tại.");
        }

        @SuppressWarnings("unchecked")
        List<ImportInvoiceDetail5> cart = (List<ImportInvoiceDetail5>)session.getAttribute("importCart");

        Object cartSupplier = session.getAttribute("importSupplierId");

        if (cart == null || cart.isEmpty() || cartSupplier == null || ((Integer)cartSupplier) != supplierId) {
            throw new IllegalArgumentException("Phiếu nhập không còn dữ liệu. Vui lòng tạo lại phiếu.");
        }

        ImportInvoice5 invoice = new ImportInvoice5();
        invoice.setSupplier(supplier);

        WarehouseStaff5 staff = new WarehouseStaff5();
        staff.setId(staffId);
        invoice.setWarehouseStaff(staff);

        invoice.setDetails(new java.util.ArrayList<ImportInvoiceDetail5>(cart));

        if (!new ImportInvoice5DAO().addImportInvoice(invoice)) {
            throw new IllegalArgumentException("Không thể lưu phiếu nhập.");
        }

        session.removeAttribute("importCart");
        session.removeAttribute("importSupplierId");
        session.removeAttribute("importStaffId");

        response.sendRedirect("FrmImportInvoice5.jsp?id=" + invoice.getId());
        return;
    }
    catch (IllegalArgumentException ex) {
        error = ex.getMessage();
    }
    catch (Exception ex) {
        application.log("Lỗi khi ghi phiếu nhập", ex);
        error = "Không thể hoàn tất phiếu nhập. Giao dịch đã được hoàn tác; hãy thử lại sau khi kiểm tra dữ liệu.";
    }
    session.setAttribute("invoiceError", error);
    Object selectedSupplier = session.getAttribute("importSupplierId");
    response.sendRedirect("FrmConfirmImportInvoice5.jsp?supplierId=" + (selectedSupplier == null ? "0" : selectedSupplier));

%>