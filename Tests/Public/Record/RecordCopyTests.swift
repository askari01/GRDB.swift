import XCTest
#if SQLITE_HAS_CODEC
    import GRDBCipher
#else
    import GRDB
#endif

private class Person : Record {
    var id: Int64!
    var name: String!
    var age: Int?
    var creationDate: NSDate
    
    init(id: Int64?, name: String?, age: Int?, creationDate: NSDate) {
        self.id = id
        self.name = name
        self.age = age
        self.creationDate = creationDate
        super.init()
    }
    
    // Record
    
    required init(_ row: Row) {
        id = row.value(named: "id")
        age = row.value(named: "age")
        name = row.value(named: "name")
        creationDate = row.value(named: "creationDate")
        super.init(row)
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "id": id,
            "name": name,
            "age": age,
            "creationDate": creationDate,
        ]
    }
}

class RecordCopyTests: GRDBTestCase {
    
    func testRecordCopy() {
        let person1 = Person(id: 123, name: "Arthur", age: 41, creationDate: NSDate())
        let person2 = person1.copy()
        XCTAssertTrue(person2.id == person1.id)
        XCTAssertTrue(person2.name == person1.name)
        XCTAssertTrue(person2.age == person1.age)
        XCTAssertTrue(abs(person2.creationDate.timeIntervalSinceDate(person1.creationDate)) < 1e-3)
    }
}
