#!/bin/sh
cd `dirname "$0"`
export FLASK_APP=uptime-generator
./uptime-generator.py dict/uptime_checks.dict ../uptime_checks.tf

echo "Running terraform validate.."
cd .. && terraform validate
echo "Done."
