db.createCollection("Contacts");

// Iterate over documents in the collection
db.PlayersSimple.find().forEach(function(doc) {
    // Iterate over Contacts in the document
    doc.contact.forEach(function(contact) {
        // Upsert contact into the Contacts collection
        db.Contacts.updateOne(
            { contact: contact },
            { $setOnInsert: { contact: contact } },
            { upsert: true }
        );
    });
});

db.PlayersSimple.aggregate([
    {
        $project: {
            contact: 0
        }
    },
    {
        $out: "PlayersBase" // Save the results to a new collection
    }
])

// Define triggers to make updates based on this collections to the original ones