//
//  HttpsManager.m
//  球汉
//
//  Created by Albert on 3/27/17.
//  Copyright © 2017 smith. All rights reserved.
//

#import "HttpsManager.h"
#import "IPAdress.h"

#define TIMEOUT 60 //请求超时时间
#define TEST_FORM_BOUNDARY @"BABABABABABBABA"

#define BMEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation HttpsManager
-(void)getServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock
{
   
    NSMutableDictionary  *dicc = [self getBaseMsg:dic];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =TIMEOUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    [manager GET:api parameters:dicc progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 1)
        {
            if ([[responseObject objectForKey:@"code"] integerValue] == 100003) {
                return ;
                
            }
            else
            {
                return ;
            }
        
        }
        else
        {
        
            successBlock(responseObject);
            return;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

-(void)postServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock
{
    [dic addEntriesFromDictionary:[self getBaseMsg:dic]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =TIMEOUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    NSLog(@"post_dic==>%@api==>%@",dic,api);
    [manager POST:api parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post_responseObject===>%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 1)
        {
            if ([[responseObject objectForKey:@"code"] integerValue] == 100003) {
                return ;
            }
            else
            {
                return ;
            }

        }
        else
        {
            successBlock(responseObject);
            return;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        return ;
    } ];

}

- (void)postServerAPI:(NSString *)url photoData:(NSData *)data withDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [dic setObject:@"test" forKey:@"Upload[file]"];
    [dic setObject:@"1" forKey:@"type"];
    manager.requestSerializer.timeoutInterval =TIMEOUT;
    [manager.requestSerializer setValue:@"form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        return ;
    }];
}


-(void)postServerAPI:(NSString*)urlStr Paramater:(NSDictionary*)para data:(NSData*)data name:(NSString*)fileName andContentType:(NSString *)cotentype successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",@"78178718261"] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] ==1) {
            successBlock(responseObject);
            return;
        }
        else
        {
            if ([[responseObject objectForKey:@"code"] integerValue] == 100003) {
                return;
            }
            else
            {
                return;
            }
          
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

}


-(NSMutableDictionary *)getBaseMsg:(NSMutableDictionary *)dic
{
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user  objectForKey:@"deviceid"])
    {
        [dic setObject:[user objectForKey:@"deviceid"] forKey:@"deviceid"];
    }
//    NSString *string = [InfoManager getToken];
//    if (string != nil ) {
//        [dic setObject:string forKey:@"token"];
//    }
    return dic;
}


-(NSString *)appendHeaderStr:(NSArray *)sortedKeys andDic:(NSMutableDictionary *)dic
{
    NSString *headerStr =[[NSString alloc] init];
    int i;
    for (i = 0; i<dic.count; i++) {
        if (i<=3) {
            NSString *str = [[NSString alloc] init];
            str = [sortedKeys[i] stringByAppendingString:[dic objectForKey:sortedKeys[i]]];
            headerStr = [headerStr stringByAppendingString:str];
        }
      
    }
    return headerStr;
}

-(NSString *)appendFooterStr:(NSArray *)sortedKeys
{
    NSString *str = [[NSString alloc] init];
    int i ;
    if (sortedKeys.count <=4) {
        
        for (i = 0; i<sortedKeys.count; i++) {
            str = [str stringByAppendingString:sortedKeys[i]];
        }
        
    }
    else
    {
        for ( i = 0; i <4; i++) {
            str = [str stringByAppendingString:sortedKeys[i]];
        }
        
        
    }
    
    return str;
    
}


-(NSString *)requestFailReason
{
    if ([self connectedToNetwork])
    {

        return @"网络连接失败!";
    }
    else
    {
        return @"请检查网络是否连接！";
    }
}

- (NSString *)deviceIPAdress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

-(void)dealloc{


}

// 判断网络是否可以连接
-(BOOL) connectedToNetwork
{
    Reachability *rea=[Reachability reachabilityForInternetConnection];
    return rea.currentReachabilityStatus==NotReachable?NO:YES;
}


/**
 *  获取图形验证码，主要返回的KEY在响应的头部，已经重新组合返回body
 */
-(void)getImageCodeServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock
{
    NSMutableDictionary  *dicc = [self getBaseMsg:dic];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =TIMEOUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    [manager GET:api parameters:dicc progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 1)
        {
            return;
        }
        else
        {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSDictionary *responseDic = @{@"code":@"1",@"object":@{@"captchaKey":allHeaders[@"captchaKey"]?allHeaders[@"captchaKey"]:@"",@"base64Str":dic[@"object"][@"base64Str"]?dic[@"object"][@"base64Str"]:@""}};
            successBlock(responseDic);
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==>%@",error);
        failBlock(error);
    }];
    
}



@end
