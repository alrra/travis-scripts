#!/bin/bash

#  If this is executed from a pull request send from a forked
#  repository, do not continue any further as the tests won't
#  work because:
#
#   1) pull requests sent from forked repositories do not
#      have access to the secure environment variables from
#      this repository, and thus, the test branches cannot
#      be automatically created
#
#      https://docs.travis-ci.com/user/pull-requests/#Security-Restrictions-when-testing-Pull-Requests
#
#   2) there is no fully secure way to automatically import
#      code from a pull request into a local branch
#
#      (... and yes, I have trust issues!)

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then

    npm link > /dev/null \
        && set-up-ssh --key "$encrypted_18a7d42f6a87_key" \
                      --iv "$encrypted_18a7d42f6a87_iv" \
                      --path-encrypted-key ".travis/github_deploy_key.enc" \
        && rm -rf dist_test \
        && babel test --out-dir dist_test \
        && node dist_test/main.js | tap-mocha-reporter spec

fi
