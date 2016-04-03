#!/bin/bash

# Load helper functions
source "$(

    # The following is done because:
    #
    #   * `readlink` on OS X outputs a relative path
    #   * `misc.sh` is not publicly exposed
    #

    cd "$(dirname "$BASH_SOURCE")";
    cd "$(dirname $(readlink "$BASH_SOURCE"))";
    pwd

)/util/misc.sh"

declare repository_url=''

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

commit_and_push_changes() {

    # Commit and push changes upstream, and
    # overwrite the content from the specified branch

    git config --global user.email "$GH_USER_EMAIL" \
        && git config --global user.name "$GH_USER_NAME" \
        && git init \
        && git add -A \
        && git commit --message "$2" \
        && git checkout --quiet -b "$1" \
        && git push --quiet --force "$repository_url" "$1"

}

print_help_message() {
    printf '\n'
    printf 'OPTIONS:'
    printf '\n'
    printf '\n'
    printf ' -c, --commands <commands>\n'
    printf '\n'
    printf '     Specifies the commands that will be executed before everything else in order to update the content\n'
    printf '\n'
    printf ' -d, --directory <directory>\n'
    printf '\n'
    printf '     Specifies the name of the distribution/build directory\n'
    printf '\n'
    printf ' --distribution-branch <branch_name>\n'
    printf '\n'
    printf '     Specifies the name of the branch that will contain the content of the site\n'
    printf '\n'
    printf ' -m, --commit-message <message>\n'
    printf '\n'
    printf '     Specifies the commit message\n'
    printf '\n'
    printf ' --source-branch <branch_name>\n'
    printf '\n'
    printf '     Specifies the name of the branch that contains the source code\n'
    printf '\n'
}

remove_unneeded_files() {

    # Remove unneeded files and move the content from
    # within the specified directory in the root of the project

    local tmpDir="$(mktemp -u /tmp/XXXXX)"

    [ -d "$1" ] \
        && cp -r "$1" "$tmpDir" \
        && find . -delete \
        && shopt -s dotglob \
        && cp -r "$tmpDir"/* . \
        && shopt -u dotglob \

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local commands=''
    local commitMessage=''
    local directory=''
    local distributionBranch=''
    local sourceBranch=''

    local allOptionsAreProvided='true'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    while :; do
        case $1 in

            -h|--help)
                print_help_message
                exit
            ;;

            -c|--commands)
                if [ "$2" ]; then
                    commands="$2"
                    shift 2
                    continue
                else
                    print_error 'ERROR: A non-empty "-c/--commands <commands>" argument needs to be specified'
                    exit 1
                fi
            ;;

            -d|--directory)
                if [ "$2" ]; then
                    directory="$2"
                    shift 2
                    continue
                else
                    print_error 'ERROR: A non-empty "-d/--directory <directory>" argument needs to be specified'
                    exit 1
                fi
            ;;

            --distribution-branch)
                if [ "$2" ]; then
                    distributionBranch="$2"
                    shift 2
                    continue
                else
                    print_error 'ERROR: A non-empty "-db/--distribution-branch <branch_name>" argument needs to be specified'
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

            --source-branch)
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

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if all the required options are provided

    if [ -z "$commands" ]; then
        print_error 'ERROR: option "-c/--commands <commands>" not given (see --help).'
        allOptionsAreProvided='false'
    fi

    if [ -z "$commitMessage" ]; then
        print_error 'ERROR: option "-m/--commit-message <message>" not given (see --help).'
        allOptionsAreProvided='false'
    fi

    if [ -z "$directory" ]; then
        print_error 'ERROR: option "-d/--directory <directory>" not given (see --help).'
        allOptionsAreProvided='false'
    fi

    if [ -z "$distributionBranch" ]; then
        print_error 'ERROR: option "--distribution-branch <branch_name>" not given (see --help).'
        allOptionsAreProvided='false'
    fi

    if [ -z "$sourceBranch" ]; then
        print_error 'ERROR: option "--source-branch <branch_name>" not given (see --help).'
        allOptionsAreProvided='false'
    fi

    [ "$allOptionsAreProvided" == 'false' ] \
        && exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Only execute the following if the commit
    # was made to the specified source branch

    if [ "$TRAVIS_BRANCH" == "$sourceBranch" ] && \
       [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

        repository_url="$(get_repository_url)"

        execute "$commands" \
            &> >(print_error_stream) \
            1> /dev/null
        print_result $? 'Update content' \
            || exit 1

        remove_unneeded_files "$directory" \
            &> >(print_error_stream) \
            1> /dev/null
        print_result $? 'Remove unneeded content' \
            || exit 1

        commit_and_push_changes "$distributionBranch" "$commitMessage" \
            &> >(print_error_stream) \
            1> /dev/null
        print_result $? 'Commit and push changes'

    fi

}

main "$@" \
    &> >(remove_sensitive_information "$GH_TOKEN" "$GH_USER_EMAIL" "$GH_USER_NAME")
