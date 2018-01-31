//
//  SubView.m
//  test
//
//  Created by DNFS on 13/05/10.
//  Copyright (c) 2013年 Ryo Hanafusa. All rights reserved.
//

#import "SubView.h"
#import "AppDelegate.h"
#import "StartViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
@implementation SubView
@synthesize xslider,yslider,imageViewload,imageViewchoco,memoricolor,resultanimation,resultlabel,modeb,resetb,labelx,labely,labelplayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    @autoreleasepool {
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    StartViewController *svc = [[StartViewController alloc]init];
    
        
    chocosize=appDelegate.cs;
    x=appDelegate.ox;
    y=appDelegate.oy;
    height=self.frame.size.height-10;
    width=self.frame.size.width;
    labelx.text=[NSString stringWithFormat:@"x = %d",x];
    labely.text=[NSString stringWithFormat:@"y = %d",y];
    //load
    if(appDelegate.appload==NO){
        if(appDelegate.startReal){
            [self buttonTapped];
            appDelegate.appload=YES;
        }
        else{
            [self addSubview:svc.view];
            appDelegate.subView=self;
            self.userInteractionEnabled=NO;
            imageViewload = [[UIImageView alloc] initWithImage:appDelegate.load];
            imageViewload.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*1.2);
            imageViewload.center = CGPointMake(width/2, height/2);
            [UIView animateWithDuration:0.3
                                  delay:1.7
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 imageViewload.alpha = 0.0;
                             }
                             completion:^(BOOL finished){
                                 self.userInteractionEnabled=YES;
                             }];
            [self addSubview:imageViewload];
            resetb.hidden=YES;
            
            resultlabel.font=[UIFont fontWithName:@"Marker Felt" size:7];
            resultlabel = [[UILabel alloc] initWithFrame:CGRectZero];
            resultlabel.frame=CGRectMake(0, 0, 400, 60);
            resultlabel.center = CGPointMake(width/2, height/2);
            resultlabel.backgroundColor = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
            resultlabel.textAlignment=NSTextAlignmentCenter;
            resultlabel.alpha=0;
            [self addSubview:resultlabel];
            animeduration1=0.1;
            svblank=appDelegate.blank;
        }
    }
    
    if(appDelegate.player%2==0)labelplayer.text=[NSString stringWithFormat:@"1st Player"];
    else labelplayer.text=[NSString stringWithFormat:@"2nd Player"];
    
    //チョコ
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context1, 0.498, 0.310, 0.129, 1.0);
    CGRect brc = CGRectMake(svblank, height-chocosize*(y+1), chocosize*(x+1), chocosize*(y+1));//480/300
    CGContextAddRect(context1, brc);
    CGContextFillPath(context1);
    
    //毒チョコ
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context2, 0.0, 0.0, 1.0, 1.0);
    CGRect blc = CGRectMake(svblank, height-chocosize, chocosize, chocosize);
    CGContextAddRect(context2, blc);
    CGContextFillPath(context2);
    
    CGContextRef context3 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context3, 0.5);
    
    if(memoricolor==false){
        CGContextSetRGBStrokeColor(context3, 1.0, 1.0, 1.0, 1.0);//white
    }
    else{
        CGContextSetRGBStrokeColor(context3, 0.0, 0.0, 0.0, 1.0);//black
    }
    
    for (int i=0; i<x; i++) {
        CGContextMoveToPoint(context3, svblank+chocosize*(i+1), height-chocosize*(y+1));
        CGContextAddLineToPoint(context3, svblank+chocosize*(i+1),height);
    }
    for (int i=0; i<y; i++) {
        CGContextMoveToPoint(context3, svblank, height-chocosize*(i+1));
        CGContextAddLineToPoint(context3, svblank+chocosize*(x+1), height-chocosize*(i+1));
    }
    //目盛り
    if(appDelegate.realchoco==false){
        for (int i=0; i<=(int)xslider.maximumValue; i++) {
            CGContextMoveToPoint(context3, 70+(300/(int)xslider.maximumValue)*i, 10);
            CGContextAddLineToPoint(context3, 70+(300/(int)xslider.maximumValue)*i, 20);
        }
        for (int i=0; i<=(int)yslider.maximumValue; i++) {
            CGContextMoveToPoint(context3, 70+(300/(int)yslider.maximumValue)*i, 35);
            CGContextAddLineToPoint(context3, 70+(300/(int)yslider.maximumValue)*i, 45);
        }
    }
    CGContextStrokePath(context3);
    
    if(appDelegate.realchoco){
        imageViewchoco=[[UIImageView alloc] init];
        UIGraphicsBeginImageContext(CGSizeMake(0, height));
        [appDelegate.chocoblue drawInRect:CGRectMake(svblank, height-chocosize, appDelegate.cs, appDelegate.cs)];
        for (int j=0; j<=appDelegate.oy; j++) {
            for (int i=0; i<=appDelegate.ox; i++) {
                if(i==0&&j==0)continue;
                [appDelegate.chocobrown drawInRect:CGRectMake(svblank+chocosize*i,    height-chocosize*(j+1), appDelegate.cs, appDelegate.cs)];
            }
        }
        UIImage *realchocoimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageViewchoco.image=realchocoimage;
        [self addSubview:imageViewchoco];
    }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    @autoreleasepool {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:self];
    if(appDelegate.appload){
        px=location.x;
        py=location.y;
        srange=appDelegate.Srange;
    
        [self JadgeTouch];
        if(jboolx&&jbooly){
            jx=0;
            jy=0;
        }
        else{
            if(jboolx){
                appDelegate.ox=jx;
                xslider.value=jx;
                if(appDelegate.ox==0&&appDelegate.oy==0){
                    [self JadgeResult];
                }
                else{
                    appDelegate.player++;
                    //AudioServicesPlaySystemSound(appDelegate.cutSound);
                }
            }
            else if(jbooly){
                appDelegate.oy=jy;
                yslider.value=jy;
                if(appDelegate.ox==0&&appDelegate.oy==0){
                    [self JadgeResult];
                }
                else{
                    appDelegate.player++;
                    //AudioServicesPlaySystemSound(appDelegate.cutSound);
                }
            }
        }
        jboolx=false;
        jbooly=false;
        xy=false;
        [super setNeedsDisplay];
        appDelegate.subView=self;
    }
    }
}
-(void)JadgeTouch{
    @autoreleasepool {
    for (int i=0; i<x; i++) {
        if(svblank+chocosize*(i+1)-srange<px&&px<svblank+chocosize*(i+1)+srange&&height-chocosize*(y+1)-srange<py&&py<height+srange){
            jx=i;
            jboolx=true;
        }
    }
    for (int i=0; i<y; i++) {
        if(svblank-srange<px&&px<svblank+chocosize*(x+1)+srange&&height-chocosize*(i+1)-srange<py&&py<height-chocosize*(i+1)+srange){
            jy=i;
            jbooly=true;
        }
    }
    }
}
-(void)JadgeResult{
    @autoreleasepool {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //result
    if(appDelegate.ox==0&&appDelegate.oy==0){
        self.userInteractionEnabled=NO;
        modeb.userInteractionEnabled=NO;
        xslider.userInteractionEnabled=NO;
        yslider.userInteractionEnabled=NO;
        labelplayer.hidden=YES;
        if(appDelegate.realchoco==YES){
            resultlabel.textColor = [UIColor blueColor];
        }
        else{
            resultlabel.textColor = [UIColor blackColor];
        }
        resultlabel.font=[UIFont fontWithName:@"Marker Felt" size:20];
        resultlabel.hidden=NO;
        if(appDelegate.player%2==0){
            resultlabel.text=[NSString stringWithFormat:@"1st Player Win"];
        }
        else{
            resultlabel.text=[NSString stringWithFormat:@"2nd Player Win"];
        }
        [UIView animateWithDuration:animeduration1
                         animations:^{
                             //AudioServicesPlaySystemSound(appDelegate.finishSound);
                             /*resultlabel.transform=CGAffineTransformMakeRotation(M_PI);
                             resultlabel.transform=CGAffineTransformMakeScale(2, 2);*/
                             resultlabel.transform=CGAffineTransformMakeScale(7, 0.3);
                             resultlabel.alpha=1;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:animeduration1//+0.5
                                              animations:^{
                                                  //resultlabel.center = CGPointMake(240, 160);
                                                  resultlabel.transform=CGAffineTransformMakeScale(0.1, 0.3);
                                              }
                                              completion:^(BOOL finished){
                                                  [UIView animateWithDuration:animeduration1//+1
                                                                   animations:^{
                                                                       resultlabel.transform=CGAffineTransformMakeScale(0.3, 22);
                                                    }
                                                    completion:^(BOOL finished){
                                                        [UIView animateWithDuration:animeduration1//+0.8
                                                                animations:^{
                                                                        resultlabel.transform=CGAffineTransformMakeScale(0.1, 0.2);
                                                                        resultlabel.alpha=0;
                                                                    }
                                                                completion:^(BOOL finished){
                                                                    [UIView animateWithDuration:animeduration1
                                                                            animations:^{
                                                                                    resultlabel.transform=CGAffineTransformMakeScale(3, 3);
                                                                                    resultlabel.alpha=1;
                                                                                    }];
                                                                         }];
                                                        }];
                                              }];
                             self.userInteractionEnabled=YES;
                             appDelegate.player=0;
                             resetb.hidden=NO;
                         }];
    }
    else{
        resultlabel.hidden=YES;
    }
    }
}
- (IBAction)SliderChanged:(id)sender {
    @autoreleasepool {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.ox=(int)xslider.value;
    appDelegate.oy=(int)yslider.value;
    resultlabel.hidden=YES;
    labelplayer.hidden=NO;
    appDelegate.player=0;
    [super setNeedsDisplay];
    }
}

