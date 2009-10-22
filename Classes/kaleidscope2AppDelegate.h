//
//  kaleidscope2AppDelegate.h
//  kaleidscope2
//
//  Created by 藤川 宏之 on 09/07/08.
//  Copyright 2009 Hiroyuki-Fujikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kaleidscope2AppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIWindow	*window;
	IBOutlet UIView *overlayView;
	IBOutlet UIView *kaleidView;
	IBOutlet UIActivityIndicatorView *indicator;
	UIImagePickerController *picker;
	NSMutableArray *viewArray;
	//
	// 三角形計算用の基本数値
	double triangleWidth;
	double sinval;
	double cosval;
	double triangleHeight;
	BOOL canSave;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *kaleidView;
@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) NSMutableArray *viewArray;

- (void)saveToPhotosAlbum;
-(UIImage*)scaleAndRotateImage:(UIImage*)image;
-(UIImage*)baseImageMake:(UIImage*)image;
-(UIImage*)rightImageMake:(UIImage*)image;
-(UIImage*)leftImageMake:(UIImage*)image;
-(UIImage*)kaleidImage:(UIImage*)image withRight:(UIImage*)rightImage andLeft:(UIImage*)leftImage;

@end

