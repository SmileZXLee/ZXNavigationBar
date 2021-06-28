//
//  ZXNavHistoryStackCell.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/12/22.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import "ZXNavHistoryStackCell.h"
#import "ZXNavHistoryStackModel.h"
#import "ZXNavigationBarDefine.h"
@interface ZXNavHistoryStackCell()
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *lineView;
@end
@implementation ZXNavHistoryStackCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:17];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(ZXNavHistoryStackCellTitleX, 0, self.frame.size.width - ZXNavHistoryStackCellTitleX * 2, self.frame.size.height);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    self.lineView.backgroundColor = ZXNavDefalutLineColor;
}

- (void)setHistoryStackModel:(ZXNavHistoryStackModel *)historyStackModel{
    _historyStackModel = historyStackModel;
    self.contentLabel.text = historyStackModel.title;
    if(self.historyStackViewStyle == ZXNavHistoryStackViewStyleLight){
        self.contentView.backgroundColor = ZXNavHistoryStackViewStyleLightBackgroundColor;
        self.contentLabel.textColor = [UIColor blackColor];
    }else{
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = ZXNavHistoryStackViewStyleDarkBackgroundColor;
    }
    if(historyStackModel.isSelected){
        if(self.historyStackViewStyle == ZXNavHistoryStackViewStyleLight){
            self.contentView.backgroundColor = ZXNavHistoryStackViewStyleLightSelectedColor;
        }else{
            self.contentView.backgroundColor = ZXNavHistoryStackViewStyleDarkSelectedColor;
        }
    }
}
@end
