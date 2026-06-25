Task 60:
db.createCollection("feedback")

Task 61:
db.feedback.insertMany([
{
    studentId: "S101",
    courseCode: "CS101",
    instructor: "Dr. Kumar",
    semester: "2025 Spring",
    rating: 5,
    comments: "Excellent teaching and clear explanations.",
    tags: ["engaging", "helpful"],
    attachments: ["notes1.pdf"]
},
{
    studentId: "S102",
    courseCode: "CS101",
    instructor: "Dr. Kumar",
    semester: "2025 Spring",
    rating: 4,
    comments: "Good course content.",
    tags: ["organized", "informative"],
    attachments: ["assignment.pdf"]
},
{
    studentId: "S103",
    courseCode: "CS101",
    instructor: "Dr. Kumar",
    semester: "2025 Fall",
    rating: 3,
    comments: "Could include more practical examples.",
    tags: ["average", "theory"]
},
{
    studentId: "S104",
    courseCode: "CS102",
    instructor: "Prof. Sharma",
    semester: "2025 Spring",
    rating: 5,
    comments: "Loved the lab sessions.",
    tags: ["practical", "interactive"],
    attachments: ["labwork.docx"]
},
{
    studentId: "S105",
    courseCode: "CS102",
    instructor: "Prof. Sharma",
    semester: "2025 Fall",
    rating: 2,
    comments: "Assignments were difficult.",
    tags: ["challenging"],
    attachments: ["report.pdf"]
},
{
    studentId: "S106",
    courseCode: "CS103",
    instructor: "Dr. Rao",
    semester: "2025 Spring",
    rating: 4,
    comments: "Interesting subject.",
    tags: ["interesting", "useful"],
    attachments: ["project.zip"]
},
{
    studentId: "S107",
    courseCode: "CS104",
    instructor: "Dr. Mehta",
    semester: "2025 Fall",
    rating: 1,
    comments: "Need better explanations.",
    tags: ["confusing"],
    attachments: ["feedback.txt"]
},
{
    studentId: "S108",
    courseCode: "CS105",
    instructor: "Prof. Singh",
    semester: "2025 Spring",
    rating: 5,
    comments: "Best course this semester.",
    tags: ["excellent", "well-paced"],
    attachments: ["certificate.pdf"]
},
{
    studentId: "S109",
    courseCode: "CS106",
    instructor: "Dr. Verma",
    semester: "2025 Fall",
    rating: 3,
    comments: "Average experience.",
    tags: ["average"],
    attachments: ["notes.pdf"]
},
{
    studentId: "S110",
    courseCode: "CS107",
    instructor: "Prof. Gupta",
    semester: "2025 Spring",
    rating: 4,
    comments: "Good support from instructor.",
    tags: ["supportive", "responsive"],
    attachments: ["assignment2.pdf"]
}
])

Task 64:
db.feedback.countDocuments()

Task 65:
db.feedback.find({
    rating: 5
})

Task 66:
db.feedback.find({
    courseCode: "CS101",
    tags: "challenging"
})

Task 67:
db.feedback.find(
    {},
    {
        _id: 0,
        studentId: 1,
        courseCode: 1,
        rating: 1
    }
)
Task 68:
db.feedback.updateMany(
    {
        rating: { $lt: 3 }
    },
    {
        $set: {
            needs_review: true
        }
    }
)

Task 69:
db.feedback.updateMany(
    {
        needs_review: true
    },
    {
        $push: {
            tags: "reviewed"
        }
    }
)

Task 70:
db.feedback.deleteMany({
    semester: "2021-EVEN"
})

Task 71:
db.feedback.aggregate([
    {
        $match: {
            semester: "2022-ODD"
        }
    },
    {
        $group: {
            _id: "$courseCode",
            avg_rating: { $avg: "$rating" },
            total_feedback: { $sum: 1 }
        }
    },
    {
        $sort: {
            avg_rating: -1
        }
    }
])

Task 72:
db.feedback.aggregate([
    {
        $match: {
            semester: "2022-ODD"
        }
    },
    {
        $group: {
            _id: "$courseCode",
            avg_rating: { $avg: "$rating" },
            total_feedback: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            courseCode: "$_id",
            average_rating: {
                $round: ["$avg_rating", 1]
            },
            total_feedback: 1
        }
    },
    {
        $sort: {
            average_rating: -1
        }
    }
])

Task 73:
db.feedback.aggregate([
    {
        $unwind: "$tags"
    },
    {
        $group: {
            _id: "$tags",
            count: { $sum: 1 }
        }
    },
    {
        $sort: {
            count: -1
        }
    }
])

Task 4:
db.feedback.createIndex({
    courseCode: 1
})