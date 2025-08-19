package com.mobilestore.dao;

import com.mobilestore.model.Wishlist;
import com.mobilestore.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class WishlistDAO {
    private static final Logger logger = Logger.getLogger(WishlistDAO.class.getName());
    private Connection connection;

    public WishlistDAO() {
        try {
            connection = DatabaseUtil.getConnection();
        } catch (SQLException e) {
            logger.severe("Failed to establish database connection: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean addToWishlist(Wishlist wishlist) {
        if (connection == null) {
            logger.severe("Database connection is null");
            return false;
        }
        
        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, wishlist.getUserId());
            statement.setInt(2, wishlist.getProductId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Error adding to wishlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int wishlistId, int userId) {
        if (connection == null) {
            logger.severe("Database connection is null");
            return false;
        }
        
        String sql = "DELETE FROM wishlist WHERE id = ? AND user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, wishlistId);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Error removing from wishlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Wishlist> getWishlistItemsByUserId(int userId) {
        List<Wishlist> wishlistItems = new ArrayList<>();
        if (connection == null) {
            logger.severe("Database connection is null");
            return wishlistItems;
        }
        
        String sql = "SELECT * FROM wishlist WHERE user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Wishlist wishlist = new Wishlist();
                wishlist.setId(resultSet.getInt("id"));
                wishlist.setUserId(resultSet.getInt("user_id"));
                wishlist.setProductId(resultSet.getInt("product_id"));
                wishlistItems.add(wishlist);
            }
        } catch (SQLException e) {
            logger.severe("Error getting wishlist items: " + e.getMessage());
            e.printStackTrace();
        }
        return wishlistItems;
    }

    public boolean isProductInWishlist(int userId, int productId) {
        if (connection == null) {
            logger.severe("Database connection is null");
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.severe("Error checking product in wishlist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}