local M = {}
local kittime = require 'cmp_kittime.state'

vim.cmd [[python << EOF
from kittime.table import Table
table = Table()
EOF]]

local function replace(text, length, back)
    local result = vim.api.nvim_win_get_cursor(0)
    local row, col = result[1], result[2]
    vim.api.nvim_buf_set_text(0,
        row - 1,
        col - length - back,
        row - 1,
        col,
        { text }
    )
    vim.api.nvim_win_set_cursor(0, { row, col - length + string.len(text) })
end

function M.process_seq(input, d)
    vim.cmd([[python <<EOF
table.process_new_seq("""]] .. string.gsub(input, '"', '\\"') .. [[""")
EOF]]
    )

    local buffer = vim.fn.pyeval 'table.pop_input()'

    local code = vim.fn.pyeval 'table.input'
    local candidates = vim.fn.pyeval 'table.candidates'

    if kittime.auto_expand and buffer ~= '' then
        replace(buffer .. code, string.len(input) - string.len(code), string.len(code))
        if code ~= '' then
            return M.process_seq(code, true)
        else
            return {}
        end
    end

    if #candidates == 0 then
        local item = {
            word = buffer,
            label = string.gsub(buffer, ' ', '_'),
            insertText = buffer,
            filterText = input,
            word_weight = 100,
        }
        return { item }
    end

    local items = {}
    for i, word in pairs(candidates) do
        items[#items + 1] = {
            word = buffer .. word,
            label = string.gsub(buffer .. word, ' ', '_') .. ' ' .. tostring(i),
            insertText = buffer .. word,
            filterText = input .. tostring(i),
            word_weight = 100 - i,
        }
    end

    return items
end

return M
