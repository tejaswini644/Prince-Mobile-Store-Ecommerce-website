<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.model.OrderItem" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #4338ca;
            --accent-color: #6366f1;
            --background-light: #f0f2f5;
            --text-light: #1e293b;
            --card-bg: rgba(255, 255, 255, 0.9);
            --border-light: rgba(79, 70, 229, 0.1);
            --shadow-light: 0 8px 32px rgba(79, 70, 229, 0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--background-light);
            background-image: linear-gradient(135deg, #f0f2f5 0%, #e4e6eb 100%);
            min-height: 100vh;
            color: var(--text-light);
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(79, 70, 229, 0.1) 0%, rgba(99, 102, 241, 0.1) 100%);
            animation: gradientAnimation 15s ease infinite;
            z-index: -1;
        }

        .floating-mobiles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            overflow: hidden;
        }

        .mobile {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.08;
            filter: blur(0.5px);
        }

        /* Accessory SVG backgrounds */
        .accessory {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.10;
            filter: blur(0.3px);
            z-index: -1;
        }

        .accessory-earphones {
            width: 80px; height: 80px;
            top: 10%; left: 45%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><path d="M12 24C12 17.3726 17.3726 12 24 12C30.6274 12 36 17.3726 36 24" stroke="%234f46e5" stroke-width="3" stroke-linecap="round"/><rect x="8" y="24" width="8" height="12" rx="4" fill="%234f46e5"/><rect x="32" y="24" width="8" height="12" rx="4" fill="%234f46e5"/></svg>');
            animation: accessoryFloat1 20s ease-in-out infinite;
        }

        .accessory-charger {
            width: 70px; height: 70px;
            bottom: 12%; right: 40%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="16" y="18" width="16" height="16" rx="4" fill="%234f46e5"/><rect x="20" y="10" width="2" height="8" rx="1" fill="%234f46e5"/><rect x="26" y="10" width="2" height="8" rx="1" fill="%234f46e5"/></svg>');
            animation: accessoryFloat2 22s ease-in-out infinite;
        }

        .accessory-watch {
            width: 60px; height: 60px;
            top: 50%; left: 0;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><circle cx="24" cy="24" r="10" stroke="%234f46e5" stroke-width="3"/><rect x="20" y="6" width="8" height="6" rx="2" fill="%234f46e5"/><rect x="20" y="36" width="8" height="6" rx="2" fill="%234f46e5"/></svg>');
            animation: accessoryFloat3 18s ease-in-out infinite;
        }

        .accessory-case {
            width: 65px; height: 65px;
            bottom: 50%; right: 0;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="14" y="10" width="20" height="28" rx="6" stroke="%234f46e5" stroke-width="3"/><rect x="20" y="36" width="8" height="2" rx="1" fill="%234f46e5"/></svg>');
            animation: accessoryFloat4 21s ease-in-out infinite;
        }

        @keyframes accessoryFloat1 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(15px, -20px) rotate(8deg); }
            50% { transform: translate(0, -40px) rotate(0deg); }
            75% { transform: translate(-15px, -20px) rotate(-8deg); }
        }

        @keyframes accessoryFloat2 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-20px, 15px) rotate(-8deg); }
            50% { transform: translate(-40px, 0) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(8deg); }
        }

        @keyframes accessoryFloat3 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(25px, 0) rotate(5deg); }
            50% { transform: translate(50px, 0) rotate(0deg); }
            75% { transform: translate(25px, 0) rotate(-5deg); }
        }

        @keyframes accessoryFloat4 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(0, -25px) rotate(-5deg); }
            50% { transform: translate(0, -50px) rotate(0deg); }
            75% { transform: translate(0, -25px) rotate(5deg); }
        }

        /* Enhanced floating animations */
        @keyframes float1 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(20px, -15px) rotate(5deg); }
            50% { transform: translate(0, -30px) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(-5deg); }
        }

        @keyframes float2 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-15px, 20px) rotate(-5deg); }
            50% { transform: translate(0, 40px) rotate(0deg); }
            75% { transform: translate(15px, 20px) rotate(5deg); }
        }

        @keyframes float3 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(15px, -20px) rotate(3deg); }
            50% { transform: translate(30px, 0) rotate(0deg); }
            75% { transform: translate(15px, 20px) rotate(-3deg); }
        }

        @keyframes float4 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-20px, 15px) rotate(-3deg); }
            50% { transform: translate(-40px, 0) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(3deg); }
        }

        @keyframes float5 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(0, 25px) rotate(2deg); }
            50% { transform: translate(0, 50px) rotate(0deg); }
            75% { transform: translate(0, 25px) rotate(-2deg); }
        }

        /* Updated mobile styles with enhanced animations */
        .mobile-right-1 { right: 0; top: 10%; width: 90px; height: 180px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 15s ease-in-out infinite; }
        .mobile-right-2 { right: 0; top: 40%; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 18s ease-in-out infinite; }
        .mobile-left-1 { left: 0; top: 20%; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 16s ease-in-out infinite; }
        .mobile-left-2 { left: 0; top: 60%; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float4 14s ease-in-out infinite; }
        .mobile-top-1 { left: 20%; top: 0; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float5 17s ease-in-out infinite; }
        .mobile-top-2 { left: 60%; top: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 19s ease-in-out infinite; }
        .mobile-bottom-1 { left: 30%; bottom: 0; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 16s ease-in-out infinite; }
        .mobile-bottom-2 { left: 70%; bottom: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 15s ease-in-out infinite; }

        .orders-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .page-header {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            color: var(--primary-color);
            font-size: 2rem;
            margin: 0;
            font-weight: 600;
        }

        .order-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-light);
        }

        .order-item {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding: 1rem;
            border-bottom: 1px solid var(--border-light);
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid var(--border-light);
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-processing {
            background: #cce5ff;
            color: #004085;
        }

        .status-shipped {
            background: #d4edda;
            color: #155724;
        }

        .status-delivered {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .empty-orders {
            text-align: center;
            padding: 3rem;
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
        }

        .empty-orders i {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .orders-container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .order-item {
                flex-direction: column;
                text-align: center;
            }
        }

        .order-timeline {
            position: relative;
            padding: 1rem 0;
            margin: 1rem 0;
        }

        .timeline-track {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--border-light);
            transform: translateY(-50%);
            z-index: 1;
        }

        .timeline-progress {
            position: absolute;
            top: 50%;
            left: 0;
            height: 4px;
            background: var(--primary-color);
            transform: translateY(-50%);
            z-index: 2;
            transition: width 0.5s ease;
        }

        .timeline-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            z-index: 3;
        }

        .timeline-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
        }

        .timeline-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--card-bg);
            border: 2px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }

        .timeline-step.active .timeline-icon {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: scale(1.1);
        }

        .timeline-step.completed .timeline-icon {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .timeline-label {
            font-size: 0.8rem;
            color: var(--text-light);
            text-align: center;
            opacity: 0.7;
        }

        .timeline-step.active .timeline-label {
            opacity: 1;
            font-weight: 600;
        }

        .order-summary-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .order-summary-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: rgba(79, 70, 229, 0.05);
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            background: rgba(79, 70, 229, 0.1);
            transform: translateY(-2px);
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--text-light);
            opacity: 0.7;
        }

        .product-preview {
            position: relative;
            overflow: hidden;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .product-preview img {
            transition: transform 0.3s ease;
        }

        .product-preview:hover img {
            transform: scale(1.1);
        }

        .product-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.7), transparent);
            padding: 1rem;
            color: white;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .product-preview:hover .product-overlay {
            transform: translateY(0);
        }

        .order-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .action-button {
            flex: 1;
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .action-button:hover {
            transform: translateY(-2px);
        }

        .action-button.primary {
            background: var(--primary-color);
            color: white;
        }

        .action-button.secondary {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .summary-stats {
                grid-template-columns: 1fr;
            }

            .order-actions {
                flex-direction: column;
            }
        }

        .floating-dots {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .dot {
            position: absolute;
            width: 4px;
            height: 4px;
            background: var(--primary-color);
            border-radius: 50%;
            opacity: 0.1;
            animation: floatDot 15s infinite;
        }

        @keyframes floatDot {
            0%, 100% { transform: translate(0, 0); }
            25% { transform: translate(10px, -15px); }
            50% { transform: translate(20px, 0); }
            75% { transform: translate(10px, 15px); }
        }

        .order-card::before {
            content: '';
            position: absolute;
            top: -1px;
            left: -1px;
            right: -1px;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            border-radius: 1rem 1rem 0 0;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .order-card:hover::before {
            opacity: 1;
        }

        .status-badge::after {
            content: '';
            position: absolute;
            top: -2px;
            right: -2px;
            width: 8px;
            height: 8px;
            background: var(--primary-color);
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .status-badge:hover::after {
            opacity: 1;
        }

        .product-preview::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border: 2px solid var(--primary-color);
            border-radius: 0.5rem;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .product-preview:hover::after {
            opacity: 0.3;
        }

        .timeline-icon::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: var(--primary-color);
            opacity: 0;
            transform: scale(0.5);
            transition: all 0.3s ease;
        }

        .timeline-step.active .timeline-icon::before {
            opacity: 0.1;
            transform: scale(1.2);
        }

        .stat-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 3px;
            height: 100%;
            background: var(--primary-color);
            border-radius: 0 3px 3px 0;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .stat-item:hover::before {
            opacity: 1;
        }

        .action-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: translateX(-100%);
            transition: transform 0.5s ease;
        }

        .action-button:hover::before {
            transform: translateX(100%);
        }
    </style>
</head>
<body>
    <div class="floating-dots">
        <% for (int i = 0; i < 20; i++) { %>
            <div class="dot" style="
                top: <%= Math.random() * 100 %>%;
                left: <%= Math.random() * 100 %>%;
                animation-delay: <%= Math.random() * 5 %>s;
            "></div>
        <% } %>
    </div>

    <div class="floating-mobiles">
        <!-- Accessories -->
        <div class="accessory accessory-earphones"></div>
        <div class="accessory accessory-charger"></div>
        <div class="accessory accessory-watch"></div>
        <div class="accessory accessory-case"></div>
        <!-- More mobiles at borders -->
        <div class="mobile mobile-right-1"></div>
        <div class="mobile mobile-right-2"></div>
        <div class="mobile mobile-left-1"></div>
        <div class="mobile mobile-left-2"></div>
        <div class="mobile mobile-top-1"></div>
        <div class="mobile mobile-top-2"></div>
        <div class="mobile mobile-bottom-1"></div>
        <div class="mobile mobile-bottom-2"></div>
    </div>

    <div class="orders-container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">My Orders</h2>
            <a href="userdashboard" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
        </div>

        <% if (orders.isEmpty()) { %>
            <div class="empty-orders" data-aos="fade-up">
                <i class="bi bi-box-seam"></i>
                <h3>No Orders Found</h3>
                <p class="text-muted">You haven't placed any orders yet.</p>
                <a href="userdashboard" class="btn btn-primary mt-3">
                    <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                </a>
            </div>
        <% } else { %>
            <% for (Order order : orders) { 
                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
            %>
                <div class="order-card" data-aos="fade-up">
                    <div class="order-header">
                        <div>
                            <h5 class="mb-0">Order #<%= order.getId() %></h5>
                            <small class="text-muted">Placed on <%= order.getOrderDate() %></small>
                        </div>
                        <div>
                            <span class="status-badge status-<%= order.getStatus().toLowerCase() %>">
                                <i class="bi bi-circle-fill"></i>
                                <%= order.getStatus() %>
                            </span>
                        </div>
                    </div>

                    <div class="order-timeline">
                        <div class="timeline-track"></div>
                        <div class="timeline-progress" style="width: <%= getProgressWidth(order.getStatus()) %>"></div>
                        <div class="timeline-steps">
                            <div class="timeline-step <%= order.getStatus().equals("PENDING") ? "active" : "completed" %>">
                                <div class="timeline-icon">
                                    <i class="bi bi-cart-check"></i>
                                </div>
                                <div class="timeline-label">Ordered</div>
                            </div>
                            <div class="timeline-step <%= order.getStatus().equals("PROCESSING") ? "active" : (order.getStatus().equals("PENDING") ? "" : "completed") %>">
                                <div class="timeline-icon">
                                    <i class="bi bi-gear"></i>
                                </div>
                                <div class="timeline-label">Processing</div>
                            </div>
                            <div class="timeline-step <%= order.getStatus().equals("SHIPPED") ? "active" : (order.getStatus().equals("DELIVERED") ? "completed" : "") %>">
                                <div class="timeline-icon">
                                    <i class="bi bi-truck"></i>
                                </div>
                                <div class="timeline-label">Shipped</div>
                            </div>
                            <div class="timeline-step <%= order.getStatus().equals("DELIVERED") ? "active" : "" %>">
                                <div class="timeline-icon">
                                    <i class="bi bi-check-circle"></i>
                                </div>
                                <div class="timeline-label">Delivered</div>
                            </div>
                        </div>
                    </div>

                    <div class="order-summary-card">
                        <h6 class="mb-3">Order Summary</h6>
                        <div class="summary-stats">
                            <div class="stat-item">
                                <div class="stat-value"><%= orderItems.size() %></div>
                                <div class="stat-label">Items</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><%= currencyFormat.format(order.getTotalAmount()) %></div>
                                <div class="stat-label">Total Amount</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><%= order.getOrderDate() %></div>
                                <div class="stat-label">Order Date</div>
                            </div>
                        </div>
                    </div>

                    <% for (OrderItem item : orderItems) { 
                        Product product = productDAO.getProductById(item.getProductId());
                    %>
                        <div class="order-item">
                            <div class="product-preview">
                                <img src="<%= product.getImageUrl() %>" class="product-image" alt="<%= product.getName() %>">
                                <div class="product-overlay">
                                    <h6 class="mb-1"><%= product.getName() %></h6>
                                    <p class="mb-0">Quantity: <%= item.getQuantity() %></p>
                                </div>
                            </div>
                            <div class="flex-grow-1">
                                <h6 class="mb-1"><%= product.getName() %></h6>
                                <p class="text-muted mb-0">Quantity: <%= item.getQuantity() %></p>
                                <p class="text-muted mb-0">Category: <%= product.getCategory() %></p>
                            </div>
                            <div class="text-end">
                                <h6 class="mb-0"><%= currencyFormat.format(item.getPrice() * item.getQuantity()) %></h6>
                                <small class="text-muted">₹<%= item.getPrice() %> each</small>
                            </div>
                        </div>
                    <% } %>

                    <div class="order-actions">
                        <button class="action-button primary">
                            <i class="bi bi-truck"></i>
                            Track Order
                        </button>
                        <button class="action-button secondary">
                            <i class="bi bi-chat"></i>
                            Contact Support
                        </button>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true
        });
    </script>
</body>
</html>

<%!
    private String getProgressWidth(String status) {
        switch (status.toUpperCase()) {
            case "PENDING":
                return "25%";
            case "PROCESSING":
                return "50%";
            case "SHIPPED":
                return "75%";
            case "DELIVERED":
                return "100%";
            default:
                return "0%";
        }
    }
%> 