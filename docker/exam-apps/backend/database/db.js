const dbHost = process.env.DB_HOST || '127.0.0.1'
const dbPort = process.env.DB_PORT || 27017
const dbName = process.env.DB_NAME

module.exports = {
    db: 'mongodb://' + dbHost + ':' + dbPort + '/' + dbName
};
