import middleware from '../utils/lambdaMiddleware';
import { addLuna } from '../controller/lunas';
import { notifyServerError, getServerResponse } from '../utils/lambdaUtils';
import { v4 as uuidv4 } from 'uuid';

async function createLuna(event, context) {
    context.callbackWaitsForEmptyEventLoop = false;
    try {
        const { title, expressSynopsis, is18, content, author, displayType, tags, keywords, displayUrl, lunaTextModel } = event.body;
        const generatedId = (uuidv4()).toString().replace(/-/g, '');
        const lunaModel = displayType == 'Image' ? { displayUrl } : { ...lunaTextModel };
        const result = await addLuna(
            generatedId,
            title,
            expressSynopsis,
            is18,
            content,
            author.id,
            displayType,
            lunaModel,
            tags,
            keywords
        );

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
        notifyServerError(500, 'Error al crear la luna');
    }
}

export const handler = middleware(createLuna);