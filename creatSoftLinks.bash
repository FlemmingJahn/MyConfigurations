#!/bin/bash
# Bash script for creating links to the misc. configurations for my Linux setup.




# Creates the link and takes a backup if the file already exist.
# IN: $1 - File to link to.
#     $2 - Subdirectory where the file is placed.
function createLn {
    fileName=$1
    subDir=$2
    softLinkFile=~/$fileName

    if [ -f $softLinkFile ];
    then
        echo "File $softLinkFile exists, creating a backup name $softLinkFile.bk."
        mv $softLinkFile $softLinkFile.bk
    fi

    dir=`pwd`
    echo     ln $dir/$subDir/$fileName $softLinkFile
    ln $dir/$subDir/$fileName $softLinkFile
}


createLn .emacs emacs
createLn .tmux.conf tmux
