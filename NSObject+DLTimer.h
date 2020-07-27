//
//  NSObject+DLTimer.h
//  testNetWorking
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 lixu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DLTimer)

-(NSTimer *)dl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        block:(void (^)(void))block
                                      repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
