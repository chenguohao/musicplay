//
//  MPProfileEditViewController.m
//  MusicPlay
//
//  Created by Chen guohao on 9/11/24.
//

#import "MPProfileEditViewController.h"
#import "MPProfileManager.h"
#import "MPUserProfile.h"
#import "TZImagePickerController.h"
#import "SDWebImage/SDWebImage.h"
#import "MPAliOSSManager.h"
#import "MPNetworkManager.h"
@interface MPProfileEditViewController ()
@property (nonatomic,strong)UIImageView* avatar;
@property (nonatomic,strong)UIImageView* editIcon;
@property (nonatomic,strong)UITextField* nameInput;
@property (nonatomic,assign)BOOL isAvatarUpdate;
@property (nonatomic,assign)BOOL isNameUpdate;
@property (nonatomic,strong)UIButton *btn_save;
@property (nonatomic,strong)MPUserProfile* originProfile;
@end

@implementation MPProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupConstrait];
    [self setupProfile];
    
    @weakify(self);
    [RACObserve(self, isNameUpdate) subscribeNext:^(id isUpdate) {
            @strongify(self);
        self.navigationItem.rightBarButtonItem.enabled = self.isNameUpdate ||self.isAvatarUpdate;
    }];
    
    [RACObserve(self, isAvatarUpdate) subscribeNext:^(id isUpdate) {
            @strongify(self);
        self.navigationItem.rightBarButtonItem.enabled = self.isNameUpdate ||self.isAvatarUpdate;
    }];
    [self.nameInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


}

- (void)textFieldDidChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    self.isNameUpdate = ![textField.text isEqualToString:self.originProfile.name] ;
}

- (void)setupUI{
    self.title = @"Profile Edit";
    self.view.backgroundColor = MPUITheme.theme_white;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    self.btn_save  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_save.frame = CGRectMake(4, 0, 40, 40);
    [self.btn_save setTitle:@"Save" forState:UIControlStateNormal];
    [self.btn_save setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.btn_save setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
    [self.btn_save addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn_save];
    
    self.avatar = [UIImageView new];
    self.avatar.layer.cornerRadius = 50;
    self.avatar.clipsToBounds = YES;
    self.avatar.userInteractionEnabled = YES;
    [self.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar)]];
    
    [self.view addSubview:self.avatar];
    
    self.nameInput = [UITextField new];
    self.nameInput.layer.borderWidth = 1;
    self.nameInput.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.nameInput.textAlignment = NSTextAlignmentCenter;
    self.nameInput.layer.cornerRadius = 10;
    [self.view addSubview:self.nameInput];
    
    self.editIcon = [UIImageView new];
    self.editIcon.image = [UIImage imageNamed:@"avatar_edit"];
    [self.view addSubview:self.editIcon];
}

- (void)setupConstrait{
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.height.mas_equalTo(100);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
    }];
    
    [self.nameInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatar.mas_bottom).offset(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(45);
            make.centerX.equalTo(self.view);
    }];
    
    [self.editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.avatar);
            make.bottom.equalTo(self.avatar);
            make.width.height.mas_equalTo(30);
    }];
}

- (void)setupProfile{
    MPUserProfile*profile = MPProfileManager.sharedManager.curUser;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:profile.avatar]];
    self.nameInput.text = profile.name;
    self.originProfile = [profile copy];
}

- (void)onAvatar{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage* image = photos[0];
        self.avatar.image = image;
        self.isAvatarUpdate = YES;
      
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kScreenWidth  = [UIScreen mainScreen].bounds.size.width;
    imagePickerVc.cropRect = CGRectMake(0,(kScreenHeight - kScreenWidth) / 2, kScreenWidth, kScreenWidth);
    imagePickerVc.allowCrop = YES;
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)snapProfile{
    
}


- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSave{
    
    NSString* newName = self.nameInput.text;
    __block  NSString* newurl = self.originProfile.avatar;
    __weak typeof(self) wkself = self;
    void (^onUpdate)(void) = ^(){
        MPUserProfile* user =  [MPProfileManager sharedManager].curUser ;
        user.name = newName;
        user.avatar = newurl;
        [[MPProfileManager sharedManager] cacheUserProfile:user];
        [wkself onBack];
    };
    
    if(self.isAvatarUpdate){
        NSData *imageData = UIImageJPEGRepresentation(self.avatar.image, 0.7);
        [DNEHUD showLoading:@"uploading"];
        [[MPAliOSSManager sharedManager] uploadData:imageData withBlock:^(NSString * url, NSError * err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DNEHUD hideHUD];
                if(err){
                    [DNEHUD showMessage:err.description];
                }else{
                    [DNEHUD showMessage:@"Upload Success"];
                    NSLog(@"url %@",url);
                    newurl = url;
                    [self updateProfileWithName:newName Avatar:newurl Complete:onUpdate];
                }
            });
        }];
    }else{
        
        [self updateProfileWithName:newName Avatar:newurl Complete:onUpdate];
    }
}

- (void)updateProfileWithName:(NSString*)name
                       Avatar:(NSString*)avatar
                     Complete:(void(^)(void))block
{
    
    NSDictionary* param = @{
        @"userID":@(self.originProfile.uid),
        @"avatar":avatar,
        @"name":name
    };
    [DNEHUD showLoading:@"updating..."];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/updateProfile" Params:param Completion:^(id rsp , NSError * err) {
        [DNEHUD hideHUD];
        if(err){
            [DNEHUD showMessage:err.description];
        }else{
            [DNEHUD showMessage:@"Update Success"];
            if(block){
                block();
            }
        }
    }];
}

@end