-(IBAction)buttonTapped{
    @autoreleasepool{
    [self realChocoJudge];
    labelplayer.hidden=NO;
    [super setNeedsDisplay];
    }
}
-(IBAction)buttonTappedReset{
    @autoreleasepool {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.ox=xslider.maximumValue;
    appDelegate.oy=yslider.maximumValue;
    appDelegate.player=0;
    labelplayer.hidden=NO;
    resultlabel.hidden=YES;
    resultlabel.alpha=0;
    xslider.value=xslider.maximumValue;
    yslider.value=yslider.maximumValue;
    modeb.userInteractionEnabled=YES;
    xslider.userInteractionEnabled=YES;
    yslider.userInteractionEnabled=YES;
    [super setNeedsDisplay];
    resetb.hidden=YES;
    }
}
-(void)realChocoJudge{
    @autoreleasepool {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.realchoco){//初期false
        self.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
        //appDelegate.textcolor=[UIColor whiteColor];
        appDelegate.realchoco=NO;
        //memoricolor=false;//false->black
    }
    else{
        self.backgroundColor = [UIColor colorWithPatternImage:appDelegate.backgroundImage];
        //appDelegate.textcolor=[UIColor blackColor];
        appDelegate.realchoco=YES;
        //memoricolor=true;//true->white
    }
    labelx.textColor=appDelegate.textcolor;
    labely.textColor=appDelegate.textcolor;
    labelplayer.textColor=appDelegate.textcolor;
    xslider.hidden=appDelegate.realchoco;
    yslider.hidden=appDelegate.realchoco;
    labelx.hidden=appDelegate.realchoco;
    labely.hidden=appDelegate.realchoco;
    memoricolor=appDelegate.realchoco;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

@end
