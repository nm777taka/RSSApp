//
//  AGConnector.m
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/28.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import "AGConnector.h"

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

- (BOOL)isNetworkAccessing
{
    return _retrieveTitleParsers.count > 0 || _refreshAllChannelParsers.count > 0;
}

#pragma mark -- フィードタイトルの取得--
- (void)retreieveTitleWithUrlString:(NSString *)urlString
{
    //現在のネットワークアクセス状況を取得
    BOOL networkAccessing = self.networkAccessing;
    
    //登録しているチャンネルを取得
    //パーサを作ってから作る
}

@end
