// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.m instead.

#import "_Item.h"

const struct ItemAttributes ItemAttributes = {
	.identifier = @"identifier",
	.itemDescription = @"itemDescription",
	.link = @"link",
	.pubData = @"pubData",
	.read = @"read",
	.timeStamp = @"timeStamp",
	.title = @"title",
};

const struct ItemRelationships ItemRelationships = {
	.channel = @"channel",
};

const struct ItemFetchedProperties ItemFetchedProperties = {
};

@implementation ItemID
@end

@implementation _Item

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Item";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc_];
}

- (ItemID*)objectID {
	return (ItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"readValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"read"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic identifier;






@dynamic itemDescription;






@dynamic link;






@dynamic pubData;






@dynamic read;



- (BOOL)readValue {
	NSNumber *result = [self read];
	return [result boolValue];
}

- (void)setReadValue:(BOOL)value_ {
	[self setRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveReadValue {
	NSNumber *result = [self primitiveRead];
	return [result boolValue];
}

- (void)setPrimitiveReadValue:(BOOL)value_ {
	[self setPrimitiveRead:[NSNumber numberWithBool:value_]];
}





@dynamic timeStamp;






@dynamic title;






@dynamic channel;

	






@end
