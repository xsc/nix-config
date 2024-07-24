{ pkgs, ... }:

{
  plugins = with pkgs.vimPlugins; [
    # General
    {
      plugin = coc-diagnostic;
      config = ''
        nmap <silent> <leader>cc <Plug>(coc-diagnostic-next)
      '';
    }

    # JS/TS
    {
      plugin = coc-prettier;
      config = ''
        function! DisablePrettier()
          call coc#config('prettier.enabled', 0)
        endfu

        command! -nargs=0 Prettier :CocCommand prettier.formatFile
        command! -nargs=0 DisablePrettier :call DisablePrettier()
      '';
    }
    coc-tsserver
    {
      plugin = coc-eslint;
      config = ''
        au FileType javascript,typescript nmap <leader>lp :CocCommand eslint.lintProject<CR>
      '';
    }
    {
      plugin = coc-jest;
      config = ''
        command! -nargs=0 Jest           :call CocAction('runCommand', 'jest.projectTest')
        command! -nargs=0 JestCurrent    :call CocAction('runCommand', 'jest.fileTest', ['%'])
        command! -nargs=0 JestSingleTest :call CocAction('runCommand', 'jest.singleTest')
        command! JestInit :call CocAction('runCommand', 'jest.init')

        aug JestCoc
          au!
          au FileType javascript,typescript nmap <buffer> <leader>tp :Jest<CR>
          au FileType javascript,typescript nmap <buffer> <leader>tt :JestCurrent<CR>
        aug END
      '';
    }

    # Markdown
    coc-markdownlint

    # Python
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
        "command" = "${pkgs.nixd}/bin/nixd";
        "filetypes" = [ "nix" ];
      };
      "kotlin" = {
        "command" = "${pkgs.kotlin-language-server}/bin/kotlin-language-server";
        "filetypes" = [ "kotlin" ];
        "disabledFeatures" = [
          "documentFormatting"
          "documentRangeFormatting"
          "documentOnTypeFormatting"
        ];
        "settings" = {
          # This is an attempt to address 'Cannot inline bytecode built with JVM
          # target 17 into bytecode [...]' errors in Kotlin projects.
          "kotlin" = {
            "compiler" = {
              "jvm" = {
                "target" = "17";
              };
            };
          };
        };
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

    "diagnostic-languageserver.formatters" = {
      "ktlint" = {
        "command" = "${pkgs.ktlint}/bin/ktlint";
        "args" = [ "--format" "--stdin" "%filepath" ];
        "rootPatterns" = [
          "build.gradle.kts"
        ];
      };
    };
    "diagnostic-languageserver.formatFiletypes" = { "kotlin" = "ktlint"; };

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
    command! -nargs=0 OrganizeImports :call CocActionAsync('runCommand', 'editor.action.organizeImport')
    command! -nargs=0 Format :call CocActionAsync('format')
    command! -nargs=0 WriteNoFormat :noa w

    nmap <silent> <leader>ff :Format<CR>
    vmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>f <Plug>(coc-format-selected)
    nmap <silent> <leader>fo :OrganizeImports<CR>

    " quickfix
    nmap <leader>qfq  <Plug>(coc-codeaction-cursor)
    nmap <leader>qff  <Plug>(coc-fix-current)

    " definition
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

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
