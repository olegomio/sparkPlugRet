#!/bin/bash
# Author: Alexander Geiger

# functions

set_author_name() {
    local q1validation=false
    local q2validation=false
    local invalid="Invalid input. Please enter 'y' or 'n'."

    while [ $q1validation == false ]; do
    #while true; do
        echo "Are you the author?(y/n)"
        read oauthor

        if [ "$oauthor" == "y" ]; then 
            q1validation=true

            while [ $q2validation == false ]; do

                echo "do you want to use your git user.name?"
                read usegit

                if [ "$usegit" == "y" ]; then 
                    # fetch git user.name
                    gituser=$(git config user.name)

                    # remove dot
                    username=${gituser/./ }

                    # uppercase
                    username=$(echo "$username" | sed -e 's/\b\(.\)/\u\1/g')

                    echo "The git user name is: $gituser, setting author name to $username"
                    q2validation=true

                elif [ "$usegit" == "n" ];  then

                    echo "please type in your name:"
                    read username

                    echo "setting author name to $username"
                    q2validation=true
                else

                    echo $invalid
                    continue
                
                fi
            done

        elif [ "$oauthor" == "n" ]; then

            echo "Enter author name:"
            read authorname
            q1validation=true

        else

            echo $invalid
            continue

        fi
    done
}

#create_file_structure( $pluginname, $username ) {

#}


# prompt user for filename
echo "Enter name of plugin:"
read pluginname

set_author_name

# create new base file

# touch

