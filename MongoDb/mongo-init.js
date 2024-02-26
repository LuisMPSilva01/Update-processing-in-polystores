// mongo-init.js
// Create a new database and switch to it
var testDB = db.getSiblingDB('test');

const fs = require('fs');

function createCollectionAndInsertDocuments(database, collectionName, jsonFilePath) {
    database.createCollection(collectionName);
    var collection = database.getCollection(collectionName);
    var jsonData = fs.readFileSync(jsonFilePath, 'utf8');
    var documents = JSON.parse(jsonData);
    collection.insertMany(documents);
}

createCollectionAndInsertDocuments(testDB, 'shop', '/Collections/shop.json');
createCollectionAndInsertDocuments(testDB, 'zips', '/Collections/zips.json');
createCollectionAndInsertDocuments(testDB, 'cities', '/Collections/cities.json');

// Create a user with read and write privileges for the database
testDB.createUser({
  user: 'admin',
  pwd: 'admin',
  roles: [
    { role: 'userAdminAnyDatabase', db: 'admin' }
  ]
});