#!/bin/bash
# By Jesse Hunt
#
# eval is the variable for the directory the user submits 
# either via cli argument or when prompted 

eval=$1

# if user doesn't specify directory at cli arg then prompt for it here

if [ -z "$1" ]; then
  printf "\n\e[1;34mWhat directory would you like to evaluate? \e[0m\n"
  read eval
fi

printf  "\n\e[1;34mHere's the size of $eval and the directories below it (if there are any): \e[0m\n\n"

# I had to do this little conditional so that du could accept ~ as a dir.

if [ $eval = "~" ]; then
  du -h --max-depth=1 --exclude=.snapshot* $HOME | sort -rn
else
  du -h --max-depth=1 --exclude=.snapshot* $eval | sort -rn
fi

# print top ten largest directories:

printf "\n\e[1;34mHere's the largest files in $eval. (If more than 10, will list top 10):\e[0m\n\n"

# I had to do this little conditional so that ls could accept ~ as a dir.
# The end grep there should remove the current and parent dir from output

if [ $eval = "~" ]; then
  ls -Shlar $HOME | tail -10 | awk -F ' ' '{print $5, $9}' | grep -v '\.$'
else
  ls -Shlar $eval | tail -10 | awk -F ' ' '{print $5, $9}' | grep -v '\.$'
fi

printf "\n\e[1;34mFinally, here's the top 10 subdirectories, starting from $eval, with the most files:\e[0m\n\n"

# the below conditional turns the string ~ into $HOME dir and changes directories
# into the user's $eval otherwise find breaks...

if [ $eval = "~" ]; then
  cd $HOME
else
  cd $eval
fi

# this will hopefully tell user there is no subdirs unless there are,
# in which case it'll list the largest subdirs and how many files are in there.
ls -d */ &> /dev/null

if [ $? -ne 0 ]; then
  printf "Looks like you don't have any subdirectories under $eval at this time.\n\n"
else
  find . -type d ! -path "./.snapshots/*" 2> /dev/null | cut -d/ -f 2 | uniq -c | sort -rn | head | grep -v '\.$'
fi

## back into the directory that the user started as to not bother them

cd - > /dev/null 2>&1

# le fin.
