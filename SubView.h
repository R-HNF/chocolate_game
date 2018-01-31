//
//  SubView.h
//  test
//
//  Created by DNFS on 13/05/10.
//  Copyright (c) 2013年 Ryo Hanafusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SubView : UIView{
    @public
    int x,y,z,px,py,jx,jy;
    IBOutlet UILabel *labelx,*labely,*labelplayer,*resultlabel;
    int chocosize,height,width,srange,svblank;
    double animeduration1;
    BOOL xy,memoricolor,jboolx,jbooly;
    IBOutlet UISlider *xslider,*yslider;
    IBOutlet UIImageView *imageViewload,*imageViewchoco,*resultanimation;
    IBOutlet UIButton *modeb,*resetb;
}
@property IBOutlet UISlider *xslider,*yslider;
@property UIImageView *imageViewload,*imageViewchoco,*resultanimation;
@property BOOL memoricolor;
@property IBOutlet UILabel *resultlabel,*labelx,*labely,*labelplayer;
@property IBOutlet UIButton *modeb,*resetb;
-(IBAction)buttonTapped:(id)sender;
-(IBAction)buttonTappedReset:(id)sender;
-(void)JadgeResult;
-(void)realChocoJudge;
-(void)fromStartView;
@end
