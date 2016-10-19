#!/bin/bash

# dependenciesは依存関係解決時のキャッシュなので以前のファイルを別名でキャッシュしておく
mkdir -p ~/cache_schema
if [ ! -e ~/cache_schema/api.json ]; then
  # previous.jsonが存在しない場合は、以前のキャッシュとして保存
  echo "~/cache_schema/api.json not found"
  cp -p api.json ~/cache_schema/previous.json
elif [ "`diff api.json ~/cache_schema/previous.json`" != "" ]; then
  # 以前のキャッシュから更新があった場合、以前のキャッシュを比較対象にcopyして、現在の情報をprevious.jsonとして保存
  echo "copy api.json"
  cp -p ~/cache_schema/previous.json ~/cache_schema/api.json
  cp -p api.json ~/cache_schema/previous.json
fi
