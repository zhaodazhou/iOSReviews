# iOS ShareExtension 记录  

ShareExtension 是 iOS 系统开放给第三方应用的一个系统分享入口的扩展功能，APP 可以通过实现此功能来接收系统分享功能中的数据，比如图片、视频等。此文记录实现过程中的一些关键点。  

## 自定义视图  

将继承类 SLComposeServiceViewController 修改为自定义类，比如 UIViewController

## 配置接收的文件类型  

在 Extension 的 Info 配置项中，增加 NSExtension - NSExtensionActionRule - NSExtensionActivationSupportsImageWithMaxCount，设置为 String 类型，值为 1，表示接收图片类型的分享，且最多接收 1 张。  

## 解析数据  

系统将分享的数据是放在 extensionContext 中，需要手动将需要的数据解析出来，具体方式如下:  

```Objective-C

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleShareFiled:^(NSMutableArray *shareList) {
        if (shareList.count > 0) {
            NSUserDefaults * userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.bundle.identifer"];
            [userDefaults setObject:[shareList yy_modelToJSONString] forKey:kESShareExtensionDataKey];
            [userDefaults synchronize];
            [self openMainApp];
            [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
        } else {
            NSError * error;
            [self.extensionContext cancelRequestWithError:error];
            if (error) {
                NSLog(@"[ShareExtension] cancel Request error:%@", error);
            }
        }
    }];
}

// 判断分享数据的文件类型，读取文件的地址
- (void)handleShareFiled:(void (^)(NSMutableArray * shareList))block {
    NSMutableArray * shareList = [NSMutableArray array];
    NSExtensionItem * attachments = self.extensionContext.inputItems.firstObject;
    NSArray<NSItemProvider *> * providerList = attachments.attachments;
    if (providerList.count == 0) {
        NSError * error;
        [self.extensionContext cancelRequestWithError:error];
        return;
    }
    
    [providerList enumerateObjectsUsingBlock:^(NSItemProvider * _Nonnull provider, NSUInteger idx, BOOL * _Nonnull stop) {
        // Check if the content type is the same as we expected
        NSString * contentType;
        if ([provider hasItemConformingToTypeIdentifier:ESSETypeImage]) {
            contentType = ESSETypeImage;
        } else if ([provider hasItemConformingToTypeIdentifier:ESSETypeMovie]) {
            contentType = ESSETypeMovie;
        } else if ([provider hasItemConformingToTypeIdentifier:ESSETypeFile]) {
            contentType = ESSETypeFile;
        }
        
        if (contentType) {
            [provider loadItemForTypeIdentifier:contentType options:nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                if (error) {
                    return;
                }
                
                if ([item isKindOfClass:NSURL.class]) {
                    ESShareExtesionModel * model = [self transfer:item];
                    if (model) {
                        [shareList addObject:model];
                    }
                }
                
                if (idx == providerList.count - 1 && block) {
                    block(shareList);
                }
            }];
        }
    }];
}

// 将分享的数据 copy 到指定目录中，便于主 APP 中进行读取
- (ESShareExtesionModel *)transfer:(__kindof id<NSSecureCoding>  _Nullable)item {
    if ([item isKindOfClass:NSURL.class]) {
        ESShareExtesionModel * model = [[ESShareExtesionModel alloc] init];
        NSURL * url = (NSURL *)item;
        model.fileName = url.lastPathComponent;
        NSURL * appGroupUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.bundle.identifer"];
        NSURL * fileUrl = [appGroupUrl URLByAppendingPathComponent:url.lastPathComponent];
        NSError * error;
        NSString * tmpPath = [fileUrl.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
            NSError * error;
            [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:&error];
        }
        [[NSFileManager defaultManager] copyItemAtURL:url toURL:fileUrl error:&error];
        if (error) {

        } else {
            return model;
        }
    }
    return nil;
}

// 通过 Universal Link 调起主 APP
- (void)openMainApp {
    UIResponder * responser = self;
    while (responser != nil) {
        if ([responser isKindOfClass:UIApplication.class]) {
            UIApplication * application = (UIApplication *)responser;
            if ([application respondsToSelector:@selector(openURL:)]) {
                NSURL * url = [NSURL URLWithString:@"https://xxx?opt=shareExtension"];
                [application performSelector:@selector(openURL:) withObject:url];
                return;
            }
        }

        responser = responser.nextResponder;
    }
}
```  

其中宏定义如下：  

```text
// See CoreServices/UTCoreType.h
#define ESSETypeImage @"public.image"
#define ESSETypeMovie @"public.movie"
#define ESSETypeFile @"public.file-url"
```  

调起主 APP 的方式采用的是 Universal Link 的方式  

## 数据传递  

ShareExtension 与 主 APP 间数据通信通过 APP Group 方式，采用 NSUserDefaults 来存取，比如：

```Objective-C
NSUserDefaults * userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.bundle.identifer"];
```  

分享数据的存取采用 NSFileManager，进入主 APP 后需要将 ShareExtension 中要分享的数据移动到 APP 的沙盒中，如下：

```Objective-C
+ (void)transfer:(ESShareExtesionModel * _Nullable )shareModel {
    NSString * localPath = [[ESFileInfoPub baseDir] stringByAppendingPathComponent:shareModel.fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        NSError * error;
        [[NSFileManager defaultManager] removeItemAtPath:localPath error:&error];
    }
    
    NSURL * groupUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.bundle.identifer"];
    NSURL * url = [groupUrl URLByAppendingPathComponent:shareModel.fileName];
    NSError * error;
    BOOL su = [[NSFileManager defaultManager] moveItemAtURL:url toURL:[NSURL fileURLWithPath:localPath] error:&error];
    if (!su) {
        return nil;
    }

    NSString *thumbnailPath;
}
```  

## 读取文件信息  

主 APP 拿到的只有文件数据，如果需要读取文件创建时间等信息，需要额外处理，对于未编辑过的图片的处理方式如下：

```Objective-C
   CGImageSourceRef imgSrc = CGImageSourceCreateWithData((__bridge CFDataRef)[NSData dataWithContentsOfFile:localPath], NULL);
    CFDictionaryRef metadataDictionaryRef = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, NULL);
    NSDictionary *exifDictionary = (__bridge_transfer NSDictionary *)metadataDictionaryRef;
    NSDictionary *dic = exifDictionary[@"{Exif}"];
```

## 参考  

- [官网地址](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html)  
- [iOS Share extension — Swift 5.1](https://medium.com/macoclock/ios-share-extension-swift-5-1-1606263746b)