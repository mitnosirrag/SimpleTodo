//
//  ArrayFunctions.m
//  FlipCup
//
//  Created by Tim Garrison on 2/25/10.
//  Copyright 2010 Implied Solutions. All rights reserved.
//

#import "ArrayFunctions.h"


@implementation ArrayFunctions

+ (float)arraySum:(NSArray *)array {
    float sum = 0;
    for ( NSNumber *value in array ) {
        sum += [value floatValue];
    }
    return sum;
}

+ (float)arrayAverage:(NSArray *)array {
    int count = [array count];
    if ( 0 == count ) {
        return 0;
    }
    float average = [ArrayFunctions arraySum:array] / count;
    return average;
}
    

@end

NSInteger intSort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}