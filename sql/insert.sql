--
-- Delete tables, in order, depending on
-- foreign key constraints.
--
--
-- add the csv files to this path before running db
-- C:\Program Files\MariaDB 11.6\data\eshop
--

-- DROP TABLE IF EXISTS Logg;
-- DROP TABLE IF EXISTS FakturaProdukt;
-- DROP TABLE IF EXISTS OrderProdukt;
DELETE FROM lagerplats;
DELETE FROM ProduktKategori;
-- DROP TABLE IF EXISTS PlocklistaProdukt;

-- DROP TABLE IF EXISTS Faktura;
-- DROP TABLE IF EXISTS Plocklista;
-- DROP TABLE IF EXISTS orders;
DELETE FROM Kund;
ALTER TABLE Kund AUTO_INCREMENT = 1;

DELETE FROM Produkt;
ALTER TABLE Produkt AUTO_INCREMENT = 1;

DELETE FROM Kategori;
ALTER TABLE Kategori AUTO_INCREMENT = 1;
DELETE FROM Lager;
ALTER TABLE Lager AUTO_INCREMENT = 1;

-- DELETE FROM kund;
-- DELETE FROM Produkt;
--
-- Enable LOAD DATA LOCAL INFILE on the server.
--
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
--
-- Insert into kund table.
--
LOAD DATA INFILE 'kund.csv'
INTO TABLE kund
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(namn, epost, telefon, adress);

-- SELECT * FROM kund;

--
-- Insert into Produkt table.
--
LOAD DATA INFILE 'Produkt.csv'
INTO TABLE Produkt
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(namn, beskrivning, pris);
select * from Produkt;

--
-- Insert into Lager table.
--
LOAD DATA INFILE 'lager.csv'
INTO TABLE Lager
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(hylla);
-- select * from Lager;

--
-- Insert into Kategori table.
--
LOAD DATA INFILE 'kategori.csv'
INTO TABLE Kategori
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(namn);
-- select * from Kategori;

--
-- Insert into LagerPlats table.
--
LOAD DATA INFILE 'lagerplats.csv'
INTO TABLE LagerPlats
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;
-- select * from LagerPlats;

--
-- Insert into ProduktKategori table.
--
LOAD DATA INFILE 'produktkategori.csv'
INTO TABLE ProduktKategori
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;
select * from ProduktKategori;