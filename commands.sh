#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   03.02.2016
#
# Commands manager.

. ~/.fancy-git/modules/config-manager.sh
. ~/.fancy-git/modules/update-manager.sh
. ~/.fancy-git/version.sh

fg_script_help() {
    sh ~/.fancy-git/help.sh | less
}

fg_show_version() {
    local current_year
    current_year=$(date +%Y)
    echo " Fancy Git v$FANCYGIT_VERSION - $current_year by Diogo Alexsander Cavilha <diogocavilha@gmail.com>."
    echo ""
}

fg_command_not_found() {
    echo ""
    echo " $1: Command not found."
    fg_script_help
}

fg_install_fonts() {
    mkdir -p ~/.fonts
    cp -i ~/.fancy-git/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf ~/.fonts
    cp -i ~/.fancy-git/fonts/Sauce-Code-Pro-Nerd-Font-Complete-Windows-Compatible.ttf ~/.fonts
    fc-cache -fv
}

fg_show_colors_config() {
    echo "
git config --global color.ui true

git config --global color.diff.meta \"yellow bold\"
git config --global color.diff.old \"red bold\"
git config --global color.diff.new \"green bold\"
git config --global color.status.added \"green bold\"
git config --global color.status.changed \"yellow\"
git config --global color.status.untracked \"cyan\"
"
}

fg_colors_config_set() {
    `git config --global color.ui true`
    `git config --global color.diff.meta "yellow bold"`
    `git config --global color.diff.old "red bold"`
    `git config --global color.diff.new "green bold"`
    `git config --global color.status.added "green bold"`
    `git config --global color.status.changed "yellow"`
    `git config --global color.status.untracked "cyan"`
}

fg_show_full_path() {
    if fancygit_config_is "show-full-path" "true"
    then
        return 0
    fi

    return 1
}

fg_show_time() {
    if fancygit_config_is "show-time" "true"
    then
        return 0
    fi

    return 1
}

fg_show_user_at_machine() {
    if fancygit_config_is "show-user-at-machine" "true"
    then
        return 0
    fi

    return 1
}

fg_is_only_local_branch() {
    local only_local_branch=$(git branch -r 2> /dev/null | grep "${branch_name}" | wc -l)

    if [ "$only_local_branch" == 0 ]; then
        return 0
    fi

    return 1
}

fg_get_branch_icon() {
    if fg_is_only_local_branch
    then
        echo "${is_only_local_branch}"
        return
    fi

    if [ "$merged_branch" != "" ]; then
        echo "${is_merged_branch}"
        return
    fi

    echo "${branch_icon}"
}

fg_branch_status() {
    . ~/.fancy-git/config.sh

    local info=""

    if [ "$git_stash" != "" ]
    then
        info="${info}∿${none} "
    fi

    if [ "$git_number_untracked_files" -gt 0 ]
    then
        info="${info}${cyan}?${none} "
    fi

    if [ "$git_number_changed_files" -gt 0 ]
    then
        info="${info}${light_green}+${none}${light_red}-${none} "
    fi

    if [ "$staged_files" != "" ]
    then
        info="${info}${light_green}✔${none} "
    fi

    if [ "$git_has_unpushed_commits" ]
    then
        info="${info}${light_green}^${git_number_unpushed_commits}${none} "
    fi

    if [ "$branch_name" != "" ] && fg_is_only_local_branch
    then
        info="${info}${light_green}*${none} "
    fi

    if [ "$merged_branch" != "" ]; then
        info="${info}${light_green}<${none} "
    fi

    if [ "$info" != "" ]; then
        info=$(echo "$info" | sed -e 's/[[:space:]]*$//')
        if [ "$1" == 1 ]; then
            echo " [$info]"
            return
        fi

        echo " $info"
        return
    fi

    echo ""
}

fg_return() {
    local fg_os
    fg_os=$(uname)

    if [ "$fg_os" = "Linux" ]; then
        return
    fi
}

fancygit_command_deprecation_warning() {
    local new_command

    new_command=${1}

    echo ""
    echo "> This command has been changed!"
    echo "> Plase type \"${new_command}\""
    echo ""
}

case "$1" in
    "-h"|"--help") fg_script_help;;
    "-v"|"--version") fg_show_version;;
    "--colors") fg_show_colors_config;;
    "--colors-set") fg_colors_config_set;;
    "--enable-full-path") fancygit_config_save "show-full-path" "true";;
    "--disable-full-path") fancygit_config_save "show-full-path" "false";;
    "--enable-show-user-at-machine") fancygit_config_save "show-user-at-machine" "true";;
    "--disable-show-user-at-machine") fancygit_config_save "show-user-at-machine" "false";;
    "--enable-show-time") fancygit_config_save "show-time" "true";;
    "--disable-show-time") fancygit_config_save "show-time" "false";;
    "--config-list") fancygit_config_show;;
    "--config-reset") fancygit_command_deprecation_warning "fancygit --reset";;
    "--reset") fancygit_config_reset;;
    "update") fancygit_update;;
    "simple") fancygit_config_save "style" "simple";;
    "default") fancygit_config_save "style" "default";;
    "double-line") fancygit_config_save "style" "fancy-double-line";;
    "simple-double-line") fancygit_config_save "style" "simple-double-line";;
    "human") fancygit_config_save "style" "human";;
    "human-single-line") fancygit_config_save "style" "human-single-line";;
    "human-dark") fancygit_config_save "style" "human-dark";;
    "human-dark-single-line") fancygit_config_save "style" "human-dark-single-line";;
    "dark") fancygit_config_save "style" "dark";;
    "dark-double-line") fancygit_config_save "style" "dark-double-line";;
    "dark-col-double-line") fancygit_config_save "style" "dark-col-double-line";;
    "light") fancygit_config_save "style" "light";;
    "light-double-line") fancygit_config_save "style" "light-double-line";;
    "configure-fonts") fg_install_fonts;;
    "--separator-default") fancygit_config_save "separator" "triangle";;
    "--separator-blocs") fancygit_config_save "separator" "blocs";;
    "--separator-blocs-tiny") fancygit_config_save "separator" "blocs-tiny";;
    "--separator-fire") fancygit_config_save "separator" "fire";;
    "--separator-lego") fancygit_config_save "separator" "lego";;
    "--separator-curve") fancygit_config_save "separator" "curve";;
    "--separator-paint") fancygit_config_save "separator" "paint";;
    "") fg_return;;
    *) fg_command_not_found "$1";;
esac
