'use strict'
const AWS = require('aws-sdk')

exports.handler = (event, context, callback) => {
  const codepipeline = new AWS.CodePipeline()

  const params = {
    name: 'mycode-rip-app'
  }

  codepipeline.startPipelineExecution(params , (error, data) => {
    if (error) {
      console.log(error, error.stack)
    } else {
      console.log(data)
    }
  })
}
