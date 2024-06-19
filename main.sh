# Functions

RESET="\e[0m"
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[37m"
BLINK="\e[5m"
STOPBLINK="\e[25m"

errorlog() {
    echo -e "${RESET}[${RED}${BLINK}ERROR${STOPBLINK}${RESET}] $1" && sleep 0.2
}
warnlog() {
    echo -e "${RESET}[${YELLOW}WARN${RESET}] $1" && sleep 0.2
}
successlog() {
    echo -e "${RESET}[${GREEN}SUCCESS${RESET}] $1" && sleep 0.2
}
infolog() {
    echo -e "${RESET}[${CYAN}INFO${RESET}] $1" && sleep 0.2
}
sublog() {
    echo -e "\t${RESET}${MAGENTA}ㄷ ${WHITE}$1" && sleep 0.2
}

source config.conf

# Setup
if [[ -d ./setup ]]; then
    for i in setup/*; do
        source "$i"
    done
    rm -r setup/
fi
service nginx start
python3 server.py
