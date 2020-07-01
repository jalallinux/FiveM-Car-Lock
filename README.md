# FiveM-Car-Lock
Simple vehicle lock/unlock system for **FiveM** linux server. (The development of this script **continues**)

### Features

Pess **U**	or your Custom key to **Lock** or **Unlock** your vehicle.

---

## Download & Installation
### Using Git
```
cd resources
git clone https://github.com/jalallinux/FiveM-Car-Lock [jalallinux]/jl_carlock
```
- Add to your **server.cfg** file ``start jl_carlock``

### Manually
- Download https://github.com/jalallinux/FiveM-Car-Lock/archive/master.zip
- Put it in the `[jalallinux]` directory
- rename it to jl_carlock
- Add to your **server.cfg** file ``start jl_carlock``

---

## Config
In `resources` folder, edit `/[jalallinux]/jl_carlock/config.lua` with your settings :

```lua
Config = {}

Config.CarLock = { 
    ControlKey          = 303,      -- Which button for Open and Lock vehicle ? 303 = U
    NotCarFound         = "Your vehicle was not ~r~detected~w~",
    CarLocked           = "Your vehicle is ~r~Locked~s~",
    CarOpen             = "Your vehicle is ~g~Open~s~",
    LimiterIsOn         = "Limiter switched ~b~On",
    LimiterIsOff        = "Limiter switched ~b~Off",
    SearchAreaRadius    = 20.0,
    BlinkingLightsON    = true,     -- Flashing Headlights on Opening and Closing vehicle
    CarBleepOnOpen      = true,     -- Bleep at Open vehicle
    CarBleepOnClose     = true,     -- Bleep at Close vehicle
    CarBleepDistance    = 5.0,      -- Radius how far the sound is audible to other players
    CarBleepVolume      = 0.5,      -- Volume of the sound / MAX = 1.0 / MIN = 0.1
    SpeedLimiter        = false,     -- Option to turn a speedlimiter on or off
    SpeedLimiterKey     = 29,       -- Which button for the limiter? default: 29 = B
}

```
- You can get other `Keys Control` from https://docs.fivem.net/game-references/controls/ but it's optional for temporarily.

---

## Screenshots

![Lock Vehicle](https://cdn.discordapp.com/attachments/684367422165090432/727826777527025714/lock.PNG "Lock Vehicler") . ![Open Vehicle](https://cdn.discordapp.com/attachments/684367422165090432/727826779880030308/open.PNG "Open Vehicle")
