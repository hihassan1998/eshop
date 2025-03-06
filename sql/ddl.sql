DROP TABLE IF EXISTS Logg;
DROP TABLE IF EXISTS FakturaProdukt;
DROP TABLE IF EXISTS OrderProdukt;
DROP TABLE IF EXISTS lagerplats;
DROP TABLE IF EXISTS ProduktKategori;
DROP TABLE IF EXISTS PlocklistaProdukt;

DROP TABLE IF EXISTS Faktura;
DROP TABLE IF EXISTS Plocklista;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS Kund;
DROP TABLE IF EXISTS Produkt;
DROP TABLE IF EXISTS Kategori;
DROP TABLE IF EXISTS Lager;
--
--



CREATE TABLE Kund (
    id INT AUTO_INCREMENT PRIMARY KEY,
    namn VARCHAR(20),
    epost VARCHAR(40),
    telefon VARCHAR(20),
    adress TEXT
);

CREATE TABLE Lager (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hylla VARCHAR(20)
);

CREATE TABLE Produkt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    namn VARCHAR(20),
    beskrivning TEXT,
    pris DECIMAL(10, 2)
);

CREATE TABLE Kategori (
    id INT AUTO_INCREMENT PRIMARY KEY,
    namn VARCHAR(255)
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kund_id INT,
    orderdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kund_id) REFERENCES Kund(id) ON DELETE CASCADE
);

