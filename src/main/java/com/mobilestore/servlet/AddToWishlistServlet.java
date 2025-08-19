package com.mobilestore.servlet;

import com.mobilestore.dao.WishlistDAO;
import com.mobilestore.model.Wishlist;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddToWishlistServlet")
public class AddToWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
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

            // Check if product is already in wishlist
            if (wishlistDAO.isProductInWishlist(user.getId(), productId)) {
                request.setAttribute("error", "Product is already in your wishlist.");
                response.sendRedirect("wishlist.jsp");
                return;
            }

            // Create wishlist item
            Wishlist wishlist = new Wishlist(user.getId(), productId);

            // Add to wishlist
            if (wishlistDAO.addToWishlist(wishlist)) {
                request.setAttribute("message", "Product added to wishlist successfully!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("error", "Failed to add product to wishlist.");
            }

            response.sendRedirect("wishlist.jsp");

        } catch (Exception e) {
            request.setAttribute("error", "Error adding to wishlist: " + e.getMessage());
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);
        }
    }
} 