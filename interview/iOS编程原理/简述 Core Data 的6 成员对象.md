# 简述 Core Data 的6 成员对象

## Core Data 是 iOS 和 macOS 中强大的对象图管理和持久化框架。它提供了一个模型层，用于管理应用程序的数据模型和对象图，并支持对数据进行持久化存储。Core Data 的功能主要通过六个核心类来实现，分别是 `NSManagedObjectContext`、`NSManagedObjectModel`、`NSPersistentStoreCoordinator`、`NSPersistentStore`、`NSManagedObject` 和 `NSFetchRequest`

以下是对 Core Data 六个核心类的简要介绍：

### 1. **NSManagedObjectContext (上下文)**

- **作用**：`NSManagedObjectContext` 是一个临时的"scratchpad"，用于管理对象图中的一组模型对象。它负责在对象层（应用内存）与持久化存储（磁盘）之间进行数据交互。
- **职责**：管理对象的生命周期、追踪对象的变化、保存数据到持久化存储、处理线程的上下文等。

   ```objective-c
   NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] persistentContainer].viewContext;
   ```

### 2. **NSManagedObjectModel (数据模型)**

- **作用**：`NSManagedObjectModel` 描述了应用程序的数据模型，包括实体、属性和关系。其设计类似于数据库的模式(schema)。
- **职责**：定义数据模型（通常由 Xcode 的数据模型编辑器生成 `*.xcdatamodeld` 文件），并提供模型信息给 `NSPersistentStoreCoordinator`。

   ```objective-c
   NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
   NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
   ```

### 3. **NSPersistentStoreCoordinator (存储协调器)**

- **作用**：`NSPersistentStoreCoordinator` 负责协调不同类型的持久化存储，它管理持久化存储的连接，并调度对象图与存储之间的数据交互。
- **职责**：协调 `NSManagedObjectContext` 和一个或多个 `NSPersistentStore` 之间的通信，确保数据持久化存储。

   ```objective-c
   NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
   NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppData.sqlite"];
   NSError *error = nil;
   [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
   ```

### 4. **NSPersistentStore (持久化存储)**

- **作用**：`NSPersistentStore` 是持久化数据的实际存储位置，支持不同类型的存储格式如 SQLite、XML、二进制文件等。
- **职责**：为数据提供物理存储机制。

   ```objective-c
   NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
   ```

### 5. **NSManagedObject (托管对象)**

- **作用**：`NSManagedObject` 是 Core Data 模型中数据的实例，代表数据库中的一行数据。它可以是具体的实体类或者直接使用 `NSManagedObject`。
- **职责**：负责封装数据，并提供对数据模型属性的访问和修改功能。

   ```objective-c
   NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
   [person setValue:@"John" forKey:@"name"];
   [person setValue:@30 forKey:@"age"];
   ```

### 6. **NSFetchRequest (提取请求)**

- **作用**：`NSFetchRequest` 用于从持久化存储中提取数据，通过指定条件从数据存储中获取满足条件的数据。
- **职责**：配置查询参数（如实体名称、谓词、排序描述符等），并执行数据提取请求。

   ```objective-c
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
   fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > %d", 25];
   NSError *error = nil;
   NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
   for (NSManagedObject *person in results) {
       NSLog(@"User: %@", [person valueForKey:@"name"]);
   }
   ```

### 总结

Core Data 的六个核心类各司其职，共同构成了一个强大的对象图管理和持久化框架。理解和合理使用这些类，可以帮助开发者高效地管理应用程序中的数据模型，提高应用程序的可靠性和可维护性。