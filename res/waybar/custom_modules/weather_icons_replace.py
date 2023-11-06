# Take in a weather forecast in stdin and replace the weather icons with nerd font icons

import sys

weather_icons = {
    "?": "", # Unknown
    "mm": "󰖐", # Cloudy
    "=": "󰖑", # Fog
    "///": "󰖖", # HeavyRain
    "//": "󰖖", # HeavyShowers
    "**": "󰼶", # HeavySnow
    "*/*": "󰙿", # HeavySnowShowers
    "/": "󰖗", # LightRain
    ".": "󰖗", # LightShowers
    "x": "󰖒", # LightSleet
    "x/": "󰖒", # LightSleetShowers
    "*": "󰖘", # LightSnow
    "*/": "󰖘", # LightSnowShowers
    "m": "󰖕", # PartlyCloudy
    "o": "󰖙", # Sunny
    "/!/": "󰙾", # ThunderyHeavyRain
    "!/": "󰙾", # ThunderyShowers
    "*!*": "󰙾", # ThunderySnowShowers
    "mmm": "󰖐", # VeryCloudy
}
    
def main():
    weather = sys.stdin.read().strip()
    for key, value in weather_icons.items():
        weather = weather.replace(key, value)
    print(weather)
    
if __name__ == "__main__":
    main()
    