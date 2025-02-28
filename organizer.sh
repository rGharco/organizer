#!/bin/bash

echo  "----------------------------------------------------------------------"
echo  "  ______                                                           "
echo  " /\  __ \                                __                        "
echo  " \ \ \/\ \  _ __    __    _____    ____ /\_\  ____     ___   ____  "
echo  "  \ \ \ \ \/\  __\/_  \  / __  \  /  _  \/__\/\_   \ / __ \/\  __\ "
echo  "   \ \ \_\ \ \ \//\ \L\ \/\ \L\.\\  \/\ \ \ \/_/  /_/\  __/\ \ \/ " 
echo  "    \ \_____\ \_\\ \____ \ \__/.\_\  \_\ \_\ \_\/\____\ \____\\ \_\ "
echo  "     \/_____/\/_/ \/___L\ \/__/\/_/\/_/\/_/\/_/\/____/\/____/ \/_/ "
echo  "                   /\____/                                        "
echo  "                   \_/__/                                        "
echo  "----------------------------------------------------------------------" 


function show_help_page() {
	echo -e "\nUsage:  organizer [flag]

	Available Flags:

 	-h, --help			help for organizer
 
 	-e, --extension			sorts based on extension, without the . at the beginning
 					Example of usage: organizer -e pdf 
 				
	-t, --time			sorts based on the days since it has been created
 					Example of usage: organizer -t 2 \n"


}

function sort_by_extension() {
	if [[ $OPTARG  =~ [0-9] || $OPTARG =~ ^-.* ]]; then
		echo "Invalid value $OPTARG"
		show_help_page
		exit 1
	else 

		if ! [[ -d $OPTARG ]]; then	
			mkdir $OPTARG
		else
			matching_files=($(find . -type f -name '*.$OPTARG'-o -name '*\.$OPTARG'))
			for files in "${matching_files[@]}"; do
				echo "$files"
				mv "$files" $OPTARG
			done
			exit 0
		fi
	fi	
}

function sort_by_weeks() {
	if [[ $OPTARG =~ [a-z] || $OPTARG =~ [A-Z] || $OPTARG =~ ^-.* ]]; then
		echo "Invalid value $OPTARG"
		show_help_page
		exit 1
	else 
		matching_files=($(find . -type f -mtime +$OPTARG))
		for args in "${matching_files[@]}"; do
			echo "Deleting file: $args"
			rm $args
		done
		exit 0
	fi

}

function main () {
	
	if [[ $# -eq 0 ]]; then
		show_help_page
		exit 0
	fi


	while getopts ":he:t:" opt; do

		# Check for --help flag 
		for arg in "$@"; do
		if [[ "$arg" == "--help" ]]; then
			show_help_page
			exit 0
		fi
		done
	
		case $opt in

			h) 
			show_help_page
			exit 0
			;;

			e) 
			sort_by_extension
			;;

			t)
			sort_by_weeks
			;;

			:) 
			echo "Error: Flag -${OPTARG} requires a value!"
			show_help_page
			exit 1
			;;


			?)
			echo "Error: unknown flag -${OPTARG}"
			show_help_page
			exit 1
			;;

		esac
	done

	shift $((OPTIND - 1))

	if [[ $# -gt 0 ]]; then
        	echo "Error: unknown flag '$1'"
        	show_help_page
      		exit 1
    	fi
}	


main "$@"
