//
//  HelloWorldLayer.h
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 20.01.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CMAttitude.h>
#import <CoreMotion/CMDeviceMotion.h>
#import <GameKit/GameKit.h>
#import "SimpleAudioEngine.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface Game : CCLayer{
    CCSprite *_start;
    CCAction *_startUp;
    CCAction *_danceMoves;
    //CCAction *_tutorialSequence;
    NSArray *moves;
    NSArray *moveTimes;
    CCLabelTTF *scoreLabel;
    int score;
    float idleX;
    float idleY;
    CMMotionManager *motionManager;
    CMAttitude *referenceAttitude;
}
@property (nonatomic, retain) CCAction *startUp;
//@property (nonatomic, retain) CCAction *tutorialSequence;
@property (nonatomic, retain) CCAction *danceMoves;
@property (nonatomic, retain) CCSprite *start;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)resumeGame;
-(void)mainMenu;
-(void)restartGame;
-(int)getScore;
-(void)postOnFaceBook;
@end
