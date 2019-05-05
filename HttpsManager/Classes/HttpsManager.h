//
//  HttpsManager.h
//  Albert
//
//  Created by Albert on 3/27/17.
//  Copyright © 2017 smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

#define GET_URL(API) [NSString stringWithFormat:@"%@",API]
#define POST_URL(API) [NSString stringWithFormat:@"%@",API]


typedef void (^RequestSuccessfulBlock)(id responseObject);
typedef void (^RequestFailureBlock)(id error);

@interface HttpsManager : NSObject

/**
 *  GET_请求
 */
-(void)getServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  POST_请求
 */
-(void)postServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock)successBlock fail:(RequestFailureBlock)failBlock;
-(NSString *)deviceIPAdress;

/**
 *  上传文件
 */
-(void)postServerAPI:(NSString*)urlStr Paramater:(NSDictionary*)para data:(NSData*)data name:(NSString*)fileName andContentType:(NSString *)cotentype successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock;

/**
 *  获取图形验证码，主要返回的KEY在响应的头部，已经重新组合返回body
 */
-(void)getImageCodeServerAPI:(NSString *)api deliveryDic:(NSMutableDictionary *)dic successful:(RequestSuccessfulBlock )successBlock fail:(RequestFailureBlock )failBlock;


@end
