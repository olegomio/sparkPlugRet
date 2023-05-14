#!/bin/bash
# Author: Alexander Geiger

# prompt user for filename
echo "Enter name of plugin:"
read pluginname

echo "Are you the author?(y/n)"
read originauthor

if [ "$originauthor" == "y" ]; then 

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

    elif [ "$usegit" == "n" ];  then

        echo "please type in your name:"
        read customname

    fi

elif [ "$originauthor" == "n" ]; then

    echo "Enter author name:"
    read authorname

else

    echo "Invalid input. Please enter 'y' or 'n'."

fi

# create new base file

# touch