#!/usr/bin/env sh
set -e

# Get auth token
TOKEN=$(curl --fail --silent --show-error --user admin:nimda --request GET http://localhost:8080/api/v2/token | jq --raw-output .access_token)

# trigger data retention check
curl --fail --silent --show-error --header "Authorization: Bearer ${TOKEN}" --request POST http://localhost:8080/api/v2/eventrules/run/delete-old-files-user1
