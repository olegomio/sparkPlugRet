#!/bin/bash
# Author: Alexander Geiger

# functions

set_plugin_name() {

    echo "Enter name of plugin:"

    while [[ -z $pluginname || $pluginname == ' ' ]]; do

        echo $invalid_empty
        read pluginname

    done

    if [[ $pluginname == '-q' ]]; then
        exit 1
    fi

}

set_author_name() {
    local q1validation=false
    local q2validation=false

    while [[ $q1validation == false && (-z $oauthor || $oauthor == ' ') ]]; do

        echo "Are you the author?(y/n)"
        read oauthor

        if [[ "$oauthor" == "y" ]]; then 
            q1validation=true

            while [[ $q2validation == false ]]; do

                echo "do you want to use your git user.name?"
                read usegit

                if [[ "$usegit" == "y" ]]; then 

                    local gituser=$(git config user.name)

                    local username=${gituser/./ }

                    username=$(echo "$username" | sed -e 's/\b\(.\)/\u\1/g')

                    echo "The git user name is: $gituser, setting author name to $username"
                    q2validation=true

                elif [[ "$usegit" == "n" ]]; then

                    echo "please type in your name:"
                    read username

                    echo "setting author name to $username"
                    q2validation=true
                
                elif [[ "$usegit"  == '-q' ]]; then
                    exit 1
                else

                    echo $invalid_yes_no
                    continue
                
                fi
            done

        elif [[ "$oauthor" == "n" ]]; then

            echo "Enter author name:"
            read authorname

            echo "setting author name to $authorname"
            q1validation=true

        elif [[ "$oauthor" == '-q' ]]; then
            exit 1
        else

            echo $invalid_yes_no
            continue

        fi
    done
}

validate_inputs() {

    #echo "Plugin Name: $pluginname // Author Name: $authorname"

    # concatenate plugin name for dir name
    dirname=$(echo "retarus_$pluginname" | sed -e 's/ /_/g' -e 's/\(.\)/\L\1/g')

    echo "Setting directory name to $dirname"

}

create_dirs_and_files() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local parent_dir="$(dirname "$script_dir")"
    
    target_dir="$parent_dir/$dirname"
    js_dir="$target_dir/js"
    css_dir="$target_dir/css"

    mkdir -p "$target_dir" "$js_dir" "$css_dir"

    php_file="${target_dir}/${dirname}.php" 
    readme_file="${target_dir}/readme.txt"
    js_file="${js_dir}/${dirname}_script.js"
    css_file="${css_dir}/${dirname}_style.css"

    touch $php_file $readme_file $js_file $css_file
    echo '.'
}

write_file_content() {

    write_file_content_readme



}

write_file_content_readme() {
    local short_description
    local usage
    local functionality

    # functionality for adding short description
    echo "Add short description?"
    read short_description

    # functionality for adding Usage
    echo "Add usage information?"
    read usage

    # functionality for adding Functionality
    echo "Add functionality information?"
    read functionality

    printf "# Plugin Name\n\n${short_description}\n\n## Usage\n\n${usage}\n\n## Functionality\n\n${functionality}\n\n## Changelog\n\n### Version 1.0.0\n- Initial Release\n\n## Author\n\n${authorname}" >> $readme_file

}



# console outputs

invalid_yes_no="Invalid input. Please enter 'y', 'n' or '-q' to quit."
invalid_empty="Invalid input. Your prompt is empty. Please enter something or '-q' to quit."

# script sequence

set_plugin_name
set_author_name
validate_inputs
create_dirs_and_files
write_file_content


