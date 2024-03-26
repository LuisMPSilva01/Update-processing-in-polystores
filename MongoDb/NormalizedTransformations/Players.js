db.createCollection("Contacts");

// Iterate over documents in the collection
db.Players.find().forEach(function(doc) {
    // Iterate over Contacts in the document
    doc.contact.forEach(function(contact) {
        // Upsert contact into the Contacts collection
        db.Contacts.updateOne(
            // Match the contact and name
            { contact: contact, name: doc.name },
            // Update or insert the document with contact and name
            {
                $setOnInsert: {
                    contact: contact,
                    name: doc.name
                }
            },
            // Upsert option to insert if not found
            { upsert: true }
        );
    });
});


db.Players.aggregate([
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