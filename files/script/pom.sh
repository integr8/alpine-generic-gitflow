#!/bin/bash
# set -e

: ${FILE_NAME:="pom.xml"}
: ${POM_PATH:=$(dirname $0)}
new_version=$1
change_version(){

    echo "POM_PATH:$POM_PATH/$FILE_NAME"
    cat "$POM_PATH/$FILE_NAME" | xq --xml-output -r ".project.version = \"$new_version\"" > $POM_PATH/new_pom.xml
    mv $POM_PATH/new_pom.xml $POM_PATH/pom.xml

    check_for_submodules $POM_PATH/$FILE_NAME
}

check_for_submodules(){
    for row in $(cat $1 | xq -r '.project.modules[]?' | jq -r '.[]?'); do
        modify_submodule $(dirname $1)/$row/$FILE_NAME
        check_for_submodules $(dirname $1)/$row/$FILE_NAME
    done
}

modify_submodule(){
    pom_path=$1
    echo "Modifying: $pom_path"
    cat $1 | xq --xml-output -r ".project.parent.version = \"$new_version\"" > $(dirname $1)/new_pom.xml
    mv $(dirname $1)/new_pom.xml $(dirname $1)/pom.xml
}


change_version $1