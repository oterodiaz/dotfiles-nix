import glob
from pynvim import attach

# Attach to all neovim sockets
sockets = (attach('socket', path=p) for p in glob.glob('/tmp/nvim/nvim*.sock'))

for socket in sockets:
    socket.exec_lua('updateColorscheme()')
