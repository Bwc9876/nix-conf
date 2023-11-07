# Until wttrin fixes their GPS parser, this can't work
# LOC=$(curl -s https://location.services.mozilla.com/v1/geolocate?key=geoclue | jq '.location | "\(.lat),\(.lng)"' --raw-output)

# echo $LOC

curl -s "https://wttr.in/?format=j1&lang=us" | python $HOME/.config/waybar/custom_modules/weather_parser.py
