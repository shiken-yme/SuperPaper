SMODS.Consumable {
    key = "thunderrage",
    set = "item",
    loc_txt = {
        name = "Thunder Rage",
        text = {
            "{C:attention}Halves{} the {C:attention}blind{}",
            "scoring requirement"
        }
    },
    unlocked = true,
    discovered = true,
    atlas = "SpmItems",
    pos = {x = 0, y = 0},
    cost = 3,
    can_use = function(self, card) return G.hand and G.GAME.blind.in_blind end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = (function()
                G.GAME.blind.chips = math.floor(
                                         G.GAME.blind.chips - G.GAME.blind.chips *
                                             0.5)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                SMODS.juice_up_blind()
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return true
            end)
        }))
        return true
    end
}
