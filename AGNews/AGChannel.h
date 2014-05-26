//
//  Channel.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/27.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface AGChannel : NSManagedObject

@property (nonatomic, retain) NSString * feedUrlstring;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *items;
@end

@interface AGChannel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
