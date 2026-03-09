SMODS.Sound{
    key="Disconnect",
    path="Disconnect.ogg",
    pitch=0.7,
    volume=3,
}

SMODS.Sound{
    key="eramlaugh",
    path="eramlaugh.ogg",
    pitch=0.7,
    volume=1,
}

SMODS.Sound{
    key="jevil_laugh",
    path="jevil_laugh.ogg",
    pitch=0.7,
    volume=3,
}

SMODS.Sound{
    key="music_fools_1",
    path="music_fools_1.ogg",
    pitch=0.7,
    volume=0.6,
}

SMODS.Sound{
    key="music_menu",
    path="music_menu.ogg",
    pitch=0.7,
    volume=0.6,
    replace = "music1"
}

local function ashersba_is_secret_boss_blind_active()
    local blind = G and G.GAME and G.GAME.blind
    if not blind then
        return false
    end
    local key = blind.key
        or (blind.config_blind and blind.config_blind.key)
        or (blind.config and blind.config.blind and blind.config.blind.key)
        or ''
    key = string.lower(tostring(key))
    return key:find('clopen', 1, true)
        or key:find('jevil', 1, true)
        or key:find('minty', 1, true)
end

SMODS.Sound{
    key="fools_music_selector",
    path="music_fools_1.ogg",
    pitch=0.7,
    volume=0.6,
    select_music_track = function(self)
        if ashersba_is_secret_boss_blind_active() then
            return 100
        end
    end
}
