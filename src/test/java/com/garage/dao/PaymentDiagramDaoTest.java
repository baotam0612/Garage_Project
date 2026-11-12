package com.garage.dao;

import com.garage.model.Service4;
import com.garage.model.ServiceReception4;
import com.garage.model.ServiceRequest4;
import com.garage.model.SparePart4;
import com.garage.model.SparePartRequest4;
import org.h2.tools.RunScript;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PaymentDiagramDaoTest {
    private static final String URL = "jdbc:h2:mem:payment_diagram;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";

    @BeforeAll
    static void createDatabase() throws Exception {
        try (Connection connection = DriverManager.getConnection(URL);
             var schema = Files.newBufferedReader(Path.of("database/schema.sql"), StandardCharsets.UTF_8);
             var seed = Files.newBufferedReader(Path.of("database/seed.sql"), StandardCharsets.UTF_8)) {
            RunScript.execute(connection, schema);
            RunScript.execute(connection, seed);
        }
    }

    @Test
    void diagramDaosReadAndWriteTheCurrentSchema() throws Exception {
        CustomerDAO customers = new CustomerDAO(() -> DriverManager.getConnection(URL));
        assertEquals("customer-demo", customers.searchCustomerByName("Văn").get(0).getId());
        assertNotNull(customers.getCustomerById("customer-demo"));

        InvoiceDAO invoices = new InvoiceDAO(() -> DriverManager.getConnection(URL));
        assertEquals("invoice-demo", invoices.getInvoiceByCustomer("customer-demo").getId());
        assertEquals("invoice-demo", invoices.getUnpaidInvoiceByCustomer("customer-demo").getId());
        assertNotNull(invoices.getInvoiceById("invoice-demo"));
        assertTrue(invoices.updateInvoiceTotal("invoice-demo"));

        ServiceReception4 reception = new ServiceReception4();
        reception.setId("reception-demo");
        SparePart4 part = new SparePart4();
        part.setId("part-brake-pad");
        SparePartRequest4 partRequest = new SparePartRequest4();
        partRequest.setServiceReception(reception); partRequest.setSparePart(part); partRequest.setQuantity(1);
        partRequest.setActualUsedQuantity(0); partRequest.setUnitPrice(new BigDecimal("750000"));
        partRequest.setCustomerApprovalStatus("APPROVED");
        SparePartRequestDAO4 partRequests = new SparePartRequestDAO4(() -> DriverManager.getConnection(URL));
        assertTrue(partRequests.addSparePartRequest(partRequest));
        assertTrue(partRequests.getByReceptionId("reception-demo").stream()
                .anyMatch(request -> "part-brake-pad".equals(request.getSparePart().getId())));

        Service4 service = new Service4();
        service.setId("svc-brake-check");
        ServiceRequest4 serviceRequest = new ServiceRequest4();
        serviceRequest.setServiceReception(reception); serviceRequest.setService(service); serviceRequest.setQuantity(1);
        serviceRequest.setUnitPrice(new BigDecimal("200000")); serviceRequest.setCustomerApprovalStatus("APPROVED");
        serviceRequest.setFulfillmentStatus("PENDING");
        ServiceRequestDAO4 serviceRequests = new ServiceRequestDAO4(() -> DriverManager.getConnection(URL));
        assertTrue(serviceRequests.addServiceRequest(serviceRequest));
        assertTrue(serviceRequests.getByReceptionId("reception-demo").stream()
                .anyMatch(request -> "svc-brake-check".equals(request.getService().getId())));
    }

    @Test
    void testRegisterAndResetPassword() throws Exception {
        InvoiceDAO dao = new InvoiceDAO(() -> DriverManager.getConnection(URL));
        
        // 1. Register new staff with simple plain password (no hash)
        dao.registerSalesStaff("testuser", "123456", "Trần Test", "NV999");
        
        // 2. Verify identity and login
        var identity = dao.findSalesStaffByUsername("testuser");
        assertNotNull(identity);
        assertEquals("Trần Test", identity.getFullName());
        assertTrue(InvoiceDAO.verifyPassword("123456", identity.getAccount().getPasswordHash()));
        assertFalse(InvoiceDAO.verifyPassword("wrongpass", identity.getAccount().getPasswordHash()));

        // 3. Reset password (forgot password)
        dao.resetPassword("testuser", "newpass654");
        var updatedIdentity = dao.findSalesStaffByUsername("testuser");
        assertNotNull(updatedIdentity);
        assertTrue(InvoiceDAO.verifyPassword("newpass654", updatedIdentity.getAccount().getPasswordHash()));
        assertFalse(InvoiceDAO.verifyPassword("123456", updatedIdentity.getAccount().getPasswordHash()));
    }

    @Test
    void testInvoiceSupplementAndConfirmFlow() throws Exception {
        InvoiceDAO dao = new InvoiceDAO(() -> DriverManager.getConnection(URL));

        // 1. Check find by invoice_number "HD001"
        var invByNumber = dao.getInvoiceById("HD001");
        assertNotNull(invByNumber);
        assertEquals("HD001", invByNumber.getInvoiceNumber());
        assertFalse(invByNumber.getServiceReception().getServiceRequests().isEmpty()
                && invByNumber.getServiceReception().getSpareParts().isEmpty());

        // 2. Confirm invoice
        dao.confirm("HD001", "sales-001");
        var confirmedInv = dao.getInvoiceById("HD001");
        assertEquals("CONFIRMED", confirmedInv.getInvoiceStatus());

        // 3. Supplement item to an already CONFIRMED unpaid invoice
        // This should NOT throw "Hóa đơn không ở trạng thái cho phép thao tác này."
        dao.addItem("HD001", "SPARE_PART", "part-coolant", 2);
        dao.addItem("HD001", "SERVICE", "svc-brake-check", 1);

        var supplementedInv = dao.getInvoiceById("HD001");
        assertNotNull(supplementedInv);
        assertEquals("DRAFT", supplementedInv.getInvoiceStatus());
        SparePartRequestDAO4 partRequests = new SparePartRequestDAO4(() -> DriverManager.getConnection(URL));
        assertTrue(partRequests.getByReceptionId("reception-demo").stream()
                .anyMatch(request -> "part-coolant".equals(request.getSparePart().getId())
                        && request.getQuantity() == 2
                        && "Bổ sung khi lập hóa đơn".equals(request.getNotes())));
        ServiceRequestDAO4 serviceRequests = new ServiceRequestDAO4(() -> DriverManager.getConnection(URL));
        assertTrue(serviceRequests.getByReceptionId("reception-demo").stream()
                .anyMatch(request -> "svc-brake-check".equals(request.getService().getId())
                        && request.getQuantity() == 1
                        && "Bổ sung khi lập hóa đơn".equals(request.getNotes())));
        // 1,250,000 + 2 * 120,000 tiền phụ tùng + 150,000 tiền dịch vụ.
        assertEquals(new BigDecimal("1640000.00"), supplementedInv.getTotalAmount());

        // 4. Re-confirm
        dao.confirm("HD001", "sales-001");
        var reconfirmedInv = dao.getInvoiceById("HD001");
        assertEquals("CONFIRMED", reconfirmedInv.getInvoiceStatus());
    }
}
