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
        && git push --force "$repository_url" "$1"

}

get_repository_url() {
    printf "https://${GH_TOKEN}@$(git config --get remote.origin.url \
        | sed 's/git:\/\///g')"
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
    printf " -d, --build-directory <directory>\n"
    printf "\n"
    printf "     Specifies the name of the distribution/build directory (default: 'dist')\n"
    printf "\n"
    printf " -db, --distribution-branch <branch_name>\n"
    printf "\n"
    printf "     Specifies the name of the branch that will contain the content of the site (default: 'gh-pages')\n"
    printf "\n"
    printf " -m, --commit-message <message>\n"
    printf "\n"
    printf "     Specifies the commit message (default: 'Hey server, this content is for you! [skip ci]')\n"
    printf "\n"
    printf " -sb, --source-branch <branch_name>\n"
    printf "\n"
    printf "     Specifies the name of the branch that contains the source code (default: 'master') \n"
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

    local commitMessage="Hey server, this content is for you! [skip ci]"
    local directory="dist"
    local distributionBranch="gh-pages"
    local sourceBranch="master"

    while :; do
        case $1 in

            -h|--help)
                print_help_message
                exit
            ;;

            -d|--directory)
                if [ "$2" ]; then
                    directory="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-d/--directory <directory>" argument needs to be specified' >&2
                    exit 1
                fi
            ;;

            -db|--distribution-branch)
                if [ "$2" ]; then
                    distributionBranch="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-db/--distribution-branch <branch_name>" argument needs to be specified' >&2
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

            -sb|--source-branch)
                if [ "$2" ]; then
                    sourceBranch="$2"
                    shift 2
                    continue
                else
                    echo 'ERROR: A non-empty "-sb/--source-branch <branch_name>" argument needs to be specified' >&2
                    exit 1
                fi
            ;;

           -?*) printf 'WARNING: Unknown option (ignored): %s\n' "$1" >&2;;
             *) break
        esac

        shift
    done

    # Only execute the following if the commit
    # was made to the specified source branch

    if [ "$TRAVIS_BRANCH" == "$sourceBranch" ] && \
       [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

        repository_url="$(get_repository_url)"

        update_content &> /dev/null
        print_result $? "Update content"

        remove_unneeded_files "$directory" &> /dev/null
        print_result $? "Remove unneeded content"

        commit_and_push_changes "$distributionBranch" "$commitMessage" &> /dev/null
        print_result $? "Commit and push changes"

    fi

}

main "$@"
