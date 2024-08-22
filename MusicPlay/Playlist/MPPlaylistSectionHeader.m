#import "MPPlaylistSectionHeader.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h" // Assuming you are using SDWebImage for loading images
#import "MPPlayDetailListCell.h"
@interface MPPlaylistSectionHeader()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artNameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView* iconLike;
@property (nonatomic, strong) UILabel *likeNumLabel;
@property (nonatomic, strong) UILabel *playNumLabel;

@property (nonatomic, strong) UIImageView* iconPlay;
@property (nonatomic, strong) UIView* cardView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIView* topView;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic, strong) NSDictionary* infoDict;
@end

@implementation MPPlaylistSectionHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupConstraints];
        
        self.clipsToBounds = YES;
        self.containerView.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI {
    
//    self.contentView.backgroundColor = UIColor.darkGrayColor;
   
    self.containerView = [UIView new];
    [self addSubview:self.containerView];
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"MPPlayDetailListCell"];
    [self.containerView addSubview:self.tableView];
    
    self.topView = [UIView new];
    [self.containerView addSubview:self.topView];
    
    self.cardView = [UIView new];
    self.cardView.backgroundColor = UIColor.whiteColor;
    self.cardView.layer.cornerRadius = 10;
    [self.containerView addSubview:self.cardView];
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.layer.cornerRadius = 5.0;
    self.coverImageView.clipsToBounds = YES;
    [self.cardView addSubview:self.coverImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.cardView addSubview:self.nameLabel];
    
    self.artNameLabel = [[UILabel alloc] init];
    self.artNameLabel.font = [UIFont systemFontOfSize:12];
    self.artNameLabel.textColor = [UIColor lightGrayColor];
    [self.cardView addSubview:self.artNameLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textColor = [UIColor whiteColor];
    [self.cardView addSubview:self.detailLabel];
    
    self.iconLike = [[UIImageView alloc] init];
    self.iconLike.image = [UIImage imageNamed:@"icon_like_off"];
    [self.cardView addSubview:self.iconLike];
    
    self.likeNumLabel = [UILabel new];
    [self.cardView addSubview:self.likeNumLabel];
    
    
    self.iconPlay = [UIImageView new];
    self.iconPlay.image = [UIImage imageNamed:@"icon_played"];
    [self.cardView addSubview:self.iconPlay];
    
    self.playNumLabel = [UILabel new];
    [self.cardView addSubview:self.playNumLabel];
}

- (void)setupConstraints {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView);
            make.right.equalTo(self.containerView);
            make.top.equalTo(self.containerView);
            make.height.equalTo(@(20));
    }];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
            make.height.equalTo(@(95));
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.cardView).offset(10);
//        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.height.equalTo(@(80));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_top).offset(10);
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.right.equalTo(self.cardView).offset(-10);
    }];

    [self.artNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.cardView).offset(-10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.artNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.cardView).offset(-10);
    }];
    
    
    [self.playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cardView).offset(-10);
            make.bottom.equalTo(self.cardView).offset(-10);
            
    }];
    
    [self.iconPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(20));
            make.centerY.equalTo(self.playNumLabel);
            make.right.equalTo(self.playNumLabel.mas_left).offset(-5);
    }];
    
    [self.likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconPlay.mas_left).offset(-10);
            make.centerY.equalTo(self.iconPlay);
            
    }];
    
    [self.iconLike mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.likeNumLabel.mas_left).offset(-4);
        make.centerY.equalTo(self.likeNumLabel);
        make.width.height.equalTo(@(20));
    }];
}

- (void)configureWithDictionary:(NSDictionary *)dict
                          index:(NSInteger)index {
    self.infoDict = dict;
    NSString *coverUrl = dict[@"coverUrl"];
    NSString *name = dict[@"title"];
    NSString *artName = dict[@"artistname"];
//    NSString *detail = dict[@"likenum"];
    self.likeNumLabel.text = [dict[@"likenum"] stringValue];
    self.playNumLabel.text =[dict[@"playnum"] stringValue];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.nameLabel.text = name;
    self.artNameLabel.text = [NSString stringWithFormat:@"by %@", artName];
    
    if (index % 2 == 0) {
        self.containerView.backgroundColor = UIColor.lightGrayColor;
        self.cardView.backgroundColor = UIColor.darkGrayColor;
        self.topView.backgroundColor = UIColor.darkGrayColor;
    }else{
        self.containerView.backgroundColor = UIColor.darkGrayColor;
        self.cardView.backgroundColor = UIColor.lightGrayColor;
        self.topView.backgroundColor = UIColor.lightGrayColor;
    }
    CGFloat newHeight = 60*((NSArray*)self.infoDict[@"playlist"]).count;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_bottom).offset(5);
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.height.equalTo(@(newHeight));
    }];
    
//    self.detailLabel.text = detail;
}



- (void)setIsExpanded:(BOOL)isExpanded{
    _isExpanded = isExpanded;
//    self.tableView.hidden = !isExpanded;
//    if(isExpanded){
        [self.tableView reloadData];
//    }
    CGFloat newHeight = isExpanded ?60*((NSArray*)self.infoDict[@"playlist"]).count:0;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cardView.mas_bottom).offset(5);
//        make.left.equalTo(self.containerView).offset(10);
//        make.right.equalTo(self.containerView).offset(-10);
//        make.height.equalTo(@(newHeight));
//    }];
    
    

//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.frame = CGRectMake(10, 0, self.frame.size.width - 40, newHeight);
//    }];
       
        
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return((NSArray*) self.infoDict[@"playlist"]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPPlayDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPPlayDetailListCell" forIndexPath:indexPath];
    NSDictionary *item = self.infoDict[@"playlist"][indexPath.row];
    [cell configureWithInfo:item];
    return cell;
}

@end
