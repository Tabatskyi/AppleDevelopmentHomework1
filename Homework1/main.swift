import Foundation;
// task 1
func gnomeSort(array: inout [Int]) -> [Int]
{
    var position: Int = 0;
    while (position < array.count)
    {
        if (position == 0 || array[position] >= array[position - 1])
        {
            position += 1;
        }
        else
        {
            array.swapAt(position, position - 1);
            position -= 1;
        }
    }
    return array;
}

var testData = [35, 12, 43, 8, 51, 27, 19, 3, 47, 30];
print(gnomeSort(array: &testData));

let testDataSize: Int = 10000;
testData = (0..<testDataSize).map { _ in .random(in: 1...200000) }  // https://stackoverflow.com/questions/28140145/create-an-array-of-random-numbers-in-swift

let defaultSortStart = Date();  // https://stackoverflow.com/questions/2129794/how-to-log-a-methods-execution-time-exactly-in-milliseconds
let defaultSortedArray: [Int] = testData.sorted();
let defaultSortFinish = Date();
let defaultSortTime = defaultSortFinish.timeIntervalSince(defaultSortStart);
print("Execution time of default sort: \(defaultSortTime) seconds");

let gnomeSortStart = Date();
let gnomeSortedArray: [Int] = gnomeSort(array: &testData);
let gnomeSortFinish = Date();
let gnomeSortTime = gnomeSortFinish.timeIntervalSince(gnomeSortStart);
print("Execution time of gnome sort: \(gnomeSortTime) seconds");

// task 2
struct Student : Codable
{
    var id: Int;
    var name: String;
    var age: Int?;
    var subjects: [String]?;
    var address: Dictionary<String, String?>?;
    var scores: Dictionary<String, Int?>?;
    var hasScholarship: Bool?;
    var graduationYear: Int?;
}

struct Students : Codable
{
    var students: [Student];
}

class ModelParser
{
    func decode(path: String) throws -> Students
    {
        enum ParserError: Error
        {
            case fileParsingFailed(name: String, Error)
        }
        
        let url = URL(fileURLWithPath: path)
        do
        {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Students.self, from: data)
        } catch
        {
            throw ParserError.fileParsingFailed(name: path, error)
        }
    }
}

do
{
    let students = try ModelParser().decode(path: "/Users/kerbi/Projects/Homework1/Homework1/students.json")
    print(students)
} catch { print(error) }

