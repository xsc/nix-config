_: {
  programs.git = {
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

    diff-so-fancy = {enable = true;};

    aliases = {
      # commit
      amend = "commit --amend";
      amend-date = "-c core.editor=true commit --amend --date=now";
      cam = "commit -a -m";
      cf = "commit --fixup";
      cm = "commit -m";
      cp = "cherry-pick";
      cl = "clone";
      lgtm = "-c core.editor=true merge -S --no-ff";
      st = "status -sb";
      addrx = ''
        !f() { git diff -U0 | grepdiff -E $1 --output-matching=hunk | git apply --cached --unidiff-zero; }; f'';

      # merge
      merged-when = ''
        !f() { git rev-list -1 --format=%p "$1" | grep -v commit | xargs -I {} sh -c 'git rev-list -1 --format="%ci" {}' | grep -v commit; }; f'';
      merged-when-relative = ''
        !f() { git rev-list -1 --format=%p "$1" | grep -v commit | xargs -I {} sh -c 'git rev-list -1 --format="%cr" {}' | grep -v commit; }; f'';
      ours = "!f() { git co --ours $@ && git add $@; }; f";
      theirs = "!f() { git co --theirs $@ && git add $@; }; f";

      # pull/rebase
      autosquash = "-c core.editor=true rebase -i --autosquash";
      rbm = "!git rebase -i --autosquash origin/$(git main-branch)";
      sqm = "!git autosquash origin/$(git main-branch)";
      ffs = "!git upr && git push";
      rebase-date = "rebase --ignore-date";
      up = "pull --ff-only --all -p";
      upr = " pull --rebase --all -p";

      # push
      pu = "push -u";
      puf = "push -uf";

      # cleanup
      cleanup = "!git branch --merged | grep -v '^  master$' | grep -v '^  main$' | grep -v '^  develop$' | grep -v '^\\*' | xargs git branch -d";
      cleanup-remote = ''
        !f() {
                  local remote="$1";
                  local pattern="$2";
                  if [ -z "$remote" ]; then remote='origin'; fi;
                  if [ -z "$pattern" ]; then pattern='.'; fi;
                  pattern="^  $remote/$pattern";
                  echo "---> Removing remote branches matching: '$pattern'";
                  local branches=$(
                      git branch -r --merged|
                      grep "^  $remote/"|
                      grep -v "$remote/HEAD ->"|
                      grep -v "$remote/master\$"|
                      grep -v "$remote/main\$"|
                      grep -v "$remote/develop\$"|
                      grep -v "$remote/development\$"|
                      grep -e "$pattern"|
                      sed "s/^  $remote\///"
                  );
                  if [ -z "$branches" ]; then
                      echo "No branches.";
                      return 0;
                  fi;
                  for branch in $branches; do
                      echo "* [$(git merged-when-relative "$remote/$branch")] $branch";
                  done;
                  read -p "Are you sure? " -n 1 -r; echo;
                  if [[ $REPLY =~ ^[Yy]$ ]]; then
                      echo $branches | xargs git push "$remote" --no-verify --delete;
                  fi;
                }; f'';

      # logging
      lg1 = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(yellow)%h%C(reset) - %C(blue)(%ar)%C(reset) %s - %C(cyan)%an%C(reset)%C(red)%d%C(reset)' --all";
      lg = "!git lg1";
      sh = "show --format=fuller";

      # diff
      d = "diff";
      dc = "diff --cached";
      dlc = ''
        log --pretty=format:"%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn]" --decorate --numstat -n 1 -p --full-diff'';

      # others
      main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
      space = ''
        !f() {
          local value="$1";
          local email="";
          if [ -z "$value" ]; then
            email="yannick@xsc.dev";
          elif [[ "$value" == *@* ]]; then
            email="$value";
          elif [[ ! "$value" == *.* ]]; then
            email="yannick.scherer@$value.com";
          else
            email="yannick.scherer@$value";
          fi;
          git config user.email "$email";
          echo "set repository email to '$email'"
        }; f'';
    };

    lfs = {enable = true;};

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
}
