### HEAD

* Update `travis-after-all` to `v1.4.0`.
* Make `update-branch.sh` allow even a non-root directory
  to be specified
  [[5554b9a](https://github.com/alrra/travis-scripts/commit/5554b9a3fc6b09b37df7a95b40438efe08148eb6)].
* Make `commit-changes.sh` push to the specified branch
  [[2861a1d](https://github.com/alrra/travis-scripts/commit/2861a1dde5489211e3a08d325f2461654330a7c1)].
* Make scripts use `travis-after-all`
  [[2d5dd96](https://github.com/alrra/travis-scripts/commit/2d5dd96e6ec1190c6963f30a9e780e98fb1e5052)].
* Move scripts into `bin/`
  [[727433c](https://github.com/alrra/travis-scripts/commit/727433c628f25fdda094bc31b655aa889fd7079a)].
* Rename script files to have more generic names
  [[69847ad](https://github.com/alrra/travis-scripts/commit/69847ada77dd76a1bf4e00c6bd5e594f65e80b0b)].

### 0.6.1 (December 10, 2014)

* Fix wrong option name in the help message from `update_site_branch.sh`
  [[#4](https://github.com/alrra/travis-scripts/issues/4)].

### 0.6.0 (December 8, 2014)

* Allow users to specify the commands that will be executed
  [[#3](https://github.com/alrra/travis-scripts/issues/3)].

### 0.5.1 (December 3, 2014)

* Fix typo in `update_site_branch.sh`
  [[#2](https://github.com/alrra/travis-scripts/issues/2)].

### 0.5.0 (November 29, 2014)

* Allow users to specify the default branch name
  [[#1](https://github.com/alrra/travis-scripts/issues/1)].

### 0.4.0 (November 8, 2014)

* Make scripts check if the pull request is targeting the `master` branch
  [[f41f5ab](https://github.com/alrra/travis-scripts/commit/f41f5abe982971342fa9b1de6fee4cdc58a28b7d)].

### 0.3.0 (November 8, 2014)

* Make `update_site_branch.sh` remove the `.travis.yml` file
  [[fb54392](https://github.com/alrra/travis-scripts/commit/fb54392f89d99a7dcc4bf268580cf28bbc59fcb9)].

### 0.2.2 (November 7, 2014)

* Use better output message in `commit_build_changes.sh`
  [[26dcf01](https://github.com/alrra/travis-scripts/commit/26dcf013a24e6a99e8d057939915e98d04f70ffe)].

### 0.2.1 (November 7, 2014)

* Make scripts only output the strictly necessary content
  [[caaea4f](https://github.com/alrra/travis-scripts/commit/caaea4f09687a906fb99b48a4b46e48ec00632c6)].

### 0.2.0 (November 6, 2014)

* Make `update_site_branch.sh` more generic
  [[b5ecd31](https://github.com/alrra/travis-scripts/commit/b5ecd3196e43001719461ad2a4f945972d789f2f)].
* Rename `update_server_branch.sh` to `update_site_branch.sh`
  [[3799852](https://github.com/alrra/travis-scripts/commit/3799852850e3790984f780252d4143aeda2ed127)].

### 0.1.0 (November 5, 2014)
