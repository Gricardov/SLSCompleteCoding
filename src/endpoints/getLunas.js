import middleware from '../utils/lambdaMiddleware';
import { getLunasPreviewByPopularity } from '../controller/lunas';
import { notifyServerError, getServerResponse } from '../utils/lambdaUtils';

async function getLunas(event, context) {
    context.callbackWaitsForEmptyEventLoop = false;
    try {
        const result = await getLunasPreviewByPopularity(5);
        return getServerResponse(200, result);
    } catch (error) {
        console.log(error);
        notifyServerError(500, 'Error al obtener las lunas');
    }
}

export const handler = middleware(getLunas);