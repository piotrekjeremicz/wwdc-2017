# WWDC17: Circut Project

> My **WWDC 2017 Scholarship** winning submission: an interactive electronic-circuit playground that tells a personal story.

Three short, narrated scenes pair a story about how I started programming with a working circuit you play with. Each beat of the story is a circuit idea:

| Scene | Story beat | Circuit |
| --- | --- | --- |
| 1 | "Turn the light on!": the moment a small idea sparked | 5 V source, switch, LED diode |
| 2 | "Change his flow": a new path for the dream | 12 V source, cross-switch, two resistors (100 Ω / 10 kΩ) |
| 3 | "Charge his brain!": energy that carries you forward | 48 V source, capacitor, charge/discharge through a resistor |

The narration is spoken with `AVSpeechSynthesizer`; flipping switches on the board advances the story and animates the current.

## Demo

[![WWDC17 Circut Project, demo on YouTube](https://img.youtube.com/vi/l7SP-pJIhcY/hqdefault.jpg)](https://www.youtube.com/watch?v=l7SP-pJIhcY)

▶ [Watch the demo on YouTube](https://www.youtube.com/watch?v=l7SP-pJIhcY)

## What's inside

Everything is a single Swift file built from scratch on UIKit and Core Animation, with no third-party code:

- `Board`: the drawing surface that evaluates and animates circuits
- `Element` subclasses: `Source`, `Wire`, `Resistor`, `Switcher`, `CrossSwitcher`, `Diode`, `Capacitor`
- `Circut`: a path of elements through which the "current" flows (the misspelling is how it was originally submitted)

## Run it

1. Open `WWDC’17 Circut Project.playground` in Xcode.
2. Show the **Live View** (Assistant Editor, `⌥⌘↩`) and run the playground.
3. Press **Start**, listen, and flip the switches.

Platform: iOS playground, written in 2017 (Swift 3/4 era). Recent Xcode versions may need small syntax fixes.
