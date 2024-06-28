#!/bin/bash

# Get the input date or default to today's date
input_date="${1:-$(date +%Y-%m-%d)}"

# Function to check if a given date is the last working day of the month
is_last_working_day() {
    local date="$1"
    local day_of_week=$(date -j -f "%Y-%m-%d" "$date" "+%u")
    local tomorrow=$(date -j -v+1d -f "%Y-%m-%d" "$date" "+%Y-%m-%d")
    local tomorrow_day_of_week=$(date -j -f "%Y-%m-%d" "$tomorrow" "+%u")
    local day_of_month=$(date -j -f "%Y-%m-%d" "$date" "+%d")
    local tomorrow_day_of_month=$(date -j -f "%Y-%m-%d" "$tomorrow" "+%d")

    # Check if today is a weekday (Monday to Friday)
    if [ "$day_of_week" -lt 6 ]; then
        # Check if tomorrow is the first day of the next month or a weekend
        if [[ "$tomorrow_day_of_month" -eq 1 || "$tomorrow_day_of_week" -eq 6 || "$tomorrow_day_of_week" -eq 7 ]]; then
            return 0
        fi
    fi

    return 1
}

# Check if the input date is the last working day of the month
if is_last_working_day "$input_date"; then
    echo "Today ($input_date) is the last working day of the month."
    exit 0
else
    echo "Today ($input_date) is not the last working day of the month."
    exit 1
fi
