#!/bin/bash

# Get the current date
current_date=$(date +%Y-%m-%d)

# Calculate the date of the next 25th
current_day=$(date +%d)
current_month=$(date +%m)
current_year=$(date +%Y)

if (( current_day >= 25 )); then
  # If today is after the 25th, calculate for next month
  next_month=$(( (current_month + 1) % 12 ))
  if (( next_month == 0 )); then
    next_month=1
    next_year=$(( current_year + 1 ))
  else
    next_year=$current_year
  fi
  next_25th=$(date -d "$next_year-$next_month-25" +%Y-%m-%d)

else
  # If today is before the 25th, calculate for this month
  next_25th=$(date -d "$current_year-$current_month-25" +%Y-%m-%d)
fi


# Calculate the difference in days (CORRECTED)
days_left=$(( ($(date -d "$next_25th" +%s) - $(date -d "$current_date" +%s)) / 86400 ))

# Echo the result
echo "<span color='#D109F6'>Days left until salary (25th): $days_left</span>"
