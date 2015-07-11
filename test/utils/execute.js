import { exec } from 'child_process';

import configs from './configs';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const sanitizeText = (text) => {

    const censureString = '[secure]';

    return `${text}`.replace(RegExp(`${configs.user.TOKEN}`, 'g'), censureString)
                    .replace(RegExp(`${configs.user.NAME}`, 'g'), censureString)
                    .replace(RegExp(`${configs.user.EMAIL}`, 'g'), censureString);

}

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
