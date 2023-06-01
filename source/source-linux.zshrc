
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# remap left alt
xmodmap -e 'keycode 64 = Hyper_L'
