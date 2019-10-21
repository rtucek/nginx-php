#!/bin/bash

set -e

TARGET_UID="${TARGET_UID:=1000}"
TARGET_GID="${TARGET_GID:=1000}"

TARGET_USER="${TARGET_USER:=www-data}"
TARGET_GROUP="${TARGET_GROUP:=www-data}"


EXISTING_GID=$(getent group "$TARGET_GROUP" | cut -d: -f3)
if [ -z "$EXISTING_GID" ]; then
	# Add group - it doesn't exist
	groupadd -g "$TARGET_GID" "$TARGET_GROUP"
else
	if [ "$EXISTING_GID" -ne "$TARGET_GID" ]; then
		# Change existing GID
		groupmod -g "$TARGET_GID" "$TARGET_GROUP"
	fi
fi


EXISTING_UID=$(getent passwd "$TARGET_USER" | cut -d: -f3)
if [ -z "$EXISTING_UID" ]; then
	# Add group - it doesn't exist
	useradd -u "$TARGET_UID" -g "$TARGET_GROUP" "$TARGET_USER"
else
	if [ "$EXISTING_UID" -ne "$TARGET_UID" ]; then
		# Change existing UID and GID
		usermod -u "$TARGET_UID" -g "$TARGET_GROUP" "$TARGET_USER"
	else
		usermod -g "$TARGET_GROUP" "$TARGET_USER"
	fi
fi

exec "$@"
