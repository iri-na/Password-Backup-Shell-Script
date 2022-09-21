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

# Set up variables for the command line arguments
targetDirectory=$1
destinationDirectory=$2

# Print argument variables to confirm
echo "Our target directory is $1"
echo "Our destination directory is $2"

# Current timestamp (in seconds)
currentTS=`date +%s`

# This is what our final backup files will be called
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# Current working directory absolute path
origAbsPath=`pwd`

# To get absolute path of destination directory
cd $destinationDirectory
destDirAbsPath=`pwd`

# To get absolute path of target directory
cd $targetDirectory
targDirAbsPath=`pwd`

# Get time stamp from 24 hours ago
yesterdayTS=$(($currentTS - 24 * 60 * 60))

# toBackup is an array, in which we will store the names
# of the files that need to be backed up
declare -a toBackup

for file in $(ls $targDirAbsPath)
do
  fileLastModified=`date -r $file +%s`
  if [[ $fileLastModified > $yesterdayTS ]]
  then
    toBackup+=($file)
  fi
done

# Now that we have an array of file names that need
# backing up, let us archive and compress each of these files
tar -czvf $backupFileName ${toBackup[@]}

# but also consider: 
# for file in ${toBackup[@]} 
# do 
#     zip -r $backupFileName $file
# done

mv $backupFileName $destDirAbsPath

# Add the execution of this file, plus args, to cron table
# and schedule to run every 24 hours
