using AzureBlob
using Dates
using Test

@testset "Black box signature" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56) |> http_date

	sig = azure_signature(
		url = "url",
		verb = "GET",
		storageaccount = "storageaccount",
		# Length of storagekey must be a multiple of 4
		storagekey = "storagekeyxx",
		container = "container",
		timestamp = timestamp
	)

	@test sig == "3uLSOeEgZxolreoOtEgCe8kUUyfK9lvaKPeYoAdjQ7Q="
end

