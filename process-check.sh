#!/bin/bash

declare -a host_list
declare -a failed_hosts
declare -i fail_count=0

INPUT_FILE="./host_list.txt"

# read in newline seperated file 
while IFS= read -r line; do
  host_list+=("$line")
done < $INPUT_FILE

if [ ${#host_list[@]} -gt 0 ]
then
  # ssh into each remote host and check if the user specified process is running
  for host in ${host_list[@]}; do
    ssh root@$host -t "pgrep $1" > /dev/null
    if [ $? -gt 0 ] 
    then
      fail_count=fail_count+1
      failed_hosts+=($host)
    fi
  done

  # if given process is not running on all hosts create a list of failed hosts
  if [ $fail_count -gt 0 ]
  then
    echo "Number of hosts checked: ${#host_list[@]}"
    echo "Total number of failed hosts: $fail_count."
    echo "Please see failed_hosts.txt for a complete list of failures"

    echo "All other hosts passed check"

    echo "" >> failed_hosts.txt
    echo "list generated on: " >> failed_hosts.txt
    date >> failed_hosts.txt
    printf '%s\n' "${failed_hosts[@]}" >> failed_hosts.txt
  fi

  if [ $fail_count -eq 0 ]
  then
    echo "number of hosts checked: ${#host_list[@]}"
    echo "$1 is running on all hosts"
  fi
else
  echo "ERROR: ./host-list.txt is empty or no such file"
fi
