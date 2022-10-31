#!/bin/bash

declare -a hosts_list
declare -a failed_hosts
declare -i fail_count=0

mapfile -t hosts_list < host-list.txt

for host in ${hosts_list[@]}; do
  ssh root@$host -t "pgrep $1" > /dev/null
  if [ $? -gt 0 ] 
  then
    fail_count=fail_count+1
    failed_hosts+=($host)
  fi
done

if [ $fail_count -gt 0 ]
then
  echo "Total number of failed hosts: $fail_count. Please see failed_hosts.txt for a complete list"
  echo "" >> failed_hosts.txt
  echo "list generated on: " >> failed_hosts.txt
  date >> failed_hosts.txt
  printf '%s\n' "${failed_hosts[@]}" >> failed_hosts.txt
fi

if [ $fail_count -eq 0 ]
then
  echo "$1 is running on all hosts"
fi
