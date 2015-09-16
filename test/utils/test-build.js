import createTestBranch from './create-test-branch';
import deleteBranch from './delete-branch';
import getTestBranchName from './get-test-branch-name';
import travis from './travis';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (tap, testDir, customTests) => {

    const TEST_BRANCH_NAME = getTestBranchName(testDir);

    tap.test(`customTests for branch "${TEST_BRANCH_NAME}"`, (t) => {

        let buildData;

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        t.test('Create branch', async (tt) => {

            try {
                await createTestBranch(testDir);
                tt.pass(`Should create branch \`${TEST_BRANCH_NAME}\``);
            } catch (e) {
                tt.error(e);
                tt.fail(`Should create branch \`${TEST_BRANCH_NAME}\``);
            }

            tt.end();

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        t.test('Get build data', async (tt) => {

            try {
                buildData = await travis.getBuildData(travis.getRepositorySlug(), TEST_BRANCH_NAME);
                tt.pass(`Should get the build data for branch \`${TEST_BRANCH_NAME}\``);
            } catch (e) {
                tt.fail(`Should get the build data for branch \`${TEST_BRANCH_NAME}\``);
                tt.error(e);
            }

            tt.end();

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        t.test('Run custom tests', async (tt) => {

            tt.ok(buildData !== undefined, `Should have the build data for branch \`${TEST_BRANCH_NAME}\``);

            if ( tt.passing() && typeof customTests === 'function' ) {
                try{
                    await customTests(tt);
                } catch (e) {
                    tt.error(e);
                }
            }

            tt.end();

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        t.test('Delete branch', async (tt) => {

            try {
                await deleteBranch(TEST_BRANCH_NAME);
                tt.pass(`Should delete branch \`${TEST_BRANCH_NAME}\``);
            } catch (e) {
                tt.fail(`Should delete branch \`${TEST_BRANCH_NAME}\``);
                tt.error(e);
            }

            tt.end();

        });

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        t.end();

    });

};
