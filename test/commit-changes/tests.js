import path from 'path';

import pkg from './../../package.json';

import { getContent, getStatusCode } from './../utils/get';
import getTestBranchName from './../utils/get-test-branch-name';
import testBuild from './../utils/test-build';
import { getRepositorySlug } from './../utils/travis';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const CURRENT_TEST_DIR = path.basename(__dirname);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const customTests = async (tap) => {

    const TEST_TEXT = `${pkg['config']['test-text']}`;

    const TEST_BRANCH_NAME = getTestBranchName(CURRENT_TEST_DIR);

    const TEST_FILE_URL = `https://raw.githubusercontent.com/${getRepositorySlug()}/${TEST_BRANCH_NAME}/test/${CURRENT_TEST_DIR}/fixtures/test_files/file.txt`;
    const TEST_FILE_STATUS_CODE = await getStatusCode(TEST_FILE_URL);
    const TEST_FILE_CONTENT = await getContent(TEST_FILE_URL);

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Test if the test file exists
    tap.equal(200, TEST_FILE_STATUS_CODE, `Test file (${TEST_FILE_URL}) should exist`);

    // Test if the test file has the expected content
    tap.equal(TEST_TEXT, TEST_FILE_CONTENT, `Test file (${TEST_FILE_URL} should contain '${TEST_TEXT}\\n'`);

}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (tap) => {
    testBuild(tap, CURRENT_TEST_DIR, customTests);
};
