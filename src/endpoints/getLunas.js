import middleware from '../utils/lambdaMiddleware';
import { getLunasByRateAndDateDesc } from '../controller/lunas';
import { notifyServerError } from '../utils/errorUtils';

async function getLunas(event, context) {
    context.callbackWaitsForEmptyEventLoop = false;
    try {
        const result = await getLunasByRateAndDateDesc(3);
        return {
            statusCode: 200,
            body: JSON.stringify({ payload: result })
        };
    } catch (error) {
        console.log(error);
        notifyServerError(500, 'Error al obtener las lunas');
    }
}

export const handler = middleware(getLunas);