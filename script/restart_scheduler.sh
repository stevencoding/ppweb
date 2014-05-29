#!/usr/bin/env bash

kill -9 `cat ../tmp/pids/resque-scheduler.pid`

PIDFILE='../tmp/pids/resque-scheduler.pid' LOGFILE='log/resque-scheduler.log' BACKGROUND=yes bundle exec rake resque:scheduler
