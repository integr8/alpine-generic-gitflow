#!/bin/bash
# set -e

: ${TO_BUMP_FILENAME:="pom.xml"}
: ${PARENT_POM_PATH:=$SOURCE_PATH}

new_version=$1

change_version(){
  echo "POM_PATH:$PARENT_POM_PATH/$TO_BUMP_FILENAME"
  echo $($PARENT_POM_PATH/$TO_BUMP_FILENAME | xq --xml-output -r ".project.version = \"$new_version\"") > $PARENT_POM_PATH/pom.xml

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
  cat $1 | xq --xml-output -r ".project.parent.version = \"$new_version\"" > $(dirname $1)/new_pom.xml
  mv $(dirname $1)/new_pom.xml $(dirname $1)/pom.xml
}

change_version $1