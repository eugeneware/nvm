#!/bin/bash

if [ `whoami` = 'root' ]; then
  NVM_DIR="/usr/local/nvm"
else
  NVM_DIR="$HOME/.nvm"
fi

if [ -d "$NVM_DIR" ]; then
  echo "=> NVM is already installed in $NVM_DIR, trying to update"
  echo -ne "\r=> "
  cd $NVM_DIR && git pull
  exit
fi

# Cloning to $NVM_DIR
git clone https://github.com/creationix/nvm.git $NVM_DIR

echo

# Detect profile file, .bash_profile has precedence over .profile
if [ `whoami` = 'root' ]; then
  PROFILE="/etc/bash.bashrc"
elif [ ! -z "$1" ]; then
  PROFILE="$1"
else
  if [ -f "$HOME/.bash_profile" ]; then
	PROFILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.profile" ]; then
	PROFILE="$HOME/.profile"
  fi
fi

# Set permissions for multi user environment
if [ `whoami` = 'root' ]; then
  mkdir -p $NVM_DIR/alias
  chmod -R u+rwX,g+rwX,o+rX $NVM_DIR
fi

SOURCE_STR="[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"  # This loads NVM"

if [ -z "$PROFILE" ] || [ ! -f "$PROFILE" ] ; then
  if [ -z $PROFILE ]; then
	echo "=> Profile not found"
  else
	echo "=> Profile $PROFILE not found"
  fi
  echo "=> Append the following line to the correct file yourself"
  echo
  echo "\t$SOURCE_STR"
  echo
  echo "=> Close and reopen your terminal to start using NVM"
  exit
fi

if ! grep -qc 'nvm.sh' $PROFILE; then
  echo "=> Appending source string to $PROFILE"
  echo "" >> "$PROFILE"
  echo $SOURCE_STR >> "$PROFILE"
else
  echo "=> Source string already in $PROFILE"
fi

echo "=> Close and reopen your terminal to start using NVM"
