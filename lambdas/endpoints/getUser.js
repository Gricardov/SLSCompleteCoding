const Responses = require('../common/API_Responses');

exports.handler = async event => {
    console.log('event', event);

    if (!event.pathParameters || !event.pathParameters.ID) {
        // failed without an ID
        return Responses._400({ message: 'Missing the ID from the path' });
    }

    let ID = event.pathParameters.ID;

    if (data[ID]) {
        // return data
        return Responses._200(data[ID]);
    }

    // failed as ID not in the data
    return Responses._400({ message: 'ID not found in data' });
}

const data = {
    1234: { name: 'Mila Luna', age: 21, job: 'IDK' },
    7893: { name: 'Bob esponja', age: 22, job: 'AFK' }
}