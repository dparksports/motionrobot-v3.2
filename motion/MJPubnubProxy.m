//
//  MJPubnubProxy.m
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "PNImports.h"
#import "MJCloudProxyProtocol.h"
#import "MJPubnubProxy.h"

@interface MJPubnubProxy () <PNDelegate>
// Stores reference on PubNub client configuration
@property (nonatomic, strong) PNConfiguration *pubnubConfig;
@end

@implementation MJPubnubProxy {
    PNChannel *channel_1;
}

- (void)dealloc {
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    if (! sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [self.class new];
        });
    }
    return sharedInstance;
}

#pragma mark MJCloudProxyProtocol

- (void)initializeCloudClient {
    NSLog(@"%s", __func__);
    
    [PubNub setDelegate:self];
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self
                                                        withCallbackBlock:
     ^(NSString *origin, BOOL connected, PNError *error)
     {
         if (error) {
             UIAlertView *infoAlertView = [UIAlertView new];
             infoAlertView.title = [NSString stringWithFormat:@"%@(%@)",
                                    [error localizedDescription],
                                    NSStringFromClass([self class])];
             infoAlertView.message = [NSString stringWithFormat:@"Reason:\n%@\nSuggestion:\n%@",
                                      [error localizedFailureReason],
                                      [error localizedRecoverySuggestion]];
             [infoAlertView addButtonWithTitle:@"OK"];
             [infoAlertView show];
         }
     }];

}

- (void)connectToCloud {
    NSLog(@"%s", __func__);
    
    NSString *publishKey = @"pub-c-43df2eb5-9405-4669-9496-8edb898087e3";
    NSString *subscribeKey = @"sub-c-19487640-6583-11e4-8740-02ee2ddab7fe";
    NSString *secretKey = @"sec-c-NjgwMThhMzktYTBmMi00NDBjLTgzOGUtZGJjMDZiOWIxMmU3";
    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                             publishKey:publishKey
                                                           subscribeKey:subscribeKey
                                                              secretKey:secretKey];
    [PubNub setConfiguration:myConfig];
    
    [PubNub connectWithSuccessBlock:
     ^(NSString *origin)
     {
         NSLog(@"connected to: %@", origin);
     }
                         errorBlock:
     ^(PNError *connectionError)
     {
         NSLog(@"connectionError: %@", connectionError.localizedDescription);
     }];
    
    NSString *channelWithName = @"my_channel";
    channel_1 = [PNChannel channelWithName:channelWithName shouldObservePresence:NO];
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self
                                                        withCallbackBlock:
     ^(NSString *origin, BOOL connected, PNError *error)
     {
         if (connected)
             [PubNub subscribeOn:@[channel_1]];
         
         if (error)
             NSLog(@"error: %@", error.localizedDescription);
     }];
    
    
    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self
                                                                 withCallbackBlock:
     ^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError)
     {
         switch (state) {
             case PNSubscriptionProcessSubscribedState:
                 NSLog(@"PNSubscriptionProcessSubscribedState: %@", channels[0]);
                 break;
             case PNSubscriptionProcessNotSubscribedState:
                 NSLog(@"PNSubscriptionProcessNotSubscribedState: %@, Error: %@", channels[0], subscriptionError);
                 break;
             case PNSubscriptionProcessWillRestoreState:
                 NSLog(@"PNSubscriptionProcessWillRestoreState: %@", channels[0]);
                 break;
             case PNSubscriptionProcessRestoredState:
                 NSLog(@"PNSubscriptionProcessRestoredState: %@", channels[0]);
                 break;
         }
     }];
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self
                                                         withBlock:
     ^(PNMessage *message)
     {
         NSLog(@"channel.name: %@, receiveDate: %@", message.channel.name, message.receiveDate);
//         NSLog(@"MessageReceiveObserver: %@, Message: %@", message.channel.name, message.message);
     }];
    
    [[PNObservationCenter defaultCenter] addPresenceEventObserver:self
                                                        withBlock:
     ^(PNPresenceEvent *presenceEvent)
     {
         NSLog(@"PresenceEventObserver: received new event: %@", presenceEvent);
     }];
}

