#!/bin/bash
# checkin if these directories are empty or not...

# the dirs are the directories in a file, this script doesn't create no file fo free. DO SOME WORK, BRO.
THETHING=`cat thedirs.txt`

#for loop to go through all the dirs
for i in $THETHING; do

# defining silly ls command
DERP=`ls /nobackup/$i`

# if silly ls command comes up EMPTY HANDED! >:(
        if [ -z "$DERP" ]; then
                echo "$i is empty, man. Nothing to see here."
        else
                echo "MONEY MONEY MONEY!: $i"
        fi
done
