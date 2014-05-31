//
//  AGNotification.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/29.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGNotification : NSObject

UIKIT_EXTERN NSString* const AGConnectorDidBeginRetriveTitle;
UIKIT_EXTERN NSString* const AGConnectorDidFinishRetriveTitle;
UIKIT_EXTERN NSString* const AGConnectorDidBeginRefreshAllChannels;
UIKIT_EXTERN NSString* const AGConnectorDidFinishRefreshAllChannels;
UIKIT_EXTERN NSString* const AGConnectorInProgressRefreshAllChannels;


@end
