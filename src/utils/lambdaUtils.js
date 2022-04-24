import createError from 'http-errors';

export const notifyServerError = (code = 500, message) => {
    throw createError(code, null, { expose: true, message: JSON.stringify({ message }), headers: { 'Content-Type': 'application/json' } });
};

export const getServerResponse = (code = 200, body, headers = { 'Content-Type': 'application/json' }) => {
    return { statusCode: code, headers, body: JSON.stringify({ payload: body }) };
};