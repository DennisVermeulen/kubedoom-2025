#!/bin/bash
ASSIGNMENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_DIR=${ASSIGNMENT_DIR}/../scripts/
TERMINAL_WIDTH=$(tput cols)
LOGO_WIDTH=$TERMINAL_WIDTH
if [[ $TERMINAL_WIDTH > 150 ]]; then LOGO_WIDTH=150; fi


white=$(tput setaf 15)
orange=$(tput setaf 208)
reset=$(tput sgr0)
underline=$(tput sgr 0 1)
bold=$(tput bold)

clear
echo
echo
docker run -v ${SCRIPT_DIR}/cinq-logo.png:/image/cinq-logo.png -ti localhost:6200/ascii-image-converter:cinq-kubecon-2025 --width=${LOGO_WIDTH} -c --color /image/cinq-logo.png
echo
echo

# Draw fancy horizontal line
echo -en ${white}
for run in $(seq ${TERMINAL_WIDTH}); do echo -n "---==#=="; done | cut -c -$LOGO_WIDTH; echo
echo -en ${reset}

# Pimp up the README.md text with some colors
sed_command_replace="
s/\*\*\(.*\)\*\*/${white}\1${reset}/;
s/##* \(.*\)/${bold}${white}\1${reset}/;
s/\`\(.*\)\`/${white}\1${reset}/;
"
while read line; do echo -e "  $line "; done < <(sed "s/^/  /; ${sed_command_replace}" README.md)
# <(sed "s/^/  /; s/\`kubectl edit\`/${white}kubectl edit${defaultl}/" README.md)
# <(cat -v README.md)
# 

# Draw fancy horizontal line
echo -en ${white}
for run in $(seq ${TERMINAL_WIDTH}); do echo -n "---==#=="; done | cut -c -$LOGO_WIDTH; echo
echo -en ${reset}

read -s -p "  You can read this assignment again in README.md. Press Enter key to start the assignment! "
echo

${SCRIPT_DIR}/game-timer.sh &