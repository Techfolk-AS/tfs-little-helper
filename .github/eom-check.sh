#!/bin/bash

# Get the input date or default to today's date
if [ -n "$1" ]; then
    input_date="$1"
else
    input_date=$(date +%Y-%m-%d)
fi

# Function to check if a given date is a weekday (Monday to Friday)
is_weekday() {
    local date="$1"
    if date --version >/dev/null 2>&1; then
        # GNU date
        local day_of_week=$(date -d "$date" +%u)
    else
        # BSD date (e.g., macOS)
        local day_of_week=$(date -j -f "%Y-%m-%d" "$date" +%u)
    fi
    [ "$day_of_week" -lt 6 ]
}

# Function to find the last day of the month
get_last_day_of_month() {
    local date="$1"
    if date --version >/dev/null 2>&1; then
        # GNU date
        echo $(date -d "$date +1 month -$(date -d "$date +1 month" +%d) days" +%Y-%m-%d)
    else
        # BSD date (e.g., macOS)
        echo $(date -j -v+1m -v1d -v-1d -f "%Y-%m-%d" "$date" +%Y-%m-%d)
    fi
}

# Function to find the last working day of the month
find_last_working_day() {
    local last_day="$1"
    while ! is_weekday "$last_day"; do
        if date --version >/dev/null 2>&1; then
            # GNU date
            last_day=$(date -d "$last_day -1 day" +%Y-%m-%d)
        else
            # BSD date (e.g., macOS)
            last_day=$(date -j -v-1d -f "%Y-%m-%d" "$last_day" +%Y-%m-%d)
        fi
    done
    echo "$last_day"
}

# Get the last day of the month for the input date
last_day_of_month=$(get_last_day_of_month "$input_date")

# Find the last working day of the current month
last_working_day=$(find_last_working_day "$last_day_of_month")

# Check if the input date is the last working day of the month
if [ "$input_date" == "$last_working_day" ]; then
    echo "The date ($input_date) is the last working day of the month."
    exit 0
else
    echo "The date ($input_date) is not the last working day of the month."
    exit 1
fi
