#!/bin/bash

commit_and_push_changes() {

    # Check if there are unstaged changes, and
    # if there are, commit and push them upstream

    if [ "$(git status --porcelain)" != "" ]; then
        git config --global user.email ${GH_USER_EMAIL} \
            && git config --global user.name ${GH_USER_NAME} \
            && git checkout master \
            && git add -A \
            && git commit --message "$1" \
            && git push --quiet "$(get_repository_url)" master
    fi

}

get_repository_url() {
    printf "https://${GH_TOKEN}@$(git config --get remote.origin.url \
        | sed 's/git:\/\///g')"
}

print_error() {
    # Print output in red
    printf "\e[0;31m [✖] $1\e[0m\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    if [ $1 -ne 0 ]; then
        exit 1
    fi
}

print_success() {
    # Print output in green
    printf "\e[0;32m [✔] $1\e[0m\n"
}

update_content() {
    npm run build
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Only execute the following if the
    # changes were made in the `master` branch

    if [ "$TRAVIS_BRANCH" == "master" ] && \
       [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

        update_content &> /dev/null
        print_result $? "Update content"

        commit_and_push_changes "$1" &> /dev/null
        print_result $? "Commit and push changes (if necessary)"

    fi

}

main "$1"
#      └─ commit message
