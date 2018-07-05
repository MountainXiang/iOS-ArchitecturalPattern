//
//  MVPViewController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MVPViewController.h"
#import "MVPPresenter.h"

#define kMargin 30

@interface MVPViewController () <MVPProtocol>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong)UILabel *heroNameLabel;

@property (nonatomic, strong)UIImageView *heroIv;

@property (nonatomic, strong)UILabel *heroSkillLabel;

@end

@implementation MVPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MVP";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.greaterThanOrEqualTo(@0.f);
    }];
    
    MVPPresenter *presenter = [MVPPresenter new];
    presenter.delegate = self;
    [presenter renderUI];
}

- (void)dealloc {
    DLOG_METHOD
}

#pragma mark - MVPProtocol
- (void)renderHeroName:(NSString *)heroName {
    UILabel *heroNameLabel = [[UILabel alloc] init];
    heroNameLabel.numberOfLines = 0;
    heroNameLabel.text = heroName;
    [self.contentView addSubview:heroNameLabel];
    _heroNameLabel = heroNameLabel;
    
    [heroNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).dividedBy(2).mas_offset(- kMargin / 2 * 3);
        make.top.equalTo(self.contentView).mas_offset(kMargin);
        make.right.equalTo(self.contentView).mas_offset(-kMargin);
    }];
}

- (void)renderHeroPicture:(NSString *)heroPicture {
    UIImageView *heroIv = [[UIImageView alloc] init];
    heroIv.image = [UIImage imageNamed:heroPicture];
    CGFloat scale = heroIv.image.size.height / heroIv.image.size.width;
    [self.contentView addSubview:heroIv];
    _heroIv = heroIv;

    [heroIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.5).mas_offset(- kMargin / 2 * 3);
        make.top.equalTo(self.contentView).mas_offset(kMargin);
        make.left.equalTo(self.contentView).mas_offset(kMargin);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.5 * scale);
        make.bottom.equalTo(self.contentView).offset(-kMargin);
    }];
}

- (void)renderHeroSkill:(NSString *)heroSkill {
    UILabel *heroSkillLabel = [[UILabel alloc] init];
    heroSkillLabel.numberOfLines = 0;
    heroSkillLabel.font = [UIFont systemFontOfSize:15];
    heroSkillLabel.textColor = [UIColor grayColor];
    heroSkillLabel.text = heroSkill;
    [self.contentView addSubview:heroSkillLabel];
    _heroSkillLabel = heroSkillLabel;
    
    [heroSkillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.heroNameLabel);
        make.top.equalTo(self.heroNameLabel).mas_offset(kMargin);
        make.right.equalTo(self.contentView).mas_offset(-kMargin);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-kMargin);
    }];
}

- (void)renderNetworkError:(NSError *)error {
    [SVProgressHUD fk_displayErrorWithStatus:@"无法获取英雄信息,请检查网络~"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
