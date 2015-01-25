//
//  newmap.m
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import "newmap.h"
#import "draw.h"
#import "SingletonManager.h"

@interface newmap ()

@end

@implementation newmap

@synthesize locationcount;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    /* 初期化 */
    locSaveStart = [NSMutableArray array];
    locSaveEnd = [NSMutableArray array];
    saveLocData = [NSUserDefaults standardUserDefaults];
//    singleton
    SingletonManager *single=[SingletonManager shareManager];
//    add scrollView
    scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(700, 750);
    scrollView.contentOffset=CGPointMake(190, 91);
    scrollView.minimumZoomScale=0.5;
    scrollView.maximumZoomScale=1.5;
    
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack:scrollView];
    
    [single setScrollView:scrollView];
    NSLog(@"set scrollview");
    
    locationcount=0;

//    button　setting
    buttonDictionary=[[NSMutableDictionary alloc]init];
    
    button=[[UIButton alloc]initWithFrame:CGRectMake(320, 375, 150, 50)];
    button.center=CGPointMake(350, 375);
    startlocation[0]=CGPointMake(320, 375);
//ここね    startlocation[locationcount]=CGPointMake(320, 375);
    endlocation[0]=startlocation[locationcount];
//ここね    endlocation[locationcount]=startlocation[locationcount];
    [locSaveStart addObject:[NSNumber numberWithFloat:button.center.x]];
    [locSaveStart addObject:[NSNumber numberWithFloat:button.center.y]];
    [locSaveEnd addObject:[NSNumber numberWithFloat:button.center.x]];
    [locSaveEnd addObject:[NSNumber numberWithFloat:button.center.y]];

//    画像のセットはここ↓
    
    //if文作ること!!
    UIImage *img=[UIImage imageNamed:@"green.png"];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
//    button.tag=0;
    button.tag=locationcount;
    NSLog(@"%ld",(long)button.tag);
    
    
//    longPress
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bt_LongPress:)];
    longPressGestureRecognizer.minimumPressDuration=0.2f;
    
