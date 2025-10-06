CREATE TABLE tbl_colour
(
	colour_id	int				NOT NULL,
	Name		varchar(20)		NULL,
	extra_fee	numeric(10, 2)	NULL,
PRIMARY KEY CLUSTERED 
(colour_id ASC)
) ON [PRIMARY]
GO

CREATE TABLE tbl_Customers(
	customer_id int			NOT NULL,
	first_name	varchar(50) NULL,
	last_name	varchar(50) NULL,
	fav_colour_id int NULL,
PRIMARY KEY CLUSTERED 
(
	customer_id ASC
)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_Customers]  WITH CHECK ADD FOREIGN KEY([fav_colour_id])
REFERENCES [dbo].[tbl_colour] ([colour_id])
GO



CREATE TABLE tbl_category(
	category_id int			NOT NULL,
	Name		varchar(30) NULL,
	parent_id	int			NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)
) ON [PRIMARY]
GO



CREATE TABLE tbl_Clothing(
	Clothing_id int NOT NULL,
	name		varchar(50) NULL,
	size		varchar(10) NULL,
	price		numeric(12, 2) NULL,
	colour_id	int NULL,
	category_id int NULL,
PRIMARY KEY CLUSTERED 
(
	Clothing_id ASC
)
) ON [PRIMARY]
GO

ALTER TABLE tbl_Clothing  WITH CHECK ADD FOREIGN KEY(category_id)
REFERENCES tbl_category (category_id)
GO

ALTER TABLE tbl_Clothing  WITH CHECK ADD FOREIGN KEY(colour_id)
REFERENCES tbl_colour (colour_id)
GO

CREATE TABLE tbl_clothing_order(
	Order_Id int NOT NULL,
	Customer_Id int NULL,
	Clothing_Id int NULL,
	Items_Ordered int NULL,
	Order_Date date NULL,
PRIMARY KEY CLUSTERED 
(
	[Order_Id] ASC
)
) ON [PRIMARY]
GO

ALTER TABLE tbl_clothing_order WITH CHECK ADD  CONSTRAINT FK_tbl_clothing_order_clothing FOREIGN KEY(Clothing_Id)
REFERENCES tbl_Clothing (Clothing_id)
GO

ALTER TABLE tbl_clothing_order CHECK CONSTRAINT FK_tbl_clothing_order_clothing
GO

ALTER TABLE tbl_clothing_order  WITH CHECK ADD  CONSTRAINT FK_tbl_clothing_order_customer FOREIGN KEY(Customer_Id)
REFERENCES tbl_Customers (customer_id)
GO

ALTER TABLE tbl_clothing_order CHECK CONSTRAINT FK_tbl_clothing_order_customer
GO


