import configs from './configs';
import { getJSON } from './get';

const CHECK_INTERVAL = 20000;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const wait = (time) =>
    new Promise((resolve) => {
        setTimeout(resolve,time);
    });

const getBuildID = async (branchName) => {

    const BUILDS_URL = configs.travis.url.BUILDS;
    const BUILD_NUMBER = configs.travis.build.NUMBER;

    let buildID = null;
    let url = BUILDS_URL;

    do {

        let builds;
        let lastBuildNumber;

        builds = await getJSON(url);

        for ( let i = 0; i < builds.length; i++ ) {
            if (builds[i].branch.indexOf(branchName) !== -1 ) {
                buildID = builds[i].id;
                break;
            }
        }

        lastBuildNumber = parseInt(builds[builds.length - 1].number, 10);


        // If buildID was not found, that means that eaither:

        if ( buildID === null ) {


            // 1) The git push was not yet picked up by Travis CI
            //    so we need to wait a little bit and then try again

            if ( lastBuildNumber <= BUILD_NUMBER ) {

                url = BUILDS_URL;
                await wait(CHECK_INTERVAL);


            // 2) The build is not in the current page of 25 builds
            //    provide by the API, so we need to move the next page

            } else {
                url = `${BUILDS_URL}?after_number=${lastBuildNumber}`;
            }

        }

    } while ( buildID === null );

    return buildID;

}

const getBuildResult = async (buildID) => {

    let build;
    const BUILD_URL = `${configs.travis.url.BUILD}${buildID}`;

    do {

        if ( build !== undefined ) {
            console.log(`Waiting for build ${buildID} to finish...`);
            await wait(CHECK_INTERVAL);
        }

        build = await getJSON(BUILD_URL);

    } while ( build.state !== 'finished' );

    return build.result;

}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export default async (branchName) => {
    return await getBuildResult(await getBuildID(branchName));
}
