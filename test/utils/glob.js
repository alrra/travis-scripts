import glob from 'glob';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (pattern, options = {}) =>
    new Promise((resolve, reject) => {
        glob(pattern, options, (error, files) => {

            if ( error === null ) {
                resolve(files);
            } else {
                reject(error);
            }

         });
    });
