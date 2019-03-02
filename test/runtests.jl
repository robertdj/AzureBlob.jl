using AzureBlob
using Dates
using TimeZones

using Test


@testset "Black box signature" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56) |> AzureBlob.http_date

	getsig = storage_signature("blob", "directory", "container", "storageaccount", "storagekeyxx", timestamp)
	@test getsig == "QDFeyZXEbQXqHJ3Pu4WByyWo1zU52SRC/GBktr+8SdU="

	putsig = storage_signature("content", "blob", "directory", "container", "storageaccount", "storagekeyxx", timestamp, "application/json")
	@test putsig == "Zxe1fAisDpvx84CpCfV4u4ptem78d0ikwOKsmvNe4lg="
end


@testset "Time zones" begin
	timestamp = DateTime(2019, 1, 1, 12, 34, 56)
	@test http_date(timestamp) == "Tue, 01 Jan 2019 12:34:56 GMT"

	timestamp = ZonedDateTime(2019, 1, 1, 12, 34, 56, tz"UTC")
	@test http_date(timestamp) == "Tue, 01 Jan 2019 12:34:56 GMT"

	timestamp = ZonedDateTime(2019, 1, 1, 12, 34, 56, tz"America/New_York")
	@test http_date(timestamp) == "Tue, 01 Jan 2019 17:34:56 GMT"

	timestamp = ZonedDateTime(2019, 1, 1, 12, 34, 56, tz"Europe/Copenhagen")
	@test http_date(timestamp) == "Tue, 01 Jan 2019 11:34:56 GMT"
end

