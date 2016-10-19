#!/bin/bash

JSONSCHEMA_PATH=`git diff HEAD^ HEAD --name-only --diff-filter=M --diff-filter=A --diff-filter=R | grep api.json`
if [ "$JSONSCHEMA_PATH" != "" ] ; then
  # JSONSchema updated
  echo "update!"
fi

