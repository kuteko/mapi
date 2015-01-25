//
//  newmap.h
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "draw.h"

@class draw;

@interface newmap : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UITextField *text;
    UIButton *button;
    NSMutableDictionary *buttonDictionary;
    CGPoint location,startlocation[100],endlocation[100];
    NSUserDefaults *savecount,*save_start;
    NSMutableArray *hogebt,*locSaveStart, *locSaveEnd;
    NSUserDefaults *saveLocData;

}

-(void)bt_LongPress:(UILongPressGestureRecognizer *)sender;
-(void)bt_pettan:(float)myX :(float)myY;
-(void)bt_SingleTapped:(id)sender;
-(IBAction)save:(id)sender;

@property(nonatomic)int locationcount;


@end
