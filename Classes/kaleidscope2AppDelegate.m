//
//  kaleidscope2AppDelegate.m
//  kaleidscope2
//
//  Created by 藤川 宏之 on 09/07/08.
//  Copyright 2009 Hiroyuki-Fujikawa. All rights reserved.
//

#import "kaleidscope2AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation kaleidscope2AppDelegate

@synthesize window;
@synthesize kaleidView;
@synthesize picker;
@synthesize viewArray;

- (void)dealloc {
	[viewArray release];
	[overlayView release];
	[indicator release];
	[kaleidView release];
	[picker release];
    [window release];
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//
	canSave = NO;
	// 基本定義
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	// 三角形計算用の基本数値
	triangleWidth = 160.0f;
	sinval = sin(M_PI / 3.0f);
	cosval = cos(M_PI / 3.0f);
	triangleHeight = floor(triangleWidth * sinval);
	self.viewArray = [NSMutableArray arrayWithCapacity:20];
	// 頂点配列
	NSArray *pointsArray = [NSArray arrayWithObjects:
							// 正方向５個
							[NSValue valueWithCGPoint:CGPointMake(0,0)],
							[NSValue valueWithCGPoint:CGPointMake(0, -triangleHeight * 2.0f)],
							[NSValue valueWithCGPoint:CGPointMake(0, triangleHeight * 2.0f)],
							[NSValue valueWithCGPoint:CGPointMake(round(-triangleWidth * 1.5f)+2, -triangleHeight)],
							[NSValue valueWithCGPoint:CGPointMake(round(triangleWidth * 1.5f)-2, -triangleHeight)],
							[NSValue valueWithCGPoint:CGPointMake(round(-triangleWidth * 1.5f)+2, triangleHeight)],
							[NSValue valueWithCGPoint:CGPointMake(round(triangleWidth * 1.5f)-2, triangleHeight)],
							//
							// [NSValue valueWithCGPoint:CGPointMake(0, triangleHeight * 4.0f)],
							// [NSValue valueWithCGPoint:CGPointMake(round(-triangleWidth * 1.5f)+2, -triangleHeight * 3.0f)],
							// [NSValue valueWithCGPoint:CGPointMake(round(triangleWidth * 1.5f)-2, -triangleHeight * 3.0f)],
							// [NSValue valueWithCGPoint:CGPointMake(round(-triangleWidth * 1.5f)+2, triangleHeight * 3.0f)],
							// [NSValue valueWithCGPoint:CGPointMake(round(triangleWidth * 1.5f)-2, triangleHeight * 3.0f)],
							// 
							nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFireMethod:) name:nil object:nil];
	// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFireMethod:) name:@"AVCaptureNotification_PreviewStarted" object:nil];
	// 頂点からviewを複製
	// テンポラリ値
	CALayer *tmpLayer;
	CGPoint pt;
	CATransform3D tmpTransform;
	double delayX = 160.0f;
	double delayY = 240.0f + triangleHeight / 2.0f * sinval;
	// 正方向
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x, delayY + pt.y);
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// 上下反転(上)
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(0.0f, -1.0f, -1.0f, 0.0f, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x, delayY + pt.y - triangleHeight);
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// 斜め位置
	// 左上
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(-sinval, -cosval, cosval, -sinval, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x - triangleHeight / 2.0f * sinval, delayY + pt.y - triangleHeight + triangleHeight / 2.0f * cosval);
		// CAShapeLayerで三角にくりぬく方法
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, triangleHeight, 0);
		CGPathAddLineToPoint(path, NULL, 0, triangleWidth / 2.0f);
		CGPathAddLineToPoint(path, NULL, triangleHeight, triangleWidth);
		CGPathCloseSubpath(path);
		CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
		maskShapeLayer.path = path;
		maskShapeLayer.lineWidth = 2.0f;
		tmpLayer.mask = maskShapeLayer;
		//
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// 右上
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(sinval, -cosval, cosval, sinval, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x + triangleHeight / 2.0f * sinval, delayY + pt.y - triangleHeight + triangleHeight / 2.0f * cosval);
		// CAShapeLayerで三角にくりぬく方法
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, triangleHeight, 0);
		CGPathAddLineToPoint(path, NULL, 0, triangleWidth / 2.0f);
		CGPathAddLineToPoint(path, NULL, triangleHeight, triangleWidth);
		CGPathCloseSubpath(path);
		CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
		maskShapeLayer.path = path;
		maskShapeLayer.lineWidth = 2.0f;
		tmpLayer.mask = maskShapeLayer;
		//
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// 左下
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(-sinval, cosval, cosval, sinval, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x - triangleHeight / 2.0f * sinval, delayY + pt.y - triangleHeight / 2.0f * cosval);
		// CAShapeLayerで三角にくりぬく方法
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, triangleHeight, 0);
		CGPathAddLineToPoint(path, NULL, 0, triangleWidth / 2.0f);
		CGPathAddLineToPoint(path, NULL, triangleHeight, triangleWidth);
		CGPathCloseSubpath(path);
		CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
		maskShapeLayer.path = path;
		maskShapeLayer.lineWidth = 2.0f;
		tmpLayer.mask = maskShapeLayer;
		//
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// 右下
	tmpTransform = CATransform3DMakeAffineTransform(CGAffineTransformMake(sinval, cosval, cosval, -sinval, 0.0f, 0.0f));
	for (NSValue *v in pointsArray) {
		tmpLayer = [CALayer layer];
		tmpLayer.edgeAntialiasingMask = 0;
		tmpLayer.contentsGravity = kCAGravityCenter;
		tmpLayer.bounds = CGRectMake(0, 0, triangleHeight, triangleWidth);
		tmpLayer.masksToBounds = YES;
		tmpLayer.transform = tmpTransform;
		pt = [v CGPointValue];
		tmpLayer.position = CGPointMake(delayX + pt.x + triangleHeight / 2.0f * sinval, delayY + pt.y - triangleHeight / 2.0f * cosval);
		// CAShapeLayerで三角にくりぬく方法
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, triangleHeight, 0);
		CGPathAddLineToPoint(path, NULL, 0, triangleWidth / 2.0f);
		CGPathAddLineToPoint(path, NULL, triangleHeight, triangleWidth);
		CGPathCloseSubpath(path);
		CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
		maskShapeLayer.path = path;
		maskShapeLayer.lineWidth = 2.0f;
		tmpLayer.mask = maskShapeLayer;
		//
		[viewArray addObject:tmpLayer];
		[self.kaleidView.layer addSublayer:tmpLayer];
	}
	// カメラが使える場合に処理をする
	NSLog(@"sourcetype available:%d", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIImagePickerController *controller = [[UIImagePickerController alloc] init];
		controller.sourceType = UIImagePickerControllerSourceTypeCamera;
		controller.delegate = self;
		controller.showsCameraControls = NO;
		// picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		//
		// controller.view.center = CGPointMake(160, 240);
		// controller.cameraViewTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
		[window addSubview:controller.view];
		self.picker = controller;
		self.picker.cameraOverlayView = overlayView;
		//
	}else	{
		NSLog(@"can't present source type");
	}
    [window makeKeyAndVisible];
}

