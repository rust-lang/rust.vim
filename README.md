# rust.vim

## Description

This is a vim plugin that provides [Rust][r] file detection and syntax highlighting.

## Installation

### Using [Vundle][v]

1. Add `Plugin 'rust-lang/rust.vim'` to `~/.vimrc`
2. `vim +PluginInstall +qall`

*Note:* Vundle will not automatically detect Rust files properly if `filetype
on` is executed before Vundle. Please check the [quickstart][vqs] for more
details.

### Using [Pathogen][p]

```shell
git clone --depth=1 https://github.com/rust-lang/rust.vim.git ~/.vim/bundle/rust.vim
```

[r]: https://rust-lang.org
[v]: https://github.com/gmarik/vundle
[vqs]: https://github.com/gmarik/vundle#quick-start
[p]: https://github.com/tpope/vim-pathogen
[nb]: https://github.com/Shougo/neobundle.vim

### Using [NeoBundle][nb]

1. Add `NeoBundle 'rust-lang/rust.vim'` to `~/.vimrc`
2. Re-open vim or execute `:source ~/.vimrc`
