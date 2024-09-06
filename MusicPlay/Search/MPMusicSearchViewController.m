#import "MPMusicSearchViewController.h"
#import <Masonry/Masonry.h>
#import "MPMusicSearchWrapper.h"
@interface MPMusicSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic, strong) UIButton* cancelBtn;
@property (nonatomic,strong)MPMusicSearchWrapper* searchWrapper;
@property (nonatomic,copy)void(^onSelect)(NSDictionary*);
@end

@implementation MPMusicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchWrapper = [MPMusicSearchWrapper new];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.view. backgroundColor = UIColor.whiteColor;
    // 初始化搜索栏
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Search Albums";
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    
    // 初始化表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.cancelBtn = [UIButton new];
    [self.cancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(onDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    // 初始化搜索结果数组
    self.searchResults = @[]; // 初始为空
}

- (void)onDismiss{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setSelect:(void(^)(NSDictionary*))block{
    self.onSelect = block;
}

- (void)setupConstraints {
    // 布局搜索栏
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).offset(-100);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchBar.mas_right);
            make.top.equalTo(self.searchBar);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.searchBar);
        }];
    
    // 布局表格视图
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 当搜索栏中的文本改变时，触发搜索操作
    [self searchForText:searchText];
}

- (void)searchForText:(NSString *)searchText {
    // 在这里进行搜索逻辑
    // 假设我们有一个方法来获取搜索结果
    [self.searchWrapper searchForSongsWithQuery:searchText completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        self.searchResults = results;
        [self.tableView reloadData];
    }];
    
    // 重新加载表格视图以显示新结果
    [self.tableView reloadData];
}

- (void)fetchSearchResultsForQuery:(NSString *)query completion: (void(^)(NSArray * _Nonnull results, NSError * _Nonnull error))block{
    // 这里假设你有一个方法来获取搜索结果
    // 返回结果数组，示例中返回的是空数组
    
    [self.searchWrapper searchForSongsWithQuery:query completion:block ];
     
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // 配置 cell，展示搜索结果
    NSDictionary *result = self.searchResults[indexPath.row];
    cell.textLabel.text = result[@"attributes"][@"name"];
    cell.detailTextLabel.text = result[@"attributes"][@"artistName"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* selectInfo = self.searchResults[indexPath.row];
    if(self.onSelect){
        self.onSelect(selectInfo);
        [self onDismiss];
    }
}
@end
