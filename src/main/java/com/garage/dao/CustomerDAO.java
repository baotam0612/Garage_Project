package com.garage.dao;

import com.garage.model.Customer4;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DAO {
    public CustomerDAO() { this(Database::getConnection); }
    public CustomerDAO(ConnectionProvider provider) { super(provider); }

    public List<Customer4> searchCustomerByName(String customerName) throws SQLException {
        String sql = "SELECT c.person_id, c.customer_code, p.full_name, p.phone_number, p.address "
                + "FROM customers c JOIN persons p ON p.id = c.person_id "
                + "WHERE LOWER(p.full_name) LIKE ? ESCAPE '!' ORDER BY p.full_name LIMIT 300";
        List<Customer4> customers = new ArrayList<>();
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, searchPattern(customerName));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    customers.add(mapCustomer(rows));
                }
            }
        }
        return customers;
    }

    public Customer4 getCustomerById(String id) throws SQLException {
        String sql = "SELECT c.person_id, c.customer_code, p.full_name, p.phone_number, p.address "
                + "FROM customers c JOIN persons p ON p.id = c.person_id WHERE c.person_id = ?";
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, id);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? mapCustomer(rows) : null;
            }
        }
    }

    private Customer4 mapCustomer(ResultSet rows) throws SQLException {
        return new Customer4(rows.getString(1), rows.getString(2), rows.getString(3), rows.getString(4), rows.getString(5));
    }
}
