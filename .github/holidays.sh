#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

fetch_holidays() {
    BASE_CALENDAR_URL="https://www.googleapis.com/calendar/v3/calendars"
    BASE_CALENDAR_ID_FOR_PUBLIC_HOLIDAY="holiday@group.v.calendar.google.com" # Calendar Id. This is public but apparently not documented anywhere officially.
    CALENDAR_REGION="en.norwegian"                                            # This variable refers to the region whose holidays we need to fetch

    # Making a fetch request
    url="${BASE_CALENDAR_URL}/${CALENDAR_REGION}%23${BASE_CALENDAR_ID_FOR_PUBLIC_HOLIDAY}/events?key=${GOOGLE_CALENDAR_API_KEY}"

    response=$(curl -s "$url")
    today=$(date -I)
    next_year=$(date -v+1y -I)
    holidays=$(echo "$response" | jq --arg today "$today" --arg next_year "$next_year" '.items[] | select(.start.date > $today and .start.date < $next_year) | { summary, start: .start.date, end: .end.date }')

    echo "$holidays"
}

# Call the function
fetch_holidays
