using AzureBlob
using Dates
using Test

@testset "Black box signature" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56) |> AzureBlob.http_date

	getsig = storage_signature("blob", "directory", "container", "storageaccount", "storagekeyxx", timestamp)
	@test getsig == "QDFeyZXEbQXqHJ3Pu4WByyWo1zU52SRC/GBktr+8SdU="

	putsig = storage_signature("content", "blob", "directory", "container", "storageaccount", "storagekeyxx", timestamp, "application/json")
	@test putsig == "Zxe1fAisDpvx84CpCfV4u4ptem78d0ikwOKsmvNe4lg="
end

