//
//  AGConnector.m
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/28.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import "AGConnector.h"
#import "AGResponseParser.h"
#import "AGNotification.h"
#import "AGDataManager.h"
#import "Channel.h"
#import "Item.h"

@implementation AGConnector

#pragma mark init
static AGConnector* _sharedInstance = nil;

+(AGConnector *)sharedConnector
{
    if (!_sharedInstance) {
        _sharedInstance = [AGConnector new];
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _refreshAllChannelParsers = [NSMutableArray array];
    _retrieveTitleParsers = [NSMutableArray array];
    
    return self;
}

#pragma mark -- カスタムgetter --
- (BOOL)isNetworkAccessing
{
    return _retrieveTitleParsers.count > 0 || _refreshAllChannelParsers.count > 0;
}

#pragma mark -- フィードタイトルの取得--
- (void)retreieveTitleWithUrlString:(NSString *)urlString
{
    //現在のネットワークアクセス状況を取得
    BOOL networkAccessing = self.networkAccessing;
    
    //レスポンスパーサーの作成
    AGResponseParser* parser;
    parser = [[AGResponseParser alloc]init];
    parser.feedUrlString = urlString;
    parser.delegate = self;
    
    //パース開始
    [parser parse];
    
    //パーサの追加
    [_retrieveTitleParsers addObject:parser];
    
    //networkAccessingの値を更新
    if (networkAccessing != self.networkAccessing) { //ゲッターは独自に設定してる
        [self willChangeValueForKey:@"networkAccessing"];
        [self didChangeValueForKey:@"networkAccessing"];
    }
    
    //userInfo
    NSMutableDictionary* userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    //ノーティフィケーション
    [[NSNotificationCenter defaultCenter]postNotificationName:AGConnectorDidBeginRetriveTitle object:userInfo];
    
}

- (void)cancelRetrieveTitleWithUrlString:(NSString *)urlString
{
    //指定されたパーサを検索
    for (AGResponseParser* parser in _retrieveTitleParsers) {
        //パーサをキャンセル
        [parser cancel];
        
        //userinfo
        NSMutableDictionary* userInfo;
        userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        
        //通知
        [[NSNotificationCenter defaultCenter]postNotificationName:AGConnectorDidFinishRetriveTitle object:userInfo];
        
        //networkAccessing更新
        [self willChangeValueForKey:@"networkAccessing"];
        [_retrieveTitleParsers removeObject:parser];
        [self didChangeValueForKey:@"networkAccessing"];
        
        break;
    }
}

#pragma mark -- 登録したすべてのチャンネルの更新 --

- (BOOL)isRefreshingChannels
{
    return _refreshAllChannelParsers.count > 0;
    
}

- (void)refreshAllChannels
{
    //現在の更新状況を確認(一度に一回まで)
    if ([self isRefreshingChannels]) {
        return;
    }
    
    //現在のネットワーク状況
    BOOL networkAccessing;
    networkAccessing = self.networkAccessing;
    
    //登録してるチャンネルの取得 (ソートされてる)
    NSArray* channels = [AGDataManager sharedManager].sortedChannels;
    
    //チャンネル更新
    for (Channel* channel in channels) {
        //レスポンスパーサ
        AGResponseParser* parser = [AGResponseParser new];
        parser.feedUrlString = channel.feedUrlstring;
        parser.delegate = self;
        
        [parser parse];
        
        [_refreshAllChannelParsers addObject:parser];
    }
    
    //networkAccessing更新
    if (networkAccessing != self.networkAccessing) {
        [self willChangeValueForKey:@"networkAccessing"];
        [self didChangeValueForKey:@"networkAccessing"];
    }
    
    //userInfo
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:_refreshAllChannelParsers forKey:@"parsers"];
    
    //通知
    [[NSNotificationCenter defaultCenter]postNotificationName:AGConnectorDidBeginRefreshAllChannels object:userInfo];
}

