#!/bin/bash

#The following script only checks for directories requiring commit, but they have already been added.

# Add an empty line
echo "";

#Set a variable with the current directory.
curdir=$(pwd)

# For loop for all the subdirectories (first layer) of the current directory
for i in $(ls -d */|tr -d '/');
do
        # Go into the directory
        cd $i
        # Check if the folder has git
        gitstate=$((git status -s) 2> /dev/null)
        exitcode=$?
        if [ "$exitcode" -eq "0" ];
        then
                # Check if the state came back empty (in case there are no changes or new files)
                if [[ ! -z "$gitstate" ]];
                then
                        if [[ $gitstate = "A"* ]];
                                then
                                        # Provide the folder name
                                        echo -e ' \t '$i;
                        fi;
                fi;
        # Cd back to the primary directory
        fi;
        cd $curdir;
done;

# Add an empty line
echo "";
