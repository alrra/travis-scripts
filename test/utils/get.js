import https from 'https';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const get = (url) =>
    new Promise((resolve, reject) => {

        https.get(url, (response) => {

            let body = '';

            response.setEncoding('utf8');
            response.on('data', (chunk) => body += chunk);
            response.on('end', () => {
                response.body = body;
                resolve(response);
            });

        }).on('error', reject);

    });

const getContent = (url) =>
    get(url).then((response) => response.body);

const getJSON = (url) =>
    getContent(url).then(JSON.parse).catch((error) => {
        console.log(`Failed to parse JSON for: ${url}`);
        throw error;
    });

const getStatusCode = (url) =>
    get(url).then((response) => response.statusCode);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default {
    getContent: getContent,
    getJSON: getJSON,
    getStatusCode: getStatusCode
};
