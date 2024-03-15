db.Players.aggregate([
    { $unwind: "$contact" }, // Unwind arrays
    {$project: {
        _id: 0
    }},
    {
        $out: "Playersgorda" // Save the results to a new collection
    }
])