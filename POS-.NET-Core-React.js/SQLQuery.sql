--- Create and Use Database

CREATE DATABASE POSSystem

USE POSSystem

DROP DATABASE POSSystem


--- Create Tables

CREATE TABLE Users
(
    UserID INTEGER IDENTITY PRIMARY KEY,
    Name VARCHAR(225),
    NIC VARCHAR(225) UNIQUE,
    Address VARCHAR(255),
    UserName VARCHAR(255) UNIQUE,
    Password TEXT,
    Type VARCHAR(255) CHECK (Type = 'Admin' OR Type = 'Cashier'),
    Status BIT
)

CREATE TABLE Item
(
    ItemID INTEGER IDENTITY PRIMARY KEY,
    ItemName VARCHAR(255),
    Unit VARCHAR(255)
)

CREATE TABLE Stock
(
    StockID INTEGER IDENTITY PRIMARY KEY,
    ItemID INTEGER,
    Qty DECIMAL(8,2),
    Price DECIMAL(8,2),
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID)
)

CREATE TABLE Supplier
(
    SupplierID INTEGER IDENTITY PRIMARY KEY,
    SupplierName VARCHAR(255) UNIQUE,
    Address VARCHAR(255),
    ContactNumber VARCHAR(255)
)

CREATE TABLE GRN
(
    GRNID INTEGER IDENTITY PRIMARY KEY,
    GRNNo INTEGER,
    GRNDate DATETIME,
    InvoiceNo VARCHAR(255),
    InvoiceDate DATETIME,
    SupplierID INTEGER,
    ItemID INTEGER,
    StockID INTEGER,
    GRNQty INTEGER,
    PayType VARCHAR(255),
    BulckPrice DECIMAL(8,2),
    ActualBulkPrice DECIMAL(8,2),
    GRNRecorderID INTEGER,
    DueDate DATETIME NULL,
    Remarks TEXT NULL,
    FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY(StockID) REFERENCES Stock(StockID)
)

CREATE TABLE GRNCart
(
    GRNID INTEGER IDENTITY PRIMARY KEY,
    InvoiceNo VARCHAR(255),
    InvoiceDate DATETIME,
    SupplierID INTEGER,
    ItemID INTEGER,
    StockID INTEGER,
    GRNQty INTEGER,
    PayType VARCHAR(255),
    BulckPrice DECIMAL(8,2),
    ActualBulkPrice DECIMAL(8,2),
    GRNRecorderID INTEGER,
    DueDate DATETIME NULL,
    Remarks TEXT NULL,
    FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY(StockID) REFERENCES Stock(StockID)
)

CREATE TABLE Cart
(
    CartID INTEGER IDENTITY PRIMARY KEY,
    ItemID INTEGER,
    StockID INTEGER,
    CartQty DECIMAL(8,2),
    Price DECIMAL(8,2),
    SellerID INTEGER,
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY(StockID) REFERENCES Stock(StockID)
)

CREATE TABLE Sale
(
    SaleID INTEGER IDENTITY PRIMARY KEY,
    ItemID INTEGER,
    StockID INTEGER,
    SoldQty DECIMAL(8,2),
    SoldPrice DECIMAL(8,2),
    SellerID INTEGER,
    Timescape DATETIME,
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY(StockID) REFERENCES Stock(StockID)
)

