alias g='git'
alias rebdev='git pull origin develop --rebase=i'
alias rebmas='git pull origin master --rebase=i'
alias rebmai='git pull origin main --rebase=i'
alias pushnew='g push -u origin `git rev-parse --abbrev-ref HEAD`'

gbf() {
  git fetch origin && git checkout --no-track -b "$1" "origin/${2:-develop}"
}

alias v='nvim'

alias gw='./gradlew'

