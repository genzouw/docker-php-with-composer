#!/usr/bin/env bash
set -u
set -e
set -o noclobber

docker build -t genzouw/php-with-composer:7.1.17-cli .