// layer構造をさかのぼる(CASlotProxyを捕まえる)
- (void)showLayerHirency:(CALayer*)tlayer prefix:(NSString*)prefix {
	NSLog(@"%@> %@ / %@", prefix, tlayer, tlayer.contents);
	if([[NSString stringWithFormat:@"%s", object_getClassName(tlayer.contents)] isEqualToString:@"CASlotProxy"] == YES){
		// ライブビューを貼付ける処理
		NSLog(@"Catch the Live View!!!");
		CALayer *live = tlayer.contents;
		for (CALayer *l in self.viewArray){
			l.contents = live;
		}
		self.viewArray = nil;
		canSave = YES;
	}else {
		// 見つからない場合子要素をさかのぼる
		for (CALayer *slayer in tlayer.sublayers) {
			[self showLayerHirency:slayer prefix:[NSString stringWithFormat:@"%@+", prefix]];
		}
	}
}

// Notificationを受ける
- (void)notificationFireMethod:(NSNotification*)note {
//	NSLog(@"Notification: %@ / %@ / %@", note.name, note.object, note.userInfo);
	NSLog(@"Notification: %@ / %@", note.name, note.object);
	if([@"AVCaptureNotification_PreviewStarted" isEqualToString:note.name] == YES){
		NSLog(@"view hirency");
		[self showLayerHirency:self.picker.view.layer prefix:@"-"];
	}
	if([@"NSUserDefaultsDidChangeNotification" isEqualToString:note.name] == YES){
		NSLog(@"Notification: %@ / %@ / %@", note.name, note.object, note.userInfo);
	}
	if([@"AVCaptureNotification_PhotoCaptured" isEqualToString:note.name] == YES){
		NSLog(@"Notification: %@ / %@ / %@ / %@", note.name, note.object, [(NSDictionary*)note.userInfo allKeys], [(NSDictionary*)note.userInfo objectForKey:@"AVCaptureNotificationInfo_Metadata"]);
	}
	// PLCameraImageFullSizeImageReadyNotification
	// PictureWasTakenNotification
	/*
	if([@"AVCaptureNotification_FocusCompleted" isEqualToString:note.name] == YES){
		NSLog(@"view hirency");
		[self showViewHirency:self.picker.view prefix:@"-"];
	}
	 */
}

