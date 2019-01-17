#!/bin/bash
# set -e

: ${TO_BUMP_FILENAME:="pom.xml"}
: ${PARENT_POM_PATH:=$SOURCE_PATH}

change_version(){
  echo "POM_PATH:$PARENT_POM_PATH/$TO_BUMP_FILENAME"
  echo $(cat $PARENT_POM_PATH/$TO_BUMP_FILENAME) | xq  --xml-output -r '.project.version="'$next_version'"' > new_pom.xml
  mv -f new_pom.xml $PARENT_POM_PATH/$TO_BUMP_FILENAME

  check_for_submodules $PARENT_POM_PATH/$TO_BUMP_FILENAME
}

check_for_submodules(){
  for SUBMODULE in $(cat $1 | xq -r '.project.modules[]?' | jq -r '.[]?'); do
    modify_submodule $(dirname $1)/$SUBMODULE/$TO_BUMP_FILENAME
    check_for_submodules $(dirname $1)/$SUBMODULE/$TO_BUMP_FILENAME
  done
}

modify_submodule(){
  POM_PATH=$1

  echo "Modifying: $POM_PATH"
  cat $1 | xq --xml-output -r ".project.parent.version = \"$next_version\"" > new_pom.xml
  mv -f new_pom.xml $(dirname $1)/pom.xml
}