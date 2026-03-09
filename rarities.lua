SMODS.Rarity {
    key = "boss",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX('b10f0f'),
    loc_txt = {
        name = "Boss"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "impostor",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0.075,
    badge_colour = HEX('d0021b'),
    loc_txt = {
        name = "Impostor"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "crewmate",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0.1,
    badge_colour = HEX('00e5ff'),
    loc_txt = {
        name = "Crewmate"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}