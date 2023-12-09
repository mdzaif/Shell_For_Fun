#!/bin/bash


#######################################################################################################################################
#######################################################################################################################################
##                                                                                                                                   ##
## Written by Md. Zaif Imam Mahi                                                                                                     ##
## Last Modified: December 9, 2023                                                                                                   ##
## Description: You can only upload your project in github by this script. If you want use advance git then type: git --help         ##
##                                                                                                                                   ##
#######################################################################################################################################
#######################################################################################################################################

## Variable
msg=$(date +"%b %d, %Y")

touch /tmp/report.log

find .git &> /dev/null

if [ $? -ne 0 ]
    then
        git init . &> /dev/null
        printf "Init exit status: $(echo $?)\n" > /tmp/report.log
else
    printf "Init status: 0\n" > /tmp/report.log
fi

## Add remote git repository
grep 'url' .git/config &> /dev/null

if [ $? -ne 0 ]
then

    read -p "Do you want to add remote github repository [y/n]: " op

    case $op in

    [yY]* )
        read -p "Enter your github username: " user
        read -p "Enter your github repository name: " repo
        git remote add origin https://github.com/$user/$repo.git
        printf "Remote repository Exit status: $(echo $?)\n" >> /tmp/report.log
        ;;


    [nN]* )
        printf "Remote repository Exit status: $(echo $?)\n" >> /tmp/report.log
        ;;
    esac

else
    printf "Remote repository Exit status: $(echo $?)\n" >> /tmp/report.log
fi

## Git add and commit
git add .
read -p "Do you want commit message as default[y/n]: " res
    case $res in

    [yY]* )
        git commit -m "Last Update: $msg"
        printf "Commit exit status: $(echo $?)\n" >> /tmp/report.log
        ;;

    [nN]* )
        read -p "Enter your commit message: " msg
        git commit -m "$msg"

        printf "Commit exit status: $(echo $?)\n" >> /tmp/report.log
        ;;

        * )
        printf "Commit exit status: 1\n" >> /tmp/report.log
        ;;

    esac

## Git push
grep 'url' .git/config &> /dev/null

if [ $? -eq 0 ]
    then
        git branch -M main
        git push -u origin main
        printf "Git push exit status: $(echo $?)\n" >> /tmp/report.log
else
    printf "Git push exit status: 1\n" >> /tmp/report.log
fi

cat /tmp/report.log

rm /tmp/report.log
