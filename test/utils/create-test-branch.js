import path from 'path';

import configs from './configs';
import copy from './copy';
import execute from './execute';
import getSecureKey from './get-secure-key';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default async () => {

    const SECURE_KEY = (await getSecureKey()).env.global[0].secure;

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Replace `.travis.yml` file with the one from fixtures

    await copy(
        path.join(__dirname, './../fixtures/.travis.yml'),
        path.join(__dirname, './../../.travis.yml'),
        {
            '{{SECURE_KEY}}': `${SECURE_KEY}`,
            '{{TEST_BRANCH}}': `${configs.branch.TEST}`,
            '{{TEST_DIST_BRANCH}}': `${configs.branch.TEST_DIST}`
        }
    );

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Switch to test branch and then commit and push changes to GitHub
    // TODO: Look into using nodegit

    await execute(`git checkout -b ${configs.branch.TEST}`);

    await execute(`git config --global user.email ${configs.user.EMAIL}`);
    await execute(`git config --global user.name ${configs.user.NAME}`);
    await execute('git add -A');
    await execute('git status');
    await execute('git commit --message "test"');
    await execute(`git push ${configs.repository.URL} ${configs.branch.TEST}`);

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Return on the original branch

    await execute(`git checkout ${configs.branch.CURRENT}`);

}
