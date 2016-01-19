//
//  HeardViewController.m
//  
//
//  Created by MRH on 16/1/18.
//
//

#import "HeardViewController.h"
#import "Masonry.h"
#define kNavBarH 64.0f
#define kHeardH  ([UIScreen mainScreen].bounds.size.width * 0.618)

#define kColorHex(rgbValue,a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface HeardViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *scaleImageView;           // 顶部图片
@property (nonatomic,assign) CGFloat lastOffsetY;                   // 记录上一次位置
@property (nonatomic,strong) MASConstraint *heightMasCon;
@property (nonatomic,strong) UIView *narBar;
@end

@implementation HeardViewController


#pragma mark - Set/Get

- (UIView *)narBar
{
    if (!_narBar) {
        _narBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        _narBar.backgroundColor = [UIColor redColor];
    }
    return _narBar;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;

    }
    return _tableView;
}

- (UIImageView *)scaleImageView
{
    if (!_scaleImageView) {
        _scaleImageView = [[UIImageView alloc] init];
        _scaleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _scaleImageView.clipsToBounds = YES;
        _scaleImageView.image = [UIImage imageNamed:@"123"];
        
    }
    return _scaleImageView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];

    // 给导航条的背景图片传递一个空图片的UIImage对象
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializationDataSource];
    [self initializationInterFace];
    [self initializationConstraints];
}


#pragma mark - privateFuction

- (void)initializationDataSource {
    self.title = @"Heard下拉";
    self.lastOffsetY = -kHeardH;
}

- (void)initializationInterFace {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scaleImageView];
    [self.view addSubview:self.narBar];
    // 移除 NaviBar 自动64高度
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 修复 侧滑失效
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // 下移TableView内容
    self.tableView.contentInset = UIEdgeInsetsMake(kHeardH, 0, 0, 0);

    // 给导航条的背景图片传递一个空图片的UIImage对象
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)initializationConstraints {
    
    _tableView.frame = self.view.bounds;
    // 设置展示图片的约束
    [_scaleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);

    }];
 
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 计算当前偏移位置
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    CGFloat height = kHeardH - delta;
    if (height < kNavBarH) {
        height = kNavBarH;
    }
    [_scaleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    
    CGFloat alpha = delta / (kHeardH - kNavBarH);
    // 当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    if (alpha >= 1) {
        alpha = 0.99;
    }
    _narBar.alpha = alpha;
//    UIImage *image = [self imageWithColor:kColorHex(0x6f4f53, alpha)];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];


}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();

    return theImage;
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 123;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifer = @"systemCells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}





@end
