# Take in a weather forecast in stdin and replace the weather icons with nerd font icons

import sys
import json
import datetime

WWO_CODE = {
    "113": "Sunny",
    "116": "PartlyCloudy",
    "119": "Cloudy",
    "122": "VeryCloudy",
    "143": "Fog",
    "176": "LightShowers",
    "179": "LightSleetShowers",
    "182": "LightSleet",
    "185": "LightSleet",
    "200": "ThunderyShowers",
    "227": "LightSnow",
    "230": "HeavySnow",
    "248": "Fog",
    "260": "Fog",
    "263": "LightShowers",
    "266": "LightRain",
    "281": "LightSleet",
    "284": "LightSleet",
    "293": "LightRain",
    "296": "LightRain",
    "299": "HeavyShowers",
    "302": "HeavyRain",
    "305": "HeavyShowers",
    "308": "HeavyRain",
    "311": "LightSleet",
    "314": "LightSleet",
    "317": "LightSleet",
    "320": "LightSnow",
    "323": "LightSnowShowers",
    "326": "LightSnowShowers",
    "329": "HeavySnow",
    "332": "HeavySnow",
    "335": "HeavySnowShowers",
    "338": "HeavySnow",
    "350": "LightSleet",
    "353": "LightShowers",
    "356": "HeavyShowers",
    "359": "HeavyRain",
    "362": "LightSleetShowers",
    "365": "LightSleetShowers",
    "368": "LightSnowShowers",
    "371": "HeavySnowShowers",
    "374": "LightSleetShowers",
    "377": "LightSleet",
    "386": "ThunderyShowers",
    "389": "ThunderyHeavyRain",
    "392": "ThunderySnowShowers",
    "395": "HeavySnowShowers",
}

weather_icons = {
    "Unknown": "",
    "Cloudy": "󰖐",
    "Fog": "󰖑",
    "HeavyRain": "󰖖",
    "HeavyShowers": "󰖖",
    "HeavySnow": "󰼶",
    "HeavySnowShowers": "󰙿",
    "LightRain": "󰖗",
    "LightShowers": "󰖗",
    "LightSleet": "󰖒",
    "LightSleetShowers": "󰖒",
    "LightSnow": "󰖘",
    "LightSnowShowers": "󰖘",
    "PartlyCloudy": "󰖕",
    "Sunny": "󰖙",
    "ThunderyHeavyRain": "󰙾",
    "ThunderyShowers": "󰙾",
    "ThunderySnowShowers": "󰙾",
    "VeryCloudy": "󰖐󰖐",
}

night_map = {"󰖙": "󰖔", "󰖕": "󰼱"}


def is_night(astronomy):
    sunset = astronomy["sunset"]
    sunset_hour = int(sunset.split(":")[0])
    sunset_minute = int(sunset.split(":")[1][:2])
    sunset_ampm = sunset.split(":")[1][2:].strip()
    sunset_time = (
        sunset_hour * 60 + sunset_minute + (12 * 60 if sunset_ampm == "PM" else 0)
    )
    
    sunrise = astronomy["sunrise"]
    sunrise_hour = int(sunrise.split(":")[0])
    sunrise_minute = int(sunrise.split(":")[1][:2])
    sunrise_ampm = sunrise.split(":")[1][2:].strip()
    
    sunrise_time = (
        sunrise_hour * 60 + sunrise_minute + (12 * 60 if sunrise_ampm == "PM" else 0)
    )

    now = datetime.datetime.now()
    now_hour = now.hour
    now_minute = now.minute
    now_time = now_hour * 60 + now_minute
    
    return now_time < sunrise_time or now_time > sunset_time


def main():
    weather_raw = sys.stdin.read().strip()
    data = json.loads(weather_raw)

    weather = data["current_condition"][0]
    astronomy = data["weather"][0]["astronomy"][0]
    area = data["nearest_area"][0]

    condition = WWO_CODE[weather["weatherCode"]]

    icon = weather_icons[condition]

    night = is_night(astronomy)

    if night and icon in night_map:
        icon = night_map[icon]

    text = f"{icon} {weather['temp_F']} °F"
    tooltip = "\n".join(
        [
            condition,
            f"Temperature: {weather['temp_F']} °F",
            f"Feels like {weather['FeelsLikeF']} °F",
            f"High of {data['weather'][0]['maxtempF']} °F / Low of {data['weather'][0]['mintempF']} °F",
            f"{weather['humidity']}% Humidity",
            f"{weather['pressure']} in. Pressure",
            f"{weather['uvIndex']} UV Index",
            f"{weather['precipInches']} in. Precipitation",
            f"{weather['visibilityMiles']} mi. Visibility",
            f"{weather['windspeedMiles']} mph Wind Speed, Going {weather['winddir16Point']}",
            f"Sunrise: {astronomy['sunrise']}",
            f"Sunset: {astronomy['sunset']}",
            f"Moon is in {astronomy['moon_phase']}",
            f"Last Refreshed: {weather['observation_time']} UTC",
            f"Location: {area['areaName'][0]['value']}, {area['region'][0]['value']}, {area['country'][0]['value']}",
            f"Fetched from https://wttr.in",
        ]
    )

    out = {
        "text": text,
        "tooltip": tooltip,
        "class": [condition, "night" if night else "day"],
    }

    print(json.dumps(out, indent=None), end="")


if __name__ == "__main__":
    main()
