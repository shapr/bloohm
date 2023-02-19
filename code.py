import time
import board
import busio
import adafruit_trellism4
import adafruit_adxl34x
import supervisor
import usb_cdc

# Set up Trellis and accelerometer
trellis = adafruit_trellism4.TrellisM4Express(rotation=0)
i2c = busio.I2C(board.ACCELEROMETER_SCL, board.ACCELEROMETER_SDA)
sensor = adafruit_adxl34x.ADXL345(i2c)
data_port = usb_cdc.data

# set data_port timeout, is this a good value to set?
data_port.timeout = 0

#define colors
black = (0,0,0)
red = (255,0,0)
green = (0,255,0)
yellow = (255,255,0)
off = (16,16,64)

# enable tap to clear
sensor.enable_tap_detection(threshold=50)
brightness = 1.0
trellis.pixels.fill((16,16,64))

# trellis.pixels.brightness(1) # full brightness on the LEDs, values go from 0 - 1, 0.3 is 30% brightness
pixlsh = [[x,y] for x in range(trellis.pixels.width)  for y in range(trellis.pixels.height) ]
pixlsw = [[x,y] for y in range(trellis.pixels.height) for x in range(trellis.pixels.width)  ]

def linear_to_pair(n):
    try:
        ival = int(n)
    except ValueError:
        return (0,0)
    x = ival % trellis.pixels.width
    y = ival // trellis.pixels.width
    return (x,y)

def countup(color,delay=0.01):
    #[setloc(x,y,color) for x in range(trellis.pixels.width) for y in range(trellis.pixels.height)]
    [setloc(xy[0],xy[1],color,delay) for xy in pixlsh]
    [setloc(xy[0],xy[1],color,delay) for xy in pixlsw]

def setloc(x,y,color,delay):
    trellis.pixels[x,y] = color
    time.sleep(delay)

def color(c):
    trellis.pixels.fill(c)

def color_from_input(color_command):
    text_data = color_command.decode("utf-8")
    data = text_data.strip()
    color = off
    # print(data)
    for l in data.split(","):
        if l[0] == "r":
            color = red
        elif l[0] == "g":
            color = green
        elif l[0] == "y":
            color = yellow
        trellis.pixels[linear_to_pair(l[1:])] = color

while True:
    pressed = trellis.pressed_keys
    if pressed:
        button_x_value = pressed[0][0] # first element of the list, first element of the x,y pair, should be 0-7
        brightness = (button_x_value + 3) / 10
        trellis.pixels.brightness = brightness
        print("set trellis brightness to",brightness)
        time.sleep(0.1)
    if data_port.in_waiting:
        # color_command = data_port.readline()
        # color_from_input(color_command)
        # combining the two lines above fixed the timing issue where some pixels were yellow and some were green!
        color_from_input(data_port.readline())
    # check tap, no colors when detected
    if sensor.events['tap']:
        countup((16,16,64))
        countup((5,5,5))
