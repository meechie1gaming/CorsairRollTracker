--#   ,-.       _,---._ __  / \
--#  /  )    .-'       `./ /   \
--# (  (   ,'            `/    /|
--#  \  `-"             \'\   / |
--#   `.              ,  \ \ /  |
--#    /`.          ,'-`----Y   |
--#   (            ;        |   '
--#   |  ,-.    ,-'         |  /
--#   |  | (   |   Meechie  | /
--#   )  |  \  `.___________|/
--================================================================================
-- crt LUA - v1.2 Date: 2026-10-24
--================================================================================

_addon.name = 'crt'
_addon.author = 'Meechie'
_addon.version = '1.2'
_addon.commands = {'crt'}

config = require('config')
texts = require('texts')
res = require('resources')

-------------------------------------------
-- Settings
-------------------------------------------
defaults = {
    roll1 = 'Samurai Roll',
    roll2 = 'Chaos Roll',
    qd = 'Fire',
    display = {
        pos = {x = 100, y = 300},
        text = {size = 10, font = 'Consolas'},
        bg = {alpha = 150},
        flags = {draggable = true},
    },
}

settings = config.load(defaults)

elements = {'Fire', 'Ice', 'Wind', 'Earth', 'Thunder', 'Water', 'Light', 'Dark'}

-------------------------------------------
-- HUD
-------------------------------------------
hud = texts.new('', settings.display)
hidden = false

function color(text, active)
    if active then
        return '\\cs(100,255,100)' .. text .. '\\cr'
    end
    return '\\cs(180,180,180)' .. text .. '\\cr'
end

function update_hud()
    local lines = {
        ' Corsair Roll Tool ',
        ' Roll 1: ' .. color(settings.roll1, roll_active(settings.roll1)),
        ' Roll 2: ' .. color(settings.roll2, roll_active(settings.roll2)),
        ' QD:     \\cs(255,200,100)' .. settings.qd .. ' Shot\\cr',
    }
    hud:text(table.concat(lines, '\n'))
    if not hidden then
        hud:show()
    end
end

-------------------------------------------
-- Lookups
-------------------------------------------
function find_roll(input)
    if input == '' then return nil end
    input = input:lower()
    for _, ja in pairs(res.job_abilities) do
        if ja.type == 'CorsairRoll' and ja.en:lower():sub(1, #input) == input then
            return ja.en
        end
    end
end

function find_element(input)
    if input == '' then return nil end
    input = input:lower()
    for _, el in ipairs(elements) do
        if el:lower():sub(1, #input) == input then
            return el
        end
    end
end

function cycle_element(step)
    for i, el in ipairs(elements) do
        if el == settings.qd then
            return elements[(i - 1 + step) % #elements + 1]
        end
    end
    return elements[1]
end

function roll_active(name)
    local player = windower.ffxi.get_player()
    local buff = res.buffs:with('en', name)
    if not player or not buff then return false end
    for _, id in ipairs(player.buffs) do
        if id == buff.id then return true end
    end
    return false
end

-------------------------------------------
-- Commands
-------------------------------------------
windower.register_event('addon command', function(cmd, ...)
    cmd = cmd and cmd:lower() or ''
    local arg = table.concat({...}, ' ')

    if cmd == 'roll1' or cmd == 'roll2' then
        local roll = find_roll(arg)
        if roll then
            settings[cmd] = roll
            config.save(settings)
            update_hud()
        else
            windower.add_to_chat(167, 'No roll found matching: ' .. arg)
        end

    elseif cmd == 'go' then
        if not roll_active(settings.roll1) then
            windower.send_command('input /ja "' .. settings.roll1 .. '" <me>')
        elseif not roll_active(settings.roll2) then
            windower.send_command('input /ja "' .. settings.roll2 .. '" <me>')
        else
            windower.add_to_chat(207, 'Both rolls active')
        end

    elseif cmd == 'qd' then
        local el
        if arg:lower() == 'next' then
            el = cycle_element(1)
        elseif arg:lower() == 'prev' then
            el = cycle_element(-1)
        else
            el = find_element(arg)
        end
        if el then
            settings.qd = el
            config.save(settings)
            update_hud()
        else
            windower.add_to_chat(167, 'No element found matching: ' .. arg)
        end

    elseif cmd == 'shot' then
        windower.send_command('input /ja "' .. settings.qd .. ' Shot" <t>')

    elseif cmd == 'show' then
        hidden = false
        update_hud()

    elseif cmd == 'hide' then
        hidden = true
        hud:hide()

    else
        windower.add_to_chat(207, 'Roll 1: ' .. settings.roll1 .. ' | Roll 2: ' .. settings.roll2 .. ' | QD: ' .. settings.qd)
    end
end)

-------------------------------------------
-- Events
-------------------------------------------
windower.register_event('load', 'login', 'gain buff', 'lose buff', update_hud)