// ボタンにジェスチャーを追加
    [button addTarget:self action:@selector(bt_SingleTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [button addGestureRecognizer:longPressGestureRecognizer];
    NSLog(@"set gesture");
    
//arrayに格納
    [buttonDictionary setObject:button forKey:[NSString stringWithFormat:@"%d",locationcount]]; // なんだこれ
    [scrollView addSubview:button];
    
    NSLog(@"ボタンタグ%ld",(long)button.tag);

/* ここから保存したデータの呼び出しになります */
    NSMutableArray *loadArrayStart = [saveLocData objectForKey:@"startPoint"];
    NSMutableArray *loadArrayEnd = [saveLocData objectForKey:@"endPoint"];

    int arrayCount = (int)[loadArrayEnd count];
    arrayCount = (int)[loadArrayStart count];
    locationcount = arrayCount/2;
    if (arrayCount != 2) {
        int length = arrayCount / 2; // 座標はx,y両方とも同じkeyで順番に保存されているので配列の長さの半分を用いる
        NSLog(@"保存されている座標の数は = %d", length);
        NSLog(@"locationcountは %d",locationcount);
    
//        for (int k=0; k>1&&k<length; k++) {
        for (int k=0; k<length; k++) {
            if (0<k) {
                
            startlocation[k].x = [[loadArrayStart objectAtIndex:2*k] floatValue];
            startlocation[k].y =[[loadArrayStart objectAtIndex:2*k+1] floatValue];
            /*おまえらか*/
            endlocation[k].x = [[loadArrayEnd objectAtIndex:2*k] floatValue];
            endlocation[k].y = [[loadArrayEnd objectAtIndex:2*k+1] floatValue];
            
            NSLog(@"No %d Start(%.f, v = %.f)", k, startlocation[k].x, startlocation[k].y);
            NSLog(@"End %d u = %.f, v = %.f", k, endlocation[k].x, endlocation[k].y);
            [single setCount:k];
            [single setStartLocation:startlocation[k]];
            [single setEndLocation:endlocation[k]];
            
            NSArray * allSubviews = [scrollView subviews];
            for(UIView *view in allSubviews)
                if([view isMemberOfClass:[UIView class]] && view.tag != 1)
                    [view removeFromSuperview];
            }
            draw *drawline=[[draw alloc]initWithFrame:scrollView.bounds];
            
            UIView *hogeView = [[UIView alloc]init];
            [hogeView addSubview:drawline];
            [scrollView addSubview:hogeView];
            [scrollView sendSubviewToBack:hogeView];
            
            [self bt_pettan:endlocation[k].x:endlocation[k].y];
            // startlocationだとまずい.
            // startlocation[0]の座標は一番最初にロングタップした場所なので
            NSLog(@"確認 %d",k);
        }
    } else {
        NSLog(@"保存されているデータの数は 0 です");
    }
    
/* ここまで */
    
}

//textfieldを長押ししたときにstartlocation、ドラッグ中にlocation、指を離したときにendlocationを取得
- (void)bt_LongPress:(UILongPressGestureRecognizer *)sender
{
    int dragFlag = 0;
    SingletonManager *single = [SingletonManager shareManager];
    // 長押し開始
    if (sender.state==UIGestureRecognizerStateBegan) {
        NSLog(@"長押しがされました．");
        dragFlag = 0;
        locationcount++;
        
        /* ここで配列にスタートの位置を格納してます */
        startlocation[locationcount]=[sender locationInView:scrollView];
        float setX = startlocation[locationcount].x;
        float setY = startlocation[locationcount].y;
        [locSaveStart addObject:[NSNumber numberWithFloat:setX]];
        [locSaveStart addObject:[NSNumber numberWithFloat:setY]];
        NSLog(@"長押し時に保存される座標は(%.f,%.f)", setX, setY);
        /* ここまで */
        
        [single setCount:locationcount];
        [single setStartLocation:startlocation[locationcount]];
    } else if (sender.state==UIGestureRecognizerStateEnded && startlocation!=0){
        NSArray * allSubviews = [scrollView subviews];
        for(UIView *view in allSubviews)
            if([view isMemberOfClass:[UIView class]]) view.tag = 1;
        //最後に追加した線に関してはtag=1をつけて管理
        
        /* ここでendの位置を配列に格納 */
        endlocation[locationcount]=[sender locationInView:scrollView];
        float endX = endlocation[locationcount].x;
        float endY = endlocation[locationcount].y;
        [locSaveEnd addObject:[NSNumber numberWithFloat:endX]];
        [locSaveEnd addObject:[NSNumber numberWithFloat:endY]];
        /* ここまでendの位置を配列に格納 */
        NSLog(@"LongtouchPressは終了しました．endlocationは(%.f,%.f)です．", endX, endY);
        scrollView.contentOffset=CGPointMake(endX - 160, endY - 290);
        
        [single setEndLocation:endlocation[locationcount]];
        
        [self bt_pettan:endX:endY]; // endXとendYの位置にボタンをはりつける
    } else if (sender.state==UIGestureRecognizerStateChanged){ /* 指が動いている時の動作 */
        NSArray * allSubviews = [scrollView subviews];
        for(UIView *view in allSubviews)
            if([view isMemberOfClass:[UIView class]] && view.tag != 1)
                [view removeFromSuperview];
        
        location=[sender locationInView:scrollView];
        NSLog(@"locationは%.f,%.f",location.x,location.y);
        
        /* singletonにlocationを引き渡し */
        [single setLocation:location];
        
        draw *drawline=[[draw alloc]initWithFrame:scrollView.bounds];
        
        UIView *hogeView = [[UIView alloc]init];
        [hogeView addSubview:drawline];
        [scrollView addSubview:hogeView];
        [scrollView sendSubviewToBack:hogeView];
        
        /* ここから 自動スクロールの命令 */
        float X, Y;
        X = location.x - scrollView.contentOffset.x;
        Y = location.y - scrollView.contentOffset.y;
//ここね        if (X>=0 && X<=700 && Y>=0 && Y<=750) {
        
            int moveLength = 50;
            int judgeLength = 100;
            int limitX = abs(location.x - startlocation[locationcount].x);
            int limitY = abs(location.y - startlocation[locationcount].y);
            
            if (limitX <= self.view.frame.size.width - judgeLength) {
                if (X <= judgeLength)
                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - moveLength, scrollView.contentOffset.y) animated:YES];
                if (X >= self.view.frame.size.width - judgeLength)
                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + moveLength, scrollView.contentOffset.y) animated:YES];
            }
            
            if (limitY <= self.view.frame.size.height - judgeLength) {
                if (Y <= judgeLength)
                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - moveLength) animated:YES];
                if (Y >= self.view.frame.size.height - judgeLength)
                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + moveLength) animated:YES];
            }
// ここね       }
//        else{
//            if (X<0)   X=0;
//            if (X>700) X=700;
//            if (Y<0)   Y=0;
//            if (Y>750) Y=750;
//        }
    }
    /* ここまで 自動スクロールの命令 */
}

