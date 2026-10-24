# crt (Corsair Roll Tool)

Windower 4 addon for FFXI Corsair. Shows your two rolls and your Quick Draw element in an on-screen box, lights up rolls that are active, and lets you fire a roll or a Quick Draw with one command.

**Author:** Meechie
**Version:** 1.2

## Install

1. Create `Windower/addons/crt/`
2. Put `crt.lua` in that folder
3. In game: `//lua load crt`

To load it every time, add `lua load crt` to `Windower/scripts/init.txt`.

## Commands

| Command | What it does |
| --- | --- |
| `//crt roll1 <name>` | Sets roll 1, for example `//crt roll1 samurai` |
| `//crt roll2 <name>` | Sets roll 2 |
| `//crt go` | Uses roll 1 if it isn't up, otherwise roll 2 if it isn't up. Posts "Both rolls active" if both are on |
| `//crt qd <element>` | Sets the Quick Draw element: fire, ice, wind, earth, thunder, water, light or dark |
| `//crt qd next` | Moves to the next element |
| `//crt qd prev` | Moves to the previous element |
| `//crt shot` | Uses Quick Draw with the set element on your target |
| `//crt show` | Shows the box |
| `//crt hide` | Hides the box until `//crt show` |
| `//crt` | Posts your current rolls and element to chat |

Roll and element names only need the start of the name. Type enough to be unique: `c` matches several rolls, `cha` only matches Chaos Roll.

## The Box

```
 Corsair Roll Tool
 Roll 1: Samurai Roll
 Roll 2: Chaos Roll
 QD:     Fire Shot
```

- Rolls show green when active and gray when not.
- It updates when you gain or lose a buff, load the addon or log in.
- Drag it to move it. The position is saved.

## Keybinds

Add binds to `Windower/scripts/init.txt` so rolls and Quick Draw are one key each:

```
bind ^1 crt go
bind ^2 crt shot
bind ^3 crt qd next
```

From an in-game macro, use `/console crt go`.

/console crt go
/console crt shot
/console crt qd next

## Settings

Saved to `Windower/addons/crt/data/settings.xml`. Changes made with commands are saved for the character you're on, so each character keeps its own rolls, element and box position.

Defaults for a new character: Samurai Roll, Chaos Roll and Fire.
