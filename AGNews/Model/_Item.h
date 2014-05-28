// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.h instead.

#import <CoreData/CoreData.h>


extern const struct ItemAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *itemDescription;
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *pubData;
	__unsafe_unretained NSString *read;
	__unsafe_unretained NSString *timeStamp;
	__unsafe_unretained NSString *title;
} ItemAttributes;

extern const struct ItemRelationships {
	__unsafe_unretained NSString *channel;
} ItemRelationships;

extern const struct ItemFetchedProperties {
} ItemFetchedProperties;

@class Channel;









@interface ItemID : NSManagedObjectID {}
@end

@interface _Item : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ItemID*)objectID;





@property (nonatomic, strong) NSString* identifier;



//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* itemDescription;



//- (BOOL)validateItemDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* link;



//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pubData;



//- (BOOL)validatePubData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* read;



@property BOOL readValue;
- (BOOL)readValue;
- (void)setReadValue:(BOOL)value_;

//- (BOOL)validateRead:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timeStamp;



//- (BOOL)validateTimeStamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Channel *channel;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;





@end

@interface _Item (CoreDataGeneratedAccessors)

@end

@interface _Item (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSString*)primitiveItemDescription;
- (void)setPrimitiveItemDescription:(NSString*)value;




- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSString*)primitivePubData;
- (void)setPrimitivePubData:(NSString*)value;




- (NSNumber*)primitiveRead;
- (void)setPrimitiveRead:(NSNumber*)value;

- (BOOL)primitiveReadValue;
- (void)setPrimitiveReadValue:(BOOL)value_;




- (NSDate*)primitiveTimeStamp;
- (void)setPrimitiveTimeStamp:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (Channel*)primitiveChannel;
- (void)setPrimitiveChannel:(Channel*)value;


@end
