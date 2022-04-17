import { queryDB } from '../rds/pool';

export async function getLunasByRateAndDateDesc(limit = 3) {
    //const { editorialId, serviceId } = req.params;
    const membersRes = await queryDB('SELECT * FROM LUNAS', []);
    return membersRes;
};

/*export async function getLunasByRateAndDateDesc(limit = 3) {
    const params = {
        TableName: process.env.process.env.LUNAS_TABLE_NAME,
        IndexName: 'popularityPlusCreatedAtIndex',
        //KeyConditionExpression: 'idDestinatario = :idDestinatario',
        Limit: limit,
        //ExpressionAttributeValues: {
        //    ':idDestinatario': id
        //},
        ProjectionExpression: 'storyId, authorId, createdAt, popularity',
        ScanIndexForward: false // Sort key value DESC
    };
    const resultado = await dynamodb.query(params).promise();
    return resultado.Items;
}*/