- (void)sendMessageToCloud:(NSString *)message {
    NSLog(@"%s", __func__);
    [PubNub sendMessage:message toChannel:channel_1 compressed:YES storeInHistory:YES
    withCompletionBlock:^(PNMessageState state, id data)
     {
         switch (state) {
             case PNMessageSending:
                 NSLog(@"PNMessageSending");
                 break;
             case PNMessageSendingError:
                 NSLog(@"PNMessageSendingError");
                 break;
             case PNMessageSent:
                 NSLog(@"PNMessageSent");
                 break;
         }
     }];
}

#pragma mark PNDelegate

- (void)pubnubClient:(PubNub *)client error:(PNError *)error {
    NSLog(@"error occurred: %@", error);
}

- (void)pubnubClient:(PubNub *)client willConnectToOrigin:(NSString *)origin {
    //    NSLog(@"connecting to PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client didConnectToOrigin:(NSString *)origin {
    NSLog(@"connected to PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client connectionDidFailWithError:(PNError *)error {
    NSLog(@"unable to connect because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client willDisconnectWithError:(PNError *)error {
    //    NSLog(@"PubNub clinet will close connection because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didDisconnectWithError:(PNError *)error {
    NSLog(@"closed connection because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didDisconnectFromOrigin:(NSString *)origin {
    NSLog(@"disconnected from PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client didSubscribeOnChannels:(NSArray *)channels {
    NSLog(@"subscribed to channel:%@", channels);
}

- (void)pubnubClient:(PubNub *)client subscriptionDidFailWithError:(NSError *)error {
    NSLog(@"failed to subscribe because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didUnsubscribeOnChannels:(NSArray *)channels {
    NSLog(@"unsubscribed from channels: %@", channels);
}

- (void)pubnubClient:(PubNub *)client unsubscriptionDidFailWithError:(PNError *)error {
    NSLog(@"failed to unsubscribe because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didReceiveTimeToken:(NSNumber *)timeToken {
    NSLog(@"recieved time token: %@", timeToken);
}

- (void)pubnubClient:(PubNub *)client timeTokenReceiveDidFailWithError:(PNError *)error {
    NSLog(@"failed to receive time token because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client willSendMessage:(PNMessage *)message {
    //    NSLog(@"PubNub client is about to send message: %@", message);
}

- (void)pubnubClient:(PubNub *)client didFailMessageSend:(PNMessage *)message withError:(PNError *)error {
    NSLog(@"failed to send message.date '%@' because of error: %@", message.date, error);
}

- (void)pubnubClient:(PubNub *)client didSendMessage:(PNMessage *)message {
    NSLog(@"sent message: receiveDate:%@", message.receiveDate);
}

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog(@"received message: receiveDate:%@", message.receiveDate);
}

- (void)pubnubClient:(PubNub *)client didReceivePresenceEvent:(PNPresenceEvent *)event {
    NSLog(@"received presence event: %@", event);
}

- (void)pubnubClient:(PubNub *)client didReceiveMessageHistory:(NSArray *)messages forChannel:(PNChannel *)channel startingFrom:(NSDate *)startDate to:(NSDate *)endDate {
    NSLog(@"received history for %@ starting from %@ to %@: %@",
          channel, startDate, endDate, messages);
}

- (void)pubnubClient:(PubNub *)client didFailHistoryDownloadForChannel:(PNChannel *)channel withError:(PNError *)error {
    NSLog(@"failed to download history for %@ because of error: %@",
          channel, error);
}

- (void)pubnubClient:(PubNub *)client didReceiveParticipantsLits:(NSArray *)participantsList forChannel:(PNChannel *)channel {
    NSLog(@"received participants list for channel %@: %@",
          participantsList, channel);
}

- (void)pubnubClient:(PubNub *)client didFailParticipantsListDownloadForChannel:(PNChannel *)channel withError:(PNError *)error {
    NSLog(@"failed to download participants list for channel %@ because of error: %@",
          channel, error);
}

- (NSNumber *)shouldResubscribeOnConnectionRestore {
    return @(NO);
}

@end
