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

// default sort is much more efficient than gnome sort, approximately, default sort is 360 times faster than gnome

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
    let students: [Student];
    init(path: String) throws
    {
        let url = URL(fileURLWithPath: path);
        do
        {
            let data = try Data(contentsOf: url);
            students = try JSONDecoder().decode(Students.self, from: data).students;
        } catch
        {
            throw error;
        }
    }
    func unwrap<T>(value: T?) -> String
    {
        if (value != nil)
        {
            return String(describing: value!);
        }
        else
        {
            return "N/A"
        }
    }
    func printStudents()
    {
        for student in students
        {
            print("Student ID: \(student.id), Name: \(student.name), Age: \(unwrap(value: student.age)), Subjects: \(unwrap(value: student.subjects)), Adress: \(unwrap(value: student.address)), Scores: \(unwrap(value: student.scores)), Scholarship: \(unwrap(value: student.hasScholarship)), Graduation Year: \(unwrap(value: student.graduationYear))")
        }
    }
    func findOldestStudents()
    {
        let sortedStudents = students.sorted(by: {$0.age ?? 0 > $1.age ?? 0});
        let maxAge = sortedStudents[0].age;
        if (maxAge == nil)
        {
            print("There is no age of any student in data")
            return
        }
        var oldestStudents: [String] = [];
        for student in sortedStudents
        {
            if (student.age == maxAge)
            {
                oldestStudents.append(student.name);
            }
        }
        print("Oldest students: \(oldestStudents.joined(separator: ", ")), with age of \(maxAge!)")  // https://stackoverflow.com/questions/25827033/how-do-i-convert-a-swift-array-to-a-string
    }
}

do
{
    let model = try ModelParser(path: "/Users/kerbi/Projects/Homework1/Homework1/students.json");
    model.printStudents();
    model.findOldestStudents();
} catch { print(error); }

// task 3

class TreeNode
{
    var value: Int;
    var children: [TreeNode];
    
    init(value: Int)
    {
        self.value = value;
        self.children = [];
    }
    
    func addChild(_ node: TreeNode)
    {
        self.children.append(node);
    }
    
    func DFSSearch(value: Int, depth: Int = 0) -> Bool
    {
        print("\(String(repeating: " ", count: depth)) Node with value \(self.value)");  // https://stackoverflow.com/questions/27806693/create-a-string-with-n-blank-spaces-or-other-repeated-character
        if (self.value == value)
        {
            print("Found \(value)");
            return true;
        }
        for child in children
        {
            if child.DFSSearch(value: value, depth: (depth + 1))
            {
                return true
            }
        }
        return false;
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
        return TreeNode(value: 0);
    }
    
    let childrenCount = Int.random(in: x...y);
    let node = TreeNode(value: abs(depth - childrenCount));
    for _ in 0..<childrenCount
    {
        if let child = createTree(childrenRangeStart: x, childrenRangeEnd: y, depth: depth - 1)
        {
            node.addChild(child);
        }
        else { return nil; }
    }
    return node;
}

guard let treeRoot = createTree(childrenRangeStart: 2, childrenRangeEnd: 5, depth: 10) else
{
    print("Error in creating tree");
    exit(1);
}
let valueToFind = 222;
if (!treeRoot.DFSSearch(value: valueToFind))
{
    print("Not found \(valueToFind) in tree");
}
print("Done");
