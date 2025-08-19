<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get products from request attribute set by UserDashboardServlet
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
    String error = (String) request.getAttribute("error");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .header {
            background-color: #1a237e;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .welcome {
            font-size: 20px;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        .nav-btn {
            background-color: #0d47a1;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .nav-btn:hover {
            background-color: #1565c0;
        }
        .product-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .product-card {
            height: 100%;
            transition: transform 0.3s;
            border: none;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .product-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .product-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin: 1rem 0;
            color: #333;
        }
        .product-category {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .product-price {
            color: #1a237e;
            font-weight: bold;
            font-size: 1.1rem;
            margin: 0.5rem 0;
        }
        .product-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            height: 60px;
            overflow: hidden;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }
        .btn-cart {
            background-color: #4CAF50;
            color: white;
            flex: 1;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-wishlist {
            background-color: #f44336;
            color: white;
            flex: 1;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-cart:hover {
            background-color: #45a049;
        }
        .btn-wishlist:hover {
            background-color: #d32f2f;
        }
        .nav-link {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
        }
        .nav-link:hover {
            color: #f8f9fa;
        }
        .stock-info {
            font-size: 0.8rem;
            color: #666;
            margin-top: 5px;
        }
        .stock-available {
            color: #4CAF50;
        }
        .stock-low {
            color: #ff9800;
        }
        .stock-out {
            color: #f44336;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <!-- Toast Container -->
    <div class="toast-container">
        <div class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="userdashboard">Mobile Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="userdashboard">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">Cart</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="wishlist.jsp">Wishlist</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orders.jsp">orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="chatbot.jsp">chat</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="bookservices.jsp">book service</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact_us.jsp">contact us</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="aboutus.html">about us</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="nav-link">Welcome, <%= user.getName() %></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="product-container">
        <h2 class="text-center mb-4">Our Products</h2>
        
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <% if (productList != null && !productList.isEmpty()) {
                for (Product product : productList) { %>
                <div class="col">
                    <div class="card product-card">
                        <img src="<%= product.getImageUrl() %>" class="card-img-top product-image" alt="<%= product.getName() %>">
                        <div class="card-body">
                            <h5 class="card-title product-title"><%= product.getName() %></h5>
                            <p class="card-text product-category"><%= product.getCategory() %></p>
                            <p class="card-text product-price">₹<%= currencyFormat.format(product.getPrice()) %></p>
                            <p class="card-text product-description"><%= product.getDescription() %></p>
                            
                            <% if (product.getStock() > 10) { %>
                                <p class="stock-info stock-available">In Stock (<%= product.getStock() %> available)</p>
                            <% } else if (product.getStock() > 0) { %>
                                <p class="stock-info stock-low">Low Stock (<%= product.getStock() %> left)</p>
                            <% } else { %>
                                <p class="stock-info stock-out">Out of Stock</p>
                            <% } %>
                            
                            <div class="action-buttons">
                                <form action="AddToCartServlet" method="post" class="d-flex gap-2">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <input type="number" name="quantity" value="1" min="1" max="<%= product.getStock() %>" class="form-control" style="width: 70px;">
                                    <button type="submit" class="btn btn-success" <%= product.getStock() == 0 ? "disabled" : "" %>>
                                        <i class="bi bi-cart-plus"></i> Add to Cart
                                    </button>
                                </form>
                                <form action="AddToWishlistServlet" method="post">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <button type="submit" class="btn btn-outline-primary">
                                        <i class="bi bi-heart"></i> Wishlist
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
            } %>
        </div>
        
        <% if (productList == null || productList.isEmpty()) { %>
            <div class="alert alert-info mt-4">
                No products available at the moment.
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to show toast message
        function showToast(message, type) {
            const toast = document.querySelector('.toast');
            const toastBody = toast.querySelector('.toast-body');
            
            // Set message and type
            toastBody.textContent = message;
            toast.className = `toast align-items-center text-white border-0 ${type}`;
            
            // Show toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }

        // Check for messages from servlets
        <% if (request.getAttribute("message") != null) { %>
            showToast('<%= request.getAttribute("message") %>', 'bg-success');
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            showToast('<%= request.getAttribute("error") %>', 'bg-danger');
        <% } %>
    </script>
</body>
</html> 