# cmp-kittime

`nvim-cmp` source for typing by table.

![preview](https://user-images.githubusercontent.com/38760833/196694640-6bf553f9-3545-4689-9c5d-70892cee9fc1.png)

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

## Note

`nvim-cmp` calculate the offset and score in `cursor_line`, so if an entry appears on current line, it's ignored in completion menu.
