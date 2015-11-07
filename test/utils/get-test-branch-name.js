import pkg from './../../package.json';

import { getCurrentBuildID } from './travis';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const PREFIX = `${pkg['config']['test-branch-prefix']}-${getCurrentBuildID()}`;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (baseName) =>
    `${PREFIX}-${baseName}`;
