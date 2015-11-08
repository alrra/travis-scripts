import fs from 'fs';
import path from 'path';

import yaml from 'js-yaml';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const getFile = (file) =>
    new Promise((resolve, reject) => {
        fs.readFile(path.join(__dirname, file), 'utf8', function (error, data) {

            if ( error ) {
                reject(error);
            } else {
                resolve(data);
            }

        });
    });

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default async () => {
    // [!] `js-yaml` doesn't support streams
    return yaml.safeLoad(await getFile('../../.travis.yml'));
};

