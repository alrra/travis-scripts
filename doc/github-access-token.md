# Setup the access token

#### 1. Enable Travis CI

If you haven't, [enable Travis CI for your
repository](https://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A)
by going to your Travis CI [profile page](https://travis-ci.org/profile)
and flicking the repository switch on.

![](https://cloud.githubusercontent.com/assets/1223565/12536703/4f9161ae-c2b5-11e5-904c-e11f561e8b6f.gif)

#### 2. [Install the Travis CLI](https://docs.travis-ci.com/user/encryption-keys/#Usage)

```bash
gem install travis
```

#### 3. [Generate a GitHub access token](https://github.com/settings/tokens)

For more information, see [GitHub's
documentation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/).

#### 4. Generate and add a secure key to your `.travis.yml` file

In order for the travis scripts to be able to make commits to
your repository, the following three environment variables need
to be provided:

 * `GH_TOKEN` - containing the GitHub access token generated at
   [step `3.`](#3-generate-a-github-access-token)
 * `GH_USER_EMAIL` and `GH_USER_NAME` - containing the [email and user
   name](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup#Your-Identity)
   with which the commits will be made

However you **should never expose** their values (especially for
`GH_TOKEN`), and instead, you should encrypt them by generating a
secure key using the Travis CLI:

```bash
travis encrypt -r "<username>/<repository>" \
    GH_TOKEN="<your_github_access_token>" \
    GH_USER_EMAIL="<your_email>" \
    GH_USER_NAME="<your_name>"
```

The above will output something like:

```bash
Please add the following to your .travis.yml file:

secure: "<secure_key_value>"

Pro Tip: You can add it automatically by running with --add.
```

:information_source: I didn't use `--add` to have the Travis CLI
automatically add the secure key to the `.travis.yml` file as that
usually screws up the formatting.

Then, once you have the secure key, add it to your `.travis.yml` file

```yaml
env:
  global:
    - secure: "<secure_key_value>"
```

--

<div align="center">
    <a href="install.md">← previous step</a> |
    <a href="../README.md#usage">table of contents</a> |
    <a href="usage.md">next step →</a>
</div>
