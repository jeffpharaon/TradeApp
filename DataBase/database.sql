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
        UserSurname      NVARCHAR(100) NOT NULL,
        UserName         NVARCHAR(100) NOT NULL,
        UserPatronymic   NVARCHAR(100) NOT NULL,
        UserLogin        NVARCHAR(MAX) NOT NULL,
        UserPassword     NVARCHAR(MAX) NOT NULL,
        UserRole         INT NOT NULL FOREIGN KEY REFERENCES [Role](RoleID)
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
        ProductName          NVARCHAR(MAX) NOT NULL,
        ProductDescription   NVARCHAR(MAX) NOT NULL,
        ProductCategory      NVARCHAR(MAX) NOT NULL,
        ProductPhoto         IMAGE NULL,  
        ProductManufacturer  NVARCHAR(MAX) NOT NULL,
        ProductCost          DECIMAL(19,4) NOT NULL,
        ProductDiscountAmount TINYINT NULL,
        ProductQuantityInStock INT NOT NULL,
        ProductStatus        NVARCHAR(MAX) NOT NULL
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
    x.UserSurname,
    x.UserName,
    x.UserPatronymic,
    x.UserLogin,
    x.UserPassword,
    x.UserRole
FROM
(
    SELECT 
        CAST([UserSurname] AS NVARCHAR(100))     AS [UserSurname],
        CAST([UserName] AS NVARCHAR(100))        AS [UserName],
        CAST([UserPatronymic] AS NVARCHAR(100))  AS [UserPatronymic],
        CAST([UserLogin] AS NVARCHAR(MAX))       AS [UserLogin],
        CAST([UserPassword] AS NVARCHAR(MAX))    AS [UserPassword],
        CAST([UserRole] AS INT)                  AS [UserRole]
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;TypeGuessRows=0;ImportMixedTypes=Text;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\users_import.xlsx',
        'SELECT [UserSurname],[UserName],[UserPatronymic],[UserLogin],[UserPassword],[UserRole] FROM [Table Data$]'
    )
) AS x;
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
    x.ProductArticleNumber,
    x.ProductName,
    x.ProductDescription,
    x.ProductCategory,
    NULL,  
    x.ProductManufacturer,
    x.ProductCost,
    x.ProductDiscountAmount,
    x.ProductQuantityInStock,
    x.ProductStatus
FROM
(
    SELECT 
        CAST([ProductArticleNumber] AS NVARCHAR(100))       AS [ProductArticleNumber],
        CAST([ProductName] AS NVARCHAR(MAX))                AS [ProductName],
        CAST([ProductDescription] AS NVARCHAR(MAX))         AS [ProductDescription],
        CAST([ProductCategory] AS NVARCHAR(MAX))            AS [ProductCategory],
        CAST([ProductManufacturer] AS NVARCHAR(MAX))        AS [ProductManufacturer],
        CAST([ProductCost] AS DECIMAL(19,4))                AS [ProductCost],
        CAST([ProductDiscountAmount] AS TINYINT)            AS [ProductDiscountAmount],
        CAST([ProductQuantityInStock] AS INT)               AS [ProductQuantityInStock],
        CAST([ProductStatus] AS NVARCHAR(MAX))              AS [ProductStatus]
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;TypeGuessRows=0;ImportMixedTypes=Text;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\products_import.xlsx',
        'SELECT [ProductArticleNumber],[ProductName],[ProductDescription],[ProductCategory],[ProductManufacturer],[ProductCost],[ProductDiscountAmount],[ProductQuantityInStock],[ProductStatus] FROM [Лист1$]'
    )
) AS x;
GO

INSERT INTO [Order] (
    OrderStatus,
    OrderDeliveryDate,
    OrderPickupPoint
)
SELECT
    x.OrderStatus,
    x.OrderDeliveryDate,
    x.OrderPickupPoint
FROM
(
    SELECT 
        CAST([OrderStatus] AS NVARCHAR(MAX))  AS [OrderStatus],
        CAST([OrderDeliveryDate] AS DATETIME) AS [OrderDeliveryDate],
        CAST([OrderPickupPoint] AS NVARCHAR(MAX)) AS [OrderPickupPoint]
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;TypeGuessRows=0;ImportMixedTypes=Text;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\order_import.xlsx',
        'SELECT [OrderStatus],[OrderDeliveryDate],[OrderPickupPoint] FROM [Table Data$]'
    )
) AS x;
GO

INSERT INTO [Pickups] (
    OrderID,
    PickupDate,
    Address
)
SELECT
    x.OrderID,
    x.PickupDate,
    x.Address
FROM
(
    SELECT
        CAST([OrderID] AS INT)         AS [OrderID],
        CAST([PickupDate] AS DATETIME) AS [PickupDate],
        CAST([Address] AS NVARCHAR(255)) AS [Address]
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;TypeGuessRows=0;ImportMixedTypes=Text;Database=D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\pickups_import.xlsx',
        'SELECT [OrderID],[PickupDate],[Address] FROM [Sheet1$]'
    )
) AS x;
GO
