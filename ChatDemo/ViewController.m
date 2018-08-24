//
//  ViewController.m
//  ChatDemo
//
//  Created by Yogesh Raj on 21/08/18.
//  Copyright © 2018 Yogesh Raj. All rights reserved.
//

#import "ViewController.h"
#import "InCommingCell.h"
#import "OutgoingCell.h"
#import "HPGrowingTextView.h"
#import "HPTextViewInternal.h"
#import "ChatModel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()<HPGrowingTextViewDelegate>
{
    CGFloat width;
    CGFloat Height;
    NSString *room;
    UIView *containerView;
    HPGrowingTextView *textView;
    
}
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (weak, nonatomic) IBOutlet UITableView *chatTbl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(8.0, 2.0, 25.0, 25.0)];
    [button1 addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"Hide" forState:UIControlStateNormal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = button;
    
    _messageArray = [[NSMutableArray alloc] init];
    [self showKeyboard];
    [self loadKeyboard];
}

#pragma mark - UITableViewDataSource / UITableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        InCommingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InCommingCell"];
        if (cell == nil) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"InCommingCell" owner:self options:nil];
            cell = [bundle objectAtIndex:0];
        }
        
        ChatModel *message = [_messageArray objectAtIndex:indexPath.row];
        cell.message.text = message.message;
        cell.userName.text = message.userName;
        cell.time.text = message.date;
        
        return cell;
    }
    else
    {
        OutgoingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutgoingCell"];
        if (cell == nil) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"OutgoingCell" owner:self options:nil];
            cell = [bundle objectAtIndex:0];
        }
        
        ChatModel *message = [_messageArray objectAtIndex:indexPath.row];
        cell.message.text = message.message;
        cell.time.text = message.date;
        return cell;
    }

    
}


#pragma mark - sendMessage
-(IBAction)sendMsg:(id)sender
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    textView.text = [textView.text stringByTrimmingCharactersInSet:whitespace];
    
    if ([textView.text length]>0)
    {
        
        [self.messageArray addObject:[ChatModel stringWithMessage:textView.text
                                                           Sender:@""
                                                         userName:@"Lala"
                                                      messageType:0
                                                      messageDate:@"10:00 AM"]];
        [self scrollTable];
        //[self playSound];
    }
    
    textView.text = @"";
    
}

-(void)showKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma loadCustomKeyboard
- (void)loadKeyboard {
    
    
    width = self.view.frame.size.width;
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-(40+[self getSafeAreaBottom]), width, 40)];
    containerView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:containerView];
    
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, width-60, 40)];
    textView.isScrollable = NO;
    textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 4;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    //textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Enter your message here";
    //textView.layer.cornerRadius = 1.0;
    //textView.layer.borderWidth = 1.0;
    //textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:textView];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_icon"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(containerView.bounds.size.width - 40.0f,
                                  5.0f,
                                  30.0f,
                                  30.0f);
    [containerView addSubview:sendButton];
}

#pragma mark - resignTextView
-(void)resignTextView
{
    [textView resignFirstResponder];
}

#pragma mark - keyboardWillShow
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    Height = containerFrame.origin.y;
    [self setTableViewHeight:self.view.frame.size.height-Height];
    NSLog(@"%f",Height);
    [self scrollTable];
    // commit animations
    [UIView commitAnimations];
}

#pragma mark - keyboardWillHide
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height-40;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    [self setTableViewHeight:self.view.frame.size.height-([self getSafeAreaBottom]+104)];
    NSLog(@"%f",self.view.frame.size.height-([self getSafeAreaBottom]+108));
    //[self.chatTbl reloadData];
    // commit animations
    [UIView commitAnimations];
}

#pragma mark - growingTextView
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    diff = diff+diff;
    containerView.frame = r;
    [self setTableViewHeight:self.view.frame.size.height-(height+Height-34)];
    NSLog(@"%f",height+Height);
    [self scrollTable];
}

#pragma mark - setTableViewFrame
-(void)setTableViewHeight:(CGFloat)height
{
    self.chatTbl.frame = CGRectMake(0, 64, width,height);
}
#pragma mark - scrollTable
-(void)scrollTable
{
    [self.chatTbl reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.messageArray.count>0)
        {
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:[self.messageArray count]-1 inSection:0];
            [self.chatTbl scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    });
}

#pragma mark - getSafeArea;
-(CGFloat)getSafeAreaBottom
{
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    //CGFloat topPadding = window.safeAreaInsets.top;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    return bottomPadding;
}

#pragma mark - Play Sound
-(void)playSound
{
    SystemSoundID soundID;
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"sendTone.wav", NULL, NULL);
    AudioServicesCreateSystemSoundID(ref, &soundID);
    AudioServicesPlaySystemSound(soundID);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
