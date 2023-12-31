{ pkgs, ... }:

{
  plugins = with pkgs.vimPlugins; [
    {
      plugin = coc-pyright;
      config = ''
        " Ad-hoc Flake8 Linting
        let g:flake8_enabled = 0
        function! ToggleFlake8()
          let g:flake8_enabled = !g:flake8_enabled
          call coc#config('python.linting.flake8Enabled',g:flake8_enabled)
        endfu

        augroup PythonCoc
          au!
          au FileType python nmap <buffer> <leader>tt :CocCommand pyright.singleTest<CR>
          au FileType python nmap <buffer> <leader>tf :CocCommand pyright.fileTest<CR>
          au FileType python nmap <buffer> <leader>ll :call ToggleFlake8()<CR>
        augroup END
      '';
    }
    {
      plugin = coc-diagnostic;
      config = ''
        nmap <silent> <leader>cc <Plug>(coc-diagnostic-next)
      '';
    }
    {
      plugin = coc-prettier;
      config = ''
        command! -nargs=0 Prettier :CocCommand prettier.formatFile
      '';
    }
    coc-tsserver
    coc-eslint
    coc-markdownlint
  ];

  settings = {
    # General
    "coc.preferences.formatOnSaveFiletypes" = [
      "nix"
      "markdown"
      "json"
      "yaml"
      "javascript"
      "typescript"
    ];
    "suggest.noselect" = true;

    # Language Servers
    "languageserver" = {
      "nix" = {
        "command" = "nixd";
        "filetypes" = [ "nix" ];
      };
    };

    # Diagnostics
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
    "diagnostic-languageserver.filetypes" = { "clojure" = "clj_kondo_lint"; };

    # Markdown
    "markdownlint.config" = {
      # Line Lengths
      "MD013" = {
        "line_length" = 120;
        "heading_line_length" = 120;
        "code_blocks" = false;
      };
    };

    # Prettier
    "prettier.proseWrap" = "always";

    # Python
    "python.formatting.provider" = "black";
    "pyright.testing.provider" = "pytest";

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

    " format
    command! -nargs=0 Format :call CocActionAsync('format')
    nmap <silent> <leader>ff :Format<CR>
    vmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " documentation
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction
  '';
}
