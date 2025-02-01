#!/bin/bash

# Maximum length for the fact
MAX_LENGTH=60  # Max allowed length
DISPLAY_LIMIT=60  # Maximum characters to display in the status bar
SPACING=2 # How much spacing to add after the fact

repeat() {
  for i in $(eval echo {0..$SPACING}); do echo -n "$1"; done
}

while true; do
  # Fetch random fact
  fact=$(curl -s https://uselessfacts.jsph.pl/api/v2/facts/random?language=en | jq -r '.text')

  # Check if the fact is under the desired length
  if [ ${#fact} -le $MAX_LENGTH ]; then
    # Truncate the fact to fit the display limit
    truncated_fact=$(echo "$fact" | cut -c 1-$DISPLAY_LIMIT)

    # Add a suffix to indicate truncation
    if [ ${#fact} -gt $DISPLAY_LIMIT ]; then
      truncated_fact="${truncated_fact}..."
    fi

    # Format and display the result
    formatted_fact="<span color='#EE37B8'>💡 Fact: $truncated_fact</span>"
    echo "$formatted_fact$(repeat ' ')"
    break
  fi
done

