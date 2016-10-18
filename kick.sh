#!/bin/bash

# Circle CIのProject Settings > Environment Variablesに以下を追加
# GH_TOKEN githubのPersonal access tokenを設定
# KICK_BRANCH travis-ci上のciを動作させるブランチ名

TRAVIS_RESPONSE=`curl -s -X POST \
                -H 'Content-Type: application/json' \
                -H 'Accept: application/vnd.travis-ci.2+json' \
                -H 'User-Agent: Travis/1.0' \
                https://api.travis-ci.org/auth/github \
                -d "{\"github_token\":\"$GH_TOKEN\"}"`
TRAVIS_TOKEN=`echo $TRAVIS_RESPONSE | cut -d'"' -f4 | cut -d'"' -f3`
if [ "$TRAVIS_TOKEN" != 'not a Travis user' ] ; then
  body=`cat << EOS
  {
    "request": {
      "branch":"$KICK_BRANCH"
    }
  }
EOS
`

  curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token $TRAVIS_TOKEN" \
    -d "$body" \
    https://api.travis-ci.org/repo/nasneg%2FAndroid-SampleApps/requests
fi