// kaleidViewをタッチしたときに呼ばれる
#pragma mark TakeAndMakePhoto
- (void)saveToPhotosAlbum {
	if(canSave == YES){
		canSave = NO;
		[indicator startAnimating];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		// 保存用写真を作る
		[self.picker takePicture];
		[pool release];
	}
}

// 画像を保存するときのコールバック(takePictureから呼び出される)
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:%@", info);
	UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSLog(@"tmpImage %0.2f x %0.2f, >> %d", tmpImage.size.width, tmpImage.size.height, tmpImage.imageOrientation);
	// 画像作成
	UIImage *tmpTriangle = [self scaleAndRotateImage:tmpImage];
	NSLog(@"tmpTriangle %0.2f x %0.2f, >> %d", tmpTriangle.size.width, tmpTriangle.size.height, tmpImage.imageOrientation);
	// 基本画像作成
	UIImage *diaImage = [self baseImageMake:tmpTriangle];
	NSLog(@"diaImage %0.2f x %0.2f, >> %d", diaImage.size.width, diaImage.size.height, diaImage.imageOrientation);
	// 菱形作成（左右）
	UIImage *rightImage = [self rightImageMake:diaImage];
	NSLog(@"rightImage %0.2f x %0.2f, >> %d", rightImage.size.width, rightImage.size.height, rightImage.imageOrientation);
	UIImage *leftImage = [self leftImageMake:diaImage];
	NSLog(@"leftImage %0.2f x %0.2f, >> %d", leftImage.size.width, leftImage.size.height, leftImage.imageOrientation);
	// 保存画像作成
	UIImage *kaleid = [self kaleidImage:diaImage withRight:rightImage andLeft:leftImage];
	// 保存
	UIImageWriteToSavedPhotosAlbum(kaleid, self, @selector(saveFinish:didFinishSavingWithError:contextInfo:), nil);
}

// 画像保存完了
- (void) saveFinish:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	NSLog(@"save finished!!: %@", error);
	[indicator stopAnimating];
	canSave = YES;
}

