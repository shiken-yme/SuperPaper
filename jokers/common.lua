-- Flipside Tower
SMODS.Joker {
    key = "flipside_tower",
    loc_txt = {
        name = "Flipside Tower",
        text = {
            "Earn {C:money}$8{} at end of", "round after beating a",
            "{C:attention}Boss Blind{}"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "SpmJokers",
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {dollars = 8}, giveDollars = false},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and
            context.beat_boss and context.main_eval and not context.blueprint then
            card.ability.giveDollars = true
            return true
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.giveDollars == true then
            card.ability.giveDollars = false
            return card.ability.extra.dollars
        end
    end
}

-- Merlee
SMODS.Joker {
    key = "merlee",
    loc_txt = {
        name = "Merlee",
        text = {"Played cards give", "{C:mult}+4{} Mult when scored"}
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    cost = 5,
    pos = {x = 0, y = 0},
    atlas = "SpmJokers",
    config = {extra = {mult = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {mult = card.ability.extra.mult}
        end
    end
}

-- Merluvlee
SMODS.Joker {
    key = "merluvlee",
    loc_txt = {
        name = "Merluvlee",
        text = {"{C:chips}+10{} Chips for every", "card {C:attention}held in hand{}", "after hand is played"}
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    cost = 6,
    pos = {x = 0, y = 0},
    atlas = "SpmJokers",
    calculate = function(self, card, context)
        if context.joker_main then
            return {chips = ((#G.hand.cards or 0) * 10)}
        end
    end
}
