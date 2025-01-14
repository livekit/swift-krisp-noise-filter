#import <Foundation/Foundation.h>

#define EXPORT_API __attribute__((visibility("default")))

typedef NS_ENUM(NSInteger, ErrorCode) {
  NoError,
  InvalidArgument,
  URLParseFailed,
  AuthorizationRequired,
  AuthorizationFailed,
  AuthorizationConnectionFailed,
  NotSupported,  // Feature not supported by server
  KrispGlobalInitRequired,
};

typedef NS_ENUM(NSInteger, LiveKitConnectionState) {
  Disconnected,
  Connecting,
  Reconnecting,
  Connected,
};

typedef NS_CLOSED_ENUM(NSInteger, KrispModelType) {
    KrispModelTypeNC,  // Noise Cancellation (existing)
    KrispModelTypeBVC  // Background Voice Cancellation
};

/**
 * KrispAudioProcessor is the main class for Krisp Noise Cancellation.
 *
 */
NS_ASSUME_NONNULL_BEGIN

@interface LiveKitRoomContext : NSObject
@property(nullable, nonatomic, strong, readonly) NSString *sid;
@property(nullable, nonatomic, strong, readonly) NSString *name;
@property(nullable, nonatomic, strong, readonly) NSString *serverVersion;
@property(nullable, nonatomic, strong, readonly) NSString *serverRegion;
@property(nullable, nonatomic, strong, readonly) NSString *serverNodeId;
@property(nonatomic, assign, readonly) LiveKitConnectionState connectionState;
@property(nullable, nonatomic, strong, readonly) NSString *url;
@property(nullable, nonatomic, strong, readonly) NSString *token;

- (instancetype)initWithSid:(nullable NSString *)sid
                       name:(nullable NSString *)name
              serverVersion:(nullable NSString *)serverVersion
               serverRegion:(nullable NSString *)serverRegion
               serverNodeId:(nullable NSString *)serverNodeId
            connectionState:(LiveKitConnectionState)connectionState
                        url:(nullable NSString *)url
                      token:(nullable NSString *)token NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface KrispNoiseFilter : NSObject

+ (BOOL)KrispGlobalInit;
+ (BOOL)KrispGlobalInit:(KrispModelType)modelType;
+ (void)KrispGlobalDestroy;
@property(class, nonatomic, assign) BOOL isBypassEnabled;

- (instancetype)init;
- (ErrorCode)lastError;
@property(nonatomic, readonly, assign) BOOL isAuthorized;

/**
 * Initialize AudioProcessor with the sample rate and number of channels.
 *
 * @param sampleRateHz The sample rate in Hz.
 * @param channels The number of channels.
 *
 */
- (BOOL)initialize:(int)sampleRateHz numChannels:(int)channels;

/**
 * Reset AudioProcessor with the new sample rate.
 *
 * @param newRate The new sample rate in Hz.
 *
 */
- (BOOL)reset:(int)newRate;

/**
 * Process the audio buffer.
 *
 * @param bands The number of frequency bands.
 * @param frames The number of frames.
 * @param bufferSize The size of the buffer.
 * @param buffer The audio buffer.
 *
 */
- (BOOL)processWithBands:(int)bands
                  frames:(int)frames
              bufferSize:(int)bufferSize
                  buffer:(float *)buffer;

- (void)updateRoomContext:(LiveKitRoomContext *)context;

+ (BOOL)setModelType:(KrispModelType)modelType;

@end

NS_ASSUME_NONNULL_END
