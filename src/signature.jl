"""
	storage_signature(blob, directory, container, storageaccount, storagekey, timestamp)

Signature for [`get_blob`](@ref).
All arguments are strings.
"""
function storage_signature(blob, directory, container, storageaccount, storagekey, timestamp)
	time_arg = signature_time(timestamp)

    location_arg = string("/", storageaccount, "/", container, "/", directory, "/", blob)

	signature = storage_signature("GET", "", "", time_arg, location_arg)

	encode_storagekey(storagekey, signature)
end


"""
	storage_signature(content, blob, directory, container, storageaccount, storagekey, timestamp, contenttype)

Signature for [`put_blob`](@ref).
All arguments are strings.
"""
function storage_signature(content, blob, directory, container, storageaccount, storagekey, timestamp, contenttype)
	# TODO: Check that contenttype is valid?
	time_arg = signature_time(timestamp, "x-ms-blob-type:Blockblob")

    location_arg = string("/", storageaccount, "/", container, "/", directory, "/", blob)

	signature = storage_signature("PUT", contentsize(content), contenttype, time_arg, location_arg)

	encode_storagekey(storagekey, signature)
end


function storage_signature(verb, contentsize, contenttype, time_arg, location_arg)
    string(verb, "\n\n\n", contentsize, "\n\n", contenttype, 
		   "\n\n\n\n\n\n\n", time_arg, "\n", location_arg)
end


# ------------------------------------------------------------------------------

"""
	encode_storagekey(storagekey, signature)

Encode the storage key using a signature string from [`storage_signature`](@ref).
"""
function encode_storagekey(storagekey, signature)
    # TODO: Check that storagekey is UTF8 encoded
	@pipe storagekey |>
		Base64.base64decode |>
		Nettle.digest("sha256", _, signature) |>
		Base64.base64encode
end


# ------------------------------------------------------------------------------

"""
signature_time(timestamp[, headers])

Include the time stamp information for the signature.
"""
function signature_time(timestamp::Dates.DateTime)
	@pipe timestamp |> 
		http_date |>
    	signature_time
end


function signature_time(timestamp::String)
  	string("x-ms-date:", timestamp, "\nx-ms-version:", X_MS_VERSION)
end


function signature_time(timestamp, headers)
	@pipe timestamp |>
		signature_time |>
		string(headers, "\n", _)
end


# ------------------------------------------------------------------------------

"""
Return the content size of an object as needed in [`storage_signature`](@ref).

# Examples
```jldoctest
julia> contentsize("foo")
3
```
"""
contentsize(obj::String) = length(obj)


# ------------------------------------------------------------------------------

"""
Print `DateTime` in RFC 1123 format as required by the REST interface.

The RFC 1123 expects to have "GMT" (aka UTC) at the end of the string,
cf. <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings>.
"""
http_date(dt::Dates.DateTime) = Dates.format(dt, RFC1123_GMT)

