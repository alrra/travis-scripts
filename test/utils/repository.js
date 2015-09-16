import travis from './travis';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const GH_TOKEN = process.env.GH_TOKEN;
const GH_USER_EMAIL = process.env.GH_USER_EMAIL;
const GH_USER_NAME = process.env.GH_USER_NAME;

const REPOSITORY_URL = `https://${GH_TOKEN}@github.com/${travis.getRepositorySlug()}.git`;

// ---------------------------------------------------------------------

export default {

    'ORIGIN_URL': REPOSITORY_URL,
    'user': {
        'EMAIL': GH_USER_EMAIL,
        'NAME': GH_USER_NAME,
        'TOKEN': GH_TOKEN
    }

};
