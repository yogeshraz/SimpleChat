//
//  ChatModel.m
//  ChatDemo
//
//  Created by Yogesh Raj on 24/08/18.
//  Copyright © 2018 Yogesh Raj. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

+ (instancetype)stringWithMessage:(NSString *)message Sender:(NSString *)senderId userName:(NSString *)user messageType:(int)type messageDate:(NSString *)date
{
   return [[ChatModel alloc] initWithMessage:message
                                      Sender:senderId
                                    userName:user
                                 messageType:type
                                 messageDate:date];
}
- (instancetype)initWithMessage:(NSString *)message Sender:(NSString *)senderId userName:(NSString *)user messageType:(int)type messageDate:(NSString *)date{
    self = [super init];
    if (self) {
        _message = message;
        _senderId = senderId;
        _date = date;
        _userName = user;
        _messageType = type;
    }
    return self;
}

@end
