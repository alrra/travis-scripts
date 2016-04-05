import { exec } from 'child_process';

import repository from './repository';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const sanitizeText = (text) => {

    const CENSOR_TEXT = '[secure]';

    return text.replace(RegExp(repository.user.NAME, 'g'), CENSOR_TEXT)
               .replace(RegExp(repository.user.EMAIL, 'g'), CENSOR_TEXT);

};

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (cmd) =>
    new Promise((resolve, reject) => {
        exec(cmd, (error, stdout, stderr) => {

            if (error === null) {
                resolve(sanitizeText(stdout));
            } else {
                error.message = sanitizeText(error.message);
                reject(error);
            }

        });
    });
