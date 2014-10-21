/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "CoCoolelephantStripeView.h"
#import "STPCard.h"
#import "Stripe.h"

@implementation CoCoolelephantStripeView


-(PTKView*) stripeView
{
    if( !_stripeView)
    {
        //NSLog(@"INITIALIZING VIEW %@",[self frame]);
        _stripeView = [[PTKView alloc] initWithFrame:[self frame]];
        
        [self addSubview:_stripeView];
        
        [_stripeView setDelegate:self];
        
    }
     //NSLog(@"INITIALIZING VIEW2 %@",[self frame]);
    return _stripeView;
    
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    //NSLog(@"[VIEW LIFECYCLE EVENT] frameSizeChanged: %@", stripeView);
    
    if (self.stripeView != nil) {
        
        // You must call the special method 'setView:positionRect' against
        // the TiUtils helper class. This method will correctly layout your
        // child view within the correct layout boundaries of the new bounds
        // of your view.
        [TiUtils setView:self.stripeView positionRect:bounds];
        
        //PTKView *oldView = stripeView;
        //stripeView removeFromSuperview];
        //stripeView = [[PTKView alloc] initWithFrame:bounds];
        
        //[self addSubview:stripeView];
        //[stripeView setDelegate:self];
        
        //[self.stripeView setFrame:bounds];
        
    }
    //NSLog(@"[VIEW LIFECYCLE EVENT] frameSizeChanged2: %@", self.stripeView);
}


- (void) paymentView:(PTKView *)paymentView withCard:(PTKCard *)card isValid:(BOOL)valid
{
    
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
    [Stripe setDefaultPublishableKey:paymentKey];
    
    //[[self stripeView] setKey:paymentKey];
}


- (void)createToken:(id)args
{
    /*
    [stripeView createToken:^(STPToken *token, NSError *error) {
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
        
    }];
    */
    if(![self.stripeView isValid]) {
        return;
    }
    
    STPCard *card = [[STPCard alloc] init];
    card.number = [self.stripeView card].number;
    card.expMonth = [self.stripeView card].expMonth;
    card.expYear = [self.stripeView card].expYear;
    card.cvc = [self.stripeView card].cvc;
    [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
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
