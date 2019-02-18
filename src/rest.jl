"""
    get_blob

Download file from blob storage using HTTP GET.
"""
function get_blob(blob, directory, container, storageaccount, storagekey, resourcegroup)
    #TODO: Check input

	timestamp = http_date(Dates.now())
	signature = storage_signature(blob, directory, container, storageaccount, storagekey, timestamp)

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => "0",
        "x-ms-version" => X_MS_VERSION, 
		"x-ms-date" => timestamp
    ]

	bloburl = blob_to_url(blob, directory, container, storageaccount)
    HTTP.get(bloburl, header)
end

"""
    put_blob

Upload file to blob storage using HTTP PUT.
"""
function put_blob(content, blob, directory, container, storageaccount,
                  storagekey, resourcegroup, contenttype::String =
                  "application/json")
    # TODO: Check if content matches contenttype

    timestamp = http_date(Dates.now())
    sz = @pipe contentsize(content) |> string

	signature = storage_signature(content, blob, directory, container, storageaccount, storagekey, timestamp, contenttype)

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => sz,
        "x-ms-version" => X_MS_VERSION, 
        "x-ms-date" => timestamp,
        "x-ms-blob-type" => "Blockblob",
        "Content-type" => contenttype
    ]

	bloburl = blob_to_url(blob, directory, container, storageaccount)
    HTTP.put(bloburl, header, content)
end


"""
	blob_to_url(blob, directory, container, storageaccount)

Concatenate the components of a blob location to a URL.
"""
function blob_to_url(blob, directory, container, storageaccount)
    string(
		"https://", storageaccount,
		".blob.core.windows.net/", container, "/", directory, "/", blob
	)
end
