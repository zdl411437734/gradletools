#!/bin/sh

echo +----------------------------------------------------------+
echo + 输入名称                                                  +   
echo +----------------------------------------------------------+
printf "Input your want execute Parameter:"  
read executeType
printf "you Input 名称 is " $executeType
printf "\n"

# cd /Users/jason/Desktop/
adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' >  $executeType.png