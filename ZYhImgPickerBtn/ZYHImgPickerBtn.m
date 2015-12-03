//
//  ZYHImgPickerBtn.m
//  ZYHImagePickers
//
//  Created by Jessee on 15/11/11.
//  Copyright © 2015年 Jessee. All rights reserved.
//

#import "ZYHImgPickerBtn.h"

@interface ZYHImgPickerBtn ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString *picDataPath;

@end

@implementation ZYHImgPickerBtn

-(void)beingActive{

    [self addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)showAlert{
    
    UIActionSheet* myActionShit = [[UIActionSheet alloc]initWithTitle:@"请选择相机或相簿" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从相册选取", nil];
    
    [myActionShit showInView:[UIApplication sharedApplication].keyWindow];

}
#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        case 2:
            NSLog(@"取消");
            break;
            
        default:
            break;
    }
}
#pragma mark-选取相机拍照
-(void)takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //判断相机可不可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
        //设置拍照后的照片可以编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [[self findViewController:self] presentViewController:picker animated:YES completion:^{
            
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:picker.view];
    }else{
        
        NSLog(@"对不起，模拟器中打不开相机");
    }
    
}
#pragma mark-选取本地相册
-(void)localPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    [[self findViewController:self] presentViewController:picker animated:YES completion:^{
        
    }];
    
}

#pragma mark-寻找view所在的控制器
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark-当选取完成时来到这里
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //判断选取的是不是图片
    if ([type isEqualToString:@"public.image"]) {
        
        //把图片转成NSdata
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *data;
        
//        data = UIImagePNGRepresentation(image);
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(image);
            
        }
        
        //保存图片的路径，这里将图片保存在沙盒的Documents里面
        NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyImg"];
        ZLog(@"%@",documentPath);
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚转化成的data对象拷贝至沙盒目录下Documents中，并保存为image.png
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [fileManager createFileAtPath:[documentPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到存好的图片的完整路径
        self.picDataPath = [[NSString alloc]initWithFormat:@"%@%@",documentPath,@"/image.png"];
        
        NSLog(@"图像路径为：%@",self.picDataPath);
        
        if ([self.delegate respondsToSelector:@selector(getChoosedImg:andImgData:andThePath:)]) {
            [self.delegate getChoosedImg:image andImgData:data andThePath:self.picDataPath];
        }
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        NSLog(@"对不起，这不是一张图片");
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"您取消了选择图片");
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
