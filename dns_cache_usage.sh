#!/bin/bash

function calc_cache_stats() {

        # create list of cache size history
        results=$(cat /root/cache_log.txt | grep -i size | awk -F ":" '{print $NF}')

        # set baseline values for avg calc
        total=0
        divisor=0

        # set baseline for high/low values
        high=0
        low=10000000

        for number in ${results[@]};
        do
                # get numbers for avg calc
                total=$(($total+$number))
                let "divisor+=1"

                # find highest cache usage
                if (($number > $high)); then
                        high=$number
                fi

                # find lowest cache usage
                if (($number < $low)); then
                        low=$number
                fi

        done

        avg=$(($total/$divisor))

        echo "Average usage across $divisor samples taken every 30mins: $avg"
        echo "Highest cache usage: $high"
        echo "Lowest cache usage: $low"

        return
}

date >> cache_log.txt

resolvectl statistics | grep -i cache >> /root/cache_log.txt

calc_cache_stats >> /root/cache_log.txt

echo "" >> /root/cache_log.txt
