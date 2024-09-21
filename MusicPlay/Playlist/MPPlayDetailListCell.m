#import "MPPlayDetailListCell.h"
#import "Masonry.h"
#import "SDWebImage/SDWebImage.h"
@interface MPPlayDetailListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic,strong) UILabel *albumLabel;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *whiteBg;
@property (nonatomic,strong) UIView *line;
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
    self.backgroundColor = MPUITheme.theme_white;
    self.contentView.backgroundColor = MPUITheme.theme_white;
    self.whiteBg = [UIView new];
//    self.whiteBg.backgroundColor = MPUITheme.theme_white;
    [self.containerView addSubview:self.whiteBg];
    
    [self.contentView addSubview:self.containerView];
    
//    self.contentView.backgroundColor = UIColor.redColor;
    self.coverImageView = [[UIImageView alloc] init];
    [self.containerView addSubview:self.coverImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = MPUITheme.contentText_semi;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.containerView addSubview:self.titleLabel];
    
    self.albumLabel =[[UILabel alloc] init];
    self.albumLabel.textColor = MPUITheme.contentText_semi;
    self.albumLabel.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:self.albumLabel];
    
    self.artistLabel = [[UILabel alloc] init];
    self.artistLabel.font = [UIFont systemFontOfSize:12];
    self.artistLabel.textColor = MPUITheme.contentText;
    [self.containerView addSubview:self.artistLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = MPUITheme.contentText_semi;
    self.line.alpha = 0.15;
    [self.containerView addSubview:self.line];
}

- (void)setupConstraint {
    
    [self.whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(10);
            make.right.equalTo(self.containerView).offset(-10);
            make.top.bottom.equalTo(self.containerView);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(10);
        make.right.equalTo(self.contentView).mas_offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
     
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.centerY.equalTo(self.containerView);
        make.width.height.mas_equalTo(45);  // Set appropriate size for the cover image
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(15);
        make.top.equalTo(self.coverImageView.mas_top);
//        make.width.lessThanOrEqualTo(@(200));
        make.right.equalTo(self.containerView).offset(-15);
    }];
    
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
         
    }];
    
    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);;
        make.width.lessThanOrEqualTo(@(200));
        make.top.equalTo(self.artistLabel.mas_bottom);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(14);
            make.right.equalTo(self.containerView).offset(-14);
            make.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(1);
    }];
}

- (void)configureWithInfo:(NSDictionary *)info {
    self.titleLabel.text = info[@"attributes"][@"name"];
    self.artistLabel.text = info[@"attributes"][@"artistName"];
    self.albumLabel.text = info[@"attributes"][@"albumName"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString: [self wrapUrl:info[@"attributes"][@"artwork"][@"url"]]] placeholderImage:[UIImage imageNamed:@"cover_default"] ];  // Assuming image name is provided
      
}

- (NSString*)wrapUrl:(NSString*)url{
    NSString* resultUrl = [url stringByReplacingOccurrencesOfString:@"{w}" withString:@"100"];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"{h}" withString:@"100"];
   
    return  resultUrl;
}
-(void)setBgColor2:(UIColor *)bgColor{
    self.containerView.backgroundColor = bgColor;
     
}

-(UIView *)containerView{
    if(_containerView ==nil){
        _containerView = [UIView new];
    }
    return _containerView;
}

@end
