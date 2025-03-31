local opt = vim.o
local fn = vim.fn
local api = vim.api
local backupdir = fn.stdpath('data') .. '/backup'
local colorcolumn_pos = '80'
vim.g.mapleader = ' ' -- Space

opt.termguicolors = true
opt.autochdir = true
opt.autoindent = true
opt.backupdir = backupdir
opt.backup = true
opt.backupext = '.bak'
opt.showbreak = '>'
opt.breakindentopt = 'sbr'
opt.breakindent = true
opt.clipboard = 'unnamedplus'
opt.confirm = true
opt.cursorline = true
opt.errorbells = true
opt.belloff = ''
opt.expandtab = true -- Use CTRL-V<Tab> in insert mode to insert a tab character
opt.tabstop = 4
opt.shiftwidth = 0 -- 0 means the tabstop value will be used
opt.formatoptions = opt.formatoptions .. 'o' -- Use Ctrl-U to delete inserted comment
opt.ignorecase = true
opt.smartcase = true
opt.tagcase = 'followscs'
opt.mouse = 'a'
opt.showmode = false
opt.number = true
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true

function toggleClipboard()
  if opt.clipboard == 'unnamedplus' then
    opt.clipboard = ''
    print('Disabled system clipboard')
  else
    opt.clipboard = 'unnamedplus'
    print('Enabled system clipboard')
  end
end

function toggleNumber()
  opt.number = not opt.number
end

function toggleLineWrapping()
  opt.wrap = not opt.wrap
end

function toggleRelativeNumber()
  opt.relativenumber = not opt.relativenumber
end

function toggleCursorColumn()
  opt.cursorcolumn = not opt.cursorcolumn
end

function toggleColorColumn(pos)
  default_pos = colorcolumn_pos or '80'
  if pos == nil and _colorColumnEnabled() then
    _disableColorColumn()
  elseif pos ~= nil then
    _updateColorColumn(pos)
  else -- pos == nil and not _colorColumnEnabled()
    _updateColorColumn(default_pos)
  end
end

function _colorColumnEnabled()
  if opt.colorcolumn == '' then
    return false
  else
    return true
  end
end

function _disableColorColumn()
  opt.colorcolumn = ''
  print('Disabled color column')
end

function _updateColorColumn(pos)
  pos = tostring(pos)
  if opt.colorcolumn == pos then
    _disableColorColumn()
  else
    opt.colorcolumn = pos
    print('Enabled color column at character ' .. pos)
  end
end

api.nvim_create_augroup('custom_startup', {})
api.nvim_create_augroup('custom', {})

api.nvim_create_autocmd('FileType', {
  desc = "Apply special indentation to lua files",
  group = 'custom',
  pattern = 'lua',
  command = 'setlocal tabstop=2 shiftwidth=0'
})

-- Keybindings
api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })
api.nvim_set_keymap('v', ';', ':', { noremap = true, silent = false })
api.nvim_set_keymap('n', '<Leader>wn', ':vnew<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wN', ':new<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wc', ':close<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>bk', ':q<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wxx', '<C-w>o', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wr', '<C-w>r', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wb', '<C-w>=', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wh', '<C-w>h', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wH', '<C-w>H', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wj', '<C-w>j', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wJ', '<C-w>J', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wk', '<C-w>k', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wK', '<C-w>K', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wl', '<C-w>l', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>wL', '<C-w>L', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>v', '<C-v>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<A-Left>', ':vertical resize +3<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<A-Right>', ':vertical resize -3<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<A-Up>', ':resize +3<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<A-Down>', ':resize -3<CR>', { noremap = true, silent = true })

api.nvim_set_keymap('n', '<Leader>sf', ':source %<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>,', ':ls<CR>:b<Space>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>.', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>/', ':nohlsearch<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>fp', ':e $MYVIMRC<CR>', { noremap = true, silent = true })

api.nvim_set_keymap('n', '<Leader>tc', '', { noremap = true, silent = true, callback = toggleColorColumn })
api.nvim_set_keymap('n', '<Leader>tC', '', { noremap = true, silent = true, callback = toggleCursorColumn })
api.nvim_set_keymap('n', '<Leader>tn', '', { noremap = true, silent = true, callback = toggleRelativeNumber })
api.nvim_set_keymap('n', '<Leader>tN', '', { noremap = true, silent = true, callback = toggleNumber })
api.nvim_set_keymap('n', '<Leader>ti', '', { noremap = true, silent = true, callback = toggleClipboard })
api.nvim_set_keymap('n', '<Leader>tw', '', { noremap = true, silent = true, callback = toggleLineWrapping })
api.nvim_set_keymap('n', '<Leader>hl', '/\t<CR>', { noremap = true, silent = true })
