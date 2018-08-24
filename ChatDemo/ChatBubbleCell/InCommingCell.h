//
//  InCommingCell.h
//  ChatDemo
//
//  Created by Yogesh Raj on 23/08/18.
//  Copyright © 2018 Yogesh Raj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@interface InCommingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end
