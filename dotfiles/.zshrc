 # 少し凝った zshrc
 # License : MIT
 # http://mollifier.mit-license.org/

 ########################################
# 環境変数
export LANG=ja_JP.UTF-8

export PATH=/usr/local/sbin:$PATH # for Homebrew
export PATH=/usr/local/bin:$PATH  # for Homebrew

export PATH=$HOME/.nodebrew/current/bin:$PATH # for nodebrew

# for Homebrew php56
export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"

# for Homebrew vim
#export PATH=/usr/local/bin:/usr/bin

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
# bindkey -e

# ヒストリの設定
 HISTFILE=~/.zsh_history
 HISTSIZE=1000000
 SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
 PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
# %# "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# for zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)
# 補完機能を有効にする
autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

#同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# pecoの設定
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
#bindkey '^r' peco-select-history

# oh my zshの設定

# eval "$(rbenv init -)" centos7のvagrantで使用

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

#グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

function cdls() {
    \cd $1; 
    ls; 
}
alias cd='cdls'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
# Mac
alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
# Linux
alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
# Cygwin
alias -g C='| putclip'
fi

# Terminal Command
alias apaches='sudo apachectl start'
alias apachee='sudo apachectl stop'
alias apacher='sudo apachectl restart'
alias apache_log='tail -f /var/log/apache2/error.log'

alias mysqls='sudo mysql.server start'
alias mysqle='sudo mysql.server stop'
alias mysqlr='sudo mysql.server restart'

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gf="git fetch"
alias gm="git merge"
alias gb="git branch"
alias gch="git checkout"
alias gl="git log"

# Vagrant
alias vup="vagrant up"
alias vs="vagrant status"
alias vh="vagrant halt"
alias vssh="vagrant ssh"
#######################################

alias vimrc_update="cp ~/.vimrc ~/settings/.vimrc"
alias task="vim ~/Documents/Program_tips/schedule.md"

# OS 別の設定
case ${OSTYPE} in
darwin*)
#Mac用の設定
export CLICOLOR=1
alias ls='ls -G -F'
;;
linux*)
#Linux用の設定
alias ls='ls -F --color=auto'
;;
esac


# vim:set ft=zsh: "
