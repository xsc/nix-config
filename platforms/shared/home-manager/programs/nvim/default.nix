{ config, pkgs, lib, theme, ... }:

let
  T = theme.vim;
  cocConfig = import ./coc.nix { inherit pkgs; };
in
{
  neovim = {
    enable = true;
    withPython3 = true;
    vimAlias = true;

    coc = {
      enable = true;
      inherit (cocConfig) settings pluginConfig;
    };

    plugins = with pkgs.vimPlugins;
      [

        # Theme
        {
          plugin = pkgs.vimPlugins.${T.colorscheme.pluginName};

          # We're setting the leader and the colorscheme here so it happens early
          # enough in the configuration file.
          config = ''
            " Leader
            let mapleader=","
            let maplocalleader=","
            let g:mapleader=","

            " Colorscheme
            function! AdaptColorscheme()
              hi! link SignColumn LineNr
            endfunction

            set background=${T.background}
            autocmd vimenter * ++nested colorscheme ${T.colorscheme.name}
            autocmd vimenter * :call AdaptColorscheme()
          '';
        }
        {
          plugin = lightline-vim;

          config = ''
            let g:lightline = {
                  \ 'colorscheme': '${T.lightline}',
                  \ 'active': {
                  \     'left': [ [ 'mode', 'paste' ],
                  \               [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings' ],
                  \               [ 'coc_status' ]]
                  \ },
                  \ }
          '';
        }
        {
          plugin = vim-lightline-coc;
          config = "call lightline#coc#register()";
        }
        rainbow-delimiters-nvim

        # Treesitter
        {
          plugin = nvim-treesitter;
          config = ''
            lua << EOF
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
            })
            EOF
          '';
        }
        nvim-treesitter-parsers.groovy
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.json
        nvim-treesitter-parsers.jsonc
        nvim-treesitter-parsers.kotlin
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.typescript
        {
          plugin = nvim-treesitter-parsers.yaml;
          config = "au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab";
        }

        # Format & Move
        {
          plugin = vim-easy-align;
          config = ''
            nmap ga <plug>(EasyAlign)
            xmap ga <plug>(EasyAlign)
          '';
        }
        {
          plugin = hop-nvim;
          config = ''
            lua require'hop'.setup()
            nmap <silent> s :HopChar2<CR>
          '';
        }
        {
          plugin = vim-trailing-whitespace;
          config =
            "let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd', 'grep', 'search']";
        }
        targets-vim
        vim-sleuth
        {
          plugin = vim-tmux-navigator;
          config = ''
            " Colemak hack
            nnoremap <C-I> :TmuxNavigateRight<CR>

            " To maintain vim-tmux-navigator functionality, C-I (which also maps to TAB)
            " is remapped to C-L in tmux.conf. This breaks TAB in insert mode, so we need
            " to fix it.
            inoremap <C-L> <TAB>
          '';
        }
        {
          plugin = vim-qf;
          config = ''
            nmap <leader>qq <Plug>(qf_qf_toggle)
            nmap <leader>qp <Plug>(qf_qf_previous)
            nmap <leader>qn <Plug>(qf_qf_next)
            nmap <PageUp> <Plug>(qf_qf_previous)
            nmap <PageDown> <Plug>(qf_qf_next)
          '';
        }

        # Git
        {
          plugin = vim-fugitive;
          config = ''
            nnoremap <leader>gb :Git blame<CR>
            nnoremap <leader>gc :Git commit<CR>
            nnoremap <leader>gd :Gvdiffsplit<CR>
            nnoremap <leader>gs :Git<CR>
          '';
        }
        {
          plugin = vim-gitgutter;
          config = ''
            nnoremap <leader>gg :GitGutterToggle<CR>
            nmap ]c <Plug>(GitGutterNextHunk)
            nmap [c <Plug>(GitGutterPrevHunk)
            highlight GitGutterAdd    ctermfg=2 ctermbg=7
            highlight GitGutterChange ctermfg=3 ctermbg=7
            highlight GitGutterDelete ctermfg=1 ctermbg=7

            " Plain
            let g:PlainBufferSet = 0
            function! PlainBuffer()
                if g:PlainBufferSet == 0
                    GitGutterDisable
                    set nonumber
                    let g:PlainBufferSet = 1
                else
                    GitGutterEnable
                    set number
                    let g:PlainBufferSet = 0
                endif
            endfu
            nmap <Leader>P :call PlainBuffer()<CR>
          '';
        }

        # Utils
        vim-repeat
        vim-eunuch
        vim-surround
        editorconfig-vim
        {
          plugin = vim-projectionist;
          config = ''
            let g:projectionist_heuristics = {
                  \   'project.clj': {
                  \     'src/*.clj':
                  \       {'type': 'source', 'alternate': 'test/{}_test.clj', 'template': ['(ns {dot|hyphenate})']},
                  \     'test/*_test.clj':
                  \       {'type': 'test', 'alternate': 'src/{}.clj', 'template': ['(ns {dot|hyphenate}-test)']},
                  \   },
                  \   'package.json': {
                  \     'src/*.ts':
                  \       {'type': 'source', 'alternate': 'test/{}.spec.ts'},
                  \     'test/*.spec.ts':
                  \       {'type': 'test', 'alternate': 'src/{}.ts'},
                  \   },
                  \ }

            nmap <leader>gt :A<CR>
          '';
        }
        {
          plugin = fzf-vim;
          config = ''
            let g:fzf_layout = { 'down': '~20%' }
            let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
              \ 'bg':      ['bg', 'Normal'],
              \ 'hl':      ['fg', 'Comment'],
              \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
              \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
              \ 'hl+':     ['fg', 'Statement'],
              \ 'info':    ['fg', 'PreProc'],
              \ 'border':  ['fg', 'Ignore'],
              \ 'prompt':  ['fg', 'Conditional'],
              \ 'pointer': ['fg', 'Exception'],
              \ 'marker':  ['fg', 'Keyword'],
              \ 'spinner': ['fg', 'Label'],
              \ 'header':  ['fg', 'Comment'] }

            if executable('rg')
              let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob "!.git"'
            endif

            if executable('bat')
              let $BAT_THEME = 'ansi'
            endif

            noremap <C-P>            :Files<CR>
            noremap <leader>b        :Buffers<CR>
            noremap <leader><leader> :Rg<CR>
          '';
        }

        # Clojure
        {
          plugin = vim-iced;
          config = ''
            let g:iced_enable_default_key_mappings = v:true
            let g:iced_enable_auto_indent = v:false
            aug VimIced
              au!
              au FileType clojure nmap <buffer> <leader>e! <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_list)
              au FileType clojure nmap <buffer> <leader>gt <Plug>(iced_cycle_src_and_test)
            aug end
          '';
        }
        vim-sexp
        vim-sexp-mappings-for-regular-people

        # JS/TS
        vim-jsx-pretty
      ] ++ cocConfig.plugins;

    extraConfig = lib.fileContents ./init.vim;
  };
}
