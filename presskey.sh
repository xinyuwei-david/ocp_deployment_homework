#!/bin/bash 
getchar() 
{ 
SAVEDTTY=`stty -g` 
stty cbreak 
dd if=/dev/tty bs=1 count=1 2> /dev/null 
stty -cbreak 
stty $SAVEDTTY 
} 
echo -n "Press any key to continue..." 
CH=`getchar` 
echo "" 
