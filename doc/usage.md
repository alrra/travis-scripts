## Usage

#### 1. Install `travis-scripts` as a `devDependency`

```bash
npm install --save-dev @alrra/travis-scripts
```

#### 2. Allow access to the repository

* [Setup the SSH keys](github-deploy-keys.md)
* or [use an access token](github-access-token.md) (not recommended, 
  as it's less secure than the first option)


#### 3. Use the `travis-scripts`

* Specify the commands to be run in `.travis.yml`.

  Here’s an example that runs `npm run build` against the `master` 
  branch whenever Travis CI completes a run, after which the resulting 
  `build` directory gets deployed to the `gh-pages` branch:

  ```yml
  after_success:
    -|

        # If deploy keys are used, add here the SSH commands, see:
        # https://github.com/alrra/travis-scripts/tree/master/doc/github-deploy-keys.md#26-setup-the-ssh-key-for-travis-ci

        $(npm bin)/update-branch --commands "npm run build"
                                 --commit-message "Hey GitHub, this content is for you! [skip ci]"
                                 --directory "build"
                                 --distribution-branch "gh-pages"
                                 --source-branch "master"
  ```

Note that these scripts use [`travis-after-all`](https://github.com/alrra/travis-after-all#readme)
to ensure this is only executed once, even when there are multiple jobs
in the build matrix.         
