//
//  MQChatTableView.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatTableView.h"
#import "MQChatViewConfig.h"
#import "MQStringSizeUtil.h"
#import "MQBundleUtil.h"
#import "MQToolUtil.h"
#import "TTTAttributedLabel.h"

//static CGFloat const kMQChatScrollBottomDistanceThreshold = 128.0;

@interface MQChatTableView()<UIGestureRecognizerDelegate>

@end

@implementation MQChatTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (MQToolUtil.kMQObtainDeviceVersionIsIphoneX) {
        CGFloat newHeight = frame.size.height - 34;
        frame.size.height = newHeight;
    }
    
    if (MQToolUtil.kMQObtainStatusBarHeight == 0 && frame.size.width > frame.size.height) {
        frame.size.width = frame.size.width - 64;
    }
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatTableView:)];
        tapViewGesture.cancelsTouchesInView = false;
        tapViewGesture.delegate = self;
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tapViewGesture];
        
        
    }
    return self;
}

- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self numberOfRowsInSection:0]) {
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


/** 点击tableView的事件 */
- (void)tapChatTableView:(id)sender {
    if (self.chatTableViewDelegate) {
        if ([self.chatTableViewDelegate respondsToSelector:@selector(didTapChatTableView:)]) {
            [self.chatTableViewDelegate didTapChatTableView:self];
        }
    }
}

- (void)scrollToCellIndex:(NSInteger)index {
    if ([self numberOfRowsInSection:0] > 0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (BOOL)isTableViewScrolledToBottom {
//    if(self.contentOffset.y + self.frame.size.height + kMQChatScrollBottomDistanceThreshold > self.contentSize.height){
//        return true;
//    } else {
//        return false;
//    }
    CGFloat distanceFromBottom = self.contentSize.height - self.contentOffset.y;
    
    if (distanceFromBottom <= self.frame.size.height + 200){
        return YES;
    }
    return NO;

}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[TTTAttributedLabel class]]){
           TTTAttributedLabel *label = (TTTAttributedLabel *)touch.view;
           if ([label containslinkAtPoint:[touch locationInView:label]]){
               return NO;
           }else{
               return YES;
           }
       }else{
           return YES;
       }
}

@end
