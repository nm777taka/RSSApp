//
//  AGDataManager.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/31.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@class Channel;

@interface AGDataManager : NSObject

@property(nonatomic) NSArray* sortedChannels;

+ (AGDataManager *)sharedManager;

//チャンネル操作
- (Channel*)insertNewChannel;
- (void)moveChannelAtIndex:(int)fromIndex toIndex:(int)toIndex;

//アイテム操作
- (Item*)insertNewItem;
- (void)deleteCurrentItem:(Item *)currentItem;

- (void)save;

@end
