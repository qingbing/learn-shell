#!/bin/bash
# This is a menu function

function menu ()
{
    title="My Menu"
    date=`date`
    website="www.phpcroner.net"
    # heredoc print
    cat <<EOF

###############################
        `echo -e "\033[32;40m${title}\033[0m"`
###############################
1). view a user information
2). add a user
3). set password for user
4). delete a user
5). print disk space
6). print memory space
7). main menu
8). quit
###############################
${website}
${date}
###############################

EOF
}
