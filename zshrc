ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast brew rails last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

eval $(/opt/homebrew/bin/brew shellenv)
eval "$(nodenv init -)"

export PATH="/Users/guillaumewrobel/.rbenv/shims:${PATH}"
export TERMINFO=/usr/share/terminfo/

export GPG_TTY=$(tty)

# Navigation
alias dr='cd /Users/guillaumewrobel/code/yespark-rails'

# Update
alias maj='brew update && brew outdated && brew upgrade && brew cleanup && softwareupdate -l'

# Rails
alias rc='rails c'
alias rs='rails s'
alias gemupdate='gem_update --commit'

# Scalingo console
alias sc="scalingo --app yespark-prod run rails console"

# Git
alias fetch_rebase='git fetch --all && git pull --rebase && bundle install'
alias repush='git pull --rebase && git push'
lazygit() {
  git add .
  if [ "$1" != "" ] # or better, if [ -n "$1" ]
  then
      git commit -m "$1"
  else
      git commit -m update
  fi
  git pull --rebase && git push
}
alias rswag='SWAGGER_DRY_RUN=0 RAILS_ENV=test rails rswag PATTERN="spec/integration/**/*_spec.rb"'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Set ruby version for rbenv
# export RBENV_VERSION=3.2.0
export RUBY_YJIT_ENABLE=1

# https://github.com/rails/rails/issues/38560#issuecomment-1139570544
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
