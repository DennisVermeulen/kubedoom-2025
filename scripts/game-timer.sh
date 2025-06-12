#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
curl -q -s localhost:32001/resettimer > /dev/null

kubectl config set-context --current --namespace=monster > /dev/null

# totale wachttijd in seconden
TOTAL=300
STEP=10

echo "Game On ...!"

# Countdown
for ((remain=TOTAL; remain>0; remain-=STEP)); do
    printf "\rNog %3d seconden...  " "$remain"   # overschrijft dezelfde regel
    sleep "$STEP"
done
echo -e "\rNog   0 seconden...  "                # sluit de teller netjes af
echo "Game Over....."


open ${SCRIPT_DIR}/gameover.png 

curl -q -s localhost:32001/done

SCORE=$(curl -q -s localhost:32001/score)
echo "Your score is : $SCORE"

sleep 10
echo "Reset, get ready for a new game"

git reset --hard HEAD
git clean -f -d

${SCRIPT_DIR}/reset.sh