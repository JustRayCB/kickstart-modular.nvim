return {
  'Wansmer/treesj',
  keys = { '<space>m' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup { --[[ your config ]]
      use_default_keymaps = false,
      -- vim.cmd "nnoremap <silent> <space>m <cmd>lua require('treesj').toggle()<cr>",
      -- vim.cmd "nnoremap <silent> <space>j <cmd>lua require('treesj').split()<cr>",
      -- vim.cmd "nnoremap <silent> <space>k <cmd>lua require('treesj').join()<cr>",
      vim.keymap.set('n', '<space>m', require('treesj').toggle, { noremap = true, silent = true }),
      vim.keymap.set('n', '<space>j', require('treesj').split, { noremap = true, silent = true }),
      vim.keymap.set('n', '<space>k', require('treesj').join, { noremap = true, silent = true }),
    }
  end,
}
