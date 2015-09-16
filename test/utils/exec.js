import { exec } from 'child_process';

import repository from './repository';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const sanitizeText = (text) => {

    const CENSURE_TEST = '[secure]';

    return `${text}`.replace(RegExp(`${repository.user.TOKEN}`, 'g'), CENSURE_TEST)
                    .replace(RegExp(`${repository.user.NAME}`, 'g'), CENSURE_TEST)
                    .replace(RegExp(`${repository.user.EMAIL}`, 'g'), CENSURE_TEST);

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
