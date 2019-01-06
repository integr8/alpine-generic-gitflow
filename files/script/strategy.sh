#!/bin/bash
set -e

: ${PROJECT_TYPE? "You need to informe which type project is this. POM, JSON"}

if [[ "$PROJECT_TYPE" == 'POM' ]]; then
  source $BINARY_PATH/strategy/pom.sh
else if [[ "$PROJECT_TYPE" == 'POM' ]] ; then
  source $BINARY_PATH/strategy/json.sh
fi