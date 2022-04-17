import Responses from '../utils/API_Responses';
import Dynamo from '../utils/Dynamo';

const tableName = process.env.tableName;

exports.handler = async event => {
    console.log('event', event);

    const { connectionId: connectionID } = event.requestContext;

    await Dynamo.delete(connectionID, tableName);

    return Responses._200({ message: 'disconnected' });
};