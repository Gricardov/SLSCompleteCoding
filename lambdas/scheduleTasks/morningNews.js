const AWS = require('aws-sdk');
const Axios = require('axios').default;
const Responses = require('../common/API_Responses');

const SES = new AWS.SES();

const newsURL = 'https://newsapi.org'

exports.handler = async event => {
    console.log('event', event);

    const techNews = await getNews();

    const emailHTML = createEmailHTML(techNews);

    const params = {
        Destination: {
            ToAddresses: ['gricardov@gmail.com']
        },
        Message: {
            Body: {
                Html: { Data: emailHTML }
            },
            Subject: { Data: 'Morning Tech News' }
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

const createEmailHTML = techNews => {
    return `
    <html>
        <body>
            <h1>Top Tech News</h1>
            ${techNews.map(article => {
        return `
                <h3>${article.title}</h3>
                <p>${article.description}</p>
                <a href=${article.url}><button>Read More</button></a>
                `
    })}
        </body>
    </html>`
}

const getNews = async () => {
    const options = {
        params: {
            q: 'technology',
            language: 'en'
        },
        headers: {
            'X-Api-Key': 'c2dffefde4a4416da67b8386eaa1aa79'
        }
    }

    const { data: newsData } = await Axios.get(`${newsURL}/v2/top-headlines`, options);
    
    if (!newsData) {
        throw Error('No data from the news API');
    }

    return newsData.articles.slice(0, 5);
}

