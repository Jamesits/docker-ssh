#!/bin/bash

if [ "$USER" ]; then
ssh-import-id $USER
fi

exec "$@"
