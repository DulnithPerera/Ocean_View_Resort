IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'OceanView_DB')
BEGIN
    CREATE DATABASE OceanView_DB;
END
GO

USE OceanView_DB;
GO

IF OBJECT_ID('ReservationFoods', 'U') IS NOT NULL DROP TABLE ReservationFoods;
IF OBJECT_ID('Bills', 'U') IS NOT NULL DROP TABLE Bills;
IF OBJECT_ID('Reservations', 'U') IS NOT NULL DROP TABLE Reservations;
IF OBJECT_ID('Foods', 'U') IS NOT NULL DROP TABLE Foods;
IF OBJECT_ID('Rooms', 'U') IS NOT NULL DROP TABLE Rooms;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(256) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'staff' CHECK (role IN ('admin', 'staff')),
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(30) NOT NULL CHECK (room_type IN ('Standard', 'Deluxe', 'Suite', 'Ocean View Suite', 'Presidential Suite')),
    rate_per_night DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Maintenance', 'Reserved')),
    floor INT NOT NULL,
    description VARCHAR(500),
    max_guests INT NOT NULL DEFAULT 2,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Reservations (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_number VARCHAR(20) NOT NULL UNIQUE,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(300) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INT NOT NULL DEFAULT 1,
    status VARCHAR(20) NOT NULL DEFAULT 'Confirmed' CHECK (status IN ('Confirmed', 'Checked-In', 'Checked-Out', 'Cancelled')),
    special_requests VARCHAR(500),
    created_by INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reservation_Room FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    CONSTRAINT FK_Reservation_User FOREIGN KEY (created_by) REFERENCES Users(user_id),
    CONSTRAINT CHK_Dates CHECK (check_out_date > check_in_date)
);
GO

CREATE TABLE Foods (
    food_id INT IDENTITY(1,1) PRIMARY KEY,
    food_name VARCHAR(100) NOT NULL,
    food_type VARCHAR(20) NOT NULL CHECK (food_type IN ('Breakfast', 'Lunch', 'Dinner')),
    price DECIMAL(10,2) NOT NULL,
    description VARCHAR(300),
    is_available BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE ReservationFoods (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    order_date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ResFoods_Reservation FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    CONSTRAINT FK_ResFoods_Food FOREIGN KEY (food_id) REFERENCES Foods(food_id)
);
GO

CREATE TABLE Bills (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT NOT NULL,
    room_charges DECIMAL(10,2) NOT NULL DEFAULT 0,
    food_charges DECIMAL(10,2) NOT NULL DEFAULT 0,
    service_charge DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    billing_type VARCHAR(20) NOT NULL DEFAULT 'Standard',
    generated_by INT,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Bill_Reservation FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    CONSTRAINT FK_Bill_User FOREIGN KEY (generated_by) REFERENCES Users(user_id)
);
GO

CREATE INDEX IX_Reservations_Status ON Reservations(status);
CREATE INDEX IX_Reservations_Dates ON Reservations(check_in_date, check_out_date);
CREATE INDEX IX_Reservations_Room ON Reservations(room_id);
CREATE INDEX IX_Rooms_Status ON Rooms(status);
CREATE INDEX IX_Foods_Type ON Foods(food_type);
CREATE INDEX IX_Bills_Reservation ON Bills(reservation_id);
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateNights(
    @check_in DATE,
    @check_out DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @check_in, @check_out);
END
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateRoomCharges(
    @reservation_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @charges DECIMAL(10,2);
    SELECT @charges = r.rate_per_night * DATEDIFF(DAY, res.check_in_date, res.check_out_date)
    FROM Reservations res
    INNER JOIN Rooms r ON res.room_id = r.room_id
    WHERE res.reservation_id = @reservation_id;
    RETURN ISNULL(@charges, 0);
END
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateFoodCharges(
    @reservation_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @charges DECIMAL(10,2);
    SELECT @charges = SUM(total_price)
    FROM ReservationFoods
    WHERE reservation_id = @reservation_id;
    RETURN ISNULL(@charges, 0);
END
GO

CREATE OR ALTER FUNCTION dbo.fn_GetOccupancyRate(
    @target_date DATE
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_rooms INT;
    DECLARE @occupied_rooms INT;
    SELECT @total_rooms = COUNT(*) FROM Rooms WHERE status != 'Maintenance';
    SELECT @occupied_rooms = COUNT(DISTINCT room_id)
    FROM Reservations
    WHERE @target_date >= check_in_date AND @target_date < check_out_date
      AND status IN ('Confirmed', 'Checked-In');
    IF @total_rooms = 0 RETURN 0;
    RETURN CAST((@occupied_rooms * 100.0 / @total_rooms) AS DECIMAL(5,2));
END
GO

CREATE OR ALTER FUNCTION dbo.fn_GenerateReservationNumber()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @num VARCHAR(20);
    DECLARE @count INT;
    SELECT @count = COUNT(*) + 1 FROM Reservations;
    SET @num = 'OVR-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + RIGHT('000' + CAST(@count AS VARCHAR), 4);
    RETURN @num;
END
GO

CREATE OR ALTER PROCEDURE sp_AuthenticateUser
    @username VARCHAR(50),
    @password_hash VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, username, password_hash, full_name, email, role, is_active
    FROM Users
    WHERE username = @username AND password_hash = @password_hash AND is_active = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_CreateReservation
    @reservation_number VARCHAR(20),
    @guest_name VARCHAR(100),
    @address VARCHAR(300),
    @contact_number VARCHAR(20),
    @email VARCHAR(100),
    @room_id INT,
    @check_in_date DATE,
    @check_out_date DATE,
    @num_guests INT,
    @special_requests VARCHAR(500),
    @created_by INT,
    @new_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF EXISTS (
            SELECT 1 FROM Reservations
            WHERE room_id = @room_id
              AND status IN ('Confirmed', 'Checked-In')
              AND check_in_date < @check_out_date
              AND check_out_date > @check_in_date
        )
        BEGIN
            RAISERROR('Room is not available for the selected dates.', 16, 1);
            RETURN;
        END
        INSERT INTO Reservations (reservation_number, guest_name, address, contact_number, email,
            room_id, check_in_date, check_out_date, num_guests, special_requests, created_by)
        VALUES (@reservation_number, @guest_name, @address, @contact_number, @email,
            @room_id, @check_in_date, @check_out_date, @num_guests, @special_requests, @created_by);
        SET @new_id = SCOPE_IDENTITY();
        UPDATE Rooms SET status = 'Reserved' WHERE room_id = @room_id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE sp_CalculateBill
    @reservation_id INT,
    @billing_type VARCHAR(20),
    @generated_by INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @room_charges DECIMAL(10,2) = dbo.fn_CalculateRoomCharges(@reservation_id);
    DECLARE @food_charges DECIMAL(10,2) = dbo.fn_CalculateFoodCharges(@reservation_id);
    DECLARE @subtotal DECIMAL(10,2) = @room_charges + @food_charges;
    DECLARE @service_charge DECIMAL(10,2) = 0;
    DECLARE @discount DECIMAL(10,2) = 0;
    DECLARE @tax DECIMAL(10,2);
    DECLARE @total DECIMAL(10,2);
    IF @billing_type = 'Premium'
    BEGIN
        SET @service_charge = @subtotal * 0.05;
        SET @tax = (@subtotal + @service_charge) * 0.10;
        SET @total = @subtotal + @service_charge + @tax;
    END
    ELSE IF @billing_type = 'Discount'
    BEGIN
        SET @discount = @subtotal * 0.10;
        SET @tax = (@subtotal - @discount) * 0.10;
        SET @total = @subtotal - @discount + @tax;
    END
    ELSE
    BEGIN
        SET @tax = @subtotal * 0.10;
        SET @total = @subtotal + @tax;
    END
    DELETE FROM Bills WHERE reservation_id = @reservation_id;
    INSERT INTO Bills (reservation_id, room_charges, food_charges, service_charge, tax, discount, total_amount, billing_type, generated_by)
    VALUES (@reservation_id, @room_charges, @food_charges, @service_charge, @tax, @discount, @total, @billing_type, @generated_by);
    SELECT * FROM Bills WHERE reservation_id = @reservation_id;
END
GO

CREATE OR ALTER PROCEDURE sp_GetRevenueReport
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        COUNT(DISTINCT b.reservation_id) AS total_bills,
        ISNULL(SUM(b.room_charges), 0) AS total_room_revenue,
        ISNULL(SUM(b.food_charges), 0) AS total_food_revenue,
        ISNULL(SUM(b.service_charge), 0) AS total_service_charges,
        ISNULL(SUM(b.tax), 0) AS total_tax,
        ISNULL(SUM(b.discount), 0) AS total_discounts,
        ISNULL(SUM(b.total_amount), 0) AS total_revenue
    FROM Bills b
    INNER JOIN Reservations r ON b.reservation_id = r.reservation_id
    WHERE r.check_in_date >= @start_date AND r.check_in_date <= @end_date;
    SELECT
        CAST(r.check_in_date AS DATE) AS report_date,
        COUNT(*) AS reservations,
        SUM(b.total_amount) AS daily_revenue
    FROM Bills b
    INNER JOIN Reservations r ON b.reservation_id = r.reservation_id
    WHERE r.check_in_date >= @start_date AND r.check_in_date <= @end_date
    GROUP BY CAST(r.check_in_date AS DATE)
    ORDER BY report_date;
END
GO

CREATE OR ALTER PROCEDURE sp_GetOccupancyReport
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        r.room_type,
        COUNT(*) AS total_rooms,
        SUM(CASE WHEN r.status IN ('Occupied', 'Reserved') THEN 1 ELSE 0 END) AS occupied_rooms,
        CAST(SUM(CASE WHEN r.status IN ('Occupied', 'Reserved') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS occupancy_rate
    FROM Rooms r
    GROUP BY r.room_type;
    SELECT
        rm.room_number, rm.room_type, rm.rate_per_night, rm.status,
        res.guest_name, res.check_in_date, res.check_out_date, res.status AS reservation_status
    FROM Rooms rm
    LEFT JOIN Reservations res ON rm.room_id = res.room_id
        AND res.status IN ('Confirmed', 'Checked-In')
        AND res.check_in_date <= @end_date AND res.check_out_date >= @start_date
    ORDER BY rm.room_number;
END
GO

CREATE OR ALTER TRIGGER trg_UpdateRoomOnCheckIn
ON Reservations
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Rooms SET status = 'Occupied'
    WHERE room_id IN (
        SELECT i.room_id FROM inserted i
        INNER JOIN deleted d ON i.reservation_id = d.reservation_id
        WHERE i.status = 'Checked-In' AND d.status != 'Checked-In'
    );
    UPDATE Rooms SET status = 'Available'
    WHERE room_id IN (
        SELECT i.room_id FROM inserted i
        INNER JOIN deleted d ON i.reservation_id = d.reservation_id
        WHERE i.status IN ('Checked-Out', 'Cancelled') AND d.status NOT IN ('Checked-Out', 'Cancelled')
    );
END
GO

INSERT INTO Users (username, password_hash, full_name, email, role) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'System Administrator', 'admin@oceanviewresort.com', 'admin');

INSERT INTO Users (username, password_hash, full_name, email, role) VALUES
('staff1', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'Jane Smith', 'jane@oceanviewresort.com', 'staff');
GO

INSERT INTO Rooms (room_number, room_type, rate_per_night, status, floor, description, max_guests) VALUES
('101', 'Standard', 150.00, 'Available', 1, 'Comfortable standard room with garden view', 2),
('102', 'Standard', 150.00, 'Available', 1, 'Comfortable standard room with garden view', 2),
('103', 'Standard', 150.00, 'Available', 1, 'Comfortable standard room with city view', 2),
('201', 'Deluxe', 250.00, 'Available', 2, 'Spacious deluxe room with balcony and partial ocean view', 3),
('202', 'Deluxe', 250.00, 'Available', 2, 'Spacious deluxe room with balcony and garden view', 3),
('203', 'Deluxe', 250.00, 'Available', 2, 'Spacious deluxe room with balcony and pool view', 3),
('301', 'Suite', 400.00, 'Available', 3, 'Luxury suite with separate living area and ocean view', 4),
('302', 'Suite', 400.00, 'Available', 3, 'Luxury suite with separate living area and panoramic view', 4),
('401', 'Ocean View Suite', 550.00, 'Available', 4, 'Premium suite with full ocean panorama and private terrace', 4),
('402', 'Ocean View Suite', 550.00, 'Available', 4, 'Premium suite with full ocean panorama and jacuzzi', 4),
('501', 'Presidential Suite', 1000.00, 'Available', 5, 'Top-floor presidential suite with 360-degree views and butler service', 6);
GO

INSERT INTO Foods (food_name, food_type, price, description) VALUES
('Continental Breakfast', 'Breakfast', 25.00, 'Fresh pastries, fruits, juice, and coffee'),
('Full English Breakfast', 'Breakfast', 35.00, 'Eggs, bacon, sausages, toast, beans, and tea/coffee'),
('Tropical Fruit Platter', 'Breakfast', 20.00, 'Seasonal tropical fruits with yogurt and honey'),
('Pancake Stack', 'Breakfast', 22.00, 'Fluffy pancakes with maple syrup and fresh berries'),
('Sri Lankan Breakfast', 'Breakfast', 28.00, 'String hoppers, dhal curry, coconut sambol, and egg'),
('Grilled Seafood Platter', 'Lunch', 55.00, 'Grilled prawns, fish, and calamari with salad'),
('Club Sandwich', 'Lunch', 30.00, 'Triple-decker sandwich with fries'),
('Caesar Salad', 'Lunch', 28.00, 'Fresh romaine, croutons, parmesan, grilled chicken'),
('Rice and Curry', 'Lunch', 35.00, 'Traditional Sri Lankan rice with assorted curries'),
('Pasta Primavera', 'Lunch', 32.00, 'Fresh pasta with seasonal vegetables in cream sauce'),
('Lobster Thermidor', 'Dinner', 85.00, 'Classic lobster dish with cream sauce and cheese'),
('Grilled Ribeye Steak', 'Dinner', 65.00, '300g prime ribeye with vegetables and mashed potato'),
('Seafood Paella', 'Dinner', 55.00, 'Spanish rice dish with mixed seafood'),
('Vegetarian Tasting Menu', 'Dinner', 45.00, 'Five-course vegetarian fine dining experience'),
('Chef''s Special Curry Feast', 'Dinner', 50.00, 'Premium Sri Lankan curry spread with 8 dishes');
GO
