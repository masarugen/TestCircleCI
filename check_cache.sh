#!/bin/bash

if [ "`diff api.json ~/cache_schema/api.json`" != "" ]; then
  echo "update api.json"
else
  echo "not update"
fi
