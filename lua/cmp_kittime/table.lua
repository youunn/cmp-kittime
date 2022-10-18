local M = {}

M.status = false

vim.cmd [[python << EOF
from kittime.table import Table
table = Table()
EOF]]

function M.process_seq(input)
    vim.cmd([[python <<EOF
table.process_new_seq("""]] .. string.gsub(input, '"', '\\"') .. [[""")
EOF]]
    )

    local buffer = vim.fn.pyeval 'table.pop_input()'
    local code = vim.fn.pyeval 'table.input'
    local candidates = vim.fn.pyeval 'table.candidates'

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
            label = string.gsub(buffer .. word, ' ', '_') .. ' ' .. code,
            insertText = buffer .. word,
            filterText = input .. tostring(i),
            word_weight = 100 - i,
        }
    end

    return items
end

return M
