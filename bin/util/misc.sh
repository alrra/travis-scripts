#!/bin/bash

declare -r LOG_PREFIX='[travis-scripts]'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

execute() {
    eval ${1}
}

get_repository_url() {

    if [ -z "$GH_TOKEN" ]; then
        printf "git@github.com:$TRAVIS_REPO_SLUG.git"
    else
        printf "https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git"
    fi

}

print() {
    printf "%b%s%b\n" \
        "$1" \
        "${2//$'\r'//}" \
        "\e[0m"
}

print_error() {
    print_in_red "$LOG_PREFIX [✖] $1"
}

print_in_green() {
    print "\e[0;32m" "$1"
}

print_in_red() {
    print "\e[0;31m" "$1"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    return $1
}

print_success() {
    print_in_green "$LOG_PREFIX [✔] $1"
}

remove_sensitive_information() {

    declare -r CENSURE_TEST='[secure]';

    while read -r line; do

        line="${line//${GH_TOKEN}/$CENSURE_TEST}"
        line="${line//${GH_USER_EMAIL}/$CENSURE_TEST}"
        line="${line//${GH_USER_NAME}/$CENSURE_TEST}"

        print_error "$line"

    done

}
