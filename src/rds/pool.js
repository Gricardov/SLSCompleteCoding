import slsMySQL from 'serverless-mysql';
import credentials from './credentials';

const mysql = slsMySQL({
    backoff: 'decorrelated',
    base: 5,
    cap: 200,
    config: {
        host: credentials.host,
        user: credentials.user,
        password: credentials.password,
        database: credentials.database,
        port: credentials.port,
        charset: 'utf8mb4',
        timezone: '+00:00',
        dateStrings: ['DATE', 'DATETIME'],
        typeCast: (field, next) => { // Para hacer el parseo a JSON automáticamente
            if (field.type.includes('BLOB')) { // && field.length == 4294967295
                let value;
                try {
                    value = field.string();
                    return JSON.parse(value);
                } catch (e) {
                    return value;
                }
            }
            return next();
        }
    },
});

export const queryDB = async (sql, args) => {
    let result = await mysql.query(sql, args);
    await mysql.end();
    return result;
};

// Sources:
// https://medium.com/the-dev-caf%C3%A9/creating-a-serverless-rest-api-with-node-js-aws-lambda-api-gateway-rds-and-postgresql-303b0baac834
// https://medium.com/@antonio.cm.oliveira/how-to-access-your-rds-database-with-lambda-function-and-serverless-b7712dde9f80
// https://javascript.plainenglish.io/serverless-things-i-wish-i-had-known-part-2-dynamodb-x-mongodb-x-aurora-serverless-1053cfddff36
// https://www.jeremydaly.com/reuse-database-connections-aws-lambda/
// https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36#:~:text=A%20closure%20is%20the%20combination,scope%20from%20an%20inner%20function.
// https://www.jeremydaly.com/manage-rds-connections-aws-lambda/