// 基本画像を切り抜く(三角一つ分の大きさの四角画像)
-(UIImage*)scaleAndRotateImage:(UIImage*)image {
	double twidth = triangleWidth * 2.0f;
	double theight = triangleHeight * 2.0f;
	CGFloat swidth = CGImageGetWidth(image.CGImage);
	CGFloat sheight = CGImageGetHeight(image.CGImage);
	NSLog(@"[%0.2f x %0.2f]", swidth, sheight);
	
	double ratio = 960.0f / swidth;
	NSLog(@"[%0.2f x %0.2f -> %0.2f x %0.2f] scale ratio : %0.2f", swidth, sheight, twidth, theight, ratio);
	// 描画サイズ
	CGRect area = CGRectMake(0, 0, twidth, theight);		// 新しく作る画像のサイズ
	//	CGRect fromarea = CGRectMake(-swidth / 2.0f, -sheight / 2.0f, swidth, sheight);	// 元画像の切り取り範囲
	CGRect fromarea = CGRectMake(-swidth / 2.0f, -sheight / 2.0f, swidth, sheight);	// 元画像の切り取り範囲
	// 描画先作成
	UIGraphicsBeginImageContext(area.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(ctx, twidth / 2.0f, theight / 2.0f);	// 中心に書く
	CGContextScaleCTM(ctx, ratio, -ratio);					// 拡大縮小
	CGContextRotateCTM(ctx, -M_PI / 2.0f);					// 回転
	CGContextDrawImage(ctx, fromarea, image.CGImage);		// 描画
	UIImage *copyImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return copyImage;
}

// ベースのミラー画像を作る
-(UIImage*)baseImageMake:(UIImage*)image {
	CGRect src = CGRectMake(0, image.size.height, image.size.width, image.size.height);
	CGRect baseArea = CGRectMake(0, 0, image.size.width, image.size.height * 2.0f);		// 
	UIGraphicsBeginImageContext(baseArea.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextDrawImage(ctx, src, image.CGImage);
	// 反転イメージコピー
    CGContextSaveGState(ctx);
	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -baseArea.size.height);
	CGContextDrawImage(ctx, src, image.CGImage);
	CGContextRestoreGState(ctx);
	UIImage *diaImage = UIGraphicsGetImageFromCurrentImageContext();	// UIImage化
	UIGraphicsEndImageContext();
	return diaImage;
}

// 右回転イメージ(菱形)
-(UIImage*)rightImageMake:(UIImage*)image {
	double width = triangleWidth * 3.0f;
	double height = triangleHeight * 2.0f;
	// 120度を示す
	CGFloat rot = M_PI * (2.0f / 3.0f);
	// -120度のイメージ
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, width / 2.0f, triangleHeight);
	CGContextRotateCTM(ctx, -rot);
	CGContextDrawImage(ctx, CGRectMake(-triangleWidth, -triangleHeight * 2.0f, triangleWidth * 2.0f, triangleHeight * 4.0f), image.CGImage);
	CGContextRestoreGState(ctx);
	// ダイヤ型にくりぬく
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
	CGContextSetLineWidth(ctx, 1.0);
	// 右上切り取り
	CGContextMoveToPoint(ctx, triangleWidth * 2.0f, triangleHeight * 2.0f);
	CGContextAddLineToPoint(ctx, triangleWidth * 3.0f, triangleHeight * 2.0f);
	CGContextAddLineToPoint(ctx, triangleWidth * 3.0f, 0.0f);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
	// 左下切り取り
	CGContextMoveToPoint(ctx, 0.0f, 0.0f);
	CGContextAddLineToPoint(ctx, 0.0f, triangleHeight * 2.0f);
	CGContextAddLineToPoint(ctx, triangleWidth, 0.0f);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
	//
	UIImage *diaImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return diaImage;
}