CREATE TABLE OrderProdukt (
    order_id INT,
    produkt_id INT,
    antal INT,
    PRIMARY KEY (order_id, produkt_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (produkt_id) REFERENCES Produkt(id) ON DELETE CASCADE
);

CREATE TABLE Plocklista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE PlocklistaProdukt (
    plocklista_id INT,
    produkt_id INT,
    hylla VARCHAR(255),
    antal INT,
    PRIMARY KEY (plocklista_id, produkt_id),
    FOREIGN KEY (plocklista_id) REFERENCES Plocklista(id) ON DELETE CASCADE,
    FOREIGN KEY (produkt_id) REFERENCES Produkt(id) ON DELETE CASCADE
);

CREATE TABLE Faktura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    totalbelopp DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE FakturaProdukt (
    faktura_id INT,
    produkt_id INT,
    pris DECIMAL(10, 2),
    antal INT,
    PRIMARY KEY (faktura_id, produkt_id),
    FOREIGN KEY (faktura_id) REFERENCES Faktura(id) ON DELETE CASCADE,
    FOREIGN KEY (produkt_id) REFERENCES Produkt(id) ON DELETE CASCADE
);

CREATE TABLE Logg (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_typ VARCHAR(150),
    tidpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_id INT NULL,
    faktura_id INT NULL,
    lager_id INT NULL,
    plocklista_id INT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (faktura_id) REFERENCES Faktura(id) ON DELETE CASCADE,
    FOREIGN KEY (lager_id) REFERENCES Lager(id) ON DELETE CASCADE,
    FOREIGN KEY (plocklista_id) REFERENCES Plocklista(id) ON DELETE CASCADE
);


CREATE TABLE ProduktKategori (
    produkt_id INT,
    kategori_id INT,
    PRIMARY KEY (produkt_id, kategori_id),
    FOREIGN KEY (produkt_id) REFERENCES Produkt(id) ON DELETE CASCADE,
    FOREIGN KEY (kategori_id) REFERENCES Kategori(id) ON DELETE CASCADE
);

CREATE TABLE LagerPlats (
    lager_id INT,
    produkt_id INT,
    antal INT,
    PRIMARY KEY (lager_id, produkt_id),
    FOREIGN KEY (lager_id) REFERENCES Lager(id) ON DELETE CASCADE,
    FOREIGN KEY (produkt_id) REFERENCES Produkt(id) ON DELETE CASCADE
);

-- SHOW TABLES;
-- DESCRIBE Produkt;
--
--  Procedures
--
-- CRUD PROCEDURES FOR PRODUKTS
--
--  Procedure to Add a New Product
--
DROP PROCEDURE IF EXISTS AddProdukt;
DELIMITER ;;
CREATE PROCEDURE AddProdukt(
    IN p_namn VARCHAR(20),
    IN p_beskrivning TEXT,
    IN p_pris DECIMAL(10,2)
)
BEGIN
    INSERT INTO Produkt (namn, beskrivning, pris) 
    VALUES (p_namn, p_beskrivning, p_pris);
END;;
DELIMITER ;
--
--  Procedure to EDIT a Produkt
--
DROP PROCEDURE IF EXISTS EditProdukt;
DELIMITER ;;
CREATE PROCEDURE EditProdukt(
    IN p_id INT,
    IN p_namn VARCHAR(20),
    IN p_beskrivning TEXT,
    IN p_pris DECIMAL(10,2)
)
BEGIN
    UPDATE Produkt 
    SET namn = p_namn, beskrivning = p_beskrivning, pris = p_pris
    WHERE id = p_id;
END ;;
DELIMITER ;
--
--  Procedure to DELETE a Produkt
--
DROP PROCEDURE IF EXISTS DeleteProdukt;
DELIMITER ;;
CREATE PROCEDURE DeleteProdukt(
    IN p_id INT
)
BEGIN
    -- Delete the product from the Produkt table
    DELETE FROM Produkt WHERE id = p_id;
END;;
DELIMITER ;

--
--  Procedure to OVERVIEW a Produkt, its lager status, kategories status and produkt info.
--
DROP PROCEDURE IF EXISTS GetProductsOverview;
DELIMITER ;;
CREATE PROCEDURE GetProductsOverview()
BEGIN
    SELECT 
        p.id AS produkt_id,
        p.namn AS produkt_namn,
        p.pris AS produkt_pris,
        COALESCE(SUM(lp.antal), 0) AS totalt_lagerantal,
        COALESCE(GROUP_CONCAT(k.namn SEPARATOR ', '), 'Ingen kategori') AS kategorier
    FROM Produkt p
    LEFT JOIN LagerPlats lp ON p.id = lp.produkt_id
    LEFT JOIN ProduktKategori pk ON p.id = pk.produkt_id
    LEFT JOIN Kategori k ON pk.kategori_id = k.id
    GROUP BY p.id, p.namn, p.pris;
END ;;
DELIMITER ;
--
-- View KAtegorier
--
DROP PROCEDURE IF EXISTS ViewCategories;
DELIMITER ;;
CREATE PROCEDURE ViewCategories()
BEGIN
    -- Select all categories
    SELECT id AS kategori_id, namn AS kategori_namn
    FROM Kategori;
END;;
DELIMITER ;


DELIMITER $$
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS showProduct;
-- Create the procedure
CREATE PROCEDURE showProduct(IN product_id INT)
BEGIN
    -- Select all details of a product by its ID
    SELECT 
        id AS produkt_id,
        namn AS produkt_namn,
        beskrivning AS produkt_beskrivning,
        pris AS produkt_pris
    FROM 
        Produkt
    WHERE
        id = product_id;
END$$
DELIMITER ;
--
-- Delete a product
-- 
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS DeleteProdukt;
DELIMITER ;;
CREATE PROCEDURE DeleteProdukt(
    IN p_produkt_id INT
)
BEGIN
    -- Delete the product from the database
    DELETE FROM Produkt WHERE id = p_produkt_id;
END ;;
DELIMITER ;

--
-- Show shelfs from Lager
-- 
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS showLager;
DELIMITER ;;
CREATE PROCEDURE showLager()
BEGIN
    SELECT * FROM Lager;
END;;
DELIMITER ;

--
-- Inv cli command procedure
--
DROP PROCEDURE IF EXISTS GetLagerPlatsOverview;
DELIMITER ;;
CREATE PROCEDURE GetLagerPlatsOverview()
BEGIN
    SELECT 
        p.id AS produkt_id,
        p.namn AS produkt_namn,
        l.hylla AS lagerhylla,
        lp.antal AS antal
    FROM 
        LagerPlats lp
    JOIN 
        Produkt p ON lp.produkt_id = p.id
    JOIN 
        Lager l ON lp.lager_id = l.id
    ORDER BY 
        p.id;
END ;;
DELIMITER ;


DROP PROCEDURE IF EXISTS ViewCategoriesWithProducts;
DELIMITER ;;
CREATE PROCEDURE ViewCategoriesWithProducts()
BEGIN
    SELECT 
        Kategori.id AS kategori_id, 
        Kategori.namn AS kategori_namn,
        Produkt.id AS product_id, 
        Produkt.namn AS product_namn,
        Produkt.pris AS product_price
    FROM 
        Kategori
    LEFT JOIN 
        ProduktKategori ON Kategori.id = ProduktKategori.kategori_id
    LEFT JOIN 
        Produkt ON ProduktKategori.produkt_id = Produkt.id
    ORDER BY 
        Kategori.namn, Produkt.namn;
END;;

DELIMITER ;
--
-- Debugg
--
-- call ViewCategoriesWithProducts();
-- call GetLagerPlatsOverview();
-- CALL AddProduct('Laptop', 'Powerful gaming laptop', 15000.00);
-- select * from Produkt;
-- Call AddProdukt('Coffee	Luxury', 'coffee blended aroamatic luxury.',85.00);
-- Call EditProdukt(6, 'Coffee	Rich', 'coffee blend.',	45.00);
-- CALL EditProdukt(7, 'Updated Laptop', 'Improved gaming laptop with better cooling', 15500.00);
-- CALL DeleteProdukt(8);
-- CALL GetProductsOverview();
-- CALL ViewCategories();
-- CALL showProduct(10);
-- CALL DeleteProdukt(18);
-- show tables;
-- call showLager();
-- select * from lagerplats;

--
-- Add given number of products to given shelf based on cli command;
-- invadd <productid> <shelf> <number>
--
DROP PROCEDURE IF EXISTS invadd;
DELIMITER ;;
CREATE PROCEDURE invadd(IN productid INT, IN shelf VARCHAR(255), IN number INT)
BEGIN
    DECLARE shelf_id INT;
    DECLARE existing_count INT;

    SELECT id INTO shelf_id
    FROM Lager
    WHERE hylla = shelf;

    SELECT COUNT(*) INTO existing_count
    FROM LagerPlats
    WHERE produkt_id = productid AND lager_id = shelf_id;

    IF existing_count > 0 THEN
        UPDATE LagerPlats
        SET antal = antal + number
        WHERE produkt_id = productid AND lager_id = shelf_id;
    ELSE
        INSERT INTO LagerPlats (produkt_id, lager_id, antal)
        VALUES (productid, shelf_id, number);
    END IF;
END ;;

DELIMITER ;
--
-- Delete given number of products from given shelf based on cli command;
-- invdel <productid> <shelf> <number>
--
DROP PROCEDURE IF EXISTS invdel;
DELIMITER ;;
CREATE PROCEDURE invdel(IN productid INT, IN shelf VARCHAR(255), IN number INT)
BEGIN
    DECLARE shelf_id INT;
    DECLARE available_quantity INT;

    SELECT id INTO shelf_id
    FROM Lager
    WHERE hylla = shelf;

    SELECT antal INTO available_quantity
    FROM LagerPlats
    WHERE produkt_id = productid AND lager_id = shelf_id;

    -- Check if the available quantity is sufficient
    IF available_quantity < number THEN
        -- Raise an error with SIGNAL if there are not enough products
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Not enough products to delete.';
    ELSE
        UPDATE LagerPlats
        SET antal = antal - number
        WHERE produkt_id = productid AND lager_id = shelf_id;
    END IF;
END ;;

DELIMITER ;
--
-- Evnets logging table
--
DROP TABLE IF EXISTS log;
CREATE TABLE log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_type VARCHAR(255),
    user_id VARCHAR(255),
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--
-- Trigger for invdel
--
-- DROP TRIGGER IF EXISTS log_invdel_update;
-- DELIMITER $$
-- CREATE TRIGGER log_invdel_update
-- AFTER UPDATE ON LagerPlats
-- FOR EACH ROW
-- BEGIN
    -- Log the update event in the 'logg' table
   --  INSERT INTO log (event_type, user_id, details)
   -- VALUES ('invdel', current_user(), 
--             CONCAT('Deleted ', OLD.antal - NEW.antal, ' units of product ID ', OLD.produkt_id, ' on shelf ', OLD.lager_id));
-- END $$
-- DELIMITER ;
--
-- Trigger for invadd
--
DELIMITER $$
DROP TRIGGER IF EXISTS log_invadd_update $$
CREATE TRIGGER log_invadd_update
AFTER UPDATE ON LagerPlats
FOR EACH ROW
BEGIN
    INSERT INTO log (event_type, user_id, details)
    VALUES ('invadd', current_user(), 
            CONCAT('Added ', NEW.antal - OLD.antal, ' units of product ID ', OLD.produkt_id, ' on shelf ', OLD.lager_id));
END $$
DELIMITER ;
--
-- Trigger for adding a product
--
DELIMITER $$
DROP TRIGGER IF EXISTS log_addprodukt$$
CREATE TRIGGER log_addprodukt
AFTER INSERT ON Produkt
FOR EACH ROW
BEGIN
    -- Log the product addition in the 'log' table
    INSERT INTO log (event_type, user_id, details)
    VALUES ('addprodukt', current_user(), 
            CONCAT('Added product ID ', NEW.id, ': ', NEW.namn, ' with price ', NEW.pris));
END $$
DELIMITER ;
--
-- Edit produkt trigger
--
DELIMITER $$
-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS log_editprodukt$$
CREATE TRIGGER log_editprodukt
AFTER UPDATE ON Produkt
FOR EACH ROW
BEGIN
    INSERT INTO log (event_type, user_id, details)
    VALUES ('editprodukt', current_user(), 
            CONCAT('Edited product ID ', OLD.id, ': changed name from ', OLD.namn, ' to ', NEW.namn, 
                   ', price from ', OLD.pris, ' to ', NEW.pris));
END $$

DELIMITER ;
--
-- Delete product Trigger
--
DELIMITER $$
-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS log_deleteprodukt$$
CREATE TRIGGER log_deleteprodukt
AFTER DELETE ON Produkt
FOR EACH ROW
BEGIN
    -- Log the product deletion in the 'log' table
    INSERT INTO log (event_type, user_id, details)
    VALUES ('deleteprodukt', current_user(), 
            CONCAT('Deleted product ID ', OLD.id, ': ', OLD.namn));
END $$
DELIMITER ;

--
-- Procedure to view the log tables latest given <number> of entries
--
DELIMITER ;;
DROP PROCEDURE IF EXISTS showLog;
CREATE PROCEDURE showLog(IN num_entries INT)
BEGIN
    SELECT * FROM log
    ORDER BY timestamp DESC
    LIMIT num_entries;
END ;;
DELIMITER ;
--
-- Debugg
--
-- call showLog(5);
-- Call EditProdukt(22,'Coffee Lux', 'coffee aroamatic luxury.',55.00);
-- Call addProdukt('Coffee Lux', 'coffee aroamatic luxury.',55.00);
-- Call EditProdukt(6, 'Coffee	Rich', 'coffee blend.',	45.00);
-- CALL EditProdukt(7, 'Updated Laptop', 'Improved gaming laptop with better cooling', 15500.00);
-- CALL DeleteProdukt(8);
-- Drop trigger log_invdel_update;
-- select * from log;
-- select * from Lager;
-- CAll GetLagerPlatsOverview();
-- call GetLagerPlatsOverview();
-- call invadd(5,'A1',5);
-- CALL invdel(5, 'A1', 5);
-- select * from log;
-- SHOW TRIGGERs;
