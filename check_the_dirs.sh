#!/bin/bash
# checkin if these directories are empty or not...

# the dirs are the directories in a file, this script doesn't create no file fo free. DO SOME WORK, BRO.
THETHING=`cat thedirs.txt`

#for loop to go through all the dirs
for i in $THETHING; do

# DUDE, did you know ls -A will show you just hidden files but ignore the . and .. directories?! 
DERP=`ls -A /nobackup/$i`

# if ls command comes up EMPTY HANDED! >:(
        if [ -z "$DERP" ]; then
                echo "$i is empty, man. Nothing to see here."
        else
                echo "$i: MONEY MONEY MONEY!"
        fi
done
