#import "Item.h"


@interface Item ()

// Private interface goes here.

@end


@implementation Item

// Custom logic goes here.

+ (Item *)insertNewItem
{
    Item *item = [Item createEntity];
    
    //識別子を作成
    CFUUIDRef uuid;
    NSString* identifier;
    uuid = CFUUIDCreate(NULL);
    identifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    CFRelease(uuid);
    item.identifier = identifier;
    
    return item;
}

@end
