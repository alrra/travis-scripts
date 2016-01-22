# travis-scripts

[![Build Status](https://travis-ci.org/alrra/travis-scripts.svg?branch=master)](https://travis-ci.org/alrra/travis-scripts)
[![devDependency Status](https://david-dm.org/alrra/travis-scripts/dev-status.svg)](https://david-dm.org/alrra/travis-scripts#info=devDependencies)


## Usage

1. Install `travis-scripts` as a `devDependency`:

    ```bash
    $ npm install --save-dev @alrra/travis-scripts
    ```

2. If you haven't, [enable Travis CI for your
repository](https://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A)
by going to your Travis CI [profile page](https://travis-ci.org/profile)
and flicking the repository switch on.

3. [Install the Travis CLI](https://docs.travis-ci.com/user/encryption-keys/#Usage).

4. [Generate a GitHub access token](https://github.com/settings/tokens).

   For more information, see [GitHub’s documentation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/).

5. Generate a secure key using the Travis CLI by running:

    ```bash
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

6. Specify the commands to be run in `.travis.yml`.

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
