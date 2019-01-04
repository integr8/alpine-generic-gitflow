#!/bin/bash
# set -e

: ${FILE_NAME:="pom.xml"}
new_version=$1
change_version(){

    cat $FILE_NAME | xq --xml-output -r ".project.version = \"$new_version\"" > "$pom_path/new_pom.xml"

    check_for_submodules
}

check_for_submodules(){
    for row in $(cat $FILE_NAME | xq -r '.project.modules[]' | jq -r .[]); do
        check_for_submodules $row
    done
}

modify_file(){
    if [ -z "$1" ]; then
        pom_path=""
    else
        pom_path=$1
    fi

    echo $pom_path

    cat $pom_path/$FILE_NAME | xq --xml-output -r ".project.version = \"$new_version\"" > "$pom_path/new_pom.xml"
}

change_version $1