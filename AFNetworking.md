# AFNetworking

## 1. AFSecurityPolicy



```objectivec
typedef NS_ENUM(NSUInteger, AFSSLPinningMode) {
    AFSSLPinningModeNone,
    AFSSLPinningModePublicKey,
    AFSSLPinningModeCertificate,
};
```

一个枚举类型，定义了HTTPS的三种验证模式：
 `AFSSLPinningModeNone`这个模式本地没有保存证书，只验证服务器证书是不是系统受信任证书列表里的证书签发的。
 `AFSSLPinningModePublicKey`这个模式表示本地存有证书，验证证书的有效期等信息，也就是将本地证书设置为锚点证书，然后验证证书有效性，再判断本地证书和服务器证书是否一致。
 `AFSSLPinningModeCertificate`这个模式同样是本地存有证书，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。



```objectivec
/**
  只读属性，证书验证模式，只能在初始化的时候设置
 */
@property (readonly, nonatomic, assign) AFSSLPinningMode SSLPinningMode;

/**
 本地证书的集合
 */
@property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

/**
 是否允许无效的证书，默认是NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 是否验证域名，默认是YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;
```

```objectivec
/**
 返回指定目录下的证书
*/
+ (NSSet <NSData *> *)certificatesInBundle:(NSBundle *)bundle;

/**
 默认验证策略的初始化
 */
+ (instancetype)defaultPolicy;

/**
 根据制定的验证模式初始化
 */
+ (instancetype)policyWithPinningMode:(AFSSLPinningMode)pinningMode;

/**
 根据指定的验证模式和本地证书初始化
 */
+ (instancetype)policyWithPinningMode:(AFSSLPinningMode)pinningMode withPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates;

/**
 返回服务器证书是否能够被信任，在NSUrlSessionDelegate的`URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler`方法中被调用
serverTrust 服务器证书验证对象
domain      域名
 */
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(nullable NSString *)domain;
```

```objectivec
static id AFPublicKeyForCertificate(NSData *certificate) {
    id allowedPublicKey = nil;
    SecCertificateRef allowedCertificate;
    SecCertificateRef allowedCertificates[1];
    CFArrayRef tempCertificates = nil;
    SecPolicyRef policy = nil;
    SecTrustRef allowedTrust = nil;
    SecTrustResultType result;

    /**
     certificate转换为SecCertificateRef类型的证书
     certificate 通过(__bridge CFDataRef)转换成 CFDataRef
     allocator CFAllocator分配证书。
     data DER编码的X.509证书。
     */
    allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificate);
    //allowedCertificate如果是空跳转到_out
    __Require_Quiet(allowedCertificate != NULL, _out);

    // 给allowedCertificates赋值
    allowedCertificates[0] = allowedCertificate;
    // 新建CF数组 tempCertificates
    tempCertificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);
    
    //  新建policy为X.509
    policy = SecPolicyCreateBasicX509();
    // 根据证书、验证策略、创建SecTrustRef对象赋值给allowedTrust，如果出错就跳到_out标记处
    __Require_noErr_Quiet(SecTrustCreateWithCertificates(tempCertificates, policy, &allowedTrust), _out);
    // 校验证书，出错跳转到_out。
    __Require_noErr_Quiet(SecTrustEvaluate(allowedTrust, &result), _out);

    //copy出allowedTrust的公钥
    allowedPublicKey = (__bridge_transfer id)SecTrustCopyPublicKey(allowedTrust);

_out:
    ...

    return allowedPublicKey;
}
```

这个函数就是获取证书文件的公钥，需要了解的知识点都写在注释里了，看一下就可以了。