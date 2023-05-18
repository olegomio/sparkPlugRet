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
                    authorname=$username
                    q2validation=true

                elif [[ "$usegit" == "n" ]]; then

                    echo "please type in your name:"
                    read username

                    echo "setting author name to $username"
                    authorname=$username
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
    print_dots 5 
}

print_dots() {
  local count=$1
  for ((i = 0; i < count; i++)); do
    echo -n "."
  done
}

remove_directory_and_files() {

    local q1validation=false
    local q2validation=false

    echo 'Remove plugin directory?(y/n)'

    while [[ $q1validation == false ]]; do
        read remove_directory
        if [[ $remove_directory == 'y' ]]; then
            rm -r $target_dir
            exit 1
            q1validation=true
        elif [[ $remove_directory == 'n' ]]; then
            exit 1
            q1validation=true
        else
            echo $invalid_yes_no
            continue
        fi

    done

}

write_file_content() {

    write_file_content_readme "$authorname"
    write_file_content_php "$authorname"
    write_file_content_js "$authorname"
    write_file_content_css "$authorname"
    print_dots 4
}

declare -g authorname=""

write_file_content_readme() {
    local authorname=$1
    local should_remove_directory=false

    # functionality for adding short description
    echo ''
    echo "Add short description?"
    read short_description

    if [[ $short_description == "-q" ]]; then
        should_remove_directory=true
    fi

    if [[ $should_remove_directory == false ]]; then
        # functionality for adding Usage
        echo "Add usage information?"
        read usage

        if [[ $usage == "-q" ]]; then
            should_remove_directory=true
        fi
    fi

    if [[ $should_remove_directory == false ]]; then
        # functionality for adding Functionality
        echo "Add functionality information?"
        read functionality

        if [[ $functionality == "-q" ]]; then
            should_remove_directory=true
        fi
    fi

    if [[ $should_remove_directory == true ]]; then
        remove_directory_and_files
        exit 1
    fi

    cat <<EOF >> "$readme_file"
# Plugin Name

${short_description}

## Usage

${usage}

## Functionality

${functionality}

## Changelog

### Version 1.0.0
- Initial Release

## Author

${authorname}
EOF

print_dots 5


}

write_file_content_php() {
    local authorname=$1
    current_date=$(date +%m/%y)
    
    cat <<EOT > $php_file
<?php

/**
 * Plugin Name: ${pluginname}
 * Description: ${short_description}
 * Version: 1.0.0
 * Author: ${authorname}
 * ${current_date}
 * @package ${pluginname}
 * 
 */

// add backend "View Details" Link for more Information about the Plugin - shows readme.txt

add_filter(
    'plugin_row_meta',
    function( \$plugin_meta, \$plugin_file, \$plugin_data ) {
        if ( __FILE__ === path_join( WP_PLUGIN_DIR, \$plugin_file ) ) {

            \$url = plugins_url( 'readme.txt', __FILE__ );

            \$plugin_meta[] = sprintf(
                '<a href="%s" class="thickbox open-plugin-details-modal" aria-label="%s" data-title="%s">%s</a>',
                add_query_arg( 'TB_iframe', 'true', \$url ),
                esc_attr( sprintf( __( 'More information about %s' ), \$plugin_data['Name'] ) ),
                esc_attr( \$plugin_data['Name'] ),
                __( 'View details' )
            );
        }
        return \$plugin_meta;
    },
    10,
    3
);


// Enqueue JavaScript File

function plugin_script() {
    wp_enqueue_script( 'plugin_script', plugin_dir_url( __FILE__ ) . 'js/${dirname}_script.js', array( 'jquery' ), '1.0.0', true );
}
add_action( 'wp_enqueue_scripts', 'plugin_script' );


// Enqueue CSS File

function plugin_style() {
    wp_enqueue_style( 'plugin_style', plugin_dir_url( __FILE__ ) . 'css/${dirname}_style.css' );
}
add_action( 'wp_enqueue_scripts', 'plugin_style' );



// Core Function

add_action( 'wp', 'plugin_function');
function plugin_function() {

    // your code

}
EOT

print_dots 5

}

write_file_content_js() {

    local authorname=$1
    current_date=$(date +%m/%y)
    
    cat <<EOT > $js_file
/**
 * Plugin Name: ${pluginname}
 * Description: ${short_description}
 * Version: 1.0.0
 * Author: ${authorname}
 * ${current_date}
 * @package ${pluginname}
 * 
 */



EOT

print_dots 5

}

write_file_content_css() {

    local authorname=$1
    current_date=$(date +%m/%y)
    
    cat <<EOT > $css_file
/**
 * Plugin Name: ${pluginname}
 * Description: ${short_description}
 * Version: 1.0.0
 * Author: ${authorname}
 * ${current_date}
 * @package ${pluginname}
 * 
 */



EOT

print_dots 5

}

# console outputs

invalid_yes_no="Invalid input. Please enter 'y', 'n' or '-q' to quit."
invalid_empty="Invalid input. Your prompt is empty. Please enter something or '-q' to quit."

# script sequence

set_plugin_name
set_author_name
validate_inputs
create_dirs_and_files
write_file_content "$authorname"


