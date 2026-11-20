
<%@page import="qlst.model.Product5"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.ImportInvoice5DAO,qlst.model.ImportInvoice5,qlst.model.ImportInvoiceDetail5,java.time.format.DateTimeFormatter" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
    ImportInvoice5 invoice = null;
    String error = null;

    try {
        int id = Integer.parseInt(request.getParameter("id"));
        invoice = new ImportInvoice5DAO().getImportInvoice(id);

        if (invoice == null) {
            error = "Không tìm thấy hóa đơn nhập.";
        }
    }
    catch (Exception ex) {
        application.log("Không thể tải hóa đơn nhập", ex);
        error = "Không thể tải hóa đơn nhập.";
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hóa đơn nhập hàng</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header class="no-print">
            <a class ="logo" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
                <%
                    if (error != null) {
                %>
                    <div class="error"><%=h(error)%></div>
                    <a class="button no-print" href="FrmWarehouseStaffMain5.jsp">Quay lại</a>
                <%
                    }
                    else {
                %>
                    <div class="notice no-print">Nhập hàng thành công.</div>
                    <p>Mã hóa đơn: <strong>PN-<%=invoice.getId()%></strong></p>
                    <p>Ngày nhập: <%=invoice.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))%></p>
                    <p>Nhà cung cấp: <strong><%=h(invoice.getSupplier().getName())%></strong> · <%=h(invoice.getSupplier().getAddress())%> · <%=h(invoice.getSupplier().getPhone())%></p>
                    <p>Nhân viên kho: <%=h(invoice.getWarehouseStaff().getName())%></p>
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mặt hàng</th>
                                <th>Mã SKU</th>
                                <th>Đơn vị tính</th>
                                <th>Số lượng</th>
                                <th>Đơn giá nhập</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int i = 1;
                                for (ImportInvoiceDetail5 d : invoice.getDetails()) {
                                    Product5 p = d.getProduct();
                            %>
                                <tr>
                                    <td><%=i++%></td>
                                    <td><%=h(p.getName())%></td>
                                    <td><%=h(p.getDetails().isEmpty() ? "" : p.getDetails().get(0).getSku())%></td>
                                    <td><%=h(p.getUnit())%></td>
                                    <td><%=d.getQuantity()%></td>
                                    <td><%=money(d.getImportPrice())%> ₫</td>
                                    <td><%=money(d.getUnitAmount())%> ₫</td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <p class="right">
                        <strong>Tổng tiền: <%=money(invoice.getTotalAmount())%> ₫</strong>
                    </p>
                    <div class="actions no-print" style="justify-content: center;">
                        <button onclick="window.print()">In hóa đơn</button>
                        <a class="button secondary" href="FrmWarehouseStaffMain5.jsp">Đóng</a>
                    </div>
                <%
                    }
                %>
            </section>
        </main>
    </body>
</html>
