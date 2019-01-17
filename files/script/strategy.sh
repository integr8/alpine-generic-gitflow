#!/bin/bash
set -e

if [[ "$PROJECT_TYPE" == 'JAVA' ]] ; then
  . $BINARY_PATH/strategy/pom.sh 
elif [[ "$PROJECT_TYPE" == 'NODE' ]] ; then
  . $BINARY_PATH/strategy/json.sh
elif [[ "$PROJECT_TYPE" == 'PHP' ]]; then 
  FILE_NAME='composer.json'  
  . $BINARY_PATH/strategy/json.sh
fi

change_version