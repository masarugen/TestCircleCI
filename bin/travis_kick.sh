#!/bin/bash

# speeeのprivateリポジトリ内の対象リポジトリの、対象ブランチに対してのtravisのciを起動する為のshell
# Circle CIで利用の場合：Project Settings > Environment Variablesに以下の環境変数を追加
# Travis CIで利用の場合：Settings > Environment Variablesに以下の環境変数を追加
# GH_TOKEN githubのPersonal access tokenを設定
# Usage: travis_kick.sh com speee bt-jsonschema2java master
# 第１引数：com or org
# 第２引数：repositoryのowner
# 第３引数：repository名
# 第４引数：branch名

TRAVIS_RESPONSE=`curl -s -f -X POST \
                -H 'Content-Type: application/json' \
                -H 'Accept: application/vnd.travis-ci.2+json' \
                -H 'User-Agent: Travis/1.0' \
                "https://api.travis-ci.${1}/auth/github" \
                -d "{\"github_token\":\"$GH_TOKEN\"}" \
                --verbose`
if [ $? -eq 0 ]; then
  # tokenが取得できた場合のみ実行
  TRAVIS_TOKEN=`echo $TRAVIS_RESPONSE | cut -d'"' -f4 | cut -d'"' -f3`
  if [ "$TRAVIS_TOKEN" != 'not a Travis user' -a "$TRAVIS_TOKEN" != '' ] ; then
    body=`cat << EOS
{
  "request": {
    "branch":"${4}"
  }
}
EOS
`
    curl -s -f -X POST \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -H "Travis-API-Version: 3" \
      -H "Authorization: token $TRAVIS_TOKEN" \
      -d "$body" \
      https://api.travis-ci.{$1}/repo/{$2}%2F{$3}/requests \
      --verbose
  fi
fi