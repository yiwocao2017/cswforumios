//
//  ConversationListVC.m
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ConversationListVC.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "ChatManager.h"
#import "NoticeListGroup.h"


#import "SystemNoticeVC.h"
#import "ZanVC.h"
#import "CommentVC.h"
#import "MentionVC.h"
#import "ContactsVC.h"

#import "NoticeTableView.h"

@interface ConversationListVC ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NoticeListGroup *group;

@property (nonatomic, strong) NoticeTableView *noticeTableView;

@property (nonatomic) id<IConversationModel> model;

//@property (nonatomic, strong) UIView *footerView;

@end

@implementation ConversationListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
 
    [self tableViewDidTriggerHeaderRefresh];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIBarButtonItem addRightItemWithImageName:@"消息列表－联系人" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(clickChat)];
    
    [ChatManager defaultManager].conversationListVC = self;
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self initHeaderView];

}

#pragma mark - Init

- (void)initHeaderView {
    
    _noticeTableView = [[NoticeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50*4 + 10 + 44) style:UITableViewStylePlain group:self.group];
    _noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noticeTableView.rowHeight = 50;
    
    self.tableView.tableHeaderView = _noticeTableView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initFooterView];
}

- (void)initFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    footerView.backgroundColor = kWhiteColor;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    topView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    [footerView addSubview:topView];
    
    UIView *topLineView = [[UIView alloc] init];
    
    topLineView.backgroundColor = [UIColor lineColor];
    
    [footerView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UILabel *titleLabel = [UILabel labelWithText:@"最近联系人" textColor:[UIColor colorWithHexString:@"#aaaaaa"] textFont:14.0];
    
    [footerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ([[EMClient sharedClient].chatManager getAllConversations].count == 0) {
            
            titleLabel.text = @"暂无消息";
            
            make.centerX.mas_equalTo(0);
            
        } else {
        
            make.left.mas_equalTo(20);

        }
        
        make.height.mas_lessThanOrEqualTo(20);
        make.width.mas_lessThanOrEqualTo(100);
        make.centerY.mas_equalTo(5);
        
    }];
    
    
    
    _noticeTableView.tableFooterView = footerView;
    
    
    
}

- (NoticeListGroup *)group {
    
    if (!_group) {
        
        CSWWeakSelf;
        _group = [[NoticeListGroup alloc] init];
        
        NSArray *names = @[@"赞",@"提到我的",@"评论",@"系统消息"];
        
        NSArray *imgNames = @[@"消息列表－点赞",@"消息列表－提到我的",@"消息列表－评论",@"消息列表－系统消息"];
        //赞
        NoticeListModel *zanItem = [NoticeListModel new];
        zanItem.imgName = imgNames[0];
        zanItem.text  = names[0];
        [zanItem setAction:^{
            
            //个人中心
            ZanVC *zanVC = [[ZanVC alloc] init];
            zanVC.userId = [TLUser user].userId;
            zanVC.title = @"赞";
            
            [weakSelf.navigationController pushViewController:zanVC animated:YES];
            
        }];
        
        //提到我的
        NoticeListModel *mentionItem = [NoticeListModel new];
        mentionItem.imgName = imgNames[1];
        mentionItem.text  = names[1];
        [mentionItem setAction:^{
            
            MentionVC *mentionVC = [MentionVC new];
            
            mentionVC.userId = [TLUser user].userId;
            mentionVC.title = names[1];
            [weakSelf.navigationController pushViewController:mentionVC animated:YES];
            
        }];
        
        //评论
        NoticeListModel *commentItem = [NoticeListModel new];
        commentItem.imgName = imgNames[2];
        commentItem.text  = names[2];
        [commentItem setAction:^{
            
            CommentVC *commentVC = [CommentVC new];
            
            commentVC.userId = [TLUser user].userId;
            commentVC.title = names[2];
            
            [weakSelf.navigationController pushViewController:commentVC animated:YES];
        }];
        
        //系统消息
        NoticeListModel *systemMsgItem = [NoticeListModel new];
        systemMsgItem.imgName = imgNames[3];
        systemMsgItem.text  = names[3];
        [systemMsgItem setAction:^{
            
            SystemNoticeVC *systemNoticeVC = [[SystemNoticeVC alloc] init];
            systemNoticeVC.title = @"系统消息";
            
            [weakSelf.navigationController pushViewController:systemNoticeVC animated:YES];
            
        }];
        
        _group.items = @[zanItem,mentionItem,commentItem,systemMsgItem];
        
    }
    return _group;
    
}

