#!/bin/bash

#source lib.sh
source obsf

# get script name
me="`basename "$0"`"

# define syntax help text
help_name=( "Lets go crazy with scripting""""" )
help_synopsis=(
    "#@NAME@# [OPTIONS]"
)
help_descr=(
	"This script is used for the linux retrain program session."
	"Optionally, we could specify the regex and file/input parameters for checks but without any parameters, general information will be displayed."
	""	
	"Note: regex implies that file/input parameters exist and file/input should not be both present"
	"      escape characters should be used in regex input whenever needed"
)
help_options=(
	"-r" "--regex"              "Regex to be checked against input string or file."
	"-i" "--input"              "Input text to be used for regex match"
	"-f" "--file"              "Input file to be used for regex match"
	"-t" "--tool"              "tool to be used. Allowed \"awk\", \"grep\" and \"sed\""
	"-h" "--help"              "Display this help and exit."
)
help_examples=(
	"#@NAME@# --file ~/tmp/example.txt --regex \"\\$\""
		"apply regex to specific example.txt file"

	"#@NAME@#"
		"display regex examples"
)
help_other=( "NOTE: This script should be used strictly for internal use." )

#########################
#                       #
#  Main script actions  #
#                       #
#########################

#parse options..
args=( "$@" )
while [ "$#" -gt 0 ]; do
	case "$1" in
		-h|--help)
			help $me;
			exit 0;
			;;
		-f=*|--file=*)
			file="${1#*=}";			
        	;;
		-f|--file)
			file="$2";
			shift;;
		-i=*|--input=*)
			input="${1#*=}";			
        	;;
		-i|--input)
			input="$2";
			shift;;
		-r=*|--regex=*)
			regex="${1#*=}";			
        	;;
		-r|--regex)
			regex="$2";
			shift;;
		-t=*|--tool=*)
			tool="${1#*=}";			
        	;;
		-t|--tool)
			tool="$2";
			shift;;
		--debug)
			debug=true;
			;;
		--awk)
			awk=true;
			;;
		*)
			error_syntax "$me" "Unknown option: $1";  
			exit 1;
			;;
	esac
	((argscount++));
	shift
done


if [[ $debug ]]; then
echo "*========================*"
echo "* check input parameters *"
echo "*========================*"
if [ $# -eq 0 ]; then
	echo "No input arguments supplied"
else
	echo "Input arguments supplied: $@"
fi
#short format
#((!$#)) && echo "No input arguments supplied"
#echo $@
echo "*===============================*"
echo "* Check parsed input parameters *"
echo "*===============================*"
echo "- regex: ${regex}"
echo "- input: ${input}"
echo "- file: ${file}"
echo "- tool: ${tool}"
echo "- debug mode: enabled"
fi

if [[ $file ]] && [[ $input ]]; then
	error_message "$me" "Error: Cannot have both file and input parameters present."
	exit 1;
fi

if ! [[ $file ]] && ! [[ $input ]]; then
	error_message "$me" "Error: Expected to have either file or input parameter present."
	exit 1;
fi

if ! [[ $regex ]]; then
	error_message "$me" "Error: Missing input regex mandatory parameter."
	exit 1;
fi

if [ ! -f ${file} ]; then
	error_message "$me" "Error: Input file does not exist."
	exit 1;
fi
#./ohmy.sh -f example -r //{print} -t awk
#./ohmy.sh -f example -r /e.a/{print} -t awk
#./ohmy.sh -f example -r /e*a/{print} -t awk
#./ohmy.sh -f example -r /[b5]/{print} -t awk
#./ohmy.sh -f example -r /[2-4]/{print} -t awk
#./ohmy.sh -f example -r /^1/{print} -t awk
#./ohmy.sh -f example -r /^5/{print} -t awk
#./ohmy.sh -f example -r /00$/{print} -t awk
#./ohmy.sh -f example -r "//{print \$2 \$3}" -t awk
doAwkWork(){
	if [[ $file ]]; then
		awk "${regex}" ${file}
	else
		echo "AWK with input string and regex not implemented."
		#echo "${input}" | awk '/'${regex}'/{print}'
	fi
}

doSedWork(){
	if [[ $file ]]; then
		echo "SED with input file and regex not implemented."
		#sed '/'\'${regex}'/' ${file}
	else
		echo "SED with input string and regex not implemented."
		#echo "${input}" | awk '/'${regex}'/{print}'
	fi
}

doGrepWork(){
	if [[ $file ]]; then
		echo "GREP with input file and regex not implemented."
		#awk '/'${regex}'/{print}' ${file}
	else
		echo "GREP with input string and regex not implemented."
		#echo "${input}" | awk '/'${regex}'/{print}'
	fi
}

case "${tool}" in
	"awk")
		doAwkWork
		;;
	"sed")
		doSedWork
		;;
	"grep")
		doGrepWork
		;;
	*)
		error_message "$me" "Error: Invalid tool option used \"${tool}\"."
		exit 1;
		;;
esac