// 左回転イメージ(菱形)
-(UIImage*)leftImageMake:(UIImage*)image {
	double width = triangleWidth * 3.0f;
	double height = triangleHeight * 2.0f;
	// 120度を示す
	CGFloat rot = M_PI * (2.0f / 3.0f);
	// -120度のイメージ
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, width / 2.0f, triangleHeight);
	CGContextRotateCTM(ctx, rot);
	CGContextDrawImage(ctx, CGRectMake(-triangleWidth, -triangleHeight * 2.0f, triangleWidth * 2.0f, triangleHeight * 4.0f), image.CGImage);
	CGContextRestoreGState(ctx);
	// ダイヤ型にくりぬく
	CGContextSetBlendMode(ctx, kCGBlendModeClear);
	CGContextSetLineWidth(ctx, 1.0);
	// 左上切り取り
	CGContextMoveToPoint(ctx, 0.0f, 0.0f);
	CGContextAddLineToPoint(ctx, 0.0f, triangleHeight * 2.0f);
	CGContextAddLineToPoint(ctx, triangleWidth, triangleHeight * 2.0f);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
	// 右下切り取り
	CGContextMoveToPoint(ctx, triangleWidth * 2.0f, 0.0f);
	CGContextAddLineToPoint(ctx, triangleWidth * 3.0f, triangleHeight * 2.0f);
	CGContextAddLineToPoint(ctx, triangleWidth * 3.0f, 0.0f);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
	//
	UIImage *diaImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return diaImage;
}

// 保存するサイズでの万華鏡イメージを作る
-(UIImage*)kaleidImage:(UIImage*)image withRight:(UIImage*)rightImage andLeft:(UIImage*)leftImage {
	UIGraphicsBeginImageContext(CGSizeMake(triangleWidth * 6.0f, triangleHeight * 8.0f));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
	CGRect area2 = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
	//
	area.origin.x = triangleWidth;
	area.origin.y = 0;
	CGContextDrawImage(ctx, area, image.CGImage);
	area.origin.x = triangleWidth;
	area.origin.y = triangleHeight * 4.0f;
	CGContextDrawImage(ctx, area, image.CGImage);
	area.origin.x = triangleWidth * 4.0f;
	area.origin.y = -triangleHeight * 2.0f;
	CGContextDrawImage(ctx, area, image.CGImage);
	area.origin.x = triangleWidth * 4.0f;
	area.origin.y = triangleHeight * 2.0f;
	CGContextDrawImage(ctx, area, image.CGImage);
	area.origin.x = triangleWidth * 4.0f;
	area.origin.y = triangleHeight * 6.0f;
	CGContextDrawImage(ctx, area, image.CGImage);
	//
	area2.origin.x = -triangleWidth;
	area2.origin.y = triangleHeight * 2.0f;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	area2.origin.x = -triangleWidth;
	area2.origin.y = triangleHeight * 6.0f;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	area2.origin.x = triangleWidth * 2.0f;
	area2.origin.y = 0;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	area2.origin.x = triangleWidth * 2.0f;
	area2.origin.y = triangleHeight * 4.0f;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	area2.origin.x = triangleWidth * 5.0f;
	area2.origin.y = triangleHeight * 2.0f;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	area2.origin.x = triangleWidth * 5.0f;
	area2.origin.y = triangleHeight * 6.0f;
	CGContextDrawImage(ctx, area2, rightImage.CGImage);
	//
	area2.origin.x = -triangleWidth;
	area2.origin.y = 0;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	area2.origin.x = -triangleWidth;
	area2.origin.y = triangleHeight * 4.0f;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	area2.origin.x = triangleWidth * 2.0f;
	area2.origin.y = triangleHeight * 2.0f;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	area2.origin.x = triangleWidth * 2.0f;
	area2.origin.y = triangleHeight * 6.0f;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	area2.origin.x = triangleWidth * 5.0f;
	area2.origin.y = 0;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	area2.origin.x = triangleWidth * 5.0f;
	area2.origin.y = triangleHeight * 4.0f;
	CGContextDrawImage(ctx, area2, leftImage.CGImage);
	//
	UIImage *kaleidImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return kaleidImage;
}

@end
