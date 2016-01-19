# travis-scripts

[![Build Status](https://travis-ci.org/alrra/travis-scripts.svg?branch=master)](https://travis-ci.org/alrra/travis-scripts)
[![devDependency Status](https://david-dm.org/alrra/travis-scripts/dev-status.svg)](https://david-dm.org/alrra/travis-scripts#info=devDependencies)

## How to use

1. Save `travis-scripts` as a `devDependency` to `package.json`:

    ```sh
    $ npm install travis-scripts --save-dev
    ```

2. [Generate a GitHub application token](https://github.com/settings/applications/new)
for command-line use. See [GitHub’s documentation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
for more info.

3. [Install the Travis client](https://docs.travis-ci.com/user/encryption-keys/#Usage)
and run:

    ```sh
    $ travis encrypt -r "<username>/<repository>" \
      GH_TOKEN="<your_github_access_token>" \
      GH_USER_EMAIL="<your_email>" \
      GH_USER_NAME="<your_name>" \
      --add env.global
    ```

    This adds an entry to your `.travis.yml` file:

    ```yaml
    env:
      global:
        - secure: "<secure_key>"
    ```

4. Specify the commands to be run in `.travis.yml`.

    Here’s an example that runs `npm install && npm run build` 
    against the `master` branch whenever Travis CI completes a run,
    after which the resulting `build` directory gets deployed to
    the `gh-pages` branch:

    ```yml
    after_success:
      - $(npm bin)/update-branch --commands "npm install && npm run build"
                                 --commit-message "Hey GitHub, this content is for you! [skip ci]"
                                 --directory "build"
                                 --distribution-branch "gh-pages"
                                 --source-branch "master"
    ```

Note that these scripts use [`travis-after-all`](https://github.com/alrra/travis-after-all#readme) 
to ensure this is only executed once, even when there are multiple jobs
in the build matrix.
