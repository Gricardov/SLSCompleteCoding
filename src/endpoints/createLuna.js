import middleware from '../utils/lambdaMiddleware';
import { addLuna } from '../controller/lunas';
import { notifyServerError, getServerResponse } from '../utils/lambdaUtils';
import { v4 as uuidv4 } from 'uuid';

async function createLuna(event, context) {
    context.callbackWaitsForEmptyEventLoop = false;
    try {
        const { title, expressSynopsis, is18, content, author, displayType, tags, keywords, displayUrl, lunaTextModel } = event.body;

        const insertedRows = await addLuna(
            (uuidv4() + uuidv4()).toString().replace(/-/g, ''),
            title,
            expressSynopsis,
            is18,
            content,
            author.id,
            displayType,
            displayType == 'Image' ? { displayUrl } : { ...lunaTextModel },
            tags,
            keywords
        );
        return getServerResponse(200, { message: `${insertedRows} row(s) inserted!` });
    } catch (error) {
        console.log(error);
        notifyServerError(500, 'Error al crear la luna');
    }
}

export const handler = middleware(createLuna);