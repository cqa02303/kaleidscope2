//
//  kaleidview.m
//  kaleidscope2
//
//  Created by 藤川 宏之 on 09/09/23.
//  Copyright 2009 Hiroyuki-Fujikawa. All rights reserved.
//

#import "kaleidview.h"
#import <QuartzCore/QuartzCore.h>
#import "kaleidscope2AppDelegate.h"

@implementation kaleidview

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}

// スクリーンキャプチャの関数
CGImageRef UIGetScreenImage();

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"[kaleidview touchesEnded:withEvent];");
	[(kaleidscope2AppDelegate*)[UIApplication sharedApplication].delegate saveToPhotosAlbum];
	/*
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	// windowの範囲コピーのしかた
	// 画面丸ごとキャプチャする
	CGImageRef image = UIGetScreenImage();
	CGRect	rect = CGRectMake(0, 0, 320.0f, 480.0f);
	UIImage *tmpImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image, rect)];
//	UIImageWriteToSavedPhotosAlbum(tmpImage, nil, nil, nil);
	// アニメーション開始
	// windowの範囲コピーのしかた OS3.0から使えなくなった
	CGRect	rect = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
	UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:(CGImageRef)objc_msgSend(self, @selector(_createCGImageRefRepresentationInFrame:), rect)], nil, nil, nil);
	// CALayerに描画してもらう
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImageWriteToSavedPhotosAlbum(UIGraphicsGetImageFromCurrentImageContext(), nil, nil, nil);
	UIGraphicsEndImageContext();
	// また他のやり方
	CGRect	rect = CGRectMake(0, 0, 320.0f, 320.0f);
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	objc_msgSend(self, @selector(_renderSnapshotWithRect:inContext:), rect, UIGraphicsGetCurrentContext());
	UIImageWriteToSavedPhotosAlbum(UIGraphicsGetImageFromCurrentImageContext(), nil, nil, nil);
	UIGraphicsEndImageContext();
	//
	[pool release];
	 */
}

@end
