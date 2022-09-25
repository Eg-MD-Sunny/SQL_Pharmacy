select s.orderid OrderId,
       s.shipmentTag,
	   st.name [Store],
	   cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime)[CreatedOn],
	   s.reconciledon Reconciledon,
	   sum(tr.saleprice) Ordervalue,
	   dbo.GetEnumName('ShipmentStatus',ShipmentStatus) ShipmentStatus,
	   s.deliveryFee [DeliveryFee]
	   

from Shipment s
join thingrequest tr on tr.shipmentid=s.id
join [order] o on o.id=s.OrderId
join store st on st.id = o.storeId
join ProductVariant pv on pv.id = tr.ProductVariantId

where cast(dbo.tobdt(o.CreatedOnUtc)as date) >='2022-08-01'
and cast(dbo.tobdt(o.CreatedOnUtc)as date) <'2022-09-01'
and pv.distributionNetworkId = 2


group by  s.orderid,
          s.shipmentTag,
	      st.name,
	      cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime),
	      s.reconciledon,
		  dbo.GetEnumName('ShipmentStatus',ShipmentStatus),
	      s.deliveryFee 


--select top 10 * from store
