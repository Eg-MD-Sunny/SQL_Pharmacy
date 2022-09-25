select t.Date,t.WarehouseID,t.Warehouse,t.PVID,t.Product,t.CustomerID,t.OrderID,t.TotalOrder,t.[TS/NonTs],t.SalePrice,t.DiscountCode,sum(t.DiscountAmount)


from (
select  cast(dbo.ToBdt(o.CreatedOnUtc)as date)[Date]
		,w.Id [WarehouseID]
		,w.Name [Warehouse] 
		,pv.Id [PVID]
		,pv.Name [Product]
		,o.CustomerId [CustomerID]
		,o.id[OrderID]
		,count((o.id))[TotalOrder]
		,(case when rn.Note like '%Order placed by an admin%' then 'TS' else 'NonTS' end)[TS/NonTs]
		,sum(tr.SalePrice) [SalePrice]
		,duh.DiscountAmount [DiscountAmount]
		,d.CouponCode [DiscountCode]


from ThingRequest tr
join Shipment s on s.id = tr.ShipmentId 
join [Order] o on o.Id = s.OrderId 
join ProductVariant pv on pv.Id = tr.ProductVariantId 
join Warehouse w on w.Id = s.WarehouseId 
join OrderNote rn on s.OrderId  = rn.OrderId
left join DiscountUsageHistory duh on o.Id = duh.OrderId 
left join Discount d on d.Id = duh.DiscountId

where cast(dbo.toBdt(o.CreatedOnUtc)as date)  >= '2022-06-01'
and cast(dbo.toBdt(o.CreatedOnUtc)as date)  < '2022-06-05'
and tr.IsCancelled = 0
and tr.HasFailedBeforeDispatch = 0
and tr.IsMissingAfterDispatch = 0
and tr.IsReturned = 0
and pv.DistributionNetworkId = 2
and o.storeId = 33
and s.ShipmentStatus not in (1,9,10)


group by cast(dbo.ToBdt(o.CreatedOnUtc)as date)
		,w.Id 
		,w.Name  
		,pv.Id 
		,pv.Name 
		,o.CustomerId 
		,o.id
		,(case when rn.Note like '%Order placed by an admin%' then 'TS' else 'NonTS' end)
		,duh.DiscountAmount 
		,d.CouponCode 
)t

group by t.Date,t.WarehouseID,t.Warehouse,t.PVID,t.Product,t.CustomerID,t.OrderID,t.TotalOrder,t.[TS/NonTs],t.SalePrice,t.DiscountCode




