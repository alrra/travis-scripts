import fs from 'fs';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const replaceInLine = (line = '', patterns = {}) => {

    Object.keys(patterns).forEach((key) => {
        line = line.replace(RegExp(key, 'g'), patterns[key]);
    });

    return line;

};

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default (sourceFilePath, targetFilePath, replacePatterns) =>
    new Promise((resolve, reject) => {

        const readableStream = fs.createReadStream(sourceFilePath, {
            encoding: 'utf-8'
        });

        const writableStream = fs.createWriteStream(targetFilePath, {
            encoding: 'utf-8',
            flags: 'w'
        });

        readableStream.on('error', reject);
        readableStream.on('readable', () => {

            let c = '';
            let line = '';

            do {

                c = readableStream.read(1);
                line += c;

                if ( c !== null && c === '\n' ) {
                    writableStream.write(replaceInLine(line, replacePatterns));
                    line = '';
                }

            } while ( c !== null );

            writableStream.end();

        });

        writableStream.on('error', reject);
        writableStream.on('finish', resolve);

    });
