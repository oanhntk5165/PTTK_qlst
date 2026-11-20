
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.Supplier5DAO,qlst.dao.WarehouseStaff5DAO,qlst.model.Supplier5,qlst.model.WarehouseStaff5,qlst.model.Product5,qlst.model.ImportInvoiceDetail5,java.util.List,java.math.BigDecimal" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");

    Supplier5 supplier = null;
    WarehouseStaff5 staff = null;
    String error = null;
    int supplierId = 0, staffId = ((Integer)session.getAttribute("userId")).intValue();

    @SuppressWarnings("unchecked")
    List<ImportInvoiceDetail5> cart = (List<ImportInvoiceDetail5>)session.getAttribute("importCart");

    if (cart == null) {
        cart = new java.util.ArrayList<ImportInvoiceDetail5>();
    }

    BigDecimal total = BigDecimal.ZERO;

    try {
        supplierId = Integer.parseInt(request.getParameter("supplierId"));
        supplier = new Supplier5DAO().getSupplier(supplierId);

        List<WarehouseStaff5> allStaff = new WarehouseStaff5DAO().getAll();

        for (WarehouseStaff5 w : allStaff) {
            if (w.getId() == staffId) {
                staff = w;
            }
        }

        if (supplier == null || staff == null) {
            throw new IllegalArgumentException("Nhà cung cấp hoặc nhân viên kho không hợp lệ.");
        }

        Object cartSupplier = session.getAttribute("importSupplierId");

        if (cart.isEmpty() || cartSupplier == null || ((Integer)cartSupplier) != supplierId) {
            throw new IllegalArgumentException("Phiếu nhập đã hết hạn hoặc nhà cung cấp đã thay đổi. Hãy thêm lại mặt hàng.");
        }

        for (ImportInvoiceDetail5 d : cart) {
            total = total.add(d.getImportPrice().multiply(BigDecimal.valueOf(d.getQuantity())));
        }
    }
    catch (Exception ex) {
        error = ex instanceof IllegalArgumentException ? ex.getMessage() : "Không thể tải thông tin xác nhận.";
        application.log("Không thể xác nhận phiếu nhập", ex);
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xác nhận phiếu nhập</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
                <%
                    if (error != null) {
                %>
                    <div class="error"><%=h(error)%></div>
                    <a class="button" href="FrmSearchSupplier5.jsp">Quay lại</a>
                <%
                    }
                    else {
                %>
                    <p>Nhà cung cấp: <strong><%=h(supplier.getName())%></strong> · <span class="muted"><%=h(supplier.getPhone())%></span> · <span class="muted"><%=h(supplier.getAddress())%></span></p>
                    <p>Nhân viên kho: <strong><%=h(staff.getName())%></strong></p>
                    <p>Ngày nhập: <%=java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))%></p>
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mặt hàng</th>
                                <th>Mã SKU</th>
                                <th>Đơn vị tính</th>
                                <th>Số lượng</th>
                                <th>Giá nhập</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < cart.size(); i++) {
                                    ImportInvoiceDetail5 d = cart.get(i);
                                    Product5 p = d.getProduct();
                            %>
                                <tr>
                                    <td><%=i + 1%></td>
                                    <td><%=h(p.getName())%></td>
                                    <td> <%=h(p.getDetails().isEmpty() ? "" : p.getDetails().get(0).getSku())%></td>
                                    <td><%=h(p.getUnit())%></td>
                                    <td><%=d.getQuantity()%></td>
                                    <td><%=money(d.getImportPrice())%> ₫</td>
                                    <td>
                                        <%=money(d.getImportPrice().multiply(
                                            BigDecimal.valueOf(d.getQuantity())))%> ₫
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <p class="right">
                        <strong>Tổng tiền: <%=money(total)%> ₫</strong>
                    </p>
                    <form method="post" action="doInsertImportInvoice.jsp">
                        <input type="hidden" name="supplierId" value="<%=supplierId%>">
                        <input type="hidden" name="staffId" value="<%=staffId%>">
                        <div class="actions">
                            <button type="submit">Hoàn tất</button>
                            <a class="button secondary" href="FrmImport5.jsp?supplierId=<%=supplierId%>&amp;staffId=<%=staffId%>">Quay lại</a>
                        </div>
                    </form>
                <%
                    }
                %>
            </section>
        </main>
    </body>
</html>
