"""
Return the content size of an object as needed in [`azure_signature`](@ref).

# Examples
```jldoctest
julia> contentsize("foo")
3
```
"""
contentsize(obj::String) = length(obj)

"""
Print `DateTime` in RFC 1123 format as required by the REST interface.

The RFC 1123 expects to have "GMT" (aka UTC) at the end of the string,
cf. <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings>.
However, the Dates package does not include the timezone by default.
"""
http_date(dt::DateTime) = @pipe Dates.format(dt, Dates.RFC1123Format) |> string(_, " GMT")


"""
Generate signature for Azure storage.
"""
function azure_signature(; url::String, verb::String,
                         storageaccount::String, storagekey,
                         container::String, timestamp::String,
                         headers::String = "", CMD::String = "",
                         contentsize::String = "", 
                         contenttype::String = "")
    time_arg = string("x-ms-date:", timestamp, "\nx-ms-version:", X_MS_VERSION)
    if length(headers) > 0
        time_arg = string(headers, "\n", time_arg)
    end

    location_arg = string("/", storageaccount, "/", container, CMD)

    signature = string(verb, "\n\n\n", contentsize, "\n\n", contenttype, 
                       "\n\n\n\n\n\n\n", time_arg, "\n", location_arg)

    # TODO: Check that storagekey is UTF8 encoded
    @pipe Nettle.digest(
        "sha256", 
        Codecs.decode(Codecs.Base64, storagekey),
        signature
    ) |> 
        Codecs.encode(Codecs.Base64, _) |>
        String(_)
end

