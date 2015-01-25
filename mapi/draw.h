//
//  draw.h
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newmap.h"

@class ViewController;

@interface draw : UIView
{
    int checknum;
}


@property(nonatomic,strong)UIView *myview;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic)CGPoint startlocation;
@property(nonatomic)CGPoint location;
@property(nonatomic)CGPoint endlocation;


-(void)drawRect:(CGRect)rect;


@end
