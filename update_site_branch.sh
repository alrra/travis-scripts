#!/bin/bash

declare repository_url=""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

commit_and_push_changes() {

    # Commit and push changes upstream, and
    # overwrite the content from the specified branch

    git config --global user.email ${GH_USER_EMAIL} \
        && git config --global user.name ${GH_USER_NAME} \
        && git init \
        && git add -A \
        && git commit --message "$2" \
        && git checkout -b "$1" \
        && git push --force --quiet "$repository_url" "$1"

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

remove_unneeded_files() {

    # Remove unneeded files and move the content from
    # within the specified directory in the root of the project

    find . -maxdepth 1 \
            ! -name "." \
            ! -name "$1" \
            -exec rm -rf {} \; \
        && shopt -s dotglob \
        && cp -r "$1"/* . \
        && shopt -u dotglob \
        && rm -rf "$1"

}

update_content() {
    npm install \
        && npm run build
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Only execute the following if the
    # commit was made to the `master` branch

    if [ "$TRAVIS_BRANCH" == "master" ]; then

        repository_url="$(get_repository_url)"

        update_content &> /dev/null
        print_result $? "Update content"

        remove_unneeded_files "$1" &> /dev/null
        print_result $? "Remove unneded content"

        commit_and_push_changes "$2" "$3" &> /dev/null
        print_result $? "Commit and push changes"

    fi

}

main "$1" "$2" "$3"
#      │    │    └─ commit message
#      │    └─ branch name
#      └─ distribution/build directory name
