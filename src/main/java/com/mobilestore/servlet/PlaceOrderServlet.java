package com.mobilestore.servlet;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dao.ShippingAddressDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.Order;
import com.mobilestore.model.OrderItem;
import com.mobilestore.model.Product;
import com.mobilestore.model.ShippingAddress;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private ShippingAddressDAO shippingAddressDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        shippingAddressDAO = new ShippingAddressDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("PlaceOrderServlet: doPost method called");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            System.out.println("PlaceOrderServlet: User not logged in, redirecting to login page");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            System.out.println("PlaceOrderServlet: Starting order placement process for user: " + user.getId());
            
            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zipCode = request.getParameter("zipCode");
            String phone = request.getParameter("phone");
            String paymentMethod = request.getParameter("paymentMethod");

            // Log all form parameters
            System.out.println("PlaceOrderServlet: Form parameters received:");
            System.out.println("fullName: " + fullName);
            System.out.println("email: " + email);
            System.out.println("address: " + address);
            System.out.println("city: " + city);
            System.out.println("state: " + state);
            System.out.println("zipCode: " + zipCode);
            System.out.println("phone: " + phone);
            System.out.println("paymentMethod: " + paymentMethod);

            // Get cart items
            List<Cart> cartItems = cartDAO.getCartItemsByUserId(user.getId());
            if (cartItems == null || cartItems.isEmpty()) {
                System.out.println("PlaceOrderServlet: No cart items found for user: " + user.getId());
                request.setAttribute("error", "Your cart is empty.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // Calculate total amount
            double totalAmount = 0;
            for (Cart item : cartItems) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null) {
                    totalAmount += item.getQuantity() * product.getPrice();
                }
            }
            System.out.println("PlaceOrderServlet: Total amount calculated: " + totalAmount);

            // Create order object
            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setTotalAmount(totalAmount);
            order.setStatus("Pending");

            // Save order to database
            System.out.println("PlaceOrderServlet: Attempting to save order...");
            int orderId = orderDAO.addOrder(order);
            System.out.println("PlaceOrderServlet: Order saved with ID: " + orderId);

            if (orderId > 0) {
                try {
                    // Create shipping address
                    ShippingAddress shippingAddress = new ShippingAddress();
                    shippingAddress.setUserId(user.getId());
                    shippingAddress.setOrderId(orderId);
                    shippingAddress.setFullName(fullName);
                    shippingAddress.setAddress(address);
                    shippingAddress.setCity(city);
                    shippingAddress.setState(state);
                    shippingAddress.setZipCode(zipCode);
                    shippingAddress.setPhone(phone);
                    shippingAddress.setDefault(true);

                    // Save shipping address
                    System.out.println("PlaceOrderServlet: Attempting to save shipping address...");
                    int shippingAddressId = shippingAddressDAO.addShippingAddress(shippingAddress);
                    System.out.println("PlaceOrderServlet: Shipping address saved with ID: " + shippingAddressId);

                    if (shippingAddressId > 0) {
                        // Clear the cart after successful order
                        System.out.println("PlaceOrderServlet: Clearing cart for user: " + user.getId());
                        cartDAO.clearCart(user.getId());

                        // Set order ID in session for confirmation page
                        session.setAttribute("orderId", orderId);
                        System.out.println("PlaceOrderServlet: Order ID set in session: " + orderId);
                        
                        // Redirect to order confirmation page
                        System.out.println("PlaceOrderServlet: Redirecting to orderconfirmation.jsp");
                        response.sendRedirect(request.getContextPath() + "/orderConfirmation.jsp");
                        return;
                    } else {
                        System.out.println("PlaceOrderServlet: Failed to save shipping address");
                        orderDAO.deleteOrder(orderId);
                        request.setAttribute("error", "Failed to save shipping address. Please try again.");
                        request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    System.out.println("PlaceOrderServlet: Error saving shipping address: " + e.getMessage());
                    e.printStackTrace();
                    orderDAO.deleteOrder(orderId);
                    request.setAttribute("error", "Error saving shipping address: " + e.getMessage());
                    request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
                    return;
                }
            } else {
                System.out.println("PlaceOrderServlet: Failed to save order");
                request.setAttribute("error", "Failed to place order. Please try again.");
                request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            System.out.println("PlaceOrderServlet: Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your order: " + e.getMessage());
            request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
            return;
        }
    }
} 