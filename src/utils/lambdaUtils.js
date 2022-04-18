import createError from 'http-errors';

export const notifyServerError = (code = 500, message) => {
    throw createError(code, null, { expose: true, message: JSON.stringify({ message }), headers: 'application/json' });
};

export const getServerResponse = (code = 200, body) => {
    return { statusCode: code, body: JSON.stringify({ payload: body }) };
};