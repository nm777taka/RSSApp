//
//  AGDataManager.m
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/31.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import "AGDataManager.h"
#import "Channel.h"
#import "Item.h"

@implementation AGDataManager

static AGDataManager* _sharedInstance = nil;

+ (AGDataManager *)sharedManager
{
    if (!_sharedInstance) {
        _sharedInstance = [AGDataManager new];
    }
    
    return _sharedInstance;
}

#pragma mark -- カスタムGetter --

- (NSArray *)sortedChannels
{
    NSArray* sortedChannels = [NSArray new];
    
    sortedChannels = [Channel MR_findAllSortedBy:@"index" ascending:YES];
    
    return sortedChannels;
}

#pragma mark -- チャンネル操作 --
- (Channel *)insertNewChannel
{
    Channel* newChannel = [Channel createEntity];
    
    //識別子を作成
    CFUUIDRef uuid;
    NSString* identifier;
    uuid = CFUUIDCreate(NULL);
    CFRelease(uuid);
    newChannel.identifier = identifier;
    
    //インデックスの設定
    NSArray* sortedChannel = self.sortedChannels;
    if (sortedChannel.count > 0) {
        //最後のチャンネル
        Channel* lastChannel = [sortedChannel lastObject];
        
        newChannel.index = [NSNumber numberWithInt:[lastChannel.index intValue] + 1];
    }
    
    
    return newChannel;
}

- (void)moveChannelAtIndex:(int)fromIndex toIndex:(int)toIndex
{
    NSMutableArray* sortedChanels = [NSMutableArray arrayWithArray:self.sortedChannels];
    
    //引数チェック
    if (fromIndex < 0 || fromIndex > sortedChanels.count -1 ) {
        return;
    }
    if (toIndex < 0 || toIndex > sortedChanels.count ) {
        return;
    }
    
    //移動
    Channel* channel = [sortedChanels objectAtIndex:fromIndex];
    [sortedChanels removeObjectAtIndex:fromIndex];
    [sortedChanels insertObject:channel atIndex:toIndex];
    
    //インデックスを更新
    int index = 0;
    for (Channel* channel in sortedChanels) {
        channel.index = [NSNumber numberWithInt:index++];
    }
}

#pragma  mark -- アイテム操作 --
- (Item *)insertNewItem
{
    Item* newItem = [Item createEntity];
    
    //識別子
    CFUUIDRef uuid;
    NSString* identifier;
    uuid = CFUUIDCreate(NULL);
    identifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    CFRelease(uuid);
    newItem.identifier = identifier;
    
    return newItem;
}

- (void)deleteCurrentItem:(Item *)currentItem
{
    [currentItem MR_deleteEntity];
}

#pragma mark -- 永続化 --
- (void)save
{
    NSManagedObjectContext* context = [NSManagedObjectContext defaultContext];
    [context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"-------> save\n%@",context);
        } else {
            NSLog(@"-------> error : %@",error);
        }
    }];
    
}
@end
