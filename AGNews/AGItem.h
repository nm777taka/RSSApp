//
//  Item.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/27.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AGItem : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * pubData;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSManagedObject *channel;

@end
