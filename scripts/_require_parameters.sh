#!/usr/bin/env sh
FOUND_ERROR=false
for parameter in "${!REQUIRED_PARAMETER[@]}"; do
  if [ -z "${!REQUIRED_PARAMETER[$parameter]}" ]
  then
     echo "  ⚠  Missing parameter: \$${REQUIRED_PARAMETER[$parameter]}"
     FOUND_ERROR=true
  fi
done

if [ "${FOUND_ERROR}" = true ]
then
  exit;
fi
