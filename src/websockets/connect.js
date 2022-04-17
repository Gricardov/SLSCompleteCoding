// Called everytime when we connect to the socket
import Responses from '../utils/API_Responses';
import Dynamo from '../utils/Dynamo';

const tableName = process.env.tableName;

exports.handler = async event => {
    console.log('event', event);

    // Store connection and message information
    const { connectionId: connectionID, domainName, stage } = event.requestContext;

    const data = {
        ID: connectionID,
        date: Date.now(),
        messages: [],
        domainName,
        stage
    };

    await Dynamo.write(data, tableName);

    return Responses._200({ message: 'connected!' });
};