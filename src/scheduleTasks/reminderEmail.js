import AWS from 'aws-sdk';
import Responses from '../utils/API_Responses';

const SES = new AWS.SES();

exports.handler = async event => {
    console.log('event', event);

    const message = `Hey chamx!
    
    Hola.`

    const params = {
        Destination: {
            ToAddresses: ['gricardov@gmail.com']
        },
        Message: {
            Body: {
                Text: { Data: message }
            },
            Subject: { Data: 'reminder email!' }
        },
        Source: 'gricardov@gmail.com'
    };

    try {
        await SES.sendEmail(params).promise();
        return Responses._200({ message: 'email sent!' });
    } catch (error) {
        console.log('error sending email', error);
        return Responses._400({ message: 'failed to send the email' });
    }
}