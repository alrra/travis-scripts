import exec from './exec';
import repository from './repository';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default async (branchName) => {
    await exec(`git push ${repository.ORIGIN_URL} :${branchName}`);
};
