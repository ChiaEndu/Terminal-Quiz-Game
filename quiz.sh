#!/bin/bash

echo "welcome to quiz  game"

read -r -p " what is your name?:" player_name
name=$player_name

echo "Hello, $name welcome to Quiz Game. let us begin"
echo

QUESTION_FILE="questions.txt"
HIGHSCORE_FILE="highscore.txt"
# create highscore file if missing
touch "$HIGHSCORE_FILE"
# check if question file exists
if [[ ! -f "$QUESTION_FILE" ]]; then
    echo "Error: question file '$QUESTION_FILE' not found"
    exit 1
fi
# load questions into an array
while IFS= read -r line; do
    QUESTIONS+=("$line")
done < "$QUESTION_FILE"
# shuffle questions using shuf
SHUFFLED=($(shuf -i 0-$((${#QUESTIONS[@]} - 1))))
score=0
streak=0
TOTAL_QUESTIONS=${#QUESTIONS[@]}
ask_question() {
    local QUESTION="$1"
    local A="$2"
    local B="$3"
    local C="$4"
    local D="$5"
    local ANSWER="$6"
    echo "$QUESTION"
    echo "$A"
    echo "$B"
    echo "$C"
    echo "$D"
    read -r -p "Your answer (A/B/C/D): " USER_ANSWER
    USER_ANSWER=$(echo "$USER_ANSWER" | tr '[:lower:]' '[:upper:]')
    if [[ "$USER_ANSWER" == "$ANSWER" ]]; then
        echo "Correct!"
        score=$((score + 1))
        streak=$((streak + 1))
    else
        echo "Wrong!"
        streak=0
    fi
    sleep 1.5
}
# loop through shuffled questions
for idx in "${SHUFFLED[@]}"; do
    line="${QUESTIONS[$idx]}"
    Q=$(echo "$line" | cut -d '|' -f1)
    A=$(echo "$line" | cut -d '|' -f2)
    B=$(echo "$line" | cut -d '|' -f3)
    C=$(echo "$line" | cut -d '|' -f4)
    D=$(echo "$line" | cut -d '|' -f5)
    ANSWER=$(echo "$line" | cut -d '|' -f6 | tr -d ' [:space:]')
    ask_question "$Q" "$A" "$B" "$C" "$D" "$ANSWER"
done
echo ""
echo "$name you scored $score out of $TOTAL_QUESTIONS"


echo "$name score $score" >> highscore.txt

