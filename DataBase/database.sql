USE master;
GO

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
GO
RECONFIGURE;
GO

IF DB_ID('Trade') IS NULL
    CREATE DATABASE [Trade];
GO

USE [Trade];
GO

IF OBJECT_ID('[Role]') IS NULL
BEGIN
    CREATE TABLE [Role]
    (
        RoleID INT PRIMARY KEY IDENTITY,
        RoleName NVARCHAR(100) NOT NULL
    );
END
GO

IF OBJECT_ID('[User]') IS NULL
BEGIN
    CREATE TABLE [User]
    (
        UserID INT PRIMARY KEY IDENTITY,
        UserSurname NVARCHAR(100) NOT NULL,
        UserName NVARCHAR(100) NOT NULL,
        UserPatronymic NVARCHAR(100) NOT NULL,
        UserLogin NVARCHAR(MAX) NOT NULL,
        UserPassword NVARCHAR(MAX) NOT NULL,
        UserRole INT NOT NULL FOREIGN KEY REFERENCES [Role](RoleID)
    );
END
GO

IF OBJECT_ID('[Order]') IS NULL
BEGIN
    CREATE TABLE [Order]
    (
        OrderID INT PRIMARY KEY IDENTITY,
        OrderStatus NVARCHAR(MAX) NOT NULL,
        OrderDeliveryDate DATETIME NOT NULL,
        OrderPickupPoint NVARCHAR(MAX) NOT NULL
    );
END
GO

IF OBJECT_ID('[Product]') IS NULL
BEGIN
    CREATE TABLE [Product]
    (
        ProductArticleNumber NVARCHAR(100) PRIMARY KEY,
        ProductName NVARCHAR(MAX) NOT NULL,
        ProductDescription NVARCHAR(MAX) NOT NULL,
        ProductCategory NVARCHAR(MAX) NOT NULL,
        ProductPhoto IMAGE NOT NULL,
        ProductManufacturer NVARCHAR(MAX) NOT NULL,
        ProductCost DECIMAL(19,4) NOT NULL,
        ProductDiscountAmount TINYINT NULL,
        ProductQuantityInStock INT NOT NULL,
        ProductStatus NVARCHAR(MAX) NOT NULL
    );
END
GO

IF OBJECT_ID('[OrderProduct]') IS NULL
BEGIN
    CREATE TABLE [OrderProduct]
    (
        OrderID INT NOT NULL FOREIGN KEY REFERENCES [Order](OrderID),
        ProductArticleNumber NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES [Product](ProductArticleNumber),
        PRIMARY KEY (OrderID, ProductArticleNumber)
    );
END
GO

IF OBJECT_ID('[Pickups]') IS NULL
BEGIN
    CREATE TABLE [Pickups]
    (
        PickupID INT PRIMARY KEY IDENTITY,
        OrderID INT NOT NULL FOREIGN KEY REFERENCES [Order](OrderID),
        PickupDate DATETIME NOT NULL,
        Address NVARCHAR(255) NOT NULL
    );
END
GO

INSERT INTO [Role] (RoleName)
VALUES
('Administrator'),
('Manager'),
('Client');
GO

INSERT INTO [User] (
    UserSurname,
    UserName,
    UserPatronymic,
    UserLogin,
    UserPassword,
    UserRole
)
SELECT
    [UserSurname],
    [UserName],
    [UserPatronymic],
    [UserLogin],
    [UserPassword],
    [UserRole]
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\user_import.xlsx',
    'SELECT [UserSurname],[UserName],[UserPatronymic],[UserLogin],[UserPassword],[UserRole] FROM [Sheet1$]'
) AS t;
GO

ALTER TABLE [Product] ALTER COLUMN ProductPhoto IMAGE NULL;
GO

INSERT INTO [Product] (
    ProductArticleNumber,
    ProductName,
    ProductDescription,
    ProductCategory,
    ProductPhoto,
    ProductManufacturer,
    ProductCost,
    ProductDiscountAmount,
    ProductQuantityInStock,
    ProductStatus
)
SELECT
    [ProductArticleNumber],
    [ProductName],
    [ProductDescription],
    [ProductCategory],
    NULL, 
    [ProductManufacturer],
    [ProductCost],
    [ProductDiscountAmount],
    [ProductQuantityInStock],
    [ProductStatus]
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\products_import.xlsx',
    'SELECT [ProductArticleNumber],[ProductName],[ProductDescription],[ProductCategory],[ProductManufacturer],[ProductCost],[ProductDiscountAmount],[ProductQuantityInStock],[ProductStatus] FROM [Sheet1$]'
) AS t;
GO

INSERT INTO [Order] (
    OrderStatus,
    OrderDeliveryDate,
    OrderPickupPoint
)
SELECT
    [OrderStatus],
    [OrderDeliveryDate],
    [OrderPickupPoint]
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\order_import.xlsx',
    'SELECT [OrderStatus],[OrderDeliveryDate],[OrderPickupPoint] FROM [Sheet1$]'
) AS t;
GO

INSERT INTO [Pickups] (
    OrderID,
    PickupDate,
    Address
)
SELECT
    [OrderID],
    [PickupDate],
    [Address]
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\pickups_import.xlsx',
    'SELECT [OrderID],[PickupDate],[Address] FROM [Sheet1$]'
) AS t;
GO

INSERT INTO [OrderProduct] (
    OrderID,
    ProductArticleNumber
)
SELECT
    [OrderID],
    [ProductArticleNumber]
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\order_products_import.xlsx',
    'SELECT [OrderID],[ProductArticleNumber] FROM [Sheet1$]'
) AS t;
GO
