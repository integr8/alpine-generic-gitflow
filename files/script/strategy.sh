#!/bin/bash
set -e

: ${PROJECT_TYPE? "You need to informe which type project is this. POM, JSON"}

if [[ "$PROJECT_TYPE" == 'POM' ]] ; then
  . $BINARY_PATH/strategy/pom.sh 
elif [[ "$PROJECT_TYPE" == 'POM' ]] ; then
  . $BINARY_PATH/strategy/json.sh
fi