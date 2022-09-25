SELECT	w.MetropolitanAreaId [MetropolitanAreaID],
        w.Id [WarehousID],
	    w.Name [Warehouse],
        PV.Id [PVID],
		PV.Name [Product],
		cws.RequiredStock [RequiredStock], 
	    SUM(cws.Shelved + cws.MarkedForRecall) [AvailableStock]

FROM CurrentWarehouseStock cws
join ProductVariant pv on pv.Id = cws.ProductVariantId 
join Warehouse w on w.Id = cws.WarehouseId 

where pv.DistributionNetworkId = 2

GROUP BY w.Id,
	     w.Name,
         PV.Id,
		 PV.Name,
		 cws.RequiredStock,
		 w.MetropolitanAreaId




