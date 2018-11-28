module AzureBlob

using Nettle
using Codecs
using Dates
using Pipe
using HTTP

export 
    azure_signature,
    get_blob,
    http_date,
    put_blob

const X_MS_VERSION = "2017-04-17"

include("rest.jl")
include("signature.jl")

end # module
