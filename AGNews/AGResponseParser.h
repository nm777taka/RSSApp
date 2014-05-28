//
//  AGResponseParser.h
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/28.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    AGNetworkStateNotConnected = 0,
    AGNetworkStateInProgress,
    AGNetworkStateFinished,
    AGNetworkStateError,
    AGNetworkStateCanceled,
};

@class Item;

@interface AGResponseParser : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property int networkState;
@property NSString* feedUrlString;
@property NSURLConnection* connecton;
@property NSString* parsedChannelTitle;
@property NSString* parsedChannelLink;
@property NSMutableArray*  items;
@property NSMutableString *buffer;
@property NSMutableData*   downloadedData;
@property NSError*  error;

@property id        delegate;


- (void)parse;

- (void)cancel;

@end

//デリゲートメソッド
@interface NSObject(AGResponseParserDelegate)

- (void)parser:(AGResponseParser *)parser didReceiveResponse:(NSURLResponse*)response;
- (void)parser:(AGResponseParser *)parser didReceiveData:(NSData *)data;
- (void)parserDidFinishLoading:(AGResponseParser *)parser;
- (void)parser:(AGResponseParser *)parser didFailWithError:(NSError *)error;
- (void)parserDidCancel:(AGResponseParser *)parser;

@end
