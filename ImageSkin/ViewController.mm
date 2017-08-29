#import "ViewController.h"
#import "ImageUnits.h"

@interface ViewController ()
@property (nonatomic, strong)UIImageView *imageView; //图片

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加图片
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"头像"];
    self.imageView.frame = CGRectMake((self.view.frame.size.width - 250)/2, 100, 250, 250);
    [self.view addSubview:self.imageView];
    
    //添加按钮
    //还原按钮
    UIButton *restoreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    restoreBtn.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 20, 50, 30);
    [restoreBtn setTitle:@"还原" forState:(UIControlStateNormal)];
    restoreBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    restoreBtn.backgroundColor = [UIColor blackColor];
    [restoreBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [restoreBtn addTarget:self action:@selector(restore:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:restoreBtn];
    
    //美白skin
    UIButton *skinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    skinBtn.frame = CGRectMake(self.view.frame.size.width - 70, CGRectGetMaxY(self.imageView.frame) + 20, 50, 30);
    [skinBtn setTitle:@"美白" forState:(UIControlStateNormal)];
    skinBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    skinBtn.backgroundColor = [UIColor blackColor];
    [skinBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [skinBtn addTarget:self action:@selector(skinBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:skinBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -- 还原
- (void)restore:(UIButton *)sender
{
    self.imageView.image = [UIImage imageNamed:@"头像"];
}

#pragma mark -- 美白
- (void)skinBtn:(UIButton *)sender
{
    //_imageView.image = [ImageUnits iosImageProcess:_imageView.image];
    _imageView.image = [ImageUnits openCVImageProcess:_imageView.image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
