module AzureBlob

using Nettle
using Codecs
using Dates
using Pipe

export 
    azure_signature,
    http_date

include("signature.jl")

end # module
