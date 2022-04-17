import AWS from 'aws-sdk';

const documentClient = new AWS.DynamoDB.DocumentClient();

const Dynamo = {
    async get(ID, TableName) {
        const params = {
            TableName,
            Key: {
                storyId: ID
            }
        };

        const data = await documentClient.get(params).promise();

        if (!data || !data.Item) {
            throw Error(`There was an error fetching the data for ID of ${ID} from ${TableName}`);
        }
        console.log(data);

        return data.Item;
    },
    async write(data, TableName) {
        // Check if data has an id
        if (!data.ID) {
            throw Error('No ID on data');
        }

        const params = {
            TableName,
            Item: data
        };

        const res = await documentClient.put(params).promise();

        if (!res) {
            throw Error(`There was an error inserting ID of${data.ID} in table ${TableName}`);
        }

        return data;
    },
    async delete(ID, TableName) {
        const params = {
            TableName,
            Key: {
                ID
            }
        };

        return documentClient.delete(params).promise();
    }
};

export default Dynamo;