//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"5t3llpHhm9olcKamviE9j2Uz7";
NSString * const kTwitterConsumerSecret = @"43xRPqSeC7u9iiZVtjo7nk4v9fQlDnmVHmRJV7p09QuiCh1QHR";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";

@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
  static TwitterClient *instance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (instance == nil) {
      instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    }
  });

  return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
  
  self.loginCompletion = completion;
  [self.requestSerializer removeAccessToken];
  [self
   fetchRequestTokenWithPath:@"oauth/request_token"
   method:@"GET"
   callbackURL:[NSURL URLWithString:@"mytwitter://oauth"]
   scope:nil
   success:^(BDBOAuth1Credential *requestToken) {
     NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
     
     NSDictionary *options = [NSDictionary dictionary];
     [[UIApplication sharedApplication] openURL:authURL options:options completionHandler:^(BOOL success) {
       
     }];
   }
   failure:^(NSError *error) {
     NSLog(@"Error Getting Token");
     self.loginCompletion(nil, error);
   }
  ];
}

- (void)logout {
  [User setCurrentUser:nil];
  [self deauthorize];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogout" object:nil];
}

- (void)openURL:(NSURL *)url {
  [self
   fetchAccessTokenWithPath:@"oauth/access_token"
   method:@"GET"
   requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
   success:^(BDBOAuth1Credential *accessToken) {
     [self.requestSerializer saveAccessToken:accessToken];

     [self currentAccountWithSuccess:^(User *user) {
        [User setCurrentUser:user];
        self.loginCompletion(user, nil);
      }
      andFailure:^(NSError *error) {
        self.loginCompletion(nil, error);
      }];
   }
   failure:^(NSError *error) {
     NSLog(@"Error Getting Access Token");
     self.loginCompletion(nil, error);
   }];
}

- (void)currentAccountWithSuccess: (void (^)(User *))success andFailure:(void (^)(NSError *))failure {
  [self
   GET:@"1.1/account/verify_credentials.json"
   parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     //NSLog(@"Progress: %lld", [downloadProgress totalUnitCount]);
   }
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     User *currentUser = [[User alloc] initWithDictionary:responseObject];
     success(currentUser);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
  ];
}

- (void)homeTimelineFromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess:(void (^)(NSArray<Tweet *> *))success andFailure:(void (^)(NSError *))failure {
  NSString *urlString = @"1.1/statuses/home_timeline.json";
  if (tweetId) {
    if (isNew) {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?since_id=%@", tweetId]];
    }
    else {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?max_id=%@", tweetId]];
    }
  }
  [self
   GET:urlString
   parameters:nil
   progress:^(NSProgress * _Nonnull downloadProgress) {
//     NSLog(@"Progress: %lld", [downloadProgress totalUnitCount]);
   }
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSArray *tweets = [Tweet tweetsWithArray:responseObject];
     success(tweets);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
  ];
}

- (void)mentionsTimelineFromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess:(void (^)(NSArray<Tweet *> *))success andFailure:(void (^)(NSError *))failure {
  NSString *urlString = @"1.1/statuses/mentions_timeline.json?count=20";
  if (tweetId) {
    if (isNew) {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&since_id=%@", tweetId]];
    }
    else {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@", tweetId]];
    }
  }
  [self
   GET: urlString
   parameters:nil
   progress:^(NSProgress * _Nonnull downloadProgress) {
     //     NSLog(@"Progress: %lld", [downloadProgress totalUnitCount]);
   }
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSArray *tweets = [Tweet tweetsWithArray:responseObject];
     success(tweets);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
   ];
}

- (void)userTimelineForUserScreenName:(NSString *)screenName fromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess:(void (^)(NSArray<Tweet *> *))success andFailure:(void (^)(NSError *))failure {
  NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@", screenName];
  if (tweetId) {
    if (isNew) {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&since_id=%@", tweetId]];
    }
    else {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@", tweetId]];
    }
  }
  [self
   GET: urlString
   parameters:nil
   progress:^(NSProgress * _Nonnull downloadProgress) {
     //     NSLog(@"Progress: %lld", [downloadProgress totalUnitCount]);
   }
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSArray *tweets = [Tweet tweetsWithArray:responseObject];
     success(tweets);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }];
}

- (void)favoriteListForUserScreenName:(NSString *)screenName fromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess:(void (^)(NSArray<Tweet *> *))success andFailure:(void (^)(NSError *))failure {
  NSString *urlString = [NSString stringWithFormat:@"1.1/favorites/list.json?screen_name=%@", screenName];
  if (tweetId) {
    if (isNew) {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&since_id=%@", tweetId]];
    }
    else {
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@", tweetId]];
    }
  }
  [self
   GET: urlString
   parameters:nil
   progress:^(NSProgress * _Nonnull downloadProgress) {
     //     NSLog(@"Progress: %lld", [downloadProgress totalUnitCount]);
   }
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSArray *tweets = [Tweet tweetsWithArray:responseObject];
     success(tweets);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }];
}

- (void)postTweet:(NSString *)text onSuccess:(void (^)(NSDictionary  *))success onFailure:(void (^)(NSError *))failure {
  NSString *encodedText = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  [self
   POST:[NSString stringWithFormat:@"1.1/statuses/update.json?status=%@", encodedText]
   parameters: nil
   progress:nil
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     success(responseObject);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
  ];
}

- (void)reTweet:(NSString *)tweetId onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSError *))failure {
  [self
   POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId]
   parameters: nil
   progress:nil
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     success(responseObject);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
  ];
}

- (void)favoriteTweet:(NSString *)tweetId onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSError *))failure {
  [self
   POST:[NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId]
   parameters: nil
   progress:nil
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     success(responseObject);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
  ];
}

- (void)replyToTweet:(NSString *)tweetId withText:(NSString *)text onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSError *))failure {
  NSString *encodedText = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  [self
   POST:[NSString stringWithFormat:@"1.1/statuses/update.json?status=%@&in_reply_to_status_id=%@", encodedText, tweetId]
   parameters: nil
   progress:nil
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     success(responseObject);
   }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     failure(error);
   }
   ];

}



@end
