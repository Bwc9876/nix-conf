# Until wttrin fixes their GPS parser, this is can't work
# LOC=$(curl -s https://location.services.mozilla.com/v1/geolocate?key=geoclue | jq '.location | "\(.lat),\(.lng)"' --raw-output)

# echo $LOC

curl -s "https://wttr.in/?format=%25c%25t"
