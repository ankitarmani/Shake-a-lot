//
//  LevelManager.h
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 24.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelManager : CCNode {
    NSString *currentSong;
    NSArray *currentLevel;
    NSArray *currentLevelMoveTime;
    int speedLevel;
}
+ (LevelManager *)sharedInstance;
-(NSArray*)getLevel;
-(NSArray*)getLevelMoveTime;
-(NSString*)getSongName;
-(void)setDifficulty:(int)difficulty;
-(int)getSpeedLevel;
@end
