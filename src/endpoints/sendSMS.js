import Responses from '../utils/API_Responses';
import AWS from 'aws-sdk';

const SNS = new AWS.SNS({ apiVersion: '2010-03-31' });

exports.handler = async event => {
    console.log('event', event);

    const body = JSON.parse(event.body);

    if (!body || !body.phoneNumber || !body.message) {
        return Responses._400({ message: 'missing phone number or message from body' });
    }

    const AttributeParams = {
        attributes: {
            DefaultSMSType: 'Promotional' // SNS types
        }
    };

    const messageParams = {
        Message: body.message,
        PhoneNumber: body.phoneNumber
    };

    try {
        await SNS.setSMSAttributes(AttributeParams).promise();
        await SNS.publish(messageParams).promise();
        return Responses._200({ message: 'text has been sent' });
    } catch (error) {
        console.log('error sending message', error);
        return Responses._400({ message: 'error sending SMS' });
    }
}