CREATE TABLE ReturnItem
(
    ReturnID INTEGER IDENTITY PRIMARY KEY,
    ItemID INTEGER,
    StockID INTEGER,
    Qty DECIMAL(8,2),
    Price DECIMAL(8,2),
    SellerID INTEGER,
    FOREIGN KEY(ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY(StockID) REFERENCES Stock(StockID)
)

--- Drop Table

--DROP TABLE Users
--DROP TABLE Item
--DROP TABLE Stock
--DROP TABLE Supplier
--DROP TABLE GRN
--DROP TABLE GRNCart
--DROP TABLE Cart
--DROP TABLE Sale
--DROP TABLE ReturnItem


--- Update Tables

ALTER TABLE Users ADD CONSTRAINTS UQ_NIC UNIQUE(NIC);

ALTER TABLE Users ALTER COLUMN Password TEXT;

ALTER TABLE Item DROP COLUMN Address;

DELETE FROM Supplier WHERE SupplierID = 4;

ALTER TABLE Supplier ADD CONSTRAINT UniqueSuppName UNIQUE (SupplierName);

UPDATE GRN SET GRNNo = 2 WHERE GRNID = 4


--- Selection
SELECT * FROM Users;
SELECT * FROM Item;
SELECT * FROM Stock;
SELECT * FROM Supplier;
SELECT * FROM GRN;
SELECT * FROM GRNCart;
SELECT * FROM Cart;
SELECT * FROM Sale;
SELECT * FROM ReturnItem;

--- Stored Procidures
---- User SPs
CREATE PROCEDURE sp_GetAllUsers
AS
BEGIN
    SELECT UserID, Name, NIC, Address, UserName, Type, Status
    FROM Users
END;

EXEC sp_GetAllUsers;

CREATE PROCEDURE sp_GetByOne(
    @UserID As INTEGER)
AS
BEGIN
    SELECT UserID, Name, NIC, Address, Type
    FROM Users
    WHERE UserID = @UserID
END;

EXEC sp_GetByOne @UserID = 1;

CREATE PROCEDURE sp_CreateUser(
    @Name AS VARCHAR(255),
    @NIC AS VARCHAR(255),
    @Address AS VARCHAR(255),
    @UserName AS VARCHAR(255),
    @Password AS TEXT,
    @Type AS VARCHAR(255))
AS
BEGIN
    INSERT INTO Users
        (Name, NIC, Address, UserName, Password, Type, Status)
    VALUES(@Name, @NIC, @Address, @UserName, @Password, @Type, 'True')
END;

EXEC sp_CreateUser @Name = 'Tharindu', @NIC = '982603056V', @Address = 'Ambalantota', @UserName = 'TharinduD', @Password = '123', @Type = 'Admin';

CREATE PROCEDURE sp_EditUser(
    @UserID As INTEGER,
    @Name AS VARCHAR(255),
    @NIC AS VARCHAR(255),
    @Address AS VARCHAR(255),
    @Type AS VARCHAR(255))
AS
BEGIN
    UPDATE Users
    SET Name = @Name, NIC = @NIC, Address = @Address, Type = @Type
    WHERE UserID = @UserID
END;

EXEC sp_EditUser @UserID = 1, @Name = 'Tharindu Theekshana', @NIC = '982603056V', @Address = 'Ambalantota', @Type = 'Admin';


CREATE PROCEDURE sp_ActiveDeactiveUser(
    @UserID AS INTEGER)
AS
BEGIN
    DECLARE @AvailableStatus BIT;
    SET @AvailableStatus = (SELECT Status FROM Users WHERE UserID = @UserID);

    IF @AvailableStatus != 'True'
    BEGIN
        UPDATE Users SET Status = 'True' WHERE UserID = @UserID
    END
    ELSE
    BEGIN
        UPDATE Users SET Status = 'False' WHERE UserID = @UserID
    END
END;

EXEC sp_ActiveDeactiveUser @UserID = 1;

CREATE PROCEDURE sp_CheckPassword(
    @UserName AS VARCHAR(255),
    @Password AS VARCHAR(255))
AS
BEGIN
    SELECT * FROM Users WHERE UserName LIKE @UserName AND Password LIKE @Password
END;

EXEC sp_CheckPassword @UserName = 'TharinduD', @Password = '125';

CREATE PROCEDURE sp_ChangePassword(
    @UserID AS INTEGER,
    @Password AS VARCHAR(255))
AS
BEGIN
    UPDATE Users SET Password = @Password WHERE UserID = @UserID
END;

EXEC sp_ChangePassword @UserID = 1, @Password = '125';

CREATE PROCEDURE sp_Login(
    @UserName AS VARCHAR(255),
    @Password AS VARCHAR(255))
AS
BEGIN
    SELECT UserID, UserName, Type
    FROM Users
    WHERE UserName LIKE @UserName AND Password LIKE @Password
END;

EXEC sp_Login @UserName = 'TharinduD', @Password = '125';

CREATE PROCEDURE sp_ResetPassword(
    @UserID AS INTEGER,
    @Password AS VARCHAR(255))
AS
BEGIN
    UPDATE Users SET Password = @Password WHERE UserID = @UserID
END;

EXEC sp_ResetPassword @UserID = 1, @Password = '125';

CREATE PROCEDURE sp_GetSearchUsers(
    @Search AS VARCHAR(255))
AS
BEGIN
    SELECT UserID, Name, NIC, Address, UserName, Type, Status
    FROM Users
    WHERE Name LIKE @Search OR NIC LIKE @Search OR Address LIKE @Search OR Type LIKE @Search
END;

EXEC sp_GetSearchUsers @Search = '%Ma%';

---- Items SPs

CREATE PROCEDURE sp_GetAllItems
AS
BEGIN
    SELECT ItemID, ItemName, Unit
    FROM Item
END;

EXEC sp_GetAllItems;

CREATE PROCEDURE sp_GetAllItemsASC
AS
BEGIN
    SELECT ItemID, ItemName, Unit
    FROM Item
    ORDER BY ItemName ASC
END;

EXEC sp_GetAllItemsASC;

CREATE PROCEDURE sp_GetItemOnce(
    @ItemID AS INTEGER
)
AS
BEGIN
    SELECT ItemID, ItemName, Unit
    FROM Item
    WHERE ItemID = @ItemID
END;

EXEC sp_GetItemOnce @ItemID = 1;

CREATE PROCEDURE sp_GetSearchItems(
    @Search AS VARCHAR(255))
AS
BEGIN
    SELECT ItemID, ItemName, Unit
    FROM Item
    WHERE ItemName LIKE @Search
END;

EXEC sp_GetSearchItems @Search = '%Ro%';

CREATE PROCEDURE sp_CreateItem(
    @ItemName AS VARCHAR(255),
    @Unit AS VARCHAR(255)
)
AS
BEGIN
    INSERT INTO Item(ItemName, Unit)
    VALUES(@ItemName, @Unit)
END;

EXEC sp_CreateItem @ItemName = 'Rocell Water Closet - URBAN D', @Unit = "NOS";

CREATE PROCEDURE sp_UpdateItems(
    @ItemID AS INTEGER,
    @ItemName AS VARCHAR(255),
    @Unit AS VARCHAR(255))
AS
BEGIN
    UPDATE Item SET ItemName = @ItemName, Unit = @Unit  WHERE ItemID = @ItemID
END;

EXEC sp_UpdateItems @ItemID = 1, @ItemName = 'Rocell Water Closet - Urban D', @Unit = 'NOS';

---- Stocks SPs

CREATE PROCEDURE sp_GetAllStocks
AS
BEGIN
    SELECT s.StockID, s.ItemID, i.ItemName, i.Unit, s.Qty, s.Price
    FROM Stock s, Item i
    WHERE s.ItemID = i.ItemID
END;

EXEC sp_GetAllStocks;

CREATE PROCEDURE sp_GetAllStocksASC(
    @ItemID AS INTEGER
)
AS
BEGIN
    SELECT StockID, ItemID,  Qty, Price
    FROM Stock
    WHERE ItemID =  @ItemID
    ORDER BY Price ASC
END;

EXEC sp_GetAllStocksASC @ItemID = 1;

CREATE PROCEDURE sp_GetStockOnce(
    @StockID AS INTEGER
)
AS
BEGIN
    SELECT s.StockID, s.ItemID, i.ItemName, i.Unit, s.Qty, s.Price
    FROM Stock s, Item i
    WHERE s.ItemID = i.ItemID AND s.StockID = @StockID
END;

EXEC sp_GetStockOnce @StockID = 1;

CREATE PROCEDURE sp_GetSearchStocks(
    @Search AS VARCHAR(255))
AS
BEGIN
    SELECT s.StockID, s.ItemID, i.ItemName, i.Unit, s.Qty, s.Price
    FROM Stock s, Item i
    WHERE i.ItemID = s.ItemID AND (i.ItemName LIKE @Search OR i.Unit LIKE @Search OR s.Qty LIKE @Search OR s.Price LIKE @Search)
END;

EXEC sp_GetSearchStocks @Search = '%Ro%';

CREATE PROCEDURE sp_CreateStock(
    @ItemID AS VARCHAR(255),
    @Qty AS DECIMAL(8,2),
    @Price AS DECIMAL(8,2)
)
AS
BEGIN
    INSERT INTO Stock(ItemID, Qty, Price)
    VALUES(@ItemID, @Qty, @Price)
END;

EXEC sp_CreateStock @ItemID = 1, @Qty = 1, @Price = 54000.00;

CREATE PROCEDURE sp_UpdateStocks(
    @StockID AS INTEGER,
    @ItemID AS VARCHAR(255),
    @Qty AS DECIMAL(8,2),
    @Price AS DECIMAL(8,2))
AS
BEGIN
    UPDATE Stock 
    SET ItemID = @ItemID, Qty = @Qty, Price = @Price
    WHERE StockID = @StockID
END;

EXEC sp_UpdateStocks @StockID = 1, @ItemID = 1, @Qty = 2, @Price = 54000.00;

---- Supplier SPs

CREATE PROCEDURE sp_GetAllSuppliers
AS
BEGIN
    SELECT SupplierID, SupplierName, Address, ContactNumber
    FROM Supplier
END;

EXEC sp_GetAllSuppliers;

CREATE PROCEDURE sp_GetAllSuppliersASC
AS
BEGIN
    SELECT SupplierID, SupplierName, Address, ContactNumber
    FROM Supplier
    ORDER BY SupplierName ASC
END;

EXEC sp_GetAllSuppliersASC;

CREATE PROCEDURE sp_GetSupplierOnce(
    @SupplierID AS INTEGER)
AS
BEGIN
    SELECT SupplierID, SupplierName, Address, ContactNumber
    FROM Supplier
    WHERE SupplierID = @SupplierID
END;

EXEC sp_GetSupplierOnce @SupplierID = 1;

CREATE PROCEDURE sp_GetSearchSuppliers(
    @Search AS VARCHAR(255))
AS
BEGIN
    SELECT SupplierID, SupplierName, Address, ContactNumber
    FROM Supplier
    WHERE SupplierName LIKE @Search OR Address LIKE @Search OR ContactNumber LIKE @Search
END;

EXEC sp_GetSearchSuppliers @Search = '%Ro%';

CREATE PROCEDURE sp_CreateSupplier(
    @SupplierName AS VARCHAR(255),
    @Address AS VARCHAR(255),
    @ContactNumber AS VARCHAR(255))
AS
BEGIN
    INSERT INTO Supplier(SupplierName, Address, ContactNumber)
    VALUES(@SupplierName, @Address, @ContactNumber)
END;

EXEC sp_CreateSupplier @SupplierName = "Rocell Company (PVT) LTD.", @Address = "No. 20, RA De Mel Mawatha, Colombo 03.", @ContactNumber = "+94766223344";

CREATE PROCEDURE sp_UpdateSupplier(
    @SupplierID AS INTEGER,
    @SupplierName AS VARCHAR(255),
    @Address AS VARCHAR(255),
    @ContactNumber AS VARCHAR(255))
AS
BEGIN
    UPDATE Supplier 
    SET SupplierName = @SupplierName, Address = @Address, ContactNumber = @ContactNumber
    WHERE SupplierID = @SupplierID
END;

EXEC sp_UpdateSupplier @SupplierID = 1, @SupplierName = "Rocell Company (PVT) LTD.", @Address = "No. 20, RA De Mel Mawatha, Colombo 03.", @ContactNumber = "0766223344";

---- GRN SPs

CREATE PROCEDURE sp_GetAllGRNs
AS
BEGIN
    SELECT g.GRNNo, g.GRNDate, g.InvoiceNo, s.SupplierName, COUNT(g.StockID) AS 'ItemCount', SUM(g.BulckPrice) AS 'BillPrice'
    FROM GRN g, Supplier s
    WHERE g.SupplierID = s.SupplierID
    GROUP BY g.GRNNo, g.GRNDate, g.InvoiceNo, s.SupplierName
    ORDER BY g.GRNDate
END;

EXEC sp_GetAllGRNs;

CREATE PROCEDURE sp_GetGRNOnce(
    @GRNNo AS INTEGER)
AS
BEGIN
    SELECT g.GRNID, g.GRNNo, g.GRNDate, g.InvoiceNo, g.InvoiceDate, g.SupplierID, sp.SupplierName, sp.Address, 
    sp.ContactNumber, g.ItemID, i.ItemName, g.StockID, s.Price, i.Unit, g.GRNQty, g.PayType , g.BulckPrice, g.ActualBulkPrice,
    u.UserName, g.DueDate, g.Remarks
    FROM GRN g, Supplier sp, Item i, Stock s, Users u
    WHERE g.SupplierID = sp.SupplierID AND g.ItemID = i.ItemID AND g.StockID = s.StockID AND g.GRNRecorderID = u.UserID AND GRNNo = @GRNNo
END;

EXEC sp_GetGRNOnce @GRNNo = 1;

CREATE PROCEDURE sp_GetOneByIDGRNs(
    @GRNID AS INTEGER
)
AS
BEGIN
    SELECT GRNID, ItemID, StockID, GRNQty, BulckPrice, Remarks
    FROM GRN
    WHERE GRNID = @GRNID
END;

EXEC sp_GetOneByIDGRNs @GRNID = 2;

CREATE PROCEDURE sp_GetGRNOnce(
    @GRNNo AS INTEGER)
AS
BEGIN
    SELECT g.GRNID, g.GRNNo, g.GRNDate, g.InvoiceNo, g.InvoiceDate, g.SupplierID, sp.SupplierName, sp.Address, 
    sp.ContactNumber, g.ItemID, i.ItemName, g.StockID, s.Price, i.Unit, g.GRNQty, g.PayType , g.BulckPrice, g.ActualBulkPrice,
    u.UserName, g.DueDate, g.Remarks
    FROM GRN g, Supplier sp, Item i, Stock s, Users u
    WHERE g.SupplierID = sp.SupplierID AND g.ItemID = i.ItemID AND g.StockID = s.StockID AND g.GRNRecorderID = u.UserID AND GRNNo = @GRNNo
END;

EXEC sp_GetGRNOnce @GRNNo = 1;

CREATE PROCEDURE sp_GetSearchGRNs(
    @Search AS VARCHAR(255))
AS
BEGIN
    SELECT g.GRNNo, g.GRNDate, g.InvoiceNo, s.SupplierName, COUNT(g.StockID) AS 'ItemCount', SUM(g.BulckPrice) AS 'BillPrice'
    FROM GRN g, Supplier s
    WHERE g.SupplierID = s.SupplierID AND (g.GRNNo LIKE @Search OR g.GRNDate LIKE @Search OR g.InvoiceNo LIKE @Search OR s.SupplierName LIKE @Search)
    GROUP BY g.GRNNo, g.GRNDate, g.InvoiceNo, s.SupplierName
    ORDER BY g.GRNDate
END;

EXEC sp_GetSearchGRNs @Search = '%Ro%';

CREATE PROCEDURE sp_CreateGRN(
    @GRNNo AS VARCHAR(255),
    @GRNDate AS DATETIME,
    @InvoiceNo AS VARCHAR(255),
    @InvoiceDate AS DATETIME,
    @SupplierID AS INTEGER,
    @ItemID AS INTEGER,
    @StockID AS INTEGER,
    @GRNQty AS INTEGER,
    @PayType AS VARCHAR(255),
    @BulckPrice AS DECIMAL(8,2),
    @ActualBulkPrice AS DECIMAL(8,2),
    @GRNRecorderID AS INTEGER,
    @DueDate AS DATETIME,
    @Remarks AS TEXT
    )
AS
BEGIN
    INSERT INTO GRN(GRNNo, GRNDate, InvoiceNo, InvoiceDate, SupplierID, ItemID, StockID, GRNQty, PayType, BulckPrice, ActualBulkPrice, GRNRecorderID, DueDate, Remarks)
    VALUES(@GRNNo, @GRNDate, @InvoiceNo, @InvoiceDate, @SupplierID, @ItemID, @StockID, @GRNQty, @PayType, @BulckPrice, @ActualBulkPrice, @GRNRecorderID, @DueDate, @Remarks)

    DECLARE @AvailableStock DECIMAL(8,2);
    DECLARE @TotalStock DECIMAL(8,2);
    SET @AvailableStock = (SELECT Qty FROM Stock WHERE StockID = @StockID);
    SET @TotalStock = @AvailableStock + @GRNQty

    UPDATE Stock SET Qty = @TotalStock WHERE StockID = @StockID
END;

EXEC sp_CreateGRN @GRNNo = 1, @GRNDate = '2002-07-08', @InvoiceNo = 'CSV0025', @InvoiceDate = '2002-07-07', @SupplierID = 1, @ItemID = 1, @StockID = 1, @GRNQty = 4, 
@PayType = "Cash", @BulckPrice = 108000.00, @ActualBulkPrice = 108000.00, @GRNRecorderID = 1, @DueDate = '', @Remarks= '';

CREATE PROCEDURE sp_CreateMaxGRN
AS
BEGIN
    SELECT MAX(GRNNo) AS 'MaxGRN' FROM GRN;
END;

EXEC sp_CreateMaxGRN;

CREATE PROCEDURE sp_UpdateGRN(
    @GRNID AS INTEGER,
    @ItemID AS INTEGER,
    @StockID AS INTEGER,
    @GRNQty AS INTEGER,
    @BulckPrice AS DECIMAL(8,2),
    @Remarks AS TEXT
    )
AS
BEGIN
    DECLARE @GRNAvailableQty DECIMAL(8,2);
    DECLARE @AvStock DECIMAL(8,2);
    DECLARE @Total DECIMAL(8,2);
    SET @GRNAvailableQty = (SELECT GRNQty FROM GRN WHERE GRNID = @GRNID);
    SET @AvStock = (SELECT Qty FROM Stock WHERE StockID = @StockID);

    UPDATE GRN 
    SET ItemID = @ItemID, StockID = @StockID, GRNQty = @GRNQty, BulckPrice = @BulckPrice, Remarks = @Remarks
    WHERE GRNID = @GRNID

    IF @GRNAvailableQty < @GRNQty
    BEGIN
        SET @Total = @AvStock + (@GRNQty - @GRNAvailableQty)
        UPDATE Stock SET Qty = @Total WHERE StockID = @StockID
    END
    ELSE
    BEGIN
        SET @Total = @AvStock - (@GRNAvailableQty - @GRNQty)
        UPDATE Stock SET Qty = @Total WHERE StockID = @StockID
    END
END;

EXEC sp_UpdateGRN @GRNID = 1, @ItemID = 1, @StockID = 1, @GRNQty = 5, @BulckPrice = 108000.00, @Remarks= 'Yes';


---GRN Cart SPs

CREATE PROCEDURE sp_GetGRNCart(
    @GRNRecorderID AS INTEGER
    )
AS
BEGIN
    SELECT g.GRNID, g.InvoiceNo, g.InvoiceDate, g.SupplierID, sp.SupplierName, sp.Address, 
    sp.ContactNumber, g.ItemID, i.ItemName, g.StockID, s.Price, i.Unit, g.GRNQty, g.PayType , g.BulckPrice, g.ActualBulkPrice,
    u.UserName, g.DueDate, g.Remarks
    FROM GRNCart g, Supplier sp, Item i, Stock s, Users u
    WHERE g.SupplierID = sp.SupplierID AND g.ItemID = i.ItemID AND g.StockID = s.StockID AND g.GRNRecorderID = u.UserID AND GRNRecorderID = @GRNRecorderID
END;

EXEC sp_GetGRNCart @GRNRecorderID = 1;

CREATE PROCEDURE sp_GetGRNCartOnce(
    @GRNID AS INTEGER
    )
AS
BEGIN
    SELECT *
    FROM GRNCart
    WHERE GRNID = @GRNID
END;

EXEC sp_GetGRNCartOnce @GRNID = 1;

CREATE PROCEDURE sp_CreateGRNCart(
    @InvoiceNo AS VARCHAR(255),
    @InvoiceDate AS DATETIME,
    @SupplierID AS INTEGER,
    @ItemID AS INTEGER,
    @StockID AS INTEGER,
    @GRNQty AS INTEGER,
    @PayType AS VARCHAR(255),
    @BulckPrice AS DECIMAL(8,2),
    @ActualBulkPrice AS DECIMAL(8,2),
    @GRNRecorderID AS INTEGER,
    @DueDate AS DATETIME,
    @Remarks AS TEXT
    )
AS
BEGIN
    INSERT INTO GRNCart(InvoiceNo, InvoiceDate, SupplierID, ItemID, StockID, GRNQty, PayType, BulckPrice, ActualBulkPrice, GRNRecorderID, DueDate, Remarks)
    VALUES(@InvoiceNo, @InvoiceDate, @SupplierID, @ItemID, @StockID, @GRNQty, @PayType, @BulckPrice, @ActualBulkPrice, @GRNRecorderID, @DueDate, @Remarks)
END;

EXEC sp_CreateGRNCart @InvoiceNo = 'CSV0026', @InvoiceDate = '2002-07-07', @SupplierID = 1, @ItemID = 1, @StockID = 2, @GRNQty = 4, 
@PayType = "Cash", @BulckPrice = 20000.00, @ActualBulkPrice = 20000.00, @GRNRecorderID = 1, @DueDate = '', @Remarks= '';

CREATE PROCEDURE sp_UpdateGRNCart(
    @GRNID AS INTEGER,
    @InvoiceNo AS VARCHAR(255),
    @InvoiceDate AS DATETIME,
    @SupplierID AS INTEGER,
    @ItemID AS INTEGER,
    @StockID AS INTEGER,
    @GRNQty AS INTEGER,
    @PayType AS VARCHAR(255),
    @BulckPrice AS DECIMAL(8,2),
    @ActualBulkPrice AS DECIMAL(8,2),
    @GRNRecorderID AS INTEGER,
    @DueDate AS DATETIME,
    @Remarks AS TEXT
    )
AS
BEGIN
    UPDATE GRNCart
    SET InvoiceNo = @InvoiceNo, InvoiceDate = @InvoiceDate, SupplierID = @SupplierID, ItemID = @ItemID, StockID = @StockID, GRNQty = @GRNQty, PayType = @PayType, 
    BulckPrice = @BulckPrice, ActualBulkPrice = @ActualBulkPrice, GRNRecorderID = @GRNRecorderID, DueDate = @DueDate, Remarks = @Remarks
    WHERE GRNID = @GRNID
END;

EXEC sp_UpdateGRNCart @GRNID = 1, @InvoiceNo = 'CSV0026', @InvoiceDate = '2022-07-07', @SupplierID = 1, @ItemID = 1, @StockID = 2, @GRNQty = 5, 
@PayType = "Cash", @BulckPrice = 20000.00, @ActualBulkPrice = 20000.00, @GRNRecorderID = 1, @DueDate = '', @Remarks= '';

CREATE PROCEDURE sp_DropGRNCart(
    @GRNID AS INTEGER
)
AS
BEGIN
    DELETE FROM GRNCart WHERE GRNID = @GRNID
END;

EXEC sp_DropGRNCart @GRNID = 1;




