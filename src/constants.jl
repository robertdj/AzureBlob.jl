const X_MS_VERSION = "2017-04-17"

# Dates.RFC1123Format with " GMT" in the end
const RFC1123_GMT = Dates.DateFormat("e, dd u yyyy HH:MM:SS G\\MT")

const UTC = TimeZones.tz"UTC"

# In some virtualized environments it is not possible to get the local timezone
const LOCALZONE = try TimeZones.localzone() catch; UTC end
