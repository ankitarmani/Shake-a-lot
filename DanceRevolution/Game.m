//
//  HelloWorldLayer.m
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 20.01.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "Game.h"
#import "MainMenu.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "LevelManager.h"
#import "PauseMenu.h"

// HelloWorldLayer implementation
@implementation Game

@synthesize start = _start;
@synthesize startUp = _startUp;
@synthesize danceMoves = _danceMoves;
//@synthesize tutorialSequence = _tutorialSequence;

CCSprite *currentDanceMoveSprite;
CCSprite *lightsActivated1;
CCSprite *lightsActivated2;
CCSprite *lightsActivated3;
CCMenuItemImage *pauseItem;
PauseMenu *pauseMenu;

int scorePos;

int timing;
int currentMove;
BOOL playerMoved;
BOOL idlePosition;

BOOL paused;
BOOL isOnStartUp;




// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	
	if( (self=[super init]) ) {
        //_______tutorial sequence setup
        /*id rightMove = [CCCallBlock actionWithBlock:^{timing = 3;[self playerMadeMove:3];}];
        id downMove = [CCCallBlock actionWithBlock:^{timing = 3;[self playerMadeMove:1];}];
        id upMove = [CCCallBlock actionWithBlock:^{timing = 3;[self playerMadeMove:0];}];
        id leftMove = [CCCallBlock actionWithBlock:^{timing = 3;[self playerMadeMove:2];}];
        id rightMove2 = [CCCallBlock actionWithBlock:^{timing = 1;[self playerMadeMove:3];}];
        id leftMove2 = [CCCallBlock actionWithBlock:^{timing = 3;[self playerMadeMove:2];}];
        id rightMove3 = [CCCallBlock actionWithBlock:^{timing = 2;[self playerMadeMove:3];}];
        _tutorialSequence =[CCSequence actions:[CCDelayTime actionWithDuration:3.2*7/11.],rightMove,[CCDelayTime actionWithDuration:3.2*4/11.],
                            [CCDelayTime actionWithDuration:3.2*7/11.],downMove,[CCDelayTime actionWithDuration:3.2*4/11.],
                            [CCDelayTime actionWithDuration:3.0*7/11.],upMove,[CCDelayTime actionWithDuration:3.0*4/11.],
                            [CCDelayTime actionWithDuration:3.0*7/11.],leftMove,[CCDelayTime actionWithDuration:3.0*4/11.],
                            [CCDelayTime actionWithDuration:3],
                            [CCDelayTime actionWithDuration:2.9*5/11.],rightMove2,[CCDelayTime actionWithDuration:2.9*6/11.],
                            [CCDelayTime actionWithDuration:2.8*7/11.],leftMove2,[CCDelayTime actionWithDuration:2.8*4/11.],
                            [CCDelayTime actionWithDuration:3.4*9/11.],rightMove3,[CCDelayTime actionWithDuration:3.4*2/11.],
                            nil];
         */
        
        //_____________________________
        
        
        motionManager = [[CMMotionManager alloc] init];
        referenceAttitude = nil;
        
        CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
        CMAttitude *attitude = deviceMotion.attitude;
        referenceAttitude = attitude;
        [motionManager startGyroUpdates];
        
        if (motionManager.isGyroAvailable) {
            motionManager.gyroUpdateInterval = 1 / 60.0;
        }
        
        if (motionManager.isDeviceMotionAvailable) {
            motionManager.deviceMotionUpdateInterval = 1 / 60.0;
        }
        // starting the device motion updates
        [motionManager startDeviceMotionUpdates];
        
        idleX = 0;
        idleY = 0;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1/20. target:self selector:@selector(gyroUpdate) userInfo:nil repeats:YES];
        
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:[[LevelManager sharedInstance] getSongName]];
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        
        paused = NO;
        pauseMenu = [[PauseMenu alloc] initWithGame:self];
        
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:34];
        scoreLabel.position = ccp(400, 280); //Middle of the screen...
        [self addChild:scoreLabel z:6];
       
        pauseItem = [[CCMenuItemImage alloc] initWithNormalImage:@"pauseButton.png" selectedImage:@"pauseButton.png" disabledImage:@"pauseButton.png" target:self selector:@selector(pause)];
        [pauseItem setIsEnabled:NO];
        pauseItem.opacity = 0;
        CCMenu *menu = [CCMenu menuWithItems:pauseItem, nil];
        menu.position = ccp(35, 280);
        [self addChild:menu z:7];
        
        
        //Background
        CCSprite *background = [[CCSprite alloc] initWithFile:@"DanceRevolutionBackground.png"];
        background.position = CGPointMake(240, 160);
        [self addChild:background z:-1];
        CCSprite *lightMarker = [[CCSprite alloc] initWithFile:@"lights.png"];
        lightMarker.position = CGPointMake(240, 122);
        [self addChild:lightMarker z:2];

        CCParticleSystemQuad *bgParticle = [CCParticleSystemQuad particleWithFile:@"backgroundParticle.plist"];
        bgParticle.position = CGPointMake(240, 340);
        bgParticle.scale = 1;
        //[self addChild:bgParticle z:0];
        
        
        //set up start animation----------------
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"startUp.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"startUp.png"];
        spriteSheet.tag = 1;
        [self addChild:spriteSheet z:4];
        NSMutableArray *startAnimation = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [startAnimation addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"dance%d.png", i]]];
        }
        
        CCAnimation *startAnim = [CCAnimation animationWithFrames:startAnimation delay:1.0f];
        
        self.startUp = [CCSequence actions: [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:startAnim restoreOriginalFrame:NO] times:1] , nil];

        
        self.start = [CCSprite spriteWithSpriteFrameName:@"dance1.png"];
        spriteSheet.position = CGPointMake(240, 240);
        [spriteSheet addChild:_start];
        //---------------------------------------
        
        
        //init lights
        
        lightsActivated1 = [CCSprite spriteWithFile:@"lightsActivated1.png"];
        lightsActivated1.position = CGPointMake(240, 178);
        lightsActivated1.opacity = 0;
        [self addChild:lightsActivated1 z:3];
        lightsActivated2 = [CCSprite spriteWithFile:@"lightsActivated1.png"];
        lightsActivated2.position = CGPointMake(240, 66);
        lightsActivated2.opacity = 0;
        [self addChild:lightsActivated2 z:3];
        lightsActivated3 = [CCSprite spriteWithFile:@"lightsActivated2.png"];
        lightsActivated3.position = CGPointMake(240, 122);
        lightsActivated3.opacity = 0;
        [self addChild:lightsActivated3 z:3];
         
         
        
        //init dance move arrays (hardcoded but could be substituted by an xml parser
        
        moves = [[LevelManager sharedInstance] getLevel];
        
        moveTimes = [[LevelManager sharedInstance]getLevelMoveTime];
        
        score = 0;
        [self startGame];
        playerMoved = YES;
        idlePosition = NO;
        self.isAccelerometerEnabled = YES;
        
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    }
	return self;
}

