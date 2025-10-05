/*Solution # 1 */

select  top 5
		so.customerid				as customer_id 
,		c.name						as customer_name
,		sum(coalesce(sod.totalamount,0)) as SalesAmount 
from salesorder so inner join salesorderdetail sod on so.orderid = sod.orderid 
left outer join payment p on so.orderid = p.orderid 
left outer join returns r on so.orderid = r.orderid 
left outer join returndetail rd on (r.returnid = rd.returnid)
inner join customer c on so.customerid = c.customerid 
Where so.PaymentStatus = 'Completed'
Group By
		so.customerid				
,		c.name						
Order by 3 desc 




/*Solution # 2 */

select 
	po.SupplierId					as Supplier_Id
,	s.Name							as Supplier_Name
,	count(distinct pod.ProductID)	as Unique_Product_Count 
from Supplier s 
	inner join purchaseorder po on s.supplierid = po.supplierid 
	inner join purchaseorderdetail pod on po.Orderid = pod.Orderid
Group By 
		po.SupplierId 
,		s.Name		  
having	
		count(distinct pod.ProductID) > 10


/*Solution # 3 */


select 
		prod.Product_Id				 as Product_Id
,		prod.Product_Name			 as Product_Name
,		sum(coalesce(sd.Quantity,0)) as Total_Quantity
from
(
select 
	P.ProductID as Product_Id
,	P.Name		as Product_Name
from Product p where not exists (
select distinct ProductID from ReturnDetail rd  
where 
		p.ProductID = rd.ProductID
		) 
) prod inner join salesorderdetail sd on (
		prod.Product_Id  = sd.productid
		)
Group By 
	prod.Product_Id
,	prod.Product_Name



/*Solution # 4 */

SELECT
    c.CategoryID as Category_Id
,	c.Name		 as Category_Name
,	p.Name		 as Product_Name	
,	p.Price		 as Most_Expensive_Category 
FROM
    Category c
INNER JOIN
    Product p ON c.CategoryID = p.CategoryID
WHERE
    p.Price = (SELECT MAX(p2.Price) FROM Product  p2 WHERE p2.CategoryID = c.CategoryID)




/*Solution # 6 */
select 
		s.ShipmentID	as Shipment_ID
	,	l.Name			as Warehouse_Name
	,	m.Name			as Manager_Name
	,	p.Name			as Product_Name
	,	sd.Quantity		as Quantity_Shiped
	,	s.TrackingNumber	as Tracking_Number
  from Shipment s inner join Warehouse w on (
		s.WarehouseID = w.WarehouseID
) left outer join Location l on (
		w.LocationID = l.LocationID
) left outer join Employee m on (
		w.ManagerID = m.ManagerID
) left outer join Inventory i on (
		i.WarehouseID = w.WarehouseID
) inner join Product p on (
		i.ProductID = p.ProductID
) inner join ShipmentDetail sd on (
		s.ShipmentID = sd.ShipmentID
	and	i.ProductID  = sd.ProductID 
) 
Order by Shipment_ID


/*Solution # 7 */

select 
	a.CustomerID		as Customer_ID
,	a.OrderId			as Order_ID
,	a.TotalAmount		as Total_Amount
,	a.Rank_Value		as Rank_Value
from 
(
select		s.CustomerID 
		,	s.OrderID 
		,	sd.TotalAmount
		,	RANK () OVER (PARTITION BY CUSTOMERID Order by sd.TotalAmount) as Rank_Value 
from SalesOrder s inner join SalesOrderDetail sd on (
		s.OrderID = sd.OrderID
)
) a 
where 
	a.Rank_Value <= 3
Order by a.CustomerID asc 


/* Solution # 8 */


SELECT
    p.ProductID		as Product_ID
,	p.Name			as Product_Name
,	so.OrderID		as OrderID
,	so.OrderDate	as Order_Date
,	sod.Quantity	as Quantity,
    LAG(sod.Quantity, 1, 0) OVER (PARTITION BY p.ProductID ORDER BY so.OrderDate) AS Pre_Quantity,
    LEAD(sod.Quantity, 1, 0) OVER (PARTITION BY p.ProductID ORDER BY so.OrderDate) AS Next_Quantity
FROM
    Product p inner join SalesOrderDetail sod on (
		p.ProductID = sod.ProductID )
	inner join SalesOrder so on sod.OrderID = so.OrderID
ORDER BY
    p.ProductID, so.OrderDate;


/* Solution # 9 */

Create view vw_CustomerOrderSummary  as 
select	
		so.CustomerID			   as Customer_ID	
,		c.Name					   as Customer_Name	
,		count(distinct so.OrderId) as distinct_orders
,		sum(coalesce(sod.TotalAmount,0)) as Total_Amount	
,		last_order_Dt.OrderDate		as Last_Order_Date
from SalesOrder so inner join SalesOrderDetail sod on (
		so.OrderID = sod.OrderID
) inner join Customer c on (
		so.CustomerID = c.CustomerID
) left outer join (select CustomerID , max(OrderDate) as OrderDate  from SalesOrder   Group By CustomerID ) last_order_Dt on (
		last_order_Dt.CustomerID = so.CustomerID
)  
Where so.PaymentStatus = 'Completed' 
Group By so.CustomerId , c.Name , last_order_Dt.OrderDate

/*Solution # 10*/

CREATE PROCEDURE sp_GetSupplierSales
    @SupplierID INT
AS
BEGIN

select 
	po.SupplierID 
,	pod.orderid 
,	pod.ProductID 
,	sd.Sales_Tot_Amount
from supplier  s 
	inner join PurchaseOrder po on s.SupplierID = po.SupplierID
	inner join PurchaseOrderDetail pod on po.OrderID = pod.OrderID
	inner join Product p on pod.ProductID = p.ProductID
	left outer join ( select sod.ProductID as Product_id, sum(coalesce(sod.TotalAmount,0)) as Sales_Tot_Amount 
	from SalesOrderDetail sod inner join SalesOrder so on 
			sod.OrderID = so.OrderID 
			Group By sod.ProductID
		---	where so.PaymentStatus = 'Completed' 
			) sd on  sd.Product_id = pod.ProductID
WHERE
        S.SupplierID = @SupplierID;
END;

exec  sp_GetSupplierSales,32

EXEC sp_GetSupplierSales @SupplierID = '1'

