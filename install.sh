#!/bin/bash

IS_ARCH=$IS_ARCH

if [ -f /etc/arch-release ]
then
  IS_ARCH=1
fi

get_user_information() {
  USER_INFORMATION=()
  my_array=()
  while IFS= read -r line; do
    USER_INFORMATION+=( "$line" )
  done < <(dialog --trim --no-tags --clear --insecure --mixedform "User information" 15 40 3 \ "Username" 1 1 "" 1 12 20 20 0 \ "Password" 2 1 "" 2 12 20 20 1 \ "Confirm" 3 1 "" 3 12 20 20 1 2>&1 >/dev/tty)

  USERNAME=${USER_INFORMATION[0]}
  PASSWORD=${USER_INFORMATION[1]}
  CONFIRM=${USER_INFORMATION[2]}

  if [ "$USERNAME" = "" ]
  then
    echo -e "\033[0m"
    clear
    echo Username cannot be blank!
    read -n1 -r -p "Press any key to continue..." key
    get_user_information
  fi

  if [ "$PASSWORD" != "$CONFIRM" ]
  then
    echo -e "\033[0m"
    clear
    echo Passwords do not match!
    read -n1 -r -p "Press any key to continue..." key
    get_user_information
  fi
}

if ! command -v dialog &> /dev/null
then
  if [ "$IS_ARCH" -eq "1" ]
  then
    sudo pacman --noconfirm -Sy dialog
  fi

  if [ -f /etc/debian_version ]
  then
    sudo apt-get install -y dialog
  fi

  if [ $(uname) == "Darwin" ]
  then
    # install brew first
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install dialog
  fi
fi

if [ $(uname) == "Linux" ]
then
  export GPU_DRIVER=$(
    dialog --no-tags --clear --title "GPU Driver" --menu "Please select a GPU driver:" 15 40 4 intel Intel amd AMD nvidia NVIDIA qxl QXL vmware VMWare none None 2>&1 >/dev/tty
  )
  clear

  export CUPS_INSTALL=$(
    dialog --no-tags --clear --title "CUPS" --menu "Do you want to install CUPS?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
  )
  clear

  export WINE_INSTALL=$(
    dialog --no-tags --clear --title "Wine" --menu "Do you want to install Wine?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
  )
  clear
  if [ "$IS_ARCH" -eq "1" ]
  then
    get_user_information
  fi
fi

#export GAMES_INSTALL=$(
#  dialog --no-tags --clear --title "Games" --menu "Do you want to install games?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
#  clear
#)

read -n1 -r -p "Press any key to continue..." key

clear
