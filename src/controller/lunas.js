import { queryDB } from '../rds/pool';

export async function getLunasPreviewByPopularity(limit = 5) {
    const comRes = await queryDB('CALL USP_GET_LUNAS_PREVIEW_BY_POPULARITY(?)', [limit]);
    return comRes[0] || [];
};

export async function getLunaWithContentById(id) {
    const comRes = await queryDB('CALL USP_GET_LUNA_WITH_CONTENT_BY_ID(?)', [id]);
    return comRes[0][0] || {};
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