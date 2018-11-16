"""
Return the content size of an object as needed in `azure_signature`.

# Examples
```jldoctest
julia> contentsize("foo")
3
```
"""
contentsize(obj::String) = length(obj)

"""
Print `DateTime` in RFC 1123 format as requireddby the REST interface.

Check
<https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings>
for info.
"""
function http_date(dt::DateTime)
    Dates.format(dt, Dates.RFC1123Format)
end

