# Set up default docker environment
eval $(docker-machine env workhorse)

# Set path for docker-sync
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

function gitlab() {
  git clone ssh://git@gitlab.lan:30001/$1/$2.git
}

function wc-actorid() {
  wash claims inspect -o json $1 $2 | jq -r '.module'
}

function wc-providerkey() {
  wash par inspect -o json $1 $2 | jq -r '.public_key'
}

kickstart() {
  mkdir $1 && cd $1 && git init && npm init -y && code .
  echo "Node $(node -v)"
  echo "You're awesome 🤘"
}
