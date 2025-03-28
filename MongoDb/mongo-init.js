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

//createCollectionAndInsertDocuments(testDB, 'shop', '/MongoDb/Collections/shop.json');
//createCollectionAndInsertDocuments(testDB, 'zips', '/MongoDb/Collections/zips.json');
//createCollectionAndInsertDocuments(testDB, 'cities', '/MongoDb/Collections/cities.json');
//createCollectionAndInsertDocuments(testDB, 'example', '/MongoDb/Collections/unwindExample.json');
createCollectionAndInsertDocuments(testDB, 'Players', '/MongoDb/Collections/Players.json');
//createCollectionAndInsertDocuments(testDB, 'ReversedKeyMap', '/MongoDb/Collections/reversedKeyMap.json');

// Create a user with read and write privileges for the database
testDB.createUser({
  user: 'admin',
  pwd: 'admin',
  roles: [
    { role: 'userAdminAnyDatabase', db: 'admin' }
  ]
});

//Carregar a gorda
//load('/MongoDb/AggregationPipeline/unwind.js');

//Carregar unwind example
//load('/MongoDb/AggregationPipeline/unwindExample.js');

//Unwind players
//load('/MongoDb/AggregationPipeline/unwindPlayers.js');

//Normalized players
//load('/MongoDb/NormalizedTransformations/Players.js');