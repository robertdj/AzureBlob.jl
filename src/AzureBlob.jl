module AzureBlob

using Nettle
using Codecs
using Dates
using Pipe
using HTTP

export 
    azure_signature,
    get_blob,
    http_date

include("rest.jl")
include("signature.jl")

end # module
