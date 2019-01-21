using AzureBlob
using Dates
using Test

@testset "Black-box signature" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56) |> http_date

	# TODO: Base64 encoding gives warning
	sig = azure_signature(
		url = "url",
		verb = "GET",
		storageaccount = "storageaccount",
		storagekey = "storagekey",
		container = "container",
		timestamp = timestamp
	)

	@test sig == "VQvVWSwxbKV/1SJEfmYVIreNyQjc6SjAJtKABLymPcQ="
end