- (float)progressOfRefreshAllChannels
{
    //パーサがない場合
    if (_refreshAllChannelParsers.count == 0) {
        return 1.0f;
    }
    
    //進捗計算
    int doneCount = 0;
    for (AGResponseParser* parser in _refreshAllChannelParsers) {
        //ネットワーク状況確認
        int networkState = parser.networkState;
        if (networkState == AGNetworkStateFinished ||
            networkState == AGNetworkStateError ||
            networkState == AGNetworkStateCanceled) {
            
            doneCount++;
        }
        
    }
    
    return (float)doneCount / _refreshAllChannelParsers.count;
}

- (void)cancelRefreshAllChannels
{
    //すべてのパーサをキャンセル
    for (AGResponseParser* parser in _refreshAllChannelParsers) {
        [parser cancel];
    }
    
    //userInfo
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:_refreshAllChannelParsers forKey:@"parsers"];
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:AGConnectorDidFinishRefreshAllChannels object:userInfo];
}

#pragma mark -- AGParserDelegate -- 
- (void)parser:(AGResponseParser *)parser didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)parser:(AGResponseParser *)parser didReceiveData:(NSData *)data
{
    
}

- (void)parserDidFinishLoading:(AGResponseParser *)parser
{
    //フィードタイトルの取得
    if ([_retrieveTitleParsers containsObject:parser]) {
        
        [self _notityRetriveTitleStatusWithParser:parser];
    }
    
    //登録したすべてのチャンネルの更新の場合
    else if ([_refreshAllChannelParsers containsObject:parser]) {
        
        Channel* channel = nil;
        
        for (Channel* ch in [AGDataManager sharedManager].sortedChannels) {
            if ([ch.feedUrlstring isEqualToString:parser.feedUrlString]) {
                channel = ch;
                break;
            }
        }
        
       //パースされたチャンネル情報を設定
        channel.feedUrlstring = parser.feedUrlString;
        channel.title = parser.parsedChannelTitle;
        channel.link = parser.parsedChannelLink;
        
        //現在のアイテムを削除
        for (Item* item in parser.items) {
            
            [[AGDataManager sharedManager] deleteCurrentItem:item];
        }
        
        //パースされたアイテムを設定
        for (Item* item in parser.items) {
            item.channel = channel;

        }
        
        [self _notifyRefreshAllChannelStatus];
    }
}

- (void)parser:(AGResponseParser *)parser didFailWithError:(NSError *)error
{
    if ([_retrieveTitleParsers containsObject:parser]) {
        [self _notityRetriveTitleStatusWithParser:parser];
    }
    else if ([_refreshAllChannelParsers containsObject:parser]) {
        [self _notifyRefreshAllChannelStatus];
    }
}

- (void)parserDidCancel:(AGResponseParser *)parser
{
    if ([_retrieveTitleParsers containsObject:parser]) {
        [self _notityRetriveTitleStatusWithParser:parser];
    }
    else if ([_refreshAllChannelParsers containsObject:parser]) {
        [self _notifyRefreshAllChannelStatus];
    }
}

- (void)_notityRetriveTitleStatusWithParser:(AGResponseParser *)parser
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AGConnectorDidFinishRetriveTitle object:userInfo];
    
    [self willChangeValueForKey:@"networkAccessing"];
    [_retrieveTitleParsers removeObject:parser];
    [self didChangeValueForKey:@"networkAccessing"];
}

- (void)_notifyRefreshAllChannelStatus
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:_refreshAllChannelParsers forKey:@"parsers"];
    
    //進捗
    float progress = [self progressOfRefreshAllChannels];
    
    //通知
    NSString* name;
    if (progress < 1.0f) {
        name =AGConnectorInProgressRefreshAllChannels;
    } else {
        name = AGConnectorDidFinishRefreshAllChannels;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:userInfo];
    
    if (progress == 1.0f) {
        
        [self willChangeValueForKey:@"networkAccessing"];
        [_refreshAllChannelParsers removeAllObjects];
        [self didChangeValueForKey:@"networkAccessing"];
    }
    
}
@end
