#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
echo "Our target directory is $1"
echo "Our destination directory is $2"

# [TASK 3]
# current timestamp (in seconds)
currentTS=`date +%s`

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=`pwd`

# [TASK 6]
# To get absolute path of destination directory
# cd $destinationDirectory
# destDirAbsPath=`pwd`
# cd ..
destDirAbsPath="$(pwd)/$destinationDirectory"

# [TASK 7]
# To get absolute path of target directory
# cd $targetDirectory
# targDirAbsPath=`pwd`
# cd ..
targDirAbsPath="$pwd/$targetDirectory"

# [TASK 8]
# time stamp from 24 hours ago
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls) # [TASK 9]
do
  # [TASK 10]
  fileLastModified=`date -r $file +%s`
  if [[ $fileLastModified > $yesterdayTS ]]
  then
    # [TASK 11]
    toBackup+=($file)
  fi
done

# [TASK 12]
tar -czvf $backupFileName ${toBackup[@]}

# but also consider: 
# for file in ${toBackup[@]} 
# do 
#     zip -r $backupFileName $file
# done

# [TASK 13]
mv $backupFileName $destDirAbsPath

# Congratulations!
