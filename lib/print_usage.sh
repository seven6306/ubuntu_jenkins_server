#!/bin/bash
print_usage()
{
    [ ! -f README.md ] && printf "\033[0;31mERROR: file README.md is not found.\033[0m\n" && return 0
    line_on=$(($(grep -n "\`\`\`javascript" README.md | cut -d \: -f1)+1))
    line_down=$(($(grep -nE "^\`\`\`$" README.md | cut -d \: -f1)-1))
    for i in `seq $line_on $line_down`
    do  cat README.md | sed -n ${i}p
    done
}
