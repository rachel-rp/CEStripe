/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "CoCoolelephantStripeViewProxy.h"
#import "TiUtils.h"

@implementation CoCoolelephantStripeViewProxy

-(void)createToken:(id)args
{
    [[self view] performSelectorOnMainThread:@selector(createToken:) withObject:args waitUntilDone:NO];
}

@end
