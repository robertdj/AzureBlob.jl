"""
    get_blob

Download file from blob storage using HTTP GET.
"""
function get_blob(blob, directory, container, storageaccount, storagekey, resourcegroup)
    #TODO: Check input
    blobdir = blob_to_url(directory, blob)
    bloburl = string("https://", storageaccount,
                     ".blob.core.windows.net/", container, "/", blobdir)

    datestamp = http_date(Dates.now())

    signature = azure_signature(
        url = bloburl,
        verb = "GET",
        storageaccount = storageaccount,
        storagekey = storagekey,
        container = container,
        timestamp = datestamp,
        CMD = string("/", blobdir)
    )

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => "0",
        "x-ms-version" => "2017-04-17", 
        "x-ms-date" => datestamp
    ]

    HTTP.request("GET", bloburl, header)
end

"""
    put_blob

Upload file to blob storage using HTTP PUT.
"""
function put_blob(blob, directory, container, storageaccount, storagekey, resourcegroup)
end

function blob_to_url(directory, blob)
    string(directory, "/", blob)
end
