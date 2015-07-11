import configs from './configs';
import execute from './execute';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (branchName) =>
    execute(`git ls-remote --heads --quiet ${configs.repository.URL} | grep "${branchName}$"`)
        .then((result) => result.length !== 0);
