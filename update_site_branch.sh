#!/bin/bash

declare repository_url=""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

commit_and_push_changes() {

    # Commit and push changes upstream, overwriting
    # the content from the branch intended for the server

    git config --global user.email ${GH_USER_EMAIL} \
        && git config --global user.name ${GH_USER_NAME} \
        && git init > /dev/null \
        && git add -A \
        && git commit --message "$2" > /dev/null \
        && git checkout -b "$1" 2> /dev/null \
        && git push --force --quiet "$repository_url" "$1"
    print_result $? "Commit and push changes"

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

    # Remove unneeded files and move the content from within
    # the `dist/` directory in the root of the project

    find . -maxdepth 1 \
            ! -name "." \
            ! -name ".travis.yml" `# It is important that this file remains,` \
                                  `# otherwise Travis will try to run the` \
                                  `# 'npm test' for the server content and fail` \
            ! -name "dist" \
            -exec rm -rf {} \; \
        && cp -r dist/{.??*,*} . \
        && rm -rf dist/
    print_result $? "Remove unneded content"

}

update_content() {
    npm -q install > /dev/null \
        && grunt > /dev/null
    print_result $? "Update content"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Only execute the following if the
    # changes were made in the `master` branch

    if [ "$TRAVIS_BRANCH" == "master" ]; then

        repository_url="$(get_repository_url)"

        update_content
        remove_unneeded_files
        commit_and_push_changes "$1" "$2"

    fi

}

main "$1" "$2"
#     │    └─ commit message
#     └─ branch name
