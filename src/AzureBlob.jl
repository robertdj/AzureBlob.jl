module AzureBlob

import Base64
import Nettle
import Dates
import HTTP

using Pipe

export 
    storage_signature,
    get_blob,
    http_date,
    put_blob

const X_MS_VERSION = "2017-04-17"

# Dates.RFC1123Format with " GMT" in the end
const RFC1123_GMT = Dates.DateFormat("e, dd u yyyy HH:MM:SS G\\MT")

include("rest.jl")
include("signature.jl")

end # module
