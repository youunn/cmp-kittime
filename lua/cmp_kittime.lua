local table = require 'cmp_kittime.table'

local source = {}

source.new = function()
    local self = setmetatable({}, { __index = source })
    return self
end

source.is_available = function()
    return table.status
end

source.get_trigger_characters = function()
    local chars = 'zyxwvutsrqponmlkjihgfedcba' .. ',.<>?;:\'"\\~!^() 1234567890'
    return vim.fn.split(chars, [[\zs]])
end

source.get_keyword_pattern = function()
    return [=[[zyxwvutsrqponmlkjihgfedcba,\.\<\>\?\;\:\'\"\\\~\!\^\(\)1234567890]]=] ..
        [=[[zyxwvutsrqponmlkjihgfedcba,\.\<\>\?\;\:\'\"\\\~\!\^\(\) 1234567890]*]=]
end

source.complete = function(self, params, callback)
    local index = vim.regex(self.get_keyword_pattern() .. '$'):match_str(params.context.cursor_before_line)
    if index == nil then
        return callback()
    end

    local input = string.sub(params.context.cursor_before_line, index + 1)
    local items = table.process_seq(input)
    
    if #items == 0 then
        return callback()
    end

    callback(items)
end

-- function source.resolve(_, completion_item, callback)
--     callback(completion_item)
-- end
--
-- function source.execute(_, completion_item, callback)
--     callback(completion_item)
-- end

return source
