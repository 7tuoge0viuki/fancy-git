. ~/.fancy-git/aliases
. ~/.fancy-git/fancygit-completion

fg_branch_status() {
    . ~/.fancy-git/config

    local info
    info=""

    if [ "$git_has_unpushed_commits" != "" ]
    then
        info="${info}${light_green}+${git_number_unpushed_commits}c${none} "
    fi

    if [ "$git_number_untracked_files" -gt 0 ]
    then
        info="${info}${blue}+${git_number_untracked_files}f${none} "
    fi

    if [ "$git_number_changed_files" -gt 0 ]
    then
        info="${info}${light_yellow}${git_number_changed_files}m${none} "
    fi

    if [ "$info" != "" ]; then
        info=$(echo "$info" | sed -e 's/[[:space:]]*$//')
        echo "$info"
        return
    fi

    echo ""
}

fg_branch_name() {
    local branch_name
    local branch_status

    branch_name=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    branch_status=$(fg_branch_status)

    if [ "$branch_status" != "" ]; then
        branch_name="$branch_name | "
    fi

    if [ "$branch_name" != "" ]; then
        branch_name="($branch_name$branch_status)"
    fi

    if [ "$branch_name" != "" ]; then
        echo " $branch_name"
        return
    fi

    echo ""
}

fancygit_prompt_builder() {
    . ~/.fancy-git/config

    local user
    local at
    local host
    local where

    user="${light_green}\u${none}"
    at="${none}@${none}"
    host="${light_green}\h${none}"
    where="${blue}\w${none}"

    PS1="${bold}$user$at$host:$where\$$(fg_branch_name)${bold_none} "
}

PROMPT_COMMAND="fancygit_prompt_builder"
