'use strict'

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request
    const requestUri = request.uri
    let replacedUri

    // 末尾がスラッシュであればindex.htmlを追記して返す
    replacedUri = requestUri.replace(/\/$/, '/index.html');

    // 末尾がスラッシュではなくかつ拡張子がなければ、/index.htmlを追記して返す
    const splittedBySlash = requestUri.split('/')
    const lastPath = splittedBySlash[splittedBySlash.length - 1]
    if (lastPath.length > 0 && lastPath.indexOf('.') === -1) {
      replacedUri = request.uri + '/index.html'
    }

    request.uri = replacedUri

    callback(null, request)
}
