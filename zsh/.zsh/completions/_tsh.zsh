#compdef tsh

_() {
    local matches=($(${words[1]} --completion-bash "${(@)words[2,$CURRENT]}"))
    compadd -a matches

    if [[ $compstate[nmatches] -eq 0 && $words[$CURRENT] != -* ]]; then
        _files
    fi
}

if [[ "$(basename -- ${(%):-%x})" != "_" ]]; then
    compdef _
fi
#compdef tsh

_tsh() {
    local matches=($(${words[1]} --completion-bash "${(@)words[2,$CURRENT]}"))
    compadd -a matches

    if [[ $compstate[nmatches] -eq 0 && $words[$CURRENT] != -* ]]; then
        _files
    fi
}

if [[ "$(basename -- ${(%):-%x})" != "_tsh" ]]; then
    compdef _tsh tsh
fi
