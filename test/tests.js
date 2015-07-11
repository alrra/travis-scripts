import assert from 'assert';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

import configs from './utils/configs';

import { getContent, getStatusCode } from './utils/get';
import deleteBranch from './utils/delete-branch';
import createTestBranch from './utils/create-test-branch';
import getBuildResult from './utils/get-build-result';
import isRemoteBranch from './utils/is-remote-branch';

// ---------------------------------------------------------------------

const deleteTestBranches = async () => {
    await deleteBranch(configs.branch.TEST);
    await deleteBranch(configs.branch.TEST_DIST);
}

const isTestBranch = (branch) =>
    branch.indexOf(configs.pkg['travis-scripts']['test-branch-prefix']) === 0;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const runTests = () => {

    describe('Tests', () => {

        const TEST_FILE_FOR_TEST_BRANCH = `https://raw.githubusercontent.com/${configs.repository.NAME}/${configs.branch.TEST}/test/fixtures/test/file.txt`;
        const TEST_FILE_FOR_TEST_DIST_BRANCH = `https://raw.githubusercontent.com/${configs.repository.NAME}/${configs.branch.TEST_DIST}/file.txt`;

        const TEST_TEXT = configs.pkg['travis-scripts']['test-text'];

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        before(() => createTestBranch());

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        describe('Test build result', () => {

            it(`build for branch '${configs.branch.TEST}' should succeed`, () => {
                return getBuildResult(configs.branch.TEST)
                        .then((result) => assert.equal(0, result));
            });

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        describe('Test branch existence', () => {

            it(`branch '${configs.branch.TEST}' should exist`, () => {
                return isRemoteBranch(configs.branch.TEST)
                        .then((result) => assert.equal(true, result));
            });

            it(`branch '${configs.branch.TEST_DIST}' should exist`, () => {
                return isRemoteBranch(configs.branch.TEST_DIST)
                        .then((result) => assert.equal(true, result));
            });

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        describe('Test file existence', () => {

            it(`test file on '${configs.branch.TEST}' branch should exist`, () => {
                return getStatusCode(TEST_FILE_FOR_TEST_BRANCH)
                         .then((statusCode) => assert.equal(200, statusCode));
            });

            it(`test file on '${configs.branch.TEST_DIST}' branch should exist`, () => {
                return getStatusCode(TEST_FILE_FOR_TEST_DIST_BRANCH)
                         .then((statusCode) => assert.equal(200, statusCode));
            });

        });

        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        describe('Test file content', () => {

            it(`test file on '${configs.branch.TEST}' branch should contain '${TEST_TEXT}\\n'`, () => {
                return getContent(TEST_FILE_FOR_TEST_BRANCH)
                         .then((content) => assert.equal(`${TEST_TEXT}\n`, content));
            });

            it(`test file on '${configs.branch.TEST_DIST}' branch should contain '${TEST_TEXT}\\n${TEST_TEXT}\\n'`, () => {
                return getContent(TEST_FILE_FOR_TEST_DIST_BRANCH)
                         .then((content) => assert.equal(`${TEST_TEXT}\n${TEST_TEXT}\n`, content));
            });

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        after(() => deleteTestBranches());

    });

}

// ---------------------------------------------------------------------

const main = () => {

    // If this is executed from a pull requests, don't do anything
    // as the tests won't work because:
    //
    //  1) pull requests sent from forked repositories don't have
    //     access to the secure environment variables from this
    //     configs
    //
    //     http://docs.travis-ci.com/user/pull-requests/
    //
    //  2) there is no fully secure way to automatically import code
    //     from a pull request
    //
    //     (and, yes, I have trust issues!)

    if ( `${process.env.TRAVIS_PULL_REQUEST}` !== "false" ) {
        process.exit(0);
    }

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // If this is executed from a branch created for testing purposes,
    // again, don't do anything

    if ( isTestBranch(configs.branch.CURRENT) ) {
        process.exit(0);
    }

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    runTests();

}

main();
