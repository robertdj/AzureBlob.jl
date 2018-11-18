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
Print `DateTime` in RFC 1123 format as requireddby the REST interface.

Check <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings> for info.
"""
http_date(dt::DateTime) = Dates.format(dt, Dates.RFC1123Format)


"""
Generate signature for Azure storage.
"""
function azure_signature(url, verb, storageaccount, storagekey,
                         container, datestamp, headers = "", CMD = "",
                         contentsize = "", 
                         contenttype = "application/json")
    time_arg = string("x-ms-date:", datestamp, "\nx-ms-version:2017-04-17")
    if length(headers) > 0
        time_arg = string(headers, "\n", time_arg)
    end

    location_arg = string("/", storageaccount, "/", container, CMD)

    signature = string(verb, "\n\n\n", contentsize, "\n\n", contenttype, 
                       "\n\n\n\n\n\n\n", time_arg, "\n", location_arg)

    @pipe Nettle.digest(
        "sha256", 
        Codecs.decode(Codecs.Base64, storagekey),
        signature
    ) |> 
        Codecs.encode(Codecs.Base64, _) |>
        String(_)
end

