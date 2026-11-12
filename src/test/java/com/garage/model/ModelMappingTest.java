package com.garage.model;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ModelMappingTest {

    @Test
    void testPersonAndStaffInheritance() {
        LocalDate now = LocalDate.now();

        Customer4 customer = new Customer4("cust-1", "KH01", "Nguyễn Văn A", "0912345678", "Hà Nội");
        assertEquals("cust-1", customer.getId());
        assertEquals("KH01", customer.getCustomerCode());
        assertEquals("Nguyễn Văn A", customer.getFullName());
        assertTrue(customer instanceof Person4);

        CustomerStatistics4 custStats = new CustomerStatistics4(100, 10);
        custStats.setCustomerCode("KH01");
        custStats.setFullName("Nguyễn Văn A");
        assertEquals(100, custStats.getTotalCustomers());
        assertEquals(10, custStats.getNewCustomers());
        assertTrue(custStats instanceof Customer4);
        assertTrue(custStats instanceof Person4);

        Account4 account = new Account4("acc-1", "nv_banhang", "hash123", "SALES", LocalDateTime.now());
        assertEquals("nv_banhang", account.getUsername());

        User4 user = new User4("user-1", "Trần Văn B", now, "Nam", "0987654321", "b@gmail.com", "Hà Nội",
                now, "Sáng", "ACTIVE", account);
        assertTrue(user instanceof Person4);
        assertEquals("Sáng", user.getWorkShift());
        assertEquals(account, user.getAccount());

        Manager4 manager = new Manager4("TRUONG_PHONG");
        manager.setFullName("Lê Quản Lý");
        assertTrue(manager instanceof User4);
        assertTrue(manager instanceof Person4);
        assertEquals("TRUONG_PHONG", manager.getManagementLevel());

        Technician4 tech = new Technician4("Máy gầm", "Bậc 4");
        tech.setFullName("Phạm Kỹ Thuật");
        assertTrue(tech instanceof User4);
        assertTrue(tech instanceof Person4);
        assertEquals("Máy gầm", tech.getSpecialization());
        assertEquals("Bậc 4", tech.getSkillLevel());

        WarehouseStaff4 whStaff = new WarehouseStaff4("Kho Phụ Tùng 1");
        whStaff.setFullName("Vũ Kho");
        assertTrue(whStaff instanceof User4);
        assertTrue(whStaff instanceof Person4);
        assertEquals("Kho Phụ Tùng 1", whStaff.getAssignedWarehouseArea());

        SalesStaff4 sales = new SalesStaff4("user-sales", "NVBH01", "Đỗ Bán Hàng");
        assertTrue(sales instanceof User4);
        assertTrue(sales instanceof Person4);
        assertEquals("NVBH01", sales.getSalesStaffCode());
    }

    @Test
    void testVehicleAndAppointmentAndReception() {
        Customer4 customer = new Customer4("cust-1", "KH01", "Nguyễn Văn A", "0912345678", "Hà Nội");
        Vehicle4 vehicle = new Vehicle4();
        vehicle.setId("veh-1");
        vehicle.setLicensePlate("29A-12345");
        vehicle.setMake("Toyota");
        vehicle.setModel("Vios");
        vehicle.setManufactureYear(2021);
        vehicle.setColor("Trắng");
        vehicle.setCustomer(customer);
        assertEquals("29A-12345", vehicle.getLicensePlate());
        assertEquals(customer, vehicle.getCustomer());

        Appointment4 appointment = new Appointment4("app-1", LocalDate.now(), "Bảo dưỡng định kỳ",
                "WEB", "CONFIRMED", vehicle);
        assertEquals(vehicle, appointment.getVehicle());
        assertEquals("CONFIRMED", appointment.getAppointmentStatus());

        ServiceReception4 reception = new ServiceReception4();
        reception.setId("rec-1");
        reception.setReceiveAt(LocalDate.now());
        reception.setVehicle(vehicle);
        reception.setAppointment(appointment);
        reception.setStatus("IN_PROGRESS");
        assertEquals(LocalDate.now(), reception.getReceiveAt());
        assertEquals(LocalDate.now(), reception.getReceivedAt());
        assertEquals(vehicle, reception.getVehicle());
    }

    @Test
    void testServiceAndServiceStatistics() {
        ServiceCategory4 cat = new ServiceCategory4("cat-1", "Bảo dưỡng", "Bảo dưỡng định kỳ");
        Service4 service = new Service4("svc-1", "BD01", "Thay dầu động cơ", "oil.jpg",
                "Thay dầu 5W30", new BigDecimal("350000"), AvailabilityStatus.AVAILABLE, cat);
        assertEquals("BD01", service.getServiceCode());
        assertEquals(cat, service.getServiceCategory());

        ServiceStatistics4 stats = new ServiceStatistics4(50, new BigDecimal("15000000"));
        stats.setServiceCode("BD01");
        assertTrue(stats instanceof Service4);
        assertEquals(50, stats.getTotalServiceRequests());
        assertEquals(new BigDecimal("15000000"), stats.getTotalServiceRevenue());

        Technician4 tech = new Technician4("Điện - Điện lạnh", "Bậc 3");
        ServiceRequest4 request = new ServiceRequest4("req-1", 1, new BigDecimal("350000"),
                "APPROVED", "COMPLETED", "Đã thay dầu", service, List.of(tech));
        assertEquals(1, request.getQuantity());
        assertEquals(service, request.getService());
        assertEquals(1, request.getTechnicians().size());
    }

    @Test
    void testSparePartAndSparePartStatistics() {
        SparePartCategory4 cat = new SparePartCategory4("spcat-1", "Phanh", "Hệ thống phanh");
        SparePart4 part = new SparePart4("part-1", "BRK01", "Má phanh trước", "brake.jpg",
                "Brembo", "Ý", "Tiêu chuẩn OEM", "Bộ", "Má phanh gốm",
                new BigDecimal("750000"), 20, 12, BusinessStatus.ACTIVE, cat);
        assertEquals("BRK01", part.getPartCode());
        assertEquals(cat, part.getSparePartCategory());

        SparePartStatistics4 stats = new SparePartStatistics4(120, new BigDecimal("90000000"));
        stats.setPartCode("BRK01");
        assertTrue(stats instanceof SparePart4);
        assertEquals(120, stats.getTotalPartsSold());
        assertEquals(new BigDecimal("90000000"), stats.getTotalSparePartRevenue());

        SparePartRequest4 partReq = new SparePartRequest4("pr-1", 2, new BigDecimal("750000"), part);
        assertEquals(2, partReq.getActualUsedQuantity());
        assertEquals(part, partReq.getSparePart());
    }

    @Test
    void testSupplierAndGoodsReceipt() {
        Supplier4 supplier = new Supplier4("sup-1", "Công ty TNHH Phụ tùng Bosch", "0101234567",
                "Hà Nội", "0243123456", "contact@bosch.vn", "Nguyễn Đại Diện", "ACTIVE");
        assertEquals("0101234567", supplier.getTaxCode());

        SupplierStatistics4 supStats = new SupplierStatistics4(15, new BigDecimal("250000000"));
        supStats.setSupplierName("Công ty TNHH Phụ tùng Bosch");
        assertTrue(supStats instanceof Supplier4);
        assertEquals(15, supStats.getTotalReceipts());
        assertEquals(new BigDecimal("250000000"), supStats.getTotalPurchaseAmount());

        WarehouseStaff4 whStaff = new WarehouseStaff4("Kho Tổng");
        whStaff.setFullName("Thủ Kho");

        SparePart4 part = new SparePart4();
        part.setId("part-1");
        GoodsReceiptDetail4 detail = new GoodsReceiptDetail4("grd-1", 10, new BigDecimal("500000"),
                new BigDecimal("5000000"), part);
        assertEquals(10, detail.getReceivedQuantity());
        assertEquals(part, detail.getSparePart());

        GoodsReceipt4 receipt = new GoodsReceipt4("gr-1", "NK2026-001", LocalDateTime.now(), "HD001",
                ReceiptStatus.CONFIRMED, new BigDecimal("5000000"), "Nhập đủ",
                List.of(detail), supplier, whStaff);
        assertEquals("NK2026-001", receipt.getReceiptCode());
        assertEquals(ReceiptStatus.CONFIRMED, receipt.getReceiptStatus());
        assertEquals(supplier, receipt.getSupplier());
        assertEquals(whStaff, receipt.getWarehouseStaff());
        assertEquals(1, receipt.getGoodsReceiptDetail().size());
    }

    @Test
    void testInvoice() {
        ServiceReception4 reception = new ServiceReception4();
        reception.setId("rec-1");
        SalesStaff4 staff = new SalesStaff4("user-sales", "NVBH01", "Đỗ Bán Hàng");

        Invoice4 invoice = new Invoice4("inv-1", "HD-2026-001", LocalDateTime.now(),
                new BigDecimal("350000"), new BigDecimal("750000"), BigDecimal.ZERO,
                new BigDecimal("1100000"), "CONFIRMED", "PAID", "CASH",
                LocalDateTime.now(), reception, staff);

        assertEquals("HD-2026-001", invoice.getInvoiceNumber());
        assertEquals("PAID", invoice.getPaymentStatus());
        assertEquals(reception, invoice.getServiceReception());
        assertEquals(staff, invoice.getSalesStaff());
    }
}

