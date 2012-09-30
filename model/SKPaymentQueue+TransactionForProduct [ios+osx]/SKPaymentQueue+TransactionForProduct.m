//
//  SKPaymentQueue+successfulTransactionForProduct.m
//  Project
//
//  Created by Dominik Pich on 04.11.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "SKPaymentQueue+TransactionForProduct.h"


@implementation SKPaymentQueue (TransactionForProduct)

- (SKPaymentTransaction*)anyTransactionForProductIdentifier:(NSString*)identifier {
	for(SKPaymentTransaction *transaction in self.transactions) {
		if([transaction.payment.productIdentifier isEqualToString:identifier]) {
            return transaction;
		}
		else if(transaction.transactionState == SKPaymentTransactionStateRestored && [transaction.originalTransaction.payment.productIdentifier isEqualToString:identifier]) {
            return transaction;
		}
	}
	
	return nil;
}

- (SKPaymentTransaction*)successfulTransactionForProductIdentifier:(NSString*)identifier {
	for(SKPaymentTransaction *transaction in self.transactions) {
		if(transaction.transactionState == SKPaymentTransactionStatePurchased && [transaction.payment.productIdentifier isEqualToString:identifier]) {
				return transaction;
		}
		else if(transaction.transactionState == SKPaymentTransactionStateRestored && [transaction.originalTransaction.payment.productIdentifier isEqualToString:identifier]) {
				return transaction;
		}
	}
	
	return nil;
}

@end