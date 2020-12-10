const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const processResponse = require('./process-response');
const TABLE_NAME = "covid19"
const IS_CORS = true;
const LIMIT = 300

exports.handler = async event => {
  if (event.httpMethod === 'OPTIONS') {
    return processResponse(IS_CORS);
  }
  let params = {
    TableName: TABLE_NAME,
    Limit: LIMIT,
    Segment: getSegment()
  }
  try {
    const response = await dynamoDb.scan(params).promise();
    return processResponse(true, response.Items);
  } catch (dbError) {
    let errorResponse = `Error: Execution update, caused a Dynamodb error, please look at your logs.`;
    if (dbError.code === 'ValidationException') {
      if (dbError.message.includes('reserved keyword')) errorResponse = `Error: You're using AWS reserved keywords as attributes`;
    }
    console.log(dbError);
    return processResponse(IS_CORS, errorResponse, 500);
  }
};

function getSegment(){
    return getRandomArbitrary(0,1000000/LIMIT)
}

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
  }