<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.dao.*,qlst.model.*,java.util.*,java.math.BigDecimal" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/requireWarehouse.jspf" %>
<%
request.setCharacterEncoding("UTF-8");
if ("cancel".equals(request.getParameter("action"))) {
    if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
    for (String attribute : new String[]{"importCart", "importSupplierId", "importStaffId", "productKeyword", "supplierKeyword", "productValues", "productError", "supplierValues", "supplierError", "invoiceError", "notice"}) session.removeAttribute(attribute);
    response.sendRedirect("FrmSearchSupplier5.jsp");
    return;
}
response.setHeader("Cache-Control", "no-store");

    if (request.getParameter("keyword") != null) session.setAttribute("productKeyword", request.getParameter("keyword"));
int supplierId = 0, staffId = (Integer)session.getAttribute("userId");
Supplier5 supplier = null;
List<Product5> products = new ArrayList<Product5>();
String error = null;
try {
 supplierId = Integer.parseInt(request.getParameter("supplierId"));
 supplier = new Supplier5DAO().getSupplier(supplierId);
 if (supplier == null) throw new IllegalArgumentException("Nhà cung cấp không tồn tại.");
 if (!Integer.valueOf(supplierId).equals(session.getAttribute("importSupplierId"))) {
  session.setAttribute("importCart", new ArrayList<ImportInvoiceDetail5>());
  session.setAttribute("importSupplierId", supplierId);
 }
 String action = request.getParameter("action");
 if (action != null && !"POST".equals(request.getMethod())) { response.sendError(405); return; }

 if ("add".equals(action)) {
  int productId = Integer.parseInt(request.getParameter("productId"));
  int quantity = Integer.parseInt(request.getParameter("quantity"));
  BigDecimal price = new BigDecimal(request.getParameter("price"));
  if (quantity <= 0 || price.signum() <= 0 || price.scale() > 2) throw new IllegalArgumentException("Số lượng và đơn giá phải lớn hơn 0; giá tối đa 2 chữ số thập phân.");
  Product5 p = new Product5DAO().getProduct(productId);
  if (p == null) throw new IllegalArgumentException("Chưa chọn mặt hàng cần nhập.");
  List<ImportInvoiceDetail5> cart = (List<ImportInvoiceDetail5>)session.getAttribute("importCart");
  for (ImportInvoiceDetail5 item : cart) if (item.getProduct().getId() == productId) throw new IllegalArgumentException("Mặt hàng này đã tồn tại trong danh sách nhập.");
  ImportInvoiceDetail5 d = new ImportInvoiceDetail5(); d.setProduct(p);
            d.setQuantity(quantity);
            d.setImportPrice(price);
            d.setUnitAmount(price.multiply(BigDecimal.valueOf(quantity)));
            cart.add(d);

            response.sendRedirect("FrmImport5.jsp?supplierId=" + supplierId + "&staffId=" + staffId);
            return;
        }

        if ("remove".equals(action)) {
            @SuppressWarnings("unchecked")
            List<ImportInvoiceDetail5> cart = (List<ImportInvoiceDetail5>)session.getAttribute("importCart");

            int index = Integer.parseInt(request.getParameter("index"));

            if (cart != null && index >= 0 && index < cart.size()) {
                cart.remove(index);
            }

            response.sendRedirect("FrmImport5.jsp?supplierId=" + supplierId + "&staffId=" + staffId);
            return;
        }

        String search = (String)session.getAttribute("productKeyword");
        products = new Product5DAO().searchProduct(search);
    }
    catch (IllegalArgumentException ex) {
        error = ex.getMessage();
    }
    catch (Exception ex) {
        application.log("Không thể chuẩn bị phiếu nhập", ex);
        error = "Không thể tải dữ liệu. Kiểm tra cấu hình cơ sở dữ liệu.";
    }

    @SuppressWarnings("unchecked")
    List<ImportInvoiceDetail5> cart = (List<ImportInvoiceDetail5>)session.getAttribute("importCart");

    if (cart == null) {
        cart = new java.util.ArrayList<ImportInvoiceDetail5>();
    }

    BigDecimal total = BigDecimal.ZERO;

    for (ImportInvoiceDetail5 d : cart) {
        total = total.add(d.getImportPrice().multiply(BigDecimal.valueOf(d.getQuantity())));
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Lập phiếu nhập</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
    </head>
    <body>
        <header>
            <a class="logo" href="<%=request.getContextPath()%>/user/FrmLogin5.jsp">Siêu thị điện máy</a>
        </header>
        <main>
            <section class="card">
            <% if (session.getAttribute("notice") != null) { %><div class="notice"><%=h(session.getAttribute("notice"))%></div><% session.removeAttribute("notice"); } %>
                <%
                    if (error != null) {
                %>
                    <div class="error"><%=h(error)%></div>
                    <a class="button" href="FrmSearchSupplier5.jsp?staffId=<%=staffId%>">Hủy</a>
                <%
                    }
                    if (supplier != null) {
                %>
                    <p class="supplier-info">Nhà cung cấp: <strong><%=h(supplier.getName())%></strong> · <span class="muted"><%=h(supplier.getPhone())%></span> · <span class="muted"><%=h(supplier.getAddress())%></span></p>
                    <form method="get" action="FrmImport5.jsp" class="grid">
                        <input type="hidden" name="supplierId" value="<%=supplierId%>">
                        <input type="hidden" name="staffId" value="<%=staffId%>">
                        <div class="field">
                            <label for="keyword">Tên mặt hàng</label>
                            <input id="keyword" name="keyword" value="<%=h(session.getAttribute("productKeyword"))%>" placeholder="Tên mặt hàng">
                        </div>
                        <div class="actions">
                            <button type="submit">Tìm</button>
                            <a class="button secondary" href="FrmAddProduct5.jsp?supplierId=<%=supplierId%>&amp;staffId=<%=staffId%>">Thêm mặt hàng mới</a>
                        </div>
                    </form>
                    <h2>Danh sách mặt hàng</h2>
                    <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mặt hàng</th>
                                <th>Mã SKU</th>
                                <th>Đơn vị tính</th>
                                <th>Chọn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (products != null) {
                                    int productIndex = 1;
                                    for (Product5 p : products) {
                            %>
                                <tr>
                                    <td><%=productIndex++%></td>
                                    <td><%=h(p.getName())%></td>
                                    <td><%=h(p.getDetails().isEmpty() ? "" : p.getDetails().get(0).getSku())%></td>
                                    <td><%=h(p.getUnit())%></td>
                                    <td>
                                        <button type="button" class="secondary product-select"
                                            data-id="<%=p.getId()%>"
                                            data-name="<%=h(p.getName())%>"
                                            data-sku="<%=h(p.getDetails().isEmpty() ? "" : p.getDetails().get(0).getSku())%>"
                                            data-unit="<%=h(p.getUnit())%>">Chọn</button>
                                    </td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    </div>
                    <div class="selected-product" id="selectedProduct">
                        <form method="post" action="FrmImport5.jsp" class="grid" id="importDetailForm">
                            <input type="hidden" name="supplierId" value="<%=supplierId%>">
                            <input type="hidden" name="staffId" value="<%=staffId%>">
                            <input type="hidden" name="productId" id="selectedProductId">
                            <input type="hidden" name="action" value="add">
                            <div class="field">
                                <label for="quantity">Số lượng</label>
                                <input id="quantity" type="number" min="1" name="quantity" value="1" required disabled>
                            </div>
                            <div class="field">
                                <label for="price">Giá nhập</label>
                                <input id="price" type="number" min="0.01" step="0.01" name="price" required disabled>
                            </div>
                            <div class="actions">
                                <button type="submit" id="addSelected" disabled>Thêm vào hóa đơn</button>
                            </div>
                        </form>
                    </div>
                    <h2>Danh sách mặt hàng nhập</h2>
                    <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mặt hàng</th>
                                <th>Mã SKU</th>
                                <th>Đơn vị tính</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < cart.size(); i++) {
                                    ImportInvoiceDetail5 d = cart.get(i);
                            %>
                                <tr>
                                    <td><%=i + 1%></td>
                                    <td><%=h(d.getProduct().getName())%></td>
                                    <td><span><%=h(d.getProduct().getDetails().isEmpty() ? "" : d.getProduct().getDetails().get(0).getSku())%></span></td>
                                    <td><%=h(d.getProduct().getUnit())%></td>
                                    <td><%=d.getQuantity()%></td>
                                    <td><%=money(d.getImportPrice())%> ₫</td>
                                    <td><%=money(d.getImportPrice().multiply(BigDecimal.valueOf(d.getQuantity())))%> ₫</td>
                                    <td>
                                        <form method="post" action="FrmImport5.jsp">
                                            <input type="hidden" name="supplierId" value="<%=supplierId%>">
                                            <input type="hidden" name="staffId" value="<%=staffId%>">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="index" value="<%=i%>">
                                            <button class="secondary" type="submit">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            <%
                                }

                                if (cart.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="7" class="muted">Chưa có mặt hàng nào trong phiếu nhập.</td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    </div>
                    <p class="right">
                        <strong>Tổng tiền: <%=money(total)%> ₫</strong>
                    </p>
                    <div class="actions">
                        <%
                            if (!cart.isEmpty()) {
                        %>
                            <form method="post" action="FrmConfirmImportInvoice5.jsp">
                                <input type="hidden" name="supplierId" value="<%=supplierId%>">
                                <input type="hidden" name="staffId" value="<%=staffId%>">
                                <button type="submit">Xác nhận</button>
                            </form>
                        <%
                            }
                        %>
                        <form method="post"><input type="hidden" name="supplierId" value="<%=supplierId%>"><button name="action" value="cancel" class="secondary">Hủy</button></form>
                    </div>
                <%
                    }
                %>
            </section>
        </main>
        <script>
            document.querySelectorAll(".product-select").forEach(function (button) {
            button.addEventListener("click", function () {

                document.querySelectorAll(".product-select").forEach(function (btn) {
                    btn.classList.remove("is-selected");
                    btn.textContent = "Chọn mặt hàng";
                });

                // Đổi trạng thái nút
                button.classList.add("is-selected");
                button.textContent = "✓ Đã chọn";

                // Lưu ID sản phẩm
                document.getElementById("selectedProductId").value = button.dataset.id;

                // Mở các ô nhập liệu
                document.getElementById("quantity").disabled = false;
                document.getElementById("price").disabled = false;
                document.getElementById("addSelected").disabled = false;

                // Focus vào số lượng
                document.getElementById("quantity").focus();
            });
        });
        </script>
    </body>
</html>
