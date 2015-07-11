// Travis CI set environment variables
// http://docs.travis-ci.com/user/ci-environment/#Environment-variables

const TRAVIS_BRANCH = process.env.TRAVIS_BRANCH;
const TRAVIS_BUILD_ID = parseInt(process.env.TRAVIS_BUILD_ID, 10);
const TRAVIS_BUILD_NUMBER = parseInt(process.env.TRAVIS_BUILD_NUMBER, 10);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Travis CI API URLs
// http://docs.travis-ci.com/api/

const TRAVIS_API_BUILD_URL = 'https://api.travis-ci.org/builds/';
const TRAVIS_API_BUILDS_URL = `https://api.travis-ci.org/repositories/${PKG.repository}/builds`;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Other

import PKG from './../../package.json';

const TEST_BRANCH_PREFIX = PKG['travis-scripts']['test-branch-prefix'];
const TEST_BRANCH = `${TEST_BRANCH_PREFIX}${TRAVIS_BUILD_ID}`;
const TEST_DIST_BRANCH = `${TEST_BRANCH_PREFIX}${TRAVIS_BUILD_ID}-dist`;

const GH_TOKEN = process.env.GH_TOKEN;
const GH_USER_EMAIL = process.env.GH_USER_EMAIL;
const GH_USER_NAME = process.env.GH_USER_NAME;
const REPOSITORY_URL = `https://${GH_TOKEN}@github.com/${PKG.repository}.git`;

// ---------------------------------------------------------------------

export default {

    'branch': {
        'TEST': TEST_BRANCH,
        'TEST_DIST': TEST_DIST_BRANCH,
        'CURRENT': TRAVIS_BRANCH,
    },

    'pkg': PKG,

    'repository': {
        'NAME': PKG.repository,
        'URL': REPOSITORY_URL
    },

    'travis': {

        'build': {
            'ID': TRAVIS_BUILD_ID,
            'NUMBER': TRAVIS_BUILD_NUMBER
        },

        'url': {
            'BUILD': TRAVIS_API_BUILD_URL,
            'BUILDS': TRAVIS_API_BUILDS_URL
        }

    },

    'user': {
        'EMAIL': GH_USER_EMAIL,
        'NAME': GH_USER_NAME,
        'TOKEN': GH_TOKEN
    }

}
