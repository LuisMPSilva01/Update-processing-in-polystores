db.PlayersSimple.aggregate([
    { $unwind: "$contact" }, // Unwind arrays
    {$project: {
        _id: 0
    }},
    {
        $out: "PlayersSimplegorda" // Save the results to a new collection
    }
])