#pragma mark -  点击会 话列表 的回调
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel{

    if(conversationModel){
        EMConversation *conversation =  conversationModel.conversation;
        
        if(conversation){
            

     //chatView 父类中将未读消息置为已读
     ChatViewController *chatController = [[ChatViewController alloc]
                                           initWithConversationChatter:conversation.conversationId
                                           conversationType:conversation.type];
            
            chatController.title = conversationModel.title;
            //设置头像
            chatController.defaultUserAvatarName = @"个人详情头像";
            chatController.mineAvatarUrlPath = [TLUser user].userExt.photo ? [[TLUser user].userExt.photo convertImageUrl] : @"个人详情头像";
            
            //对方的？？？？
            if(conversationModel.avatarURLPath || conversationModel.avatarURLPath.length > 0){
                
                chatController.oppositeAvatarUrlPath = self.model.avatarURLPath? self.model.avatarURLPath: @"个人详情头像";

            }
            
            [self.navigationController pushViewController:chatController animated:YES];
            
        }
    
        //改变未读消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCountNotification" object:nil];
        
        //如果该会话有未读消息，刷新列表
        [self.tableView reloadData];
    
    }

}

#pragma mark -获取数据源
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    
    //根据conversion 的 ext属性,获取用户的 头像 和昵称 这个需要事先约定好
    
    if ([conversation.latestMessage.to isEqualToString:[TLUser user].userId]) {
        
        NSDictionary *ext = conversation.latestMessage.ext;
        
        NSString *imgUrl = ext[@"photo"];
        
        model.avatarURLPath = imgUrl ? [imgUrl convertImageUrl]: nil;
        
        model.title = ext[@"nickName"];
        
        self.model = model;
        
    } else {
    
        NSArray *contacts = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ContactList"];
        
        ContactModel *contactModel = [ContactModel new];
        
        for (NSData *data in contacts) {
            
            ContactModel *cModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if ([cModel.conversationId isEqualToString:conversation.conversationId]) {
                
                contactModel = cModel;
            }
        }
        
        model.title = contactModel.nickName;
        
        NSString *imgUrl = contactModel.photo;
        
        model.avatarURLPath = imgUrl ? [imgUrl convertImageUrl]: nil;
        
        self.model = model;
        
    }
    
    //思路1，从服务端获取，配合本地数据库缓存 缺点不及时
    //思路2，夹在消息中的ext,及时。不用配合本地数据库
    //选择思路2
    if(conversation.latestMessage.ext){
    //把ext 带有的用户信息存到数据库
        
//        [[EMClient sharedClient].chatManager importMessages:@[conversation] completion:^(EMError *aError) {
//            
//            if (!aError) {
//                
//                //                [TLAlert alertWithSucces:@"存到数据库成功"];
//            }
//        }];
//        
//        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
//
//        [array enumerateObjectsUsingBlock:^(EMConversation *conver, NSUInteger idx, BOOL *stop){
//            
//            if(![conver.conversationId isEqualToString:conversation.conversationId]){
//            
//                
//            }
//            
//        }];
    
    }
    
    return model;
    
}


- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - Events
- (void)clickChat {

    ContactsVC *contactsVC = [ContactsVC new];
    
    contactsVC.title = @"发起聊天";
    
    [self.navigationController pushViewController:contactsVC animated:YES];

}

@end
