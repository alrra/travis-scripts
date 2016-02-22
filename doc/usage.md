# Usage

Specify the commands to be run in `.travis.yml`.

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

--

<div align="center">
    <a href="github-deploy-keys.md">← previous step</a> |
    <a href="contents.md">table of contents</a> |
    <a href="handle-multiple-jobs.md">next step →</a>
</div>
