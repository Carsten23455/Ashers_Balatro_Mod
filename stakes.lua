SMODS.Stake {
    key = 'boss_stake1',
    name = "Boss Stake LV1",
    pos = {x = 0, y = 0},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 1, y = 0},
    order = 2,
    above_stake = 'stake_white',
    applied_stakes = {'stake_white'}, 
    prefix_config = {
        key = false,
        applied_stakes = {mod = false}, -- why the hell is this green on my VSC anyways this note fixed it for some reason :p
        above_stake = {mod = false}
    },

    modifiers = function()
        return {}
    end,

    loc_txt = {
        name = "Steam Stake",
        text = {
            "Boss Joker: ON, 1 Per 8 Ante",
            "Previous Stake Effects Applied"
        },
        sticker = {
            name = "Steam Winner",
            text = {
                "Won a run with this Joker",
                "on Steam Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake2',
    name = "Boss Stake LV2",
    pos = {x = 1, y = 0},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 3, y = 0},
    order = 4,
    colour = G.C.RED,
    above_stake = 'stake_red',
    modifiers = function()
    
    end,
    applied_stakes = {'stake_red'},
    prefix_config = { 
        key = false,
        applied_stakes = {mod = false},
        above_stake = {mod = false} 
    },
    loc_txt = {
        name = "Steamy Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Previous Stake Effects Apply"
        },
        sticker = {
            name = "Steamy Winner",
            text = {
                "Won a run with this Joker",
                "on Steamy Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake3',
    name = "Boss Stake LV3",
    pos = {x = 2, y = 0},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 0, y = 1},
    order = 6,
    colour = G.C.GREEN,
    above_stake = 'stake_green',
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    modifiers = function()
        return{}
    end,
    applied_stakes = {'stake_green'},
    loc_txt = {
        name = "Old Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Win Ante Increased",
            "Previous Stake Effects Applied"
        },
        sticker = {
            name = "Old Winner",
            text = {
                "Won a run with this Joker",
                "on Old Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake4',
    name = "Boss Stake LV4",
    pos = {x = 3, y = 0},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 1, y = 1},
    order = 8,
    colour = G.C.BLACK,
    above_stake = 'stake_black',
    modifiers = function()
        return{}
    end,
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    applied_stakes = {'stake_black'},
    loc_txt = {
        name = "Stinky Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Previous Stake Effects Applied"
        },
        sticker = {
            name = "Stinky Winner",
            text = {
                "Won a run with this Joker",
                "on Stinky Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake5',
    name = "Boss Stake LV5",
    pos = {x = 4, y = 0},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 3, y = 1},
    order = 10,
    colour = G.C.BLUE,
    above_stake = 'stake_blue',
    modifiers = function()
        return{}
    end,
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    applied_stakes = {'stake_blue'},
    loc_txt = {
        name = "Togopi Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Previous Stake Effects Applied"
        },
        sticker = {
            name = "Togopi Winner",
            text = {
                "Won a run with this Joker",
                "on Togopi Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake6',
    name = "Boss Stake LV6",
    pos = {x = 0, y = 1},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 0, y = 2},
    order = 12,
    colour = G.C.PURPLE,
    above_stake = 'stake_purple',
    modifiers = function()
        return{}
    end,
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    applied_stakes = {'stake_purple'},
    loc_txt = {
        name = "Stinkier Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Previous Stake Effects Applied",
            "Base {C:green}Reroll Cost{} Doubled"
        },
        sticker = {
            name = "Stinkier Winner",
            text = {
                "Won a run with this Joker",
                "on Stinkier Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake7',
    name = "Boss Stake LV7",
    pos = {x = 1, y = 1},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 3, y = 2},
    order = 14,
    colour = G.C.ORANGE,
    above_stake = 'stake_orange',
    modifiers = function()
        G.GAME.win_ante = 9;
    end,
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    applied_stakes = {'stake_orange'},
    loc_txt = {
        name = "Gilded Stake",
        text = {
            "Boss Joker: {C:red}ON{}",
            "Previous Stake Effects Applied",
            "Win Ante Increased"
        },
        sticker = {
            name = "Gilded Winner",
            text = {
                "Won a run with this Joker",
                "on Gilded Stake"
            }
        },
    }
}

SMODS.Stake {
    key = 'boss_stake8',
    name = "Boss Stake LV8",
    pos = {x = 2, y = 1},
    atlas = 'chips',
    sticker_atlas = 'Sticker',
    sticker_pos = {x = 0, y = 3},
    order = 16,
    colour = G.C.GOLD,
    shiny = false,
    above_stake = 'stake_gold',
    modifiers = function()
        G.GAME.win_ante = 9
        G.GAME.inflation = 5
        G.GAME.tarot_rate = 2
        G.GAME.planet_rate = 2
        G.GAME.bankrupt_at = -1
        G.GAME.interest_cap = 5
    end,
    prefix_config = {
        above_stake = {mod = false},
        key = false,
        applied_stakes = {mod = false}
    },
    applied_stakes = {'stake_gold'},
    loc_txt = {
        name = "STINKY",
        text = {
            "Boss Jokers: {C:red}ON{}",
            "The End Challenge Good Luck",
            "Previous Stake Effects Applied",
        }
        ,
        sticker = {
            name = "STINKY Winner",
            text = {
                "Won a run with this Joker",
                "on STINKY Stake"
            }
        },
    }
}

local calculate_reroll_cost_ref = calculate_reroll_cost
function calculate_reroll_cost(update)

    calculate_reroll_cost_ref(update)

    if G.GAME.stake >= 12 and G.GAME.stake < 16 then 
        G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + 5
    elseif G.GAME.stake >= 16 then
        G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + 15
    end
end
