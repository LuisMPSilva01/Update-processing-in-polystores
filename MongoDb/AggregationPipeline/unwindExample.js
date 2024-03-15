db.example.aggregate([
    { $project: { "_id": 1, "h": 1} },
    { $unwind: "$h" },
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
        $out: "h_table" // Save the results to a new collection
    }
  ])

db.example.aggregate([
    { $project: { "_id": 1, "w": 1} },
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
        $out: "w_table" // Save the results to a new collection
    }
])
  