package com.mobilestore.servlet;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Check if product is already in cart
            Cart existingCartItem = cartDAO.getCartItem(user.getId(), productId);
            
            if (existingCartItem != null) {
                // Update quantity if item exists
                existingCartItem.setQuantity(existingCartItem.getQuantity() + quantity);
                cartDAO.updateCartItem(existingCartItem);
                request.setAttribute("message", "Cart updated successfully!");
            } else {
                // Add new item to cart
                Cart cartItem = new Cart();
                cartItem.setUserId(user.getId());
                cartItem.setProductId(productId);
                cartItem.setQuantity(quantity);
                
                if (cartDAO.addToCart(cartItem)) {
                    request.setAttribute("message", "Product added to cart successfully!");
                } else {
                    request.setAttribute("error", "Failed to add product to cart.");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity or product ID.");
        } catch (Exception e) {
            request.setAttribute("error", "Error adding to cart: " + e.getMessage());
        }

        // Redirect to cart page
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
} 