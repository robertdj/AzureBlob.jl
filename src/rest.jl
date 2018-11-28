"""
    get_blob

Download file from blob storage using HTTP GET.
"""
function get_blob(blob, directory, container, storageaccount, storagekey, resourcegroup)
    #TODO: Check input
    # TODO: Function for bloburl
    blobdir = blob_to_url(directory, blob)
    bloburl = string("https://", storageaccount,
                     ".blob.core.windows.net/", container, "/", blobdir)

    timestamp = http_date(Dates.now())

    signature = azure_signature(
        url = bloburl,
        verb = "GET",
        storageaccount = storageaccount,
        storagekey = storagekey,
        container = container,
        timestamp = timestamp,
        CMD = string("/", blobdir)
    )

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => "0",
        "x-ms-version" => "2017-04-17", 
        "x-ms-date" => timestamp
    ]

    HTTP.request("GET", bloburl, header)
end

"""
    put_blob

Upload file to blob storage using HTTP PUT.
"""
function put_blob(content, blob, directory, container, storageaccount,
                  storagekey, resourcegroup, contenttype::String =
                  "application/json")
    blobdir = blob_to_url(directory, blob)
    bloburl = string("https://", storageaccount,
                     ".blob.core.windows.net/", container, "/", blobdir)

    timestamp = http_date(Dates.now())
    sz = @pipe contentsize(content) |> string

    signature = azure_signature(
        url = bloburl,
        verb = "PUT",
        storageaccount = storageaccount,
        storagekey = storagekey,
        container = container,
        headers = "x-ms-blob-type:Blockblob",
        contentsize = sz,
        contenttype = contenttype,
        timestamp = timestamp,
        CMD = string("/", blobdir)
    )

    token = string("SharedKey ", storageaccount, ":", signature)

    header = [
        "Authorization" => token, 
        "Content-Length" => sz,
        "x-ms-version" => "2017-04-17", 
        "x-ms-date" => timestamp,
        "x-ms-blob-type" => "Blockblob",
        "Content-type" => contenttype
    ]

    HTTP.request("PUT", bloburl, header, content)
end

function blob_to_url(directory, blob)
    string(directory, "/", blob)
end
