//
//  SingletonManager.h
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingletonManager : NSObject
{
    int managedCount;
    CGPoint managedStartLocation,managedLocation,managedEndLocation;
    UIScrollView *managedScrollView;
    NSUserDefaults *managedSaveCount;
}

-(void)setCount:(int)count;
-(int)getCount;

-(void)setStartLocation:(CGPoint)location;
-(CGPoint)getStartLocation;

-(void)setLocation:(CGPoint)location;
-(CGPoint)getLocation;

-(void)setEndLocation:(CGPoint)location;
-(CGPoint)getEndLocation;

-(void)setScrollView:(UIScrollView *)scview;
-(UIScrollView *)getScrollView;

//-(void)setSaveCount:(NSUserDefaults *)savecount;
//-(NSUserDefaults *)getSaveCount;

+(SingletonManager *)shareManager;



@end
