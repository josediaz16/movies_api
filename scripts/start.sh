#!/bin/bash --login

export BUNDLE_PATH=./gems

bundle check || bundle install

#entrypoint for docker
bundle exec "$@"
