SMODS.current_mod.optional_features = {retrigger_joker = true}

SMODS.Atlas {key = "SpmJokers", path = "SpmJokers.png", px = 71, py = 95}

SMODS.Atlas {key = "SpmItems", path = "SpmItems.png", px = 71, py = 95}

--[[

    CUSTOM INFRA

]]

-- Define Sage joker type
SMODS.Rarity {
    key = "sage",
    loc_txt = {name = "Sage"},
    badge_colour = HEX('bdba75'),
    pools = {["Joker"] = false},
    default_weight = 0
}

-- Define consumable type for Items
SMODS.ConsumableType {
    key = "item",
    primary_colour = HEX('ffc478'),
    secondary_colour = HEX('ba7e5b'),
    collection_rows = {1, 1},
    shop_rate = 0,
    loc_txt = {
        name = 'Item',
        collection = 'Items',
        undiscovered = {
            name = 'Undiscovered Item',
            text = {
                'Open more {C:attention}Howzit Packs{}',
                'to find more {C:attention}Items{}', 'and uncover their',
                'unique abilities'
            }
        }
    }
}

-- load components
local subdirs = {"jokers", "decks", "items", "seals"}
for y, subdir in ipairs(subdirs) do
    local folder = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
    for _, filename in pairs(folder) do
        assert(SMODS.load_file(subdir .. "/" .. filename))()
    end
end

-- handle behavior for Items

local ScoringHandPerishItems = {
    "tag_spm_fireburst", "tag_spm_icestorm", "tag_spm_shootingstar"
}

SMODS.current_mod.calculate = function(self, context)
    -- Calculate scoring-hand-type Item effects
    if context.individual and context.cardarea == G.play then
        local effects = {}
        for i, tag in pairs(G.GAME.tags) do
            if tag.key == "tag_spm_fireburst" then
                table.insert(effects, {
                    mult = 5,
                    message_card = context.other_card,
                    juice_card = tag
                })
            end
            if tag.key == "tag_spm_icestorm" then
                table.insert(effects, {
                    chips = 40,
                    message_card = context.other_card,
                    juice_card = tag
                })
            end
            if tag.key == "tag_spm_shootingstar" then
                table.insert(effects, {
                    xmult = 1.2,
                    message_card = context.other_card,
                    juice_card = tag
                })
            end
        end
        return SMODS.merge_effects(effects)
    end

    -- Summary of experiment: Tag positions do not change immediately after they are removed, which makes iterating through them simple
    --[[
    GetCurrentTagKeys = function(parent_iterator)
        for i = 1, #G.GAME.tags do
            ret = string.format("Call #%d: Tag ID #%d has key '%s'.", parent_iterator, i, G.GAME.tags[i].key)
            sendDebugMessage(ret, "KQLOVE")
        end
        return true
    end
    ]]

    -- Kill scoring-hand-type Items after hand played
    if context.after then
        for i = 1, #G.GAME.tags do
            for _, tag in ipairs(ScoringHandPerishItems) do
                if G.GAME.tags[i].key == tag then
                    --    GetCurrentTagKeys(i)
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.GAME.tags[i]:yep('!',
                                               G.GAME.tags[i].ability.kill_col,
                                               function()
                                return true
                            end)
                            G.GAME.tags[i].triggered = true
                            return true
                        end)
                    }))
                end
            end
        end
    end
end
