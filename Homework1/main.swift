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
        let url = URL(fileURLWithPath: path);
        do
        {
            let data = try Data(contentsOf: url);
            return try JSONDecoder().decode(Students.self, from: data);
        } catch
        {
            throw error;
        }
    }
}

do
{
    let students = try ModelParser().decode(path: "/Users/kerbi/Projects/Homework1/Homework1/students.json");
    print(students);
    print("Max students age: \(students.students.map { $0.age ?? 0 }.max()!)");
} catch { print(error); }

// task 3

class TreeNode
{
    var value: Int;
    var children: [TreeNode?];
    
    init(value: Int, children: [TreeNode])
    {
        self.value = value;
        self.children = children;
    }
}

func createTree(childrenRangeStart x: Int, childrenRangeEnd y: Int, depth: Int) -> TreeNode?
{
    if ((x < 0 || y <= 0) || (x >= y))
    {
        return nil;
    }
    else if (depth <= 0)
    {
        return TreeNode(value: 0, children: []);
    }
    
    var children: [TreeNode] = [];
    let childrenCount = Int.random(in: x...y);
    for i in 0...childrenCount
    {
        if let child = createTree(childrenRangeStart: x, childrenRangeEnd: y, depth: depth - i - 1)
        {
            children.append(child);
        }
        else { return nil; }
    }
    return TreeNode(value: depth, children: children);
}

func recursiveTraverse(_ node: TreeNode?){
    guard let node = node else { return }
    print(node.value)
    for child in node.children
    {
        recursiveTraverse(child)
    }
}

let deepTreeRoot = createTree(childrenRangeStart: 2, childrenRangeEnd: 10, depth: 10)
recursiveTraverse(deepTreeRoot)

print("Done")
