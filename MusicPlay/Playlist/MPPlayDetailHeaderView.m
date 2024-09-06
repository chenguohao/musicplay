#import "MPPlayDetailHeaderView.h"
#import "Masonry.h"

@interface MPPlayDetailHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation MPPlayDetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupConstraint];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.detailLabel];
}




- (void)setupConstraint {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(60);  // Set appropriate size for the image
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.top.equalTo(self.imageView.mas_top);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.titleLabel);
    }];
}

@end
