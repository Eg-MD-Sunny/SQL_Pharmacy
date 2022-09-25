select  pv.id [PVID],
		pv.Name [Product]

from ProductVariant pv
where pv.DistributionNetworkId = 2
and pv.Published =1
and pv.Deleted = 0