import middy from '@middy/core';
import httpJsonBodyParser from '@middy/http-json-body-parser';
import httpEventNormalizer from '@middy/http-event-normalizer';
import httpErrorHandler from '@middy/http-error-handler';
import cors from '@middy/http-cors';

export default handler => middy(handler)
    .use([
        httpJsonBodyParser(),  // Con esto, ya no debo hacerle parse al event.body
        httpEventNormalizer(), // Disminuye los errores de recuperar objetos no existentes de los parámetros del path/query
        httpErrorHandler(), // Funciona con http-errors para crear errores de forma declarativa
        cors()
    ]);