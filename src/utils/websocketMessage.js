import AWS from 'aws-sdk';

export const create = (domainName, stage) => {
    const endpoint = `${domainName}/${stage}`;
    return new AWS.ApiGatewayManagementApi({
        apiVersion: '2018-11-29',
        endpoint,
    });
};

export const send = ({ domainName, stage, connectionID, message }) => {
    const ws = create(domainName, stage);

    const postParams = {
        Data: message,
        ConnectionId: connectionID
    };

    return ws.postToConnection(postParams).promise();
};
