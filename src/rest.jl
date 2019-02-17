"""
    get_blob

Download file from blob storage using HTTP GET.
"""
function get_blob(blob, directory, container, storageaccount, storagekey, resourcegroup)
    #TODO: Check input
    # TODO: Function for bloburl
    blobdir = blob_directory(directory, blob)
    bloburl = string("https://", storageaccount,
                     ".blob.core.windows.net/", container, "/", blobdir)

	timestamp = http_date(Dates.now())
	signature = storage_signature(blob, directory, container, storageaccount, storagekey, timestamp)

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => "0",
        "x-ms-version" => X_MS_VERSION, 
		"x-ms-date" => timestamp
    ]

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
	blobdir = blob_directory(directory, blob)
    bloburl = string("https://", storageaccount,
                     ".blob.core.windows.net/", container, "/", blobdir)

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

    HTTP.put(bloburl, header, content)
end

function blob_directory(directory, blob)
    string(directory, "/", blob)
end
