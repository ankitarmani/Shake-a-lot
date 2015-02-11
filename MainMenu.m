//
//  MainMenu.m
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 25.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "LevelManager.h"
#import "Game.h"
#import "Tutorial.h"

@implementation MainMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	
	if( (self=[super init]) ) {
        CCSprite *background = [[CCSprite alloc] initWithFile:@"mainMenuBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background z:0];
        
        CCSprite *title = [[CCSprite alloc] initWithFile:@"titleDanceRevo.png"];
        title.position = ccp(310,275);
        [self addChild:title z:4];
        CCSprite *titleGlow = [[CCSprite alloc] initWithFile:@"titleDanceRevoGlow.png"];
        titleGlow.position = ccp(310,275);
        [self addChild:titleGlow z:3];
        CCRepeatForever *glow = [CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeOut actionWithDuration:5],[CCFadeIn actionWithDuration:2], nil]];
        [titleGlow runAction:glow];
        //init buttons
        
        CCMenuItemImage *easyButton= [[CCMenuItemImage alloc] initWithNormalImage:@"buttonEasy.png" selectedImage:@"buttonEasy.png" disabledImage:@"buttonEasy.png" target:self selector:@selector(startEasyGame)];
        CCMenu *menuEasy = [CCMenu menuWithItems:easyButton, nil];
        
        CCMenuItemImage *mediumButton= [[CCMenuItemImage alloc] initWithNormalImage:@"buttonMedium.png" selectedImage:@"buttonMedium.png" disabledImage:@"buttonMedium.png" target:self selector:@selector(startMediumGame)];
        CCMenu *menuMedium = [CCMenu menuWithItems:mediumButton, nil];

        CCMenuItemImage *hardButton= [[CCMenuItemImage alloc] initWithNormalImage:@"buttonHard.png" selectedImage:@"buttonHard.png" disabledImage:@"buttonHard.png" target:self selector:@selector(startHardGame)];
        CCMenu *menuHard = [CCMenu menuWithItems:hardButton, nil];
        
        CCMenuItemImage *tutorialButton= [[CCMenuItemImage alloc] initWithNormalImage:@"buttonTutorial.png" selectedImage:@"buttonTutorial.png" disabledImage:@"buttonEasy.png" target:self selector:@selector(startTutorial)];
        CCMenu *menuTutorial = [CCMenu menuWithItems:tutorialButton, nil];
        
        menuEasy.position =ccp(260,140);
        menuMedium.position =ccp(310,90);
        menuHard.position =ccp(360,40);
        menuTutorial.position = ccp(80,20);
        
        [self addChild:menuEasy z:1];
        [self addChild:menuMedium z:1];
        [self addChild:menuHard z:1];
        [self addChild:menuTutorial z:1];


    }
	return self;
}

-(void)startEasyGame{
    [[LevelManager sharedInstance] setDifficulty:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccBLACK]];
}
-(void)startMediumGame{
    [[LevelManager sharedInstance] setDifficulty:2];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccBLACK]];
}
-(void)startHardGame{
    [[LevelManager sharedInstance] setDifficulty:3];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccBLACK]];
}
-(void)startTutorial{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Tutorial scene] withColor:ccBLACK]];
}


@end
