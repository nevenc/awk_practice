#!/bin/bash

DONE="Verified - you are done"
NOT_DONE="No - you are not done"

SCENARIO_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd) 
TEST_DIR=${SCENARIO_DIR}/test

main() {
   for((x=1;x<=12;x++))
   do
       if [[ ${x} -lt 10 ]]
       then
           NUM=0${x}
       else
           NUM=${x}
       fi
       pushd ${TEST_DIR} &> /dev/null
       bash ${SCENARIO_DIR}/scenario_${NUM}.bash &> /dev/null
       test_that_verification_fails_for_scenario ${NUM}
       solution_for_scenario_${NUM}
       test_that_verification_passes_for_scenario ${NUM}
       rm ${TEST_DIR}/answer_${NUM}.awk &> /dev/null
       rm ${TEST_DIR}/{description,help}.txt
       popd &> /dev/null
   done
}

solution_for_scenario_01() {
    echo '{print $2}' > ${TEST_DIR}/answer_01.awk
}

solution_for_scenario_02() {
    echo '$6 == "m"' > ${TEST_DIR}/answer_02.awk
}

solution_for_scenario_03() {
    echo 'BEGIN {FS=","} ; $6 == "m"' > ${TEST_DIR}/answer_03.awk
}

solution_for_scenario_04() {
    echo 'BEGIN {RS=":";FS=","} ; $7 > 42' > ${TEST_DIR}/answer_04.awk
}

solution_for_scenario_05() {
    echo '($4/356) > 3 && ($7 > 40) && ($3 < 21500)' > ${TEST_DIR}/answer_05.awk
}

solution_for_scenario_06() {
    echo '$5 == 4 {printf "[%-10s][%-10s]\n",$2,$4}' > ${TEST_DIR}/answer_06.awk
}

solution_for_scenario_07() {
    echo 'NR > 1 && $3 > max { max = $3 }; END {print max}' > ${TEST_DIR}/answer_07.awk
}

solution_for_scenario_08() {
    echo 'BEGIN{FS=","};NR > 1 {($6 == "m")?++m:++f};END{print m, f}' > ${TEST_DIR}/answer_08.awk
}

solution_for_scenario_09() {
    cat > ${TEST_DIR}/answer_09.awk <<EOF
{ for(n=1;n<=NF;n++) arr[\$n]++ }
END { for (i=0;i<length(arr);i++) print i, arr[i] }
EOF
}

solution_for_scenario_10() {
    cat > ${TEST_DIR}/answer_10.awk <<EOF
{ print_box(\$1,\$2,\$3) }
function print_box(width,height,body) {
 for(h=0;h<height;h++) {
   str=""
   for(w=0;w<width;w++) 
     str=body str
   print str
 }
}
EOF
}

solution_for_scenario_11() {
    cat > ${TEST_DIR}/answer_11.awk <<EOF
BEGIN{RS=";"}
NR==1 {
    height=\$1
    width=\$2
    for(y=1;y<=height;y++)
        for(x=1;x<=width;x++)
            image[y,x]=" "
}
{ image[\$1,\$2]="@" }
END{
    for(y=1;y<=height;y++) {
        for(x=1;x<=width;x++)
            printf "%s", image[y,x]
        printf "\n"
    }

}
EOF
}

solution_for_scenario_12() {
   cat > ${TEST_DIR}/answer_12.awk <<EOF
BEGIN{FS=""}
{ for(x=1;x<=NF;x++) {
    width=NF
    height=NR
    if(\$x != " ")
    res=res ";" NR " " x
  }
}
END{print height,width res}
EOF
}

test_that_verification_fails_for_scenario() {
    if [[ $(bash ${SCENARIO_DIR}/scenario_${1}.bash --verify) == ${NOT_DONE} ]]
    then
        echo "T${1}_neg passed"
    else
        echo "T${1}_neg failed"
    fi
}

test_that_verification_passes_for_scenario() {
    if [[ $(bash ${SCENARIO_DIR}/scenario_${1}.bash --verify) == ${DONE} ]]
    then
        echo "T${1}_pos passed"
    else
        echo "T${1}_pos failed"
    fi
}

main
