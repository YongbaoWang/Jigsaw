//
//  SettingViewController.m
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "SettingViewController.h"
#import "iCarousel.h"

#define PHOTO_HEIGHT 100

@interface SettingViewController ()<iCarouselDelegate,iCarouselDataSource>
{
    NSMutableArray *_picArrayM;
    iCarousel *_carousel;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor grayColor]];
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
//    [view setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:view];
    
//    [self drawMyLayer];
    
    _carousel=[[iCarousel alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    [self.view addSubview:_carousel];
    _carousel.delegate=self;
    _carousel.dataSource=self;
    
    _carousel.type=iCarouselTypeCylinder;
    _picArrayM=[[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e", nil];
    [_carousel reloadData];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  _picArrayM.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_picArrayM[index]]];
    UIView *view = [[UIImageView alloc] initWithImage:image] ;
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}


- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 2;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 5;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}


- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _carousel.itemWidth);
}

-(void)drawMyLayer
{
    CALayer *layer=[[CALayer alloc] init];
    layer.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position=CGPointMake(100, 200);
    [layer setBackgroundColor:[UIColor blueColor].CGColor];
    layer.cornerRadius=PHOTO_HEIGHT/2;
    layer.masksToBounds=YES;
    layer.shadowColor=[UIColor blackColor].CGColor;
    layer.shadowOffset=CGSizeMake(5, 5);
    layer.shadowOpacity=0.8;
    layer.shadowRadius=2;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=2;
    layer.delegate=self;
    [self.view.layer addSublayer:layer];
    UIImage *image=[UIImage imageNamed:@"b"];
    layer.contents=(id)image.CGImage;
    //一定要调用，否则代理方便不执行
//    [layer setNeedsDisplay];
    
//    //自定义图层
//    CALayer *layer=[[CALayer alloc]init];
//    layer.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
//    layer.position=CGPointMake(160, 200);
//    layer.backgroundColor=[UIColor redColor].CGColor;
//    layer.cornerRadius=PHOTO_HEIGHT/2;
//    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
//    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
//    layer.masksToBounds=YES;
//    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
//    //而阴影效果刚好在外边框
//    //    layer.shadowColor=[UIColor grayColor].CGColor;
//    //    layer.shadowOffset=CGSizeMake(2, 2);
//    //    layer.shadowOpacity=1;
//    //设置边框
//    layer.borderColor=[UIColor whiteColor].CGColor;
//    layer.borderWidth=2;
//    
//    //设置图层代理
//    layer.delegate=self;
//    
//    //添加图层到根图层
//    [self.view.layer addSublayer:layer];
//    
//    //调用图层setNeedDisplay,否则代理方法不会被调用
//    [layer setNeedsDisplay];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    UIImage *image=[UIImage imageNamed:@"b.png"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    CGContextRestoreGState(ctx);
    
//    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
//    CGContextSaveGState(ctx);
//    
//    //图形上下文形变，解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
//    
//    UIImage *image=[UIImage imageNamed:@"b.png"];
//    //注意这个位置是相对于图层而言的不是屏幕
//    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
//    
//    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
//    //    CGContextDrawPath(ctx, kCGPathFillStroke);
//    
//    CGContextRestoreGState(ctx);
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch=[touches anyObject];
//    CGPoint point=[touch previousLocationInView:self.view];
//    NSLog(@"--%@",NSStringFromCGPoint(point));
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
