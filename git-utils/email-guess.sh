#!/usr/bin/env bash

remote=`git remote -v | awk '/\(push\)$/ {print $2}'`
email=julian.lannigan@gmail.com # default

if [[ $remote == *github.com:mrlannigan* ]]; then
  email=julian.lannigan@gmail.com
fi

echo "Configuring user.email as $email"
git config user.email $email
