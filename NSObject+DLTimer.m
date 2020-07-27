//
//  NSObject+DLTimer.m
//  testNetWorking
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 lixu. All rights reserved.
//

#import "NSObject+DLTimer.h"
#import <objc/message.h>

@interface NSTimer (DLAutorelease)

@end

@implementation NSTimer (DLAutorelease)

+ (NSTimer *)dl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(dl_blockSelector:) userInfo:[block copy] repeats:repeats];
}

+ (void)dl_blockSelector:(NSTimer *)timer {
    
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end

@interface DLAutoreleaseTimerManager : NSObject

@property (nonatomic ,strong) NSMutableArray *timers;

@end

@implementation DLAutoreleaseTimerManager

-(void)dealloc {
    for (NSTimer *timer in _timers) {
        [timer invalidate];
    }
}

-(NSTimer *)dl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        block:(void (^)(void))block
                                       repeats:(BOOL)repeats {
    NSTimer *timer = [NSTimer dl_scheduledTimerWithTimeInterval:interval block:block repeats:repeats];
    [self.timers addObject:timer];
    return timer;
}

-(NSMutableArray *)timers {
    if (!_timers) {
        _timers = [NSMutableArray new];
    }
    return _timers;
}

@end

@interface NSObject (DLTimerPrivate)

@property (nonatomic ,strong)DLAutoreleaseTimerManager *timerManager;

@end

static void *NSObjectDLTimerKey = &NSObjectDLTimerKey;

@implementation NSObject (DLTimer)

-(NSTimer *)dl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        block:(void (^)(void))block
                                      repeats:(BOOL)repeats {
    return [self.timerManager dl_scheduledTimerWithTimeInterval:interval block:block repeats:repeats];
}

- (DLAutoreleaseTimerManager *)timerManager
{
  id timerManager = objc_getAssociatedObject(self, NSObjectDLTimerKey);
  
  if (nil == timerManager) {
      timerManager = [DLAutoreleaseTimerManager new];
      self.timerManager = timerManager;
  }
  
  return timerManager;
}

- (void)setTimerManager:(DLAutoreleaseTimerManager *)timerManager
{
  objc_setAssociatedObject(self, NSObjectDLTimerKey, timerManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
