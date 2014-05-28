//
//  AGResponseParser.m
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/28.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import "AGResponseParser.h"
#import "Item.h"
#import "Channel.h"

@implementation AGResponseParser{
    BOOL _foundRss;
    BOOL _isRss;
    BOOL _isChannel;
    BOOL _isItem;
    Item* _currentItem;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //初期化
    self.networkState = AGNetworkStateNotConnected;
    self.items = [NSMutableArray array];
    
    return self;
}

#pragma mark - Parse

- (void)parse
{
    //リクエストの作成
    NSURLRequest* request = nil;
    if (self.feedUrlString) {
        NSURL* url = [NSURL URLWithString:self.feedUrlString];
        if (url) {
            request = [NSURLRequest requestWithURL:url];
        }
    }
    
    if (!request) {
        return;
    }
    
    //データバッファの作成
    self.downloadedData = [NSMutableData data];
    
    //NSURLConnectionオブジェクト作成
    self.connecton = [NSURLConnection connectionWithRequest:request delegate:self];
    
    //ネットワークの状態を設定
    self.networkState = AGNetworkStateInProgress;
}

#pragma mark - cancel

- (void)cancel
{
    //ネットワークアクセスのキャンセル
    [self.connecton cancel];
    
    //アクセス状態の設定
    self.networkState = AGNetworkStateCanceled;
    
    //デリゲート通知
    //デリゲートオブジェクトがちゃんとデリゲートメソッドを持ってるかチェック
    if ([self.delegate respondsToSelector:@selector(parserDidCancel:)]) {
        [self.delegate parserDidCancel:self];
    }
    
    
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //デリゲートに通知
    if ([self.delegate respondsToSelector:@selector(parser:didReceiveResponse:)]) {
        [self.delegate parser:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //ダウンロード済データを柄
    [self.downloadedData appendData:data];
    
    if ([self.delegate respondsToSelector:@selector(parser:didReceiveData:)]) {
        [self.delegate parser:self didReceiveData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   //フラグ初期化
    _foundRss = NO;
    _isRss = NO;
    _isChannel = NO;
    _isItem = NO;
    _currentItem = nil;
    
    [_items removeAllObjects];
    
    //XMLパーサの作成
    NSXMLParser* parser;
    parser = [[NSXMLParser alloc]initWithData:self.downloadedData];
    [parser setDelegate:self];
    
    //パース実行
    [parser parse];
    
    //成功した場合(RSS要素があった場合)
    if (_foundRss) {
        self.networkState = AGNetworkStateFinished;
        
        //デリゲート通知
        if ([self.delegate respondsToSelector:@selector(parserDidFinishLoading:)]) {
            [self.delegate parserDidFinishLoading:self];
        }
    }
    
    //失敗
    else {
        self.networkState = AGNetworkStateError;
        
        //デリゲート通知
        if ([self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
            NSError *error;
            error = [NSError errorWithDomain:@"RSS" code:0 userInfo:nil];
            [self.delegate parser:self didFailWithError:nil];   
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.networkState = AGNetworkStateError;
    
    //デリゲート通知
    if ([self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
}

#pragma mark -NSXMLParserDelegate

//要素の開始
- (void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI
        qualifiedName:(NSString *)qName
        attributes:(NSDictionary *)attributeDict
{
    //rssの場合
    if ([elementName isEqualToString:@"rss"]) {
        _foundRss = YES;
        _isRss = YES;
    }
    
    //channelの場合
    else if ([elementName isEqualToString:@"channel"]) {
        _isChannel = YES;
    }
    
    //itemの場合
    else if ([elementName isEqualToString:@"item"]) {
        _isItem = YES;
        
        //アイテム作成
        Item *item;
        item = [Item insertNewItem];
        [self.items addObject:item];
        
        //パース中アイテムとして設定
        _currentItem = item;
        
    }
    
    //それ以外の要素で取得する必要のあるもの
    else if ([elementName isEqualToString:@"title"] ||
             [elementName isEqualToString:@"link"] ||
             [elementName isEqualToString:@"description"] ||
             [elementName isEqualToString:@"pubData"])
    {
        //バッファ作成
        self.buffer = [NSMutableString string];
    }
}

//要素の終了
- (void)parser:(NSXMLParser *)parser
        didEndElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI
        qualifiedName:(NSString *)qName
{
    //rssの場合
    if ([elementName isEqualToString:@"rss"]) {
        _isRss = NO;
    }
    
    //channelの場合
    else if ([elementName isEqualToString:@"channel"]) {
        _isChannel = NO;
    }
    
    //itemの場合
    else if ([elementName isEqualToString:@"item"]) {
        _isItem = NO;
    }
    
    //titleの場合
    else if ([elementName isEqualToString:@"title"]) {
        //アイテムのtitileの場合
        if (_isItem) {
            _currentItem.title = self.buffer;
        }
        
        //チャンネルのtitleの場合
        else if (_isChannel) {
            self.parsedChannelTitle = self.buffer;
        }
    }
    
    //リンクの場合
    else if ([elementName isEqualToString:@"link"]) {
        //アイテムのlinkの場合
        if (_isItem) {
            _currentItem.link = self.buffer;
        }
        
        //チャンネルのlinkの場合
        else if (_isChannel) {
            self.parsedChannelLink = self.buffer;
        }
    }
    
    //descriptionの場合
    else if ([elementName isEqualToString:@"description"]) {
        //アイテムのディスクリプション
        if (_isItem) {
            _currentItem.itemDescription = self.buffer;
        }
    }
    
    //pubDataの場合
    //ほんとはpudDateだけどミスったのでそのままいく
    else if ([elementName isEqualToString:@"pubDate"]) {
        if (_isItem) {
            _currentItem.pubData = _buffer;
        }
    }
    
}

//文字列の出現
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //文字列の追加
    [self.buffer appendString:string];
}

@end
