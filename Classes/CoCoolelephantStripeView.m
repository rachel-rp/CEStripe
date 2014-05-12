/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "CoCoolelephantStripeView.h"

@implementation CoCoolelephantStripeView


-(STPView*) stripeView
{
    if( stripeView == nil )
    {
        //NSLog(@"INITIALIZING VIEW %@",[self frame]);
        stripeView = [[STPView alloc] initWithFrame:[self frame]];
        
        [self addSubview:stripeView];
        [stripeView setDelegate:self];
        
    }
    return stripeView;
    
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    //NSLog(@"[VIEW LIFECYCLE EVENT] frameSizeChanged: %@", timePicker);
    
    if (stripeView != nil) {
        
        // You must call the special method 'setView:positionRect' against
        // the TiUtils helper class. This method will correctly layout your
        // child view within the correct layout boundaries of the new bounds
        // of your view.
        [TiUtils setView:stripeView positionRect:bounds];
        
        STPView *oldView = stripeView;
        [stripeView removeFromSuperview];
        stripeView = [[STPView alloc] initWithFrame:bounds andKey:oldView.key];
        
        [self addSubview:stripeView];
        [stripeView setDelegate:self];
        
    }
    
}

//Delegate method fired if the card is has a valid format
- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    
    //NSLog(@"isValid");
    
    if ([self.proxy _hasListeners:@"cardIsValid"])
    {
        // fire event
        [self.proxy fireEvent:@"cardIsValid" withObject:@{
                                                    @"value":NUMBOOL(valid)
                                                    }];
    }
    
}


-(void)setPaymentKey_:(id)key
{
    paymentKey = [TiUtils stringValue:key];
    [[self stripeView] setKey:paymentKey];
}


- (void)createToken:(id)args
{
    [stripeView createToken:^(STPToken *token, NSError *error) {
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
        
    }];
}

- (void)hasError:(NSError *)error
{
    if ([self.proxy _hasListeners:@"error"])
    {
        // fire event
        [self.proxy fireEvent:@"error" withObject:@{
                                                     @"value":[error localizedDescription]
                                                     }];
    }
}

- (void)hasToken:(STPToken *)token
{
    //NSLog(@"Received token %@", token.tokenId);
    
    if ([self.proxy _hasListeners:@"receivedToken"])
    {
        // fire event
        [self.proxy fireEvent:@"receivedToken" withObject:@{
                                                    @"value":token.tokenId
                                                    }];
    }
}


@end
