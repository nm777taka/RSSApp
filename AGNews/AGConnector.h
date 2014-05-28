//
//  AGConnector.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/28.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGConnector : NSObject
{
    NSMutableArray *_retrieveTitleParsers;
    NSMutableArray *_refreshAllChannelParsers;
}

@property (nonatomic,readonly, getter = isNetworkAccessing)BOOL networkAccessing;

+ (AGConnector *)sharedConnector;

//フィードタイトルの取得
- (void)retreieveTitleWithUrlString:(NSString *)urlString;
- (void)cancelRetrieveTitleWithUrlString:(NSString *)urlString;

//登録したチャンネルの更新
- (BOOL)isRefreshingChannels;
- (void)refreshAllChannels;
- (float)progressOfRefreshAllChannels;
- (void)cancelRefreshAllChannels;
@end
