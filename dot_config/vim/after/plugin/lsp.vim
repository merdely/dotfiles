if !exists(':LspAddServer') | finish | endif

" Clangd language server
call LspAddServer([#{
	\    name: 'clangd',
	\    filetype: ['c', 'cpp'],
	\    path: '/usr/bin/clangd',
	\    args: ['--background-index']
	\  }])

" Javascript/Typescript language server
call LspAddServer([#{
	\    name: 'typescriptlang',
	\    filetype: ['javascript', 'typescript'],
	\    path: '/usr/bin/typescript-language-server',
	\    args: ['--stdio'],
	\  }])

" Go language server
call LspAddServer([#{
	\    name: 'golang',
	\    filetype: ['go', 'gomod'],
	\    path: '/usr/bin/gopls',
	\    args: ['serve'],
	\    syncInit: v:true
	\  }])

" Rust language server
call LspAddServer([#{
	\    name: 'rustlang',
	\    filetype: ['rust'],
	\    path: '/usr/bin/rust-analyzer',
	\    args: [],
	\    syncInit: v:true
	\  }])
