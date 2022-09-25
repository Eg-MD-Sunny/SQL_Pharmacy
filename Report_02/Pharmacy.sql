----Pharmacy

Select		CAST ( dbo.ToBdt ( o.CreatedOnUtc ) as date ) Date,
			Count ( Distinct ( S.OrderId ) ) TotalOrders,
			SUM ( tr.SalePrice ) TotalRevenue,
			SUM ( Case When ShelfType in (11,12,13) then tr.SalePrice end)  Pharmacy_Revenue,
			SUM ( Case When ShelfType not in (11,12,13) then tr.SalePrice end ) Grocery_Revenue,
			SUM ( tr.SalePrice ) / Count ( Distinct ( S.OrderId ) )  Pharmacy_AVGOrderValue,
			Count ( Distinct ( CASE WHEN FirstCompletedOrderForCustomer = 1  THEN S.OrderId END ) ) as Pharmacy_TotalNewOrders,
			Cancelled_Order Pharmacy_CancelledOrder,
			Count (Distinct CustomerId) as Pharmacy_CustomersOrdering,
			Count ( Distinct ( CASE WHEN OPM.OrderId is not null  THEN S.OrderId END ) ) as WithPrescription,
			Count ( Distinct ( CASE WHEN OPM.OrderId is null  THEN S.OrderId END ) ) as WithOutPrescription

From		ThingRequest TR
	Join	Shipment S on S.id=Tr.ShipmentId
	join	ProductVariant PV on Pv.id=tr.ProductVariantId
	Join	[Order] o on s.OrderId = o.Id

	left Join	(
					SELECT		CAST ( dbo.ToBdt ( o.CreatedOnUtc ) as date ) Date, Count ( Distinct ( OrderId ) ) Cancelled_Order

					FROM		ThingRequest TR
						Join	Shipment S on S.id=Tr.ShipmentId
						join	ProductVariant PV on Pv.id=tr.ProductVariantId
						Join	[Order] o on s.OrderId = o.Id

					WHERE		OrderStatus = 40  
						and		o.CreatedOnUtc >= DATEADD(DAY,-30,GETUTCDATE())
						and		O.StoreId=33

					Group By	CAST ( dbo.ToBdt ( o.CreatedOnUtc ) as date )

				) Co	On		Co.Date = CAST ( dbo.ToBdt ( o.CreatedOnUtc ) as date )

	left Join	( Select Distinct OrderId  From OrderPrescriptionMapping ) OPM On OPM.OrderId = O.Id


where		cast( dbo.ToBdt( o.CreatedOnUtc ) as date ) >= Cast ( DATEADD(DAY,-30,dbo.tobdt(GETUTCDATE())) as date )
	and		s.ShipmentStatus not in (1,9,10)
	and		tr.IsCancelled = 0
	and		tr.IsReturned = 0
	and		tr.IsMissingAfterDispatch = 0
	and		tr.HasFailedBeforeDispatch = 0
	and		O.StoreId=33

Group By	CAST ( dbo.ToBdt ( o.CreatedOnUtc ) as date ),
			Cancelled_Order

Order By	1 Desc