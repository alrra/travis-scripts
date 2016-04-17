import tap from 'tap';

import pkg from './../package.json';

import * as travis from './utils/travis';

import testCommitChangesScript from './commit-changes/tests';
import testUpdateBranchScript from './update-branch/tests';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const isTestBranch = () =>
    (travis.getBranchName()).indexOf(pkg['config']['test-branch-prefix']) === 0;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const main = async () => {

    if ( travis.isPullRequest() === true ) {
        process.exit(0);
    }

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ( isTestBranch() ) {
        tap.pass('Job passed');
    } else {
        tap.test('Tests', (t) => {

            testCommitChangesScript(t);
            testUpdateBranchScript(t);

            t.end();

        });
    }

};

main();
