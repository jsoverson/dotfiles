#!/bin/sh
# Delete the daily account and its home directory, then recreate it with the same UID.
# dot installs this as ~/reset-daily-user for the reset account, filling in the defaults below.
# Usage: ~/reset-daily-user [user] [uid]
set -e
user=${1:-__USER__}
uid=${2:-__UID__}

printf "delete %s (UID %s) and its home directory? [y/N] " "$user" "$uid"
read -r answer
[ "$answer" = y ] || exit 1

sudo sysadminctl -deleteUser "$user" -adminUser "$USER" -adminPassword -
sudo sysadminctl -addUser "$user" -UID "$uid" -admin -password - -adminUser "$USER" -adminPassword -
id "$user" >/dev/null # sysadminctl can exit 0 without creating the account
sudo createhomedir -c -u "$user"

# Without a token the account can't unlock FileVault after a restart.
if sysadminctl -secureTokenStatus "$user" 2>&1 | grep -q DISABLED; then
  sudo sysadminctl -secureTokenOn "$user" -password - -adminUser "$USER" -adminPassword -
fi

# The group exists only when Remote Login is limited to specific users.
if dscl . -read /Groups/com.apple.access_ssh >/dev/null 2>&1; then
  sudo dseditgroup -o edit -a "$user" -t user com.apple.access_ssh
fi

if [ -f "$HOME/.ssh/authorized_keys" ]; then
  sudo install -d -o "$user" -g staff -m 700 "/Users/$user/.ssh"
  sudo install -o "$user" -g staff -m 600 "$HOME/.ssh/authorized_keys" "/Users/$user/.ssh/authorized_keys"
fi

echo "done: log in as $user and run the bootstrap command from the dotfiles README"
