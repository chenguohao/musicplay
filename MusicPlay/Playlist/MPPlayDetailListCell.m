#import "MPPlayDetailListCell.h"
#import "Masonry.h"
#import "SDWebImage/SDWebImage.h"
@interface MPPlayDetailListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic,strong) UILabel *albumLabel;
@property (nonatomic,strong) UIView *containerView;
@end

@implementation MPPlayDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupConstraint];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [UIView new];
    self.containerView.backgroundColor = UIColor.lightGrayColor;
    [self.contentView addSubview:self.containerView];
    
//    self.contentView.backgroundColor = UIColor.redColor;
    self.backgroundColor = UIColor.clearColor;
    self.coverImageView = [[UIImageView alloc] init];
    [self.containerView addSubview:self.coverImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.containerView addSubview:self.titleLabel];
    
    self.albumLabel =[[UILabel alloc] init];
    self.albumLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.containerView addSubview:self.albumLabel];
    
    self.artistLabel = [[UILabel alloc] init];
    self.artistLabel.font = [UIFont systemFontOfSize:14];
    self.artistLabel.textColor = [UIColor grayColor];
    [self.containerView addSubview:self.artistLabel];
}

- (void)setupConstraint {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(10);
            make.right.equalTo(self.contentView).mas_offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.centerY.equalTo(self.containerView);
        make.width.height.mas_equalTo(40);  // Set appropriate size for the cover image
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(15);
        make.top.equalTo(self.coverImageView.mas_top);
//        make.width.lessThanOrEqualTo(@(200));
        make.right.equalTo(self.containerView).offset(-15);
    }];
    
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.titleLabel);
    }];
    
    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView);
        make.width.lessThanOrEqualTo(@(200));
            make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (void)configureWithInfo:(NSDictionary *)info {
    self.titleLabel.text = info[@"attributes"][@"name"];
    self.artistLabel.text = info[@"attributes"][@"artistName"];
    self.albumLabel.text = info[@"attributes"][@"albumName"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString: [self wrapUrl:info[@"attributes"][@"artwork"][@"url"]]] ];  // Assuming image name is provided
}

- (NSString*)wrapUrl:(NSString*)url{
    NSString* resultUrl = [url stringByReplacingOccurrencesOfString:@"{w}" withString:@"100"];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"{h}" withString:@"100"];
   
    return  resultUrl;
}

@end
