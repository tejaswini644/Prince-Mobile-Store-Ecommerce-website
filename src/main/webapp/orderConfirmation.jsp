<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.dao.ShippingAddressDAO" %>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.model.ShippingAddress" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId = (Integer) session.getAttribute("orderId");
    if (orderId == null) {
        response.sendRedirect("userdashboard");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    ShippingAddressDAO shippingAddressDAO = new ShippingAddressDAO();
    
    Order order = orderDAO.getOrderById(orderId);
    ShippingAddress shippingAddress = shippingAddressDAO.getShippingAddressByOrderId(orderId);
    
    if (order == null || shippingAddress == null) {
        response.sendRedirect("userdashboard");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .confirmation-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .success-icon {
            color: #28a745;
            font-size: 4rem;
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <div class="text-center mb-4">
            <i class="bi bi-check-circle-fill success-icon"></i>
            <h2 class="mt-3">Order Placed Successfully!</h2>
            <p class="text-muted">Thank you for your purchase</p>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h4>Order Details</h4>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Order ID:</strong>
                        <p><%= order.getId() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Order Date:</strong>
                        <p><%= order.getOrderDate() %></p>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Total Amount:</strong>
                        <p><%= order.getTotalAmount() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Order Status:</strong>
                        <p><span class="badge bg-primary"><%= order.getStatus() %></span></p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h4>Shipping Information</h4>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Full Name:</strong>
                        <p><%= shippingAddress.getFullName() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Phone:</strong>
                        <p><%= shippingAddress.getPhone() %></p>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-12">
                        <strong>Address:</strong>
                        <p>
                            <%= shippingAddress.getAddress() %><br>
                            <%= shippingAddress.getCity() %>, <%= shippingAddress.getState() %> <%= shippingAddress.getZipCode() %>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center">
            <a href="userdashboard" class="btn btn-primary">
                <i class="bi bi-house"></i> Return to Dashboard
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>  