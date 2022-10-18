# cmp-kittime

`nvim-cmp` source for typing by table.

## Setup

``` lua
local compare = require 'cmp.config.compare'
local compare_weight = require('cmp_kittime.utils').compare_weight

require('cmp').setup {
    sources = {
        { name = 'kittime' },
    },
    sorting = {
        comparators = {
            compare.offset,
            compare.exact,
            compare_weight, -- add this line
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
}

vim.keymap.set('i', '<c-s>', require('cmp_kittime.utils').toggle)
```
