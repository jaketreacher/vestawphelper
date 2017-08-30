#!/bin/bash

if [ -z "$2" ]; then
    echo "Requires two arguments"
    echo "$0 [Infile.sh] [Outfile]"
    exit 1
fi

Infile=$1
Outfile=$2
Sbin="/usr/local/sbin/"

# Check if sudo/root - needed to access folders
if [ "root" != $(whoami) ]; then
    echo "This script must be run with sudo"
    exit 1
fi

echo "==========================="
echo "Working on ${Outfile}"
echo "==========================="

if [ "${1}" == "--remove" ]; then
    if [ -e ${Sbin}${Outfile} ]; then
        rm -rf ${Sbin}${Outfile}
        echo "Removed"
    else
        echo "Not installed"
    fi
    echo
    exit 0
fi

if [ ! -e ${Infile} ]; then
    echo "ERROR: ${Infile} not found."
    exit 1
fi

Prepend=${Infile%/*}
if [ "${Prepend}" == "${Infile}" ]; then
    Prepend=""
else
    Prepend="${Prepend}/"
fi

# Get shebang line
Header="$(grep '#!' ${Infile})"
echo "Grabbed header: ${Header}"

cat ${Infile} | grep -oP '^(?!#\!).*' > $Outfile
echo "Copied ${Infile} into '${Outfile}'"

# Replace 'source ...' with contents of that file
while true; do
    # Find a line starting with 'soruce'
    Source="$(grep -n ^source ${Outfile} | head -n 1)"

    # If no lines found, we're done
    if [ -z "${Source}" ]; then
        break
    fi

    # Split $Source into line number and line content
    Line="$(echo ${Source} | grep -oP '[0-9]*')"
    Source=$(echo ${Source} | grep -oP '[0-9]*:\K.*')

    # Get only the filename from $Source
    Name="$(echo ${Source} | grep -oP "\"\K.*(?=\")" | head -n 1)"

    # If in a different folder, change the filepath
    if [ ! -z $Prepend ]; then
        Name=$Prepend$Name
    fi

    echo "Inserting ${Name}"
    # Exit if a file cannot be found
    if [ ! -e "${Name}" ]; then
        echo "ERROR: Can't find ${Name}."
        rm ${Outfile}
        exit 1
    fi
    
    # Get the part before $Line
    Top="$(cat ${Outfile} | head -n $((${Line} - 1)))"
    # Get the data of the source file
    Data="$(cat ${Name})"
    # Get the part after $Line
    Bot="$(cat ${Outfile} | tail -n +$((${Line} + 1)))"

    # Combine into $Outfile
    printf "%s\n\n%s\n\n%s\n" "$Top" "$Data" "$Bot" > ${Outfile}
done

# Add the #! header to the file
echo "Inserting header"
printf "%s\n%s" "$Header" "$(cat ${Outfile})"> ${Outfile}

echo "Moving to $Sbin"
mv ${Outfile} ${Sbin}

echo "Maing executable"
chmod 755 ${Sbin}${Outfile}

echo "Done."
echo "Run '${Outfile} -h for more info"
echo

exit 0
