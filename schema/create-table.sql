CREATE TABLE Publishers (
	Identifier bigint(20) NOT NULL AUTO_INCREMENT, 
	Name varchar(255) UNIQUE, 
	Country varchar(50), 
	Publisher_Desc text, 
	Primary Key (Identifier)
);

CREATE TABLE Games_Library ( 
	Identifier bigint(20) NOT NULL AUTO_INCREMENT,
	Title varchar(255) UNIQUE, 
	Release_Date datetime not null, 
	Size_In_MB int(10) not null, 
	Publisher_ID bigint(10), 
	Copies_Available int(10) DEFAULT 0,
	Price decimal(10,2), 
	PRIMARY KEY (Identifier), 
	FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Identifier) 
);

CREATE TABLE Inventory ( 
	Identifier bigint(20) NOT NULL AUTO_INCREMENT,
	Barcode varchar(255), 
	Game_ID bigint(10),
	PRIMARY KEY (Identifier), 
	FOREIGN KEY (Game_ID) REFERENCES Games_Library(Identifier) 
);

CREATE TABLE Audit ( 
	Game_ID bigint(10), 
	Audited_On timestamp, 
	Copies_Stocked int(10), 
	FOREIGN KEY (Game_ID) REFERENCES Inventory(Game_ID) 
);

CREATE TABLE Customers ( 
	Identifier bigint(20) NOT NULL AUTO_INCREMENT,
	First_Name varchar(255) not null, 
	Last_Name varchar(255) not null, 
	Contact_Number int(10) not null, 
	Email varchar(255) unique, 
	Address text, 
	PRIMARY KEY (Identifier) 
);

CREATE TABLE Rental ( 
	Identifier bigint(20) NOT NULL AUTO_INCREMENT,
	Inventory_Item_ID bigint(20),
	Customer_ID bigint(20), 
	Payment decimal(10,2),
	Rented_On_Date date, 
	Returned_Date date DEFAULT null, 
	PRIMARY KEY (Identifier),
	FOREIGN KEY (Inventory_Item_ID) REFERENCES Inventory(Identifier), 
	FOREIGN KEY (Customer_ID) REFERENCES Customers(Identifier)
);

