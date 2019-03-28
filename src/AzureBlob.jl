module AzureBlob

import Base64
import Dates
import HTTP
import Nettle
import TimeZones

using Pipe


export 
    get_blob,
	http_date,
    put_blob,
	storage_signature


include("constants.jl")
include("rest.jl")
include("signature.jl")

end # module
