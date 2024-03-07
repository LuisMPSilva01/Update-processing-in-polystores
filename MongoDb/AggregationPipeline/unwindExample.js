db.example.aggregate([
    { $unwind: "$h" }, // Unwind arrays
    { $unwind: "$w" },
    {
        $addFields: {
            original_id: "$_id" // Rename id to original_id
        }
    },
    {
        $project: {
            size: 0,
            _id: 0 // Remove the rest of the json
        }
    },
    {
        $out: "unwindExample" // Save the results to a new collection
    }
  ])
  