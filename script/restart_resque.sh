#!/usr/bin/env bash

kill -9 `cat ../tmp/pids/resque.pid`

QUEUE='*' PIDFILE='../tmp/pids/resque.pid' BACKGROUND=yes bundle exec rake environment resque:work
