module AzureBlob

using Nettle
using Codecs
using Dates

export 
    azure_signature,
    http_date

include("signature.jl")

end # module
