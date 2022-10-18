local M = {}
local table = require 'cmp_kittime.table'

function M.compare_weight(entry1, entry2)
    local item1 = entry1:get_completion_item()
    local item2 = entry2:get_completion_item()
    local weight1 = item1.word_weight == nil and 0 or item1.word_weight
    local weight2 = item2.word_weight == nil and 0 or item2.word_weight

    local diff = weight2 - weight1
    if diff < 0 then
        return true
    elseif diff > 0 then
        return false
    end
end

function M.toggle()
    table.status = not table.status
end

return M