/* ボタンを貼るメソッド */
-(void)bt_pettan:(float)myX :(float)myY{
    
    if (locationcount > 99){
//ここね    if (locationcount > 99){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"注意" message:@"これ以上テキストを置く事はできません" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else { // ボタンを貼る
        button=[[UIButton alloc]initWithFrame:CGRectMake(myX, myY, 150, 50)];
        button.center=CGPointMake(myX, myY);
        
        button.tag=locationcount; // ボタンにタグを付与 -> 編集時にボタンにアクセスできるようにするために必要

        //ボタンの画像設定はここn
        [button setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];  // 画像をセットする
//     ここと   UIImage *img = [UIImage imageNamed:@"blue.png"];  // ボタンにする画像を生成する
//       ここんt [button setBackgroundImage:img forState:UIControlStateNormal];  // 画像をセットする
        [button setTitleColor:[ UIColor whiteColor] forState:UIControlStateNormal ];

        //ロングタップ
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bt_LongPress:)];
        longPressGestureRecognizer.minimumPressDuration=0.2f;
        [button addTarget:self action:@selector(bt_SingleTapped:)
         forControlEvents:UIControlEventTouchUpInside];
        [button addGestureRecognizer:longPressGestureRecognizer];
        
        [scrollView addSubview:button];
        [scrollView bringSubviewToFront:button];
        
        /* buttonDictionaryにkeyをlocationcountで連想配列に保存？ */
        [buttonDictionary setObject:button forKey:[NSString stringWithFormat:@"%d",locationcount]];
    }
}

//キーボードを閉じる時のメソッド
// Doneを押したとき
-(BOOL)textFieldShouldReturn:(UITextField*)textField{// 仮引数 <- 何にするか
    [textField resignFirstResponder];
    [textField removeFromSuperview];
    NSLog(@"textFieldtext%@", textField.text);
    NSString *key = [NSString stringWithFormat:@"%ld",(long)[textField tag]];
    [buttonDictionary[key] setTitle:[NSString stringWithFormat:@"%@",textField.text] forState:UIControlStateNormal];

    NSLog(@"keyboard_return");
    NSLog(@"textFieldTag,%ld",(long)[button tag]);
    NSLog(@"ボタンディクショナリータグ%ld,テキスト%@",(long)[buttonDictionary[key] tag],[buttonDictionary[key] currentTitle]);
    return YES;
}


//scrollViewを押したとき
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // ここにtextデータの処理
    [scrollView resignFirstResponder];
    [text removeFromSuperview];
    if (text.text) {
        NSLog(@"textFieldtext%@", text.text);
        NSString *key = [NSString stringWithFormat:@"%ld",(long)[text tag]];
        [buttonDictionary[key] setTitle:[NSString stringWithFormat:@"%@",text.text] forState:UIControlStateNormal];
        NSLog(@"keyboard_return");
        NSLog(@"textFieldTag,%ld",(long)[text tag]);
        NSLog(@"ボタンディクショナリータグ%ld,テキスト%@",(long)[buttonDictionary[key] tag],[buttonDictionary[key] currentTitle]);
    }
}

-(void)bt_SingleTapped:(id)sender{
    long tag = [(UIButton *)sender tag];
    NSString *key = [NSString stringWithFormat:@"%ld",tag];
    [buttonDictionary[key] setTitle:@" " forState:UIControlStateNormal];
    text=[[UITextField alloc]initWithFrame:CGRectMake(endlocation[tag].x, endlocation[tag].y, 100, 50)];
    text.center=CGPointMake(endlocation[tag].x, endlocation[tag].y);
    text.enabled=YES;
    text.delegate=self;
    text.textAlignment = NSTextAlignmentCenter;
    text.textColor=[UIColor whiteColor];
//    NSLog(@"buttonSender%ld",tag);
    text.tag = tag;
    
    
    if (!button.titleLabel.text) {
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    [scrollView addSubview:text];
    [scrollView bringSubviewToFront:text];
//    NSLog(@"single tapped");
}


-(IBAction)save:(id)sender{
    //locationcount 貼った回数
    //locSave データを格納する配列
    NSLog(@"ただいまのlocationcountは%d", locationcount);
    
    int arrayCount = (int)[locSaveStart count] /2;
//    NSLog(@"やふー！ %d", arrayCount);
    
    float kakuninX, kakuninY;
    for (int k = 0; k<arrayCount; k++) {
        kakuninX = [[locSaveStart objectAtIndex:2*k] floatValue];
        kakuninY = [[locSaveStart objectAtIndex:2*k+1] floatValue];
        NSLog(@"kakunin X, Y = %.f, %.f", kakuninX, kakuninY);
    }
    
    /* 配列を保存する */
    [saveLocData setObject:locSaveStart forKey:@"startPoint"];
    [saveLocData setObject:locSaveEnd forKey:@"endPoint"];
    [saveLocData synchronize];

//    [saveLocData removeObjectForKey:@"startPoint"];
//    [saveLocData removeObjectForKey:@"endPoint"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)kakuninBtn
{
    /* 保存された配列を呼び起こす */
    NSMutableArray *loadArray = [saveLocData objectForKey:@"startPoint"];
    /* 配列の長さを取得 */
    int maxLength = (int)[loadArray count];
    NSLog(@"arrayLength = %d", maxLength);
    
    /* 配列の中身を確認 */
    for (int j = 0; j < maxLength; j++) NSLog(@"No.%d, %@", j, [loadArray objectAtIndex:j]);
}


@end
