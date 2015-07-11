import configs from './configs';
import execute from './execute';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (branchName) =>
    execute(`git push ${configs.repository.URL} :${branchName}`);
