#!/bin/bash

# Define the list of servers and their corresponding remote directories
servers=("picambedyard" "picampool1" "piusbwatch1" "piusbwatch2")
remote_dirs=("/var/log/motion/data/" "/var/log/motion/data/" "/var/lib/motion/data/" "/var/lib/motion/data")

# output for the user and to a log file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
logfile=~/Documents/scripts/pi-pulldown/pulldown-logs/log_$timestamp.txt

# output info
message="Pulling data from $servers\n...\n$remote_dirs\n"
echo "$message"
echo "$message" >> $logfile

# Loop through each server
for ((i=0; i < ${#servers[@]}; i++)); do
    # get the server and associated directory
    server="${servers[i]}"
    remote_dir="${remote_dirs[i]}"

    # Define the local directory for this server
    # Define the local base directory where files will be pulled down
    local_dir="$HOME/Documents/scripts/pi-pulldown/pi-media-pulldowns/$server/$(date +'%Y-%m-%d')"

    # info output
    message="Connecting to $server:$remote_dir...\n"

    # Create the local directory for this server if it doesn't exist
    mkdir -p "$local_dir"

    # Sync files from remote server to local directory
    # Chatgpt help: Perform the rsync operation and stream the output to both the user and the log file
    if rsync -avz --progress -e "ssh -i $HOME/.ssh/ssh-keys/key-2024-04" "pi@$server:$remote_dir/" "$local_dir/" 2>&1 | tee -a "$logfile"; then
        success_message="Successfully synced $server:$dir."
        echo "$success_message"
        echo "$success_message" >> $logfile
    else
        error_message="Error syncing $server:$dir. Continuing with next directory..."
        echo "$error_message"
        echo "$error_message" >> $logfile
    fi
done





