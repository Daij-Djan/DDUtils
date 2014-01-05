//
//  DDSocialMessenger.m
//
//  Created by Dominik Pich on 17.08.11.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDSocialMessenger.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation DDSocialMessenger

+ (void)postToTwitter:(NSString *)text remaining:(NSMutableArray *)accounts done:(NSMutableArray*)accountsDone completion:(DDSocialMessengerCompletionBlock)completion {

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            if ([arrayOfAccounts count] > 0) {
                ACAccount *account = [arrayOfAccounts lastObject];
                
                NSDictionary *message = @{@"status":text};
                NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:message];
                postRequest.account = account;
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(urlResponse.statusCode==200) //all good
                        [accountsDone addObject:ACAccountTypeIdentifierTwitter];
                    [self broadcast:text remaining:accounts done:accountsDone completion:completion];
                }];
                
                return;
            }
        }
        [self broadcast:text remaining:accounts done:accountsDone completion:completion];
    }];
}

+ (void)postToFacebook:(NSString *)text remaining:(NSMutableArray *)accounts done:(NSMutableArray*)accountsDone completion:(DDSocialMessengerCompletionBlock)completion {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    
    // Specify FB App ID and permissions
    NSString *facebookID = [self facebookAppID];
    if(!facebookID.length) {
        NSLog(@"Skipping Facebook as no AppID is specified");
        [self broadcast:text remaining:accounts done:accountsDone completion:completion];
        return;
    }
    
    //first we need basic read rights THEN we publish
    __block NSDictionary *options = @{ACFacebookAppIdKey: facebookID, ACFacebookPermissionsKey: @[@"email"], ACFacebookAudienceKey: ACFacebookAudienceOnlyMe};
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            options = @{ACFacebookAppIdKey: facebookID, ACFacebookPermissionsKey: @[@"publish_stream", @"publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceFriends};
    
            [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
                    if ([arrayOfAccounts count] > 0) {
                        ACAccount *account = [arrayOfAccounts lastObject];
                        
                        NSDictionary *message = @{@"message":text};
                        NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                        SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:requestURL parameters:message];
                        postRequest.account = account;
                        
                        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                            if(urlResponse.statusCode==200) //all good
                                [accountsDone addObject:ACAccountTypeIdentifierFacebook];
                            [self broadcast:text remaining:accounts done:accountsDone completion:completion];
                        }];
                        
                        return;
                    }
                }
                [self broadcast:text remaining:accounts done:accountsDone completion:completion];
            }];
            return;
        }
        [self broadcast:text remaining:accounts done:accountsDone completion:completion];
    }];
}

+ (void)broadcast:(NSString *)text remaining:(NSMutableArray *)remaining done:(NSMutableArray*)accountsDone completion:(DDSocialMessengerCompletionBlock)completion {
    if(remaining.count) {
        id identifier = remaining[0];
        [remaining removeObjectAtIndex:0];
        
        if([identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
            [self postToTwitter:text remaining:remaining done:accountsDone completion:completion];
        }
        else if([identifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
            [self postToFacebook:text remaining:remaining done:accountsDone completion:completion];
        }
        else {
            NSLog(@"Skipping unknown account type %@", identifier);
            [self broadcast:text remaining:remaining done:accountsDone completion:completion];
        }
    }
    else {
        if(completion) {
            completion(accountsDone);
        }
    }
}

//---

+ (NSString*)facebookAppID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:DDFacebookAppIdKey];
}

+ (void)postToTwitter:(NSString *)text completion:(DDSocialMessengerCompletionBlock)completion {
    [self broadcast:text remaining:@[ACAccountTypeIdentifierTwitter].mutableCopy done:[NSMutableArray arrayWithCapacity:1] completion:completion];
}

+ (void)postToFacebook:(NSString *)text completion:(DDSocialMessengerCompletionBlock)completion {
    [self broadcast:text remaining:@[ACAccountTypeIdentifierFacebook].mutableCopy done:[NSMutableArray arrayWithCapacity:1] completion:completion];
}

+ (void)broadcast:(NSString *)text to:(NSArray *)accounts completion:(DDSocialMessengerCompletionBlock)completion {
    NSMutableArray *maccounts = [accounts mutableCopy];
    NSMutableArray *mdone = [NSMutableArray array];
    [self broadcast:text remaining:maccounts done:mdone completion:completion];
}
@end