-(void)initDanceMove:(int)moveNumber{
    int numberOfDanceMoves = [moves count];
    float moveDuration = [[moveTimes objectAtIndex:moveNumber] floatValue];
    id moveDown = [CCMoveTo actionWithDuration:moveDuration position:CGPointMake(240, -50)];
    
    CCCallBlock *nextMove = [CCCallBlock actionWithBlock:^{[self initDanceMove:(moveNumber+1)];}];
    
    CCCallBlock *timingRed = [CCCallBlock actionWithBlock:^{timing = 4;}];
    CCCallBlock *timingOrange = [CCCallBlock actionWithBlock:^{timing = 1;}];
    CCCallBlock *timingOrange2 = [CCCallBlock actionWithBlock:^{timing = 2;}];
    CCCallBlock *timingGreen = [CCCallBlock actionWithBlock:^{timing = 3;}];
    CCCallBlock *moveReset = [CCCallBlock actionWithBlock:^{playerMoved = NO;}];
    CCCallBlock *repeat = [CCCallBlock actionWithBlock:^{[self gameOver];}];

    CCSequence *timingSequence = [CCSequence actions:moveReset,timingRed,[CCDelayTime actionWithDuration:moveDuration*0.42],timingOrange,[CCDelayTime actionWithDuration:moveDuration*0.13],timingGreen,[CCDelayTime actionWithDuration:moveDuration*0.13],timingOrange2,[CCDelayTime actionWithDuration:moveDuration*0.13],timingRed, nil];
    
    
    NSString *move = [moves objectAtIndex:moveNumber];
    if(move == @"break"){
        CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
        [self runAction:[CCSequence actions:delay,nextMove, nil]];
      
    }
    else{
    
    
        if(move == @"up"){
            currentMove = 0;
            CCSprite *arrow = [[CCSprite alloc] initWithFile:@"arrow.png"];
            currentDanceMoveSprite = arrow;
            CCCallBlock *removeSprite = [CCCallBlock actionWithBlock:^{[self removeChild:arrow cleanup:YES];}];
            arrow.position = CGPointMake(240, 370);
            [self addChild:arrow z:3];
            
            if(moveNumber+1<numberOfDanceMoves){
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,nextMove,nil],timingSequence, nil]];
            }
            else{
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,repeat,nil],timingSequence, nil]];
            }
        }
        
        
        else if(move == @"down"){
            currentMove = 1;
            CCSprite *arrow = [[CCSprite alloc] initWithFile:@"arrow.png"];
            arrow.rotation = 180;
            currentDanceMoveSprite = arrow;
            CCCallBlock *removeSprite = [CCCallBlock actionWithBlock:^{[self removeChild:arrow cleanup:YES];}];
            arrow.position = CGPointMake(240, 370);
            [self addChild:arrow z:3];
            if(moveNumber+1<numberOfDanceMoves){
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,nextMove,nil],timingSequence, nil]];
            }
            else{
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,repeat,nil],timingSequence, nil]];
            }
        }
        else if(move == @"left"){
            currentMove = 2;
            CCSprite *arrow = [[CCSprite alloc] initWithFile:@"arrow.png"];
            arrow.rotation = 270;
            currentDanceMoveSprite = arrow;
            CCCallBlock *removeSprite = [CCCallBlock actionWithBlock:^{[self removeChild:arrow cleanup:YES];}];
            arrow.position = CGPointMake(240, 370);
            [self addChild:arrow z:3];
            if(moveNumber+1<numberOfDanceMoves){
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,nextMove,nil],timingSequence, nil]];
            }
            else{
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,repeat,nil],timingSequence, nil]];
            }
            
        }
        else if(move == @"right"){
            currentMove = 3;
            CCSprite *arrow = [[CCSprite alloc] initWithFile:@"arrow.png"];
            arrow.rotation = 90;
            currentDanceMoveSprite = arrow;
            CCCallBlock *removeSprite = [CCCallBlock actionWithBlock:^{[self removeChild:arrow cleanup:YES];}];
            arrow.position = CGPointMake(240, 370);
            [self addChild:arrow z:3];
            if(moveNumber+1<numberOfDanceMoves){
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,nextMove,nil],timingSequence, nil]];
            }
            else{
                [arrow runAction:[CCSpawn actions:[CCSequence actions:moveDown,removeSprite,repeat,nil],timingSequence, nil]];
            }
            
        }
    }
    
}



