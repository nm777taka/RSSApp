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
    NSArray* channels;
}

@end
