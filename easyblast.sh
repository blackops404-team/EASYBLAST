#!/bin/bash

# EasyBlast Installer and Launcher
# Developed by blackops404 team

detect_distro() {
    if [[ "$OSTYPE" == linux-android* ]]; then
        distro="termux"
    fi

    if [ -z "$distro" ]; then
        distro=$(ls /etc | awk 'match($0, "(.+?)[-_](?:release|version)", groups) {if(groups[1] != "os") {print groups[1]}}')
    fi

    if [ -z "$distro" ]; then
        if [ -f "/etc/os-release" ]; then
            distro="$(source /etc/os-release && echo $ID)"
        elif [ "$OSTYPE" == "darwin" ]; then
            distro="darwin"
        else
            distro="invalid"
        fi
    fi
}

pause() {
    read -n1 -r -p "Press any key to continue..." key
}

banner() {
    clear
    echo -e "\e[1;31m"
    if ! command -v figlet &> /dev/null; then
        echo 'Introducing blackops404 team'
    else
        figlet EasyBlast
    fi

    if ! command -v toilet &> /dev/null; then
        echo -e "\e[4;34m This Bomber Was Created By \e[1;32mblackops404 team \e[0m"
    else
        echo -e "\e[1;34mCreated By:"
        toilet -f mono12 -F border blackops404
    fi

    echo -e "\e[1;34m Official Telegram Support:\e[0m"
    echo -e "\e[1;32m           https://t.me/TBombChat \e[0m"
    echo -e "\e[4;32m   YouTube: https://www.youtube.com/c/CyberQuestInstitute \e[0m"
    echo
    echo "NOTE: You are using EasyBlast – a fork of TBomb."
    echo "Always use with proper authorization."
    echo
}

init_environ() {
    declare -A backends; backends=(
        ["arch"]="pacman -S --noconfirm"
        ["debian"]="apt-get -y install"
        ["ubuntu"]="apt -y install"
        ["termux"]="apt -y install"
        ["fedora"]="yum -y install"
        ["redhat"]="yum -y install"
        ["SuSE"]="zypper -n install"
        ["sles"]="zypper -n install"
        ["darwin"]="brew install"
        ["alpine"]="apk add"
    )

    INSTALL="${backends[$distro]}"

    if [ "$distro" == "termux" ]; then
        PYTHON="python"
        SUDO=""
    else
        PYTHON="python3"
        SUDO="sudo"
    fi
    PIP="$PYTHON -m pip"
}

install_deps() {
    packages=(openssl git $PYTHON $PYTHON-pip figlet toilet)

    if [ -n "$INSTALL" ]; then
        for package in "${packages[@]}"; do
            $SUDO $INSTALL $package
        done
        $PIP install -r requirements.txt
    else
        echo "Could not detect a supported distro or install dependencies."
        echo "Please ensure Python 3, pip, and required packages are installed manually."
        exit 1
    fi
}

# Main Script Logic
banner
pause
detect_distro
init_environ

if [ -f .update ]; then
    echo "✔ All requirements already installed."
else
    echo "🔧 Installing requirements..."
    install_deps
    echo "This script was initialized by blackops404 team" > .update
    echo "✔ Requirements installed successfully."
    pause
fi

while :
do
    banner
    echo -e "\e[4;31m Please read the instructions carefully \e[0m"
    echo
    echo "1. Start SMS Bomber"
    echo "2. Start CALL Bomber"
    echo "3. Start MAIL Bomber (Coming Soon)"
    echo "4. Update EasyBlast"
    echo "5. Exit"
    echo
    read -p "Enter your choice: " ch
    clear

    case $ch in
        1)
            $PYTHON easyblast.py --sms
            exit
            ;;
        2)
            $PYTHON easyblast.py --call
            exit
            ;;
        3)
            echo "📧 Email bombing feature is under development."
            pause
            ;;
        4)
            echo -e "\e[1;34m Updating EasyBlast..."
            rm -f .update
            $PYTHON easyblast.py --update
            echo -e "\e[1;34m Restart EasyBlast to continue."
            pause
            exit
            ;;
        5)
            banner
            exit
            ;;
        *)
            echo -e "\e[4;32m Invalid input! Please try again. \e[0m"
            pause
            ;;
    esac
done
