using AzureBlob
using Dates
using Test

@testset "Black box signature" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56) |> http_date

	getsig = storage_signature(
		verb = "GET",
		storageaccount = "storageaccount",
		# Length of storagekey must be a multiple of 4
		storagekey = "storagekeyxx",
		container = "container",
		timestamp = timestamp
	)

	@test getsig == "3uLSOeEgZxolreoOtEgCe8kUUyfK9lvaKPeYoAdjQ7Q="


	putsig = storage_signature(
		verb = "PUT",
		storageaccount = "storageaccount",
		# Length of storagekey must be a multiple of 4
		storagekey = "storagekeyxx",
		container = "container",
        headers = "x-ms-blob-type:Blockblob",
		contentsize = "2",
		contenttype = "application/json",
		timestamp = timestamp,
	)

	@test putsig == "DepfzhDDUlyxFlJ7hy1Rcb62+1Y2tZIZrjd7/wn/O60="
end

