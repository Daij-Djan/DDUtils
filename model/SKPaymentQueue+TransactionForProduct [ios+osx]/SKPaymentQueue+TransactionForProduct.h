//
//  SKPaymentQueue+successfulTransactionForProduct.h
//  Project
//
//  Created by Dominik Pich on 04.11.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import <StoreKit/StoreKit.h>


@interface SKPaymentQueue (TransactionForProduct)

- (SKPaymentTransaction*)anyTransactionForProductIdentifier:(NSString*)identifier;
- (SKPaymentTransaction*)successfulTransactionForProductIdentifier:(NSString*)identifier;
	
@end