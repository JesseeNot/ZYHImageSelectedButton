//
//  ZYHImgPickerBtn.h
//  ZYHImagePickers
//
//  Created by Jessee on 15/11/11.
//  Copyright © 2015年 Jessee. All rights reserved.
//  本三方旨在为广大开发人员节省时间，简洁，高效的获取手机照片和用相机照相片，可以从下方代理方法直接获取（用代码判断过的相片信息以及暂时存储它的二进制文件路径，爽吗

#import <UIKit/UIKit.h>

@protocol ZYHImgPickerBtnDelegate <NSObject>
@optional
/***代理方法，获取选择好的图片*/
-(void)getChoosedImg:(UIImage *)img andImgData:(NSData *)data andThePath:(NSString *)path;

@end

@interface ZYHImgPickerBtn : UIButton<UIActionSheetDelegate>


@property (weak, nonatomic) id<ZYHImgPickerBtnDelegate> delegate;

/***成为能选取照片的按钮*/
-(void)beingActive;


@end
