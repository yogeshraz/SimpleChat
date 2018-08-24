//
//  ChatModel.h
//  ChatDemo
//
//  Created by Yogesh Raj on 24/08/18.
//  Copyright © 2018 Yogesh Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, assign) int messageType;
@property (nonatomic, strong) NSString *senderId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *date;
//@property (nonatomic, strong) NSString *time;


- (instancetype)initWithMessage:(NSString *)message Sender:(NSString *)senderId userName:(NSString *)user messageType:(int)type messageDate:(NSString *)date;
+ (instancetype)stringWithMessage:(NSString *)message Sender:(NSString *)senderId userName:(NSString *)user messageType:(int)type messageDate:(NSString *)date;

@end
