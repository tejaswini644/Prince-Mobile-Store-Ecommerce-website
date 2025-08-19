<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="java.util.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Care Chatbot - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
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
            padding: 20px;
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

        .mobile-right-1 { right: 0; top: 10%; width: 90px; height: 180px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 15s ease-in-out infinite; }
        .mobile-right-2 { right: 0; top: 40%; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 18s ease-in-out infinite; }
        .mobile-left-1 { left: 0; top: 20%; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 16s ease-in-out infinite; }
        .mobile-left-2 { left: 0; top: 60%; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float4 14s ease-in-out infinite; }
        .mobile-top-1 { left: 20%; top: 0; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float5 17s ease-in-out infinite; }
        .mobile-top-2 { left: 60%; top: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 19s ease-in-out infinite; }
        .mobile-bottom-1 { left: 30%; bottom: 0; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 16s ease-in-out infinite; }
        .mobile-bottom-2 { left: 70%; bottom: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 15s ease-in-out infinite; }

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

        @keyframes gradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .chat-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .chat-box { 
            width: 100%; 
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            padding: 20px; 
            border-radius: 1rem;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-light);
        }

        .chat-header {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary-color);
        }

        .chat-header i {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .msg { 
            margin: 10px 0; 
            padding: 15px;
            border-radius: 1rem;
            max-width: 80%;
            position: relative;
            animation: messageAppear 0.3s ease-out;
        }

        .user { 
            color: white;
            background-color: var(--primary-color);
            margin-left: 20%;
            border-bottom-right-radius: 0.2rem;
        }

        .bot { 
            color: var(--text-light);
            background-color: var(--card-bg);
            margin-right: 20%;
            border-bottom-left-radius: 0.2rem;
            border: 1px solid var(--border-light);
        }

        .chat-form {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        .chat-input {
            flex: 1;
        }

        .chat-input input {
            border: 1px solid var(--border-light);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            width: 100%;
            transition: all 0.3s ease;
        }

        .chat-input input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .chat-history {
            height: 400px;
            overflow-y: auto;
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            background: var(--card-bg);
        }

        .back-button {
            margin-bottom: 20px;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .send-button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .send-button:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        @keyframes messageAppear {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 768px) {
            .chat-container {
                padding: 10px;
            }
            
            .msg {
                max-width: 90%;
            }
            
            .chat-history {
                height: calc(100vh - 250px);
            }
        }
    </style>
</head>
<body>
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

    <div class="chat-container">
        <a href="userdashboard" class="btn back-button">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        
        <div class="chat-box">
            <div class="chat-header">
                <i class="bi bi-robot"></i>
                <h2>Mobile Store Chatbot</h2>
            </div>
            
            <div class="chat-history" id="chatHistory">
                <div class="msg bot">
                    <strong>Bot:</strong> Hello! I'm your Mobile Store assistant. How can I help you today?
                </div>
                
                <%
                    String userInput = request.getParameter("userInput");
                    String botReply = "";

                    if (userInput != null && !userInput.trim().isEmpty()) {
                        userInput = userInput.toLowerCase();

                        switch (userInput) {
                            case "hi":
                            case "hello":
                                botReply = "Hello! How can I help you today?";
                                break;
                            case "what are your store hours?":
                            case "store hours":
                                botReply = "Our store is open from 9 AM to 9 PM, 7 days a week.";
                                break;
                            case "do you offer repair services?":
                            case "repair":
                                botReply = "Yes, we offer mobile repair services. You can schedule a repair through our Services page.";
                                break;
                            case "how to track my order?":
                            case "order tracking":
                                botReply = "You can track your order from the 'My Orders' section in your account.";
                                break;
                            case "what payment methods do you accept?":
                            case "payment":
                                botReply = "We accept Credit Cards, Debit Cards, UPI, and Net Banking.";
                                break;
                            case "what is your return policy?":
                            case "return":
                                botReply = "We offer a 7-day return policy for unused products with original packaging and receipt.";
                                break;
                            case "do you offer warranty?":
                            case "warranty":
                                botReply = "Yes, all our products come with a minimum 1-year manufacturer warranty.";
                                break;
                            case "bye":
                                botReply = "Thank you for visiting. Have a great day!";
                                break;
                            default:
                                botReply = "Sorry, I didn't understand that. Here are some things you can ask about: store hours, repair services, order tracking, payment methods, return policy, or warranty.";
                        }
                %>
                    <div class="msg user">
                        <strong>You:</strong> <%= userInput %>
                    </div>
                    <div class="msg bot">
                        <strong>Bot:</strong> <%= botReply %>
                    </div>
                <% } %>
            </div>

            <form method="post" class="chat-form">
                <div class="chat-input">
                    <input type="text" name="userInput" placeholder="Ask something..." required />
                </div>
                <button type="submit" class="send-button">
                    <i class="bi bi-send"></i> Send
                </button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Scroll to bottom of chat history
        window.onload = function() {
            var chatHistory = document.getElementById('chatHistory');
            chatHistory.scrollTop = chatHistory.scrollHeight;
        };
    </script>
</body>
</html> 