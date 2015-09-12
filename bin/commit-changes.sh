#!/bin/bash

commit_and_push_changes() {

    # Check if there are unstaged changes, and
    # if there are, commit and push them upstream

    if [ "$(git status --porcelain)" != "" ]; then
        git config --global user.email ${GH_USER_EMAIL} \
            && git config --global user.name ${GH_USER_NAME} \
            && git checkout "$1" \
            && git add -A \
            && git commit --message "$2" \
            && git push "$(get_repository_url)" "$1"
    fi

}

execute() {
    eval ${1}
}

get_repository_url() {
    printf "https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git"
}

print_error() {
    # Print output in red
    printf "\e[0;31m [✖] $1\e[0m\n"
}

print_help_message() {
    printf "\n"
    printf "OPTIONS:"
    printf "\n"
    printf "\n"
    printf " -b, --branch <branch_name>\n"
    printf "\n"
    printf "     Specifies the commands that will be executed before everything else in order to update the content (default: 'npm install && npm run build')\n"
    printf "\n"
    printf " -c, --commands <commands>\n"
    printf "\n"
    printf "     Specifies the commands that will be executed before everything else (default: 'npm install && npm run build')\n"
    printf "\n"
    printf " -m, --commit-message <message>\n"
    printf "\n"
    printf "     Specifies the commit message (default: 'Update content [skip ci]')\n"
    printf "\n"
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

run_travis_after_all() {

    command -v "$(npm bin 2> /dev/null)/travis-after-all" &> /dev/null

    if [ $? -eq 0 ]; then
        $(npm bin)/travis-after-all
    else
        curl -sSL https://raw.githubusercontent.com/alrra/travis-after-all/1.4.1/lib/travis-after-all.js | node
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local branch="master"
    local commands="npm install && npm run build"
    local commitMessage="Update content [skip ci]"

    while :; do
        case $1 in

            -h|--help)
                print_help_message
                exit
            ;;

            -b|--branch)
                if [ "$2" ]; then
                    branch="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-b/--branch <branch_name>" argument needs to be specified' >&2
                    exit 1
                fi
            ;;

            -c|--commands)
                if [ "$2" ]; then
                    commands="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-c/--commands <commands>" argument needs to be specified' >&2
                    exit 1
                fi
            ;;

            -m|--commit-message)
                if [ "$2" ]; then
                    commitMessage="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-m/--commit-message <message>" argument needs to be specified' >&2
                    exit 1
                fi
            ;;

           -?*) printf 'WARNING: Unknown option (ignored): %s\n' "$1" >&2;;
             *) break
        esac

        shift
    done

    # Only execute the following if the
    # commit was made to the specified branch

    if [ "$TRAVIS_BRANCH" == "$branch" ] && \
       [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

        run_travis_after_all
        [ $? -ne 0 ] && exit 0

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        execute "$commands" &> /dev/null
        print_result $? "Update content"

        commit_and_push_changes "$branch" "$commitMessage" &> /dev/null
        print_result $? "Commit and push changes (if necessary)"

    fi

}

main "$@"
