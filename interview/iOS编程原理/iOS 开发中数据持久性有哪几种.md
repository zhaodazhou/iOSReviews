# 数据持久性方式

## 在iOS开发中，数据持久性是指将数据保存到可长时间存储的介质中，以便在应用关闭或设备重启后仍然可以访问这些数据。iOS提供了多种不同的数据持久性方案，根据不同的需求和数据复杂性选择合适的方案。以下是常见的几种数据持久性方案：

### 1. **NSUserDefaults**

`NSUserDefaults`适用于存储少量的、简单的键值对数据。通常用于存储应用设置、用户偏好等信息。

```objective-c
// 保存数据
[[NSUserDefaults standardUserDefaults] setObject:@"John" forKey:@"username"];
[[NSUserDefaults standardUserDefaults] synchronize];

// 读取数据
NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
```

### 2. **文件系统**

iOS 提供了访问本地文件系统的能力，可以将数据保存为文件。适用于保存较大的、结构化的或者非结构化的数据，如日志文件、缓存数据。

#### 2.1 文本文件

```objective-c
// 获取Document目录路径
NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
NSString *filePath = [documentsPath stringByAppendingPathComponent:@"example.txt"];

// 写文件
NSString *content = @"Hello, iOS!";
[content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

// 读文件
NSString *savedContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
```

#### 2.2 数据归档（NSCoding）

适用于存储复杂对象。通过实现 `NSCoding`协议，可以将对象归档到文件中，也可以从文件中解档。

```objective-c
@interface Person : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation Person
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _age = [coder decodeIntegerForKey:@"age"];
    }
    return self;
}
@end

// 保存
Person *person = [[Person alloc] init];
person.name = @"John";
person.age = 30;
[NSKeyedArchiver archiveRootObject:person toFile:filePath];

// 读取
Person *decodedPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
```

### 3. **SQLite**

SQLite 是一种轻量级的关系型数据库，适用于结构化数据的存储，支持复杂的查询和事务操作。可以使用原生的C接口，也可以使用第三方库如FMDB进行操作。

#### 3.1 原生SQLite

```objective-c
#import <sqlite3.h>
sqlite3 *db;
sqlite3_open([filePath UTF8String], &db);
char *errMsg;
const char *sql_stmt = "CREATE TABLE IF NOT EXISTS Users (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT)";
sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg);
sqlite3_close(db);
```

#### 3.2 FMDB

```objective-c
#import "FMDB.h"
FMDatabase *db = [FMDatabase databaseWithPath:filePath];
[db open];
[db executeUpdate:@"CREATE TABLE IF NOT EXISTS Users (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT)"];
[db executeUpdate:@"INSERT INTO Users (NAME) values (?)", @"John"];
FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Users"];
while ([resultSet next]) {
    NSString *name = [resultSet stringForColumn:@"NAME"];
    NSLog(@"User: %@", name);
}
[db close];
```

### 4. **Core Data**

Core Data 是苹果公司提供的对象图和持久化框架，适用于需要对象关系管理（ORM）、对象图托管和依赖管理的复杂数据模型。它支持自动生成的模型和对象关系、多线程等。

```objective-c
// 获取NSManagedObjectContext
NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] persistentContainer].viewContext;

// 插入数据
Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
person.name = @"John";
person.age = 30;
NSError *error;
[context save:&error];

// 查询数据
NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
for (Person *person in results) {
    NSLog(@"User: %@", person.name);
}
```

### 5. **Keychain**

Keychain适用于存储需要高安全级别的数据，如用户密码和其他敏感信息。Keychain服务提供了加密的存储机制，确保数据的安全性。

```objective-c
#import <Security/Security.h>

// 保存数据到Keychain
NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
[keychainItem setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
[keychainItem setObject:@"com.example.KeychainDemo" forKey:(__bridge id)kSecAttrService];
[keychainItem setObject:@"username" forKey:(__bridge id)kSecAttrAccount];
[keychainItem setObject:[@"password" dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);

// 从Keychain读取数据
NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
[keychainQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
[keychainQuery setObject:@"com.example.KeychainDemo" forKey:(__bridge id)kSecAttrService];
[keychainQuery setObject:@"username" forKey:(__bridge id)kSecAttrAccount];
[keychainQuery setObject:(id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
[keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
CFTypeRef result = NULL;
status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, &result);
NSData *data = (NSData *)result;
NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
```

### 总结

iOS 中提供了多种数据持久化方案，从简单的 `NSUserDefaults` 到强大的 `Core Data` 和 `SQLite`，开发者可以根据具体需求选择合适的持久化方式，以满足不同的数据存储需求。这些持久化方式各有优劣，需要综合考虑数据结构、读写频率、安全性要求等因素来做出选择。