-(void)startGame{
    isOnStartUp = YES;
    CCFadeIn *showButton = [CCFadeIn actionWithDuration:0.8];
    CCCallBlock *remove = [CCCallBlock actionWithBlock:^{[self removeChildByTag:1 cleanup:YES]; }];
    CCCallBlock *startDanceMoves = [CCCallBlock actionWithBlock:^{playerMoved = NO;isOnStartUp = NO;[self initDanceMove:0];[pauseItem setIsEnabled:YES];[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];[pauseItem runAction:showButton];}];
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.8],_startUp,remove,startDanceMoves, nil];
    [_start runAction:seq];
}


-(void)playerMadeMove:(int)moveType{
    if(moveType == currentMove){
        if(timing==1){
            lightsActivated1.opacity = 1;
            [lightsActivated1 runAction:[CCFadeOut actionWithDuration:1]];
            scorePos = 0;
            [self addScore:40];
            
        }
        else if(timing==2){
            lightsActivated2.opacity = 1;
            [lightsActivated2 runAction:[CCFadeOut actionWithDuration:1]];
            scorePos = 2;
            [self addScore:40];
        }
        else if(timing==3){
            lightsActivated3.opacity = 1;
            [lightsActivated3 runAction:[CCFadeOut actionWithDuration:1]];
            CCParticleSystemQuad *firework = [CCParticleSystemQuad particleWithFile:@"firework.plist"];
            firework.position = currentDanceMoveSprite.position;
            firework.scale = 2;
            [self addChild:firework z:5];
            [firework runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],[CCCallBlock actionWithBlock:^{[self removeChild:firework cleanup:YES];}], nil]];
            scorePos = 1;
            [self addScore:100];

        }
        else{
            CCSprite *fail = [[CCSprite alloc] initWithFile:@"fail.png"];
            fail.position = [currentDanceMoveSprite convertToNodeSpace:currentDanceMoveSprite.position];
            [currentDanceMoveSprite addChild:fail];
            [fail runAction:[CCBlink actionWithDuration:1 blinks:3]];
            [self addScore:-150];
        }

    }else{
        CCSprite *fail = [[CCSprite alloc] initWithFile:@"fail.png"];
        fail.position = [currentDanceMoveSprite convertToNodeSpace:currentDanceMoveSprite.position];
        [currentDanceMoveSprite addChild:fail];
        [fail runAction:[CCBlink actionWithDuration:1 blinks:3]];
        
        [self addScore:-150];
           }
    
}

- (void)gyroUpdate {
    // use the running scene to grab the appropriate game layer by it's tag
    
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    
    if(ABS(attitude.roll-idleX)<0.1 &&ABS(attitude.pitch-idleY)<0.1){
        idlePosition = YES;
    }
    if(isOnStartUp){
        idleX = (idleX+attitude.roll)/2;
        idleY = (idleY+attitude.pitch)/2;
    }
    
        
    if(!playerMoved && !paused && idlePosition){
    if(attitude.roll > idleX +0.15) {  // tilting the device downwards
        [self playerMadeMove:1];
        playerMoved = YES;
        idlePosition = NO;
    } else if (attitude.roll < idleX-0.15) {// tilting the device upwards
        [self playerMadeMove:0];
        playerMoved = YES;
        idlePosition = NO;
    } else if(attitude.pitch < idleY-0.15) {  // tilting the device to the right
        [self playerMadeMove:3];
        playerMoved = YES;
        idlePosition = NO;
    } else if (attitude.pitch> idleY+0.15) {  // tilting the device to the left
        [self playerMadeMove:2];
        playerMoved = YES;
        idlePosition = NO;
    }
        
    }
     
    
        
}

-(void)addScore:(int)number{
    if(score+number>=0){
    score = score+number;
    }
    else{
        score = 0;
    }
    [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
    if(number>=0){
        
    CCLabelTTF *scoreUp = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:20];
    scoreUp.position = ccp(400, 180-50*scorePos);
    [self addChild:scoreUp z:6];
    [scoreUp setString:[NSString stringWithFormat:@"%i", number]];
        
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:2 position:CGPointMake(0, 100)];
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:2];
    CCCallBlock *remove = [CCCallBlock actionWithBlock:^{[self removeChild:scoreUp cleanup:YES];}];
    [scoreUp runAction:[CCSequence actions:[CCSpawn actions:moveUp,fadeOut, nil],remove, nil]];
    
    
    CCParticleSystemQuad *scoreParticle = [CCParticleSystemQuad particleWithFile:@"scoreParticle.plist"];
    scoreParticle.position = ccp(400, 280);
    scoreParticle.scale = 1;
        CCCallBlock *addParticle = [CCCallBlock actionWithBlock:^{ [self addChild:scoreParticle z:5];}];
        CCCallBlock *removeParticle = [CCCallBlock actionWithBlock:^{ [self removeChild:scoreParticle cleanup:YES];}];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.3];
        [self runAction:[CCSequence actions:addParticle,delay,removeParticle, nil]];
     
    }

}
-(void)gameOver{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [pauseMenu gameOver];
    [pauseItem setIsEnabled:NO];
    CCFadeOut *fadeOutPauseButton = [CCFadeOut actionWithDuration:1];
    [pauseItem runAction:fadeOutPauseButton];
    

    
}
-(void)pause{
    CCFadeOut *fadeOutPauseButton = [CCFadeOut actionWithDuration:1];
    [pauseItem runAction:fadeOutPauseButton];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    [currentDanceMoveSprite pauseSchedulerAndActions];
    [pauseItem setIsEnabled:NO];
    paused = YES;
    [pauseMenu openMenu];
}
-(void)resumeGame{
    CCFadeIn *fadeInPauseButton = [CCFadeIn actionWithDuration:1];
    [pauseItem runAction:fadeInPauseButton];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    [currentDanceMoveSprite resumeSchedulerAndActions];
    paused = NO;
    [pauseItem setIsEnabled:YES];
    [pauseMenu closeMenu];
}
-(void)restartGame{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccBLACK]];
}
-(void)mainMenu{
   [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];
}

-(int)getScore{
    return score;
}
-(void)postOnFacebook{
    NSLog(@"post");
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
}

@end
