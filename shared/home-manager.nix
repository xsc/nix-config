{ config, pkgs, lib, ... }:

let name = "Yannick Scherer";
    user = "yannick.scherer@futurice.com";
    email = "yannick@xsc.dev"; in
{

  # Alacritty
  alacritty = {
    enable = true;
    settings = {
      import = [ pkgs.alacritty-theme.solarized_light ];

      window = {
        opacity = 1.0;
        padding = {
          x = 4;
          y = 4;
        };
      };

      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 12)
        ];
      };

      title = "Terminal";
      dynamic_padding = true;
      decorations = "full";
      class = {
        instance = "Alacritty";
        general = "Alacritty";
      };

    };
  };

  # Shared shell configuration
  zsh.enable = true;
  zsh.autocd = false;
  zsh.cdpath = [ "~/.local/share/src" ];

  zsh.shellAliases = {
    ll = "ls -l --color=auto";
    ls = "ls --color=auto";
  };

  zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "history"
      "gpg-agent"
      "lein"
      "fasd"
      "docker-compose"
      "docker"
      "git-prompt"
      "z"
    ];
  };

  zsh.initExtra = ''
    # VI Mode
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey -M vicmd v edit-command-line

    # FZF
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # Prompt
    function collapse_pwd {
      echo $(pwd | sed -e "s,^$HOME,~,")
    }

    function prompt_char {
      echo '$';
    }

    # asciinema: Simple prompt
    if [ ! "$ASCIINEMA_REC" -eq "1" ]; then
      # istheinternetonfire
      if [ $[$RANDOM % 100] -lt 10 ]; then
          host -t txt istheinternetonfire.com | cut -f 2 -d '"' | cowsay -f moose
      fi

      PROMPT='yannick:%{$fg[yellow]%}$(collapse_pwd)%{$reset_color%}$(git_super_status) $(prompt_char) '
      RPROMPT=""
      ZSH_THEME_GIT_PROMPT_PREFIX=" on "
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_SEPARATOR=" ∆ "
      ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
      ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[yellow]%}%{●%G%}"
      ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
      ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[green]%}%{+%G%}"
      ZSH_THEME_GIT_PROMPT_BEHIND=" %{$fg[red]%}%{↓%G%}"
      ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg[blue]%}%{↑%G%}"
      ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[gray]%}%{⧖%G%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

      # tmux
      _not_inside_tmux() { [[ -z "$TMUX" ]] }

      ensure_tmux_is_running() {
        if _not_inside_tmux; then
          tmux attach 2> /dev/null || tmux new-session -s ft;
        fi
      }

      ensure_tmux_is_running
    else
      PROMPT='$(collapse_pwd) $(prompt_char) '
      RPROMPT=""
    fi
  '';

  zsh.initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    # Environment
    export PATH=$PATH:~/.bin
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    # Clear
    zsh_clear() { command clear; zle redisplay; }
    zle -N zsh_clear
    bindkey -M viins '^@' zsh_clear
  '';

  git = {
    enable = true;
    ignores = [
      "*.swp"
        "*~"
        "*.jar"
        "*.class"
        "~$*.xlsx"
        ".lein-deps-sum"
        ".lein-failures"
        ".lein-plugins"
        ".lein-repl-history"
        ".nrepl_port"
        ".DS_Store"
        "/.idea"
        "/tags"
        "/project/build.properties"
        "/tags.*"
      ];
    userName = name;
    userEmail = email;

    diff-so-fancy = {
      enable = true;
    };

    aliases = {
      # commit
      amend = "commit --amend";
      amend-date = "-c core.editor=true commit --amend --date=now";
      cam = "commit -a -m";
      cm = "commit -m";
      cp = "cherry-pick";
      cl = "clone";
      lgtm = "-c core.editor=true merge -S --no-ff";
      st = "status -sb";

      # merge

      merged-when = "!f() { git rev-list -1 --format=%p \"$1\" | grep -v commit | xargs -I {} sh -c 'git rev-list -1 --format=\"%ci\" {}' | grep -v commit; }; f";
      merged-when-relative = "!f() { git rev-list -1 --format=%p \"$1\" | grep -v commit | xargs -I {} sh -c 'git rev-list -1 --format=\"%cr\" {}' | grep -v commit; }; f";
      ours = "!f() { git co --ours $@ && git add $@; }; f";
      theirs = "!f() { git co --theirs $@ && git add $@; }; f";

      # pull/rebase
      autosquash = "-c core.editor=true rebase -i --autosquash";
      ffs = "!git upr && git push";
      rebase-date = "rebase --ignore-date";
      up = "pull --ff-only --all -p";
      upr = " pull --rebase --all -p";

      # push
      pu = "push -u";
      puf = "push -uf";

      # cleanup
      cleanup = "!git branch --merged | grep -v '^  master$' | grep -v '^  main$' | grep -v '^  develop$' | grep -v '^\\*' | xargs git branch -d";
      cleanup-remote =
        "!f() {
          local remote=\"$1\";
          local pattern=\"$2\";
          if [ -z \"$remote\" ]; then remote='origin'; fi;
          if [ -z \"$pattern\" ]; then pattern='.'; fi;
          pattern=\"^  $remote/$pattern\";
          echo \"---> Removing remote branches matching: '$pattern'\";
          local branches=$(
              git branch -r --merged|
              grep \"^  $remote/\"|
              grep -v \"$remote/HEAD ->\"|
              grep -v \"$remote/master\\$\"|
              grep -v \"$remote/main\\$\"|
              grep -v \"$remote/develop\\$\"|
              grep -v \"$remote/development\\$\"|
              grep -e \"$pattern\"|
              sed \"s/^  $remote\\///\"
          );
          if [ -z \"$branches\" ]; then
              echo \"No branches.\";
              return 0;
          fi;
          for branch in $branches; do
              echo \"* [$(git merged-when-relative \"$remote/$branch\")] $branch\";
          done;
          read -p \"Are you sure? \" -n 1 -r; echo;
          if [[ $REPLY =~ ^[Yy]$ ]]; then
              echo $branches | xargs git push \"$remote\" --no-verify --delete;
          fi;
        }; f";

      # logging
      lg1 = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(yellow)%h%C(reset) - %C(blue)(%ar)%C(reset) %s - %C(cyan)%an%C(reset)%C(red)%d%C(reset)' --all";
      lg = "!git lg1";
      sh = "show --format=fuller";

      # diff
      d = "diff";
      dc = "diff --cached";
      dlc = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat -n 1 -p --full-diff";

      # others
    };

    lfs = {
      enable = true;
    };

    signing = {
      key = "FCC8CDA4";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };
      apply.whitespace = "fix";
      push.default = "current";
    };
  };

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

    extraConfig = lib.fileContents ./config/nvim/init.vim;
  };

  ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          User git
          IdentitiesOnly yes
          IdentityFile /Users/${user}/.ssh/id_github
      ''
    ];
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'light'
          '';
      }
    ];
    terminal = "alacritty";
    clock24 = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 5;
    historyLimit = 50000;
    extraConfig = lib.fileContents ./config/tmux/tmux.conf;
  };

  gpg = {
    enable = true;
  };
}
