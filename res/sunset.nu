# Start wlroots sunset with location from Mozilla Location Services

echo "Retrieving location from Mozilla Location Services"

let LOC = (curl -s https://location.services.mozilla.com/v1/geolocate?key=geoclue | jq '.location | "[\(.lat*10|round/10),\(.lng*10|round/10)]"' --raw-output) | from json

let LAT = $LOC.0
let LON = $LOC.1

echo "Starting wlsunset"

wlsunset -l $LAT -L $LON
