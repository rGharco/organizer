#!/bin/bash

#PROGRAM INTRODUCTION AND OPTION CHOOSING

echo "------------------------------------------------------------------"

echo "   ____  _____   _____          _   _ _____ ____________ _____  "
echo "  / __ \|  __ \ / ____|   /\   | \ | |_   _|___  /  ____|  __ \ "
echo " | |  | | |__) | |  __   /  \  |  \| | | |    / /| |__  | |__) |"
echo " | |  | |  _  /| | |_ | / /\ \ | . \ | | |   / / |  __| |  _  / "
echo " | |__| | | \ \| |__| |/ ____ \| |\  |_| |_ / /__| |____| | \ \ "
echo "  \____/|_|  \_\\_____/_/    \_\_| \_|_____/_____|______|_|  \_\ "
echo "                                                                  "
echo "------------------------------------------------------------------"

echo "WELCOME! LET'S ORGANIZE SOME FILES, SELECT AN OPTION: "

display_menu () {
        echo -e "\n"
        echo "1.ORGANIZE FILES"
        echo "2.DELETE OLD FILES"
        echo "3.ADVANCED ORGANIZE"
        echo "4.EXIT"
        echo -e "\n"
        read -p "Enter your option: " option
}

display_menu

#ORGANIZE FILES FUNCTION

organize_files () {

                #getting the folder files && setting folder existance
                files=$(ls)

                folder_exist=1
                #verifying and choosing folder name
                while [[ $folder_exist == 1 ]]; do
                        read -p "What name should the sorted folder be: " folder_name

                        folder_exist=0
                        for file in $files
                        do
                                if [[ $file == $folder_name ]]; then
                                        folder_exist=1
                                        echo "That name is taken, please choose another one"
                                        break
                                else
                                        continue
                                fi
                        done

                        #verifying for folder name avaliability
                        if [[ $folder_exist == 0 ]]; then
                                mkdir "$folder_name"
                        fi
                done

                #choosing sorting keyword
                read -p "What is the keyword to sort by: " keyword

                #sorting the files
                for file in $files
                do
                if [[ -d $file ]]; then
                        continue
                else
                        if grep -q "$keyword" $file; then
                                $(mv $file $(pwd)/$folder_name)
                                echo "Files have been organized successfully!"
                        fi
                fi
                done
}

#DELETE OLD FILES

old_files () {
        cur_world_time=$(date +%s)
        read -p "Do you want to search for old files in a directory (y/n)?: " answer
        if [[ $answer == y ]]; then
                read -p "Enter dir/subdir name (x/y/z): " directory
                cd $(pwd)/$directory
                files=$(ls)
                read -p "Files over what number of weeks would you like to see?: " week_selection
                old_files=()
                for file in $files
                do
                cur_file_time=$(stat $file -c %Y)
                file_age=$((cur_world_time - cur_file_time))
                file_week_age=$((file_age / (7 * 24 * 3600)))
                if [[ $file_week_age -gt $week_selection ]]; then
                        old_files+=("$file")
                fi
                done
                echo "The files are: ${old_files[@]}"
                read -p "Would you like to delete all the old files (y/n)?: " delete_answer
                if [[ $delete_answer == y ]]; then
                        for file in "${old_files[@]}"
                        do
                                rm "$file"
                        done
                        echo "The files have been deleted succesfully"
                fi
        else
                read -p "Files over what number of weeks would you like to see?: " week_selection
                files=$(ls)
                old_files=()
                for file in $files
                do
                cur_file_time=$(stat $file -c %Y)
                file_age=$((cur_world_time - cur_file_time))
                file_week_age=$((file_age / (7 * 24 * 3600)))
                if [[ $file_week_age -gt $week_selection ]]; then
                        old_files+=("$file")
                fi
                done
                echo "The files are: ${old_files[@]}"
                read -p "Would you like to delete all the old files, this process is ireversible (y/n)?: " delete_answer
                if [[ $delete_answer == y ]]; then
                        for file in "${old_files[@]}"
                        do
                                rm "$file"
                        done
                        echo "The files have been deleted succesfully"
                fi
        fi
}

#ADVANCED ORGANIZE FUNCTION

advanced_organize () {
                #getting the folder files && setting folder existance
                files=$(ls)

                folder_exist=1
                #verifying and choosing folder name
                while [[ $folder_exist == 1 ]]; do
                        read -p "What name should the sorted folder be: " folder_name

                        folder_exist=0
                        for file in $files
                        do
                                if [[ $file == $folder_name ]]; then
                                        folder_exist=1
                                        echo "That name is taken, please choose another one"
                                        break
                                else
                                        continue
                                fi
                        done

                        #verifying for folder name avaliability
                        if [[ $folder_exist == 0 ]]; then
                                mkdir "$folder_name"
                        fi
                done

                #choosing extension filtering
                read -p "What is the file extension you want to filter (zip,rar,gz..)?: " extension

                for file in $files
                do
                        if [[ -d $file ]]; then
                                continue
                        else
                                find $(pwd) -name "*.$extension" -not -path "*/$folder_name/*" -exec mv {} "$folder_name/" \;
                        fi
                done
                echo "Files sorted successfully"
}

#OPTION SELECTION

case $option in
        1) read -p "Do you want to search in a folder (y/n)?: " answer
                if [[ $answer == y ]]; then
                        read -p "What is the folder you wanna look through (for subdirs specify x/y/z): " folder_name
                        cd $(pwd)/$folder_name
                        organize_files
                else
                        organize_files
                fi;;

        2) old_files ;;

        3) read -p "Do you want to search in a folder (y/n)?: " answer
                if [[ $answer == y ]]; then
                        read -p "What is the folder you wanna look through (for subdirs specify x/y/z): " folder_name
                        cd $(pwd)/$folder_name
                        advanced_organize
                else
                        advanced_organize
                fi;;
        4) exit ;;
        *) echo "That is not a valid option, please choose something else" ;;
esac
