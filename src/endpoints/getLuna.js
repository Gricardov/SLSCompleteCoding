import middleware from '../utils/lambdaMiddleware';
import { getLunaWithContentById } from '../controller/lunas';
import { notifyServerError, getServerResponse } from '../utils/lambdaUtils';

async function getLuna(event, context) {
    context.callbackWaitsForEmptyEventLoop = false;
    try {
        const { id } = event.pathParameters;
        const result = await getLunaWithContentById(id);

        // Must be shaped like what the getLunas endpoints returns
        let shapedResult = {};
        if (Object.keys(result).length > 0) {
            const { authorFName, authorLName, authorProfileImgUrl, authorUsername, is18, ...rest } = result;
            shapedResult = {
                ...rest,
                is18: !!is18,
                authorData: {
                    fName: authorFName,
                    lName: authorLName,
                    username: authorUsername,
                    profileImgUrl: authorProfileImgUrl
                }
            };
        }

        return getServerResponse(200, shapedResult);
    } catch (error) {
        console.log(error);
        notifyServerError(500, 'Error al obtener las lunas');
    }
}

export const handler = middleware(getLuna);