const AWS = require('aws-sdk');
// FaaS based on https://github.com/simalexan/api-lambda-save-dynamodb
// Thanks to Aleksandar Simovic
// Adapted by Leonardo Reboucas de Carvalho

const dynamoDb = new AWS.DynamoDB.DocumentClient();
const processResponse = require('./process-response.js');
const TABLE_NAME = "covid19"
const  IS_CORS = true;
exports.handler = async event => {
  if (event.httpMethod === 'OPTIONS') {
    return processResponse(IS_CORS);
  }
  if (!event.body) {
    return processResponse(IS_CORS, 'invalid', 400);
  }
  const item = JSON.parse(event.body);
  item['pk'] = getID();
  const params = {
    TableName: TABLE_NAME,
    Item: item
  }
  try {
    await dynamoDb.put(params).promise()
    return processResponse(IS_CORS);
  } catch (error) {
    let errorResponse = `Error: Execution update, caused a Dynamodb error, please look at your logs.`;
    if (error.code === 'ValidationException') {
      if (error.message.includes('reserved keyword')) errorResponse = `Error: You're using AWS reserved keywords as attributes`;
    }
    console.log(error);
    return processResponse(IS_CORS, errorResponse, 500);
  }
};

function getID(){
  return parseInt(process.hrtime())
}