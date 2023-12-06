{ config, pkgs, lib, ... }:

{
  neovim = {
    enable = true;
    withPython3 = true;
    vimAlias = true;

    coc = {
      enable = true;
      settings = {
        "diagnostic-languageserver.linters" = {
          "clj_kondo_lint" = {
            "command" = "clj-kondo";
            "debounce" = 100;
            "args" = [ "--lint" "%filepath" ];
            "offsetLine" = 0;
            "offsetColumn" = 0;
            "offsetColumnEnd" = 1;
            "sourceName" = "clj-kondo";
            "formatLines" = 1;
            "formatPattern" = [
              "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$"
              {
                "line" = 1;
                "column" = 2;
                "endColumn" = 2;
                "message" = 4;
                "security" = 3;
              }
            ];
            "securities" = {
              "error" = "error";
              "warning" = "warning";
              "note" = "info";
            };
          };
        };
        "diagnostic-languageserver.filetypes" = {
          "clojure" = "clj_kondo_lint";
        };
        "python.formatting.provider" = "black";
        "suggest.noselect" = true;
      };

      pluginConfig = ''
        " Use tab for trigger completion with characters ahead and navigate
        " NOTE: There's always complete item selected by default, you may want to enable
        " no select by `"suggest.noselect": true` in your configuration file
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        command! -nargs=0 Format :call CocActionAsync('format')
        nmap <silent> <leader>cc <Plug>(coc-diagnostic-next)
        nmap <silent> <leader>ff :Format<CR>
        vmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)
      '';
    };

    plugins = with pkgs.vimPlugins; [

      # CoC
      coc-pyright
      coc-diagnostic
      coc-prettier

      # Theme
      vim-colors-solarized
      {
        plugin = vim-solarized8;
        config = ''
          " Leader
          let mapleader=","
          let maplocalleader=","
          let g:mapleader=","

          function! AdaptColorscheme()
            hi! link SignColumn LineNr
            hi! MatchParen cterm=bold ctermbg=14 gui=bold guifg=#dc322f guibg=#eee8d5
          endfunction

          autocmd vimenter * ++nested colorscheme solarized8
          autocmd vimenter * :call AdaptColorscheme()
          '';
      }
      {
        plugin = lightline-vim;
        config = ''
          let g:lightline = {
                \ 'colorscheme': 'solarized',
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
        config = "let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd', 'grep', 'search']";
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
          function! s:init_projectionist()
              nmap <silent> <leader>gt :AV<CR>
              let g:projectionist_heuristics = {
                    \   'project.clj': {
                    \     'src/*.clj':
                    \       {'type': 'source', 'alternate': 'test/{}_test.clj', 'template': ['(ns {dot|hyphenate})']},
                    \     'src/*.cljc':
                    \       {'type': 'source', 'alternate': 'test/{}_test.cljc', 'template': ['(ns {dot|hyphenate})']},
                    \     'test/*_test.clj':
                    \       {'type': 'test', 'alternate': 'src/{}.clj', 'template': ['(ns {dot|hyphenate}-test)']},
                    \     'test/*_test.cljc':
                    \       {'type': 'test', 'alternate': 'src/{}.cljc', 'template': ['(ns {dot|hyphenate}-test)']},
                    \   }
                    \ }
          endfunction
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

          noremap <C-P>            :Files<CR>
          noremap <leader>b        :Buffers<CR>
          noremap <leader><leader> :Rg<CR>
        '';
      }

      # Clojure
      vim-sexp
      vim-sexp-mappings-for-regular-people

      # Others
      {
        plugin = vim-markdown;
        config = ''
          au FileType markdown :set textwidth=80
          let g:vim_markdown_folding_disabled = 1
        '';
      }
      {
        plugin = vim-yaml;
        config = "au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab";
      }
    ];

    extraConfig = lib.fileContents ./init.vim;
  };
}
