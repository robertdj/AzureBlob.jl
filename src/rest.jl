# TODO: Haven't made up my mind about whether or not to have a function to return 
# a base header for both get_blob and put_blob

"""
	get_blob(blob, directory, container, storageaccount, storagekey)

Download file from blob storage using HTTP GET.
"""
function get_blob(blob, directory, container, storageaccount, storagekey)
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
	put_blob(content, blob, directory, container, storageaccount,
			 storagekey, contenttype::String = "application/json")

Upload file to blob storage using HTTP PUT.
"""
function put_blob(content, blob, directory, container, storageaccount,
                  storagekey, contenttype::String = "application/json")
    # TODO: Check if content matches contenttype

    timestamp = http_date(Dates.now())
	signature = storage_signature(content, blob, directory, container, storageaccount, storagekey, timestamp, contenttype)

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
		"Content-Length" => contentsize(content),
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

