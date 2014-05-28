// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Channel.h instead.

#import <CoreData/CoreData.h>


extern const struct ChannelAttributes {
	__unsafe_unretained NSString *feedUrlstring;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *title;
} ChannelAttributes;

extern const struct ChannelRelationships {
	__unsafe_unretained NSString *items;
} ChannelRelationships;

extern const struct ChannelFetchedProperties {
} ChannelFetchedProperties;

@class Item;







@interface ChannelID : NSManagedObjectID {}
@end

@interface _Channel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChannelID*)objectID;





@property (nonatomic, strong) NSString* feedUrlstring;



//- (BOOL)validateFeedUrlstring:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* identifier;



//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* index;



@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* link;



//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _Channel (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(Item*)value_;
- (void)removeItemsObject:(Item*)value_;

@end

@interface _Channel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFeedUrlstring;
- (void)setPrimitiveFeedUrlstring:(NSString*)value;




- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
