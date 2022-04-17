import createError from 'http-errors';

export const notifyServerError = (code, message) => {
    throw createError(code, null, { expose: true, message: JSON.stringify({ message }), headers: 'application/json' });
};