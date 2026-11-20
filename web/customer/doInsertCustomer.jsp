
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="qlst.model.Customer5,qlst.dao.Customer5DAO,java.time.LocalDate" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String error = null;

    try {
        String name = request.getParameter("inName");
        String phone = request.getParameter("inPhone");
        String email = request.getParameter("inEmail");
        String username = request.getParameter("inUsername");
        String password = request.getParameter("inPassword");
        String confirm = request.getParameter("inConfirmPassword");
        String address = request.getParameter("inAddress");
        String dob = request.getParameter("inDob");

        if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty() || username == null || username.trim().isEmpty() || password == null || password.isEmpty() || confirm == null || confirm.isEmpty()) throw new IllegalArgumentException("Chưa nhập đủ thông tin bắt buộc.");
        if (!phone.matches("0[0-9]{9}")) throw new IllegalArgumentException("Số điện thoại không hợp lệ.");
        if (email == null) email = "";
        if (!email.isEmpty() && !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) throw new IllegalArgumentException("Email không hợp lệ.");
        if (password.length() < 6 || !password.matches(".*[A-Za-z].*") || !password.matches(".*[0-9].*") || !password.matches(".*[^A-Za-z0-9\\s].*")) throw new IllegalArgumentException("Mật khẩu tối thiểu 6 ký tự, có chữ cái, chữ số và ký tự đặc biệt.");
        if (!password.equals(confirm)) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
        }

        Customer5 customer = new Customer5();
        customer.setName(name.trim());
        customer.setPhone(phone.trim());
        customer.setEmail(email.trim());
        customer.setUsername(username.trim());
        customer.setPassword(password);


        if (dob != null && !dob.trim().isEmpty()) {
            if (LocalDate.parse(dob).isAfter(LocalDate.now())) throw new IllegalArgumentException("Ngày sinh không hợp lệ.");
            customer.setDateOfBirth(LocalDate.parse(dob));
        }

        if (!new Customer5DAO().addCustomer(customer)) {
            throw new IllegalArgumentException("Không thể lưu đăng ký.");
        }
    }
    catch (IllegalArgumentException ex) {
        error = ex.getMessage();
    }
    catch (java.sql.SQLIntegrityConstraintViolationException ex) {
        error = "Tên đăng nhập đã được sử dụng. Hãy chọn tên khác.";
    }
    catch (Exception ex) {
        application.log("Không thể đăng ký thành viên", ex);
        error = "Không thể lưu đăng ký. Hãy kiểm tra cấu hình cơ sở dữ liệu rồi thử lại.";
    }
    java.util.Map<String,String> values = new java.util.HashMap<String,String>();
    for (String field : request.getParameterMap().keySet()) {
        if (!field.toLowerCase(java.util.Locale.ROOT).contains("password")) values.put(field, request.getParameter(field));
    }
    if (error != null) {
        session.setAttribute("registerValues", values);
        session.setAttribute("registerError", error);
        response.sendRedirect(request.getContextPath()+"/customer/FrmRegister5.jsp");
    } else {
        session.removeAttribute("registerValues");
        session.setAttribute("notice", "Đăng ký thành công.");
        response.sendRedirect(request.getContextPath()+"/user/FrmLogin5.jsp");
    }

%>