//
//  PauseMenu.m
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 25.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PauseMenu.h"


@implementation PauseMenu

CCMenu *menu;
CCSprite *background;

-(id) initWithGame:(Game*)danceGame
{
	game = danceGame;
	if( (self=[super init]) ) {
            }
	return self;
}

-(void)gameOver{
    CCMenuItemImage *homeButton= [[CCMenuItemImage alloc] initWithNormalImage:@"homeButton.png" selectedImage:@"homeButton.png" disabledImage:@"homeButton.png" target:game selector:@selector(mainMenu)];
    CCMenuItemImage *restartButton= [[CCMenuItemImage alloc] initWithNormalImage:@"restartButton.png" selectedImage:@"restartButton.png" disabledImage:@"restartButton.png" target:game selector:@selector(restartGame)];
    
    CCMenuItemImage *facebookButton= [[CCMenuItemImage alloc] initWithNormalImage:@"facebookButton.png" selectedImage:@"facebookButton.png" disabledImage:@"facebookButton.png" target:game selector:@selector(postOnFacebook)];


    restartButton.position = ccp(80,50);
    homeButton.position = ccp(150,50);
    facebookButton.position = ccp(10,45);
    
    menu = [CCMenu menuWithItems:facebookButton,homeButton,restartButton, nil];
    menu.position = ccp(160,60);
    menu.tag = 5;
    
    background = [[CCSprite alloc] initWithFile:@"menuBackground.png"];
    background.position = ccp(240,160);
    background.tag = 6;
    background.scaleY = 1.5;
    background.scaleX = 1.2;
    
    [game addChild:menu z:11];
    [game addChild:background z:10];
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:34];
    score.position = ccp(210, 190);
    [game addChild:score z:13];
    [score setString:[NSString stringWithFormat:@"SCORE: %i", [game getScore]]];

}


-(void)closeMenu{
    
    [game removeChildByTag:5 cleanup:YES];
    [game removeChildByTag:6 cleanup:YES];
}
-(void)openMenu{
    CCMenuItemImage *resumeButton= [[CCMenuItemImage alloc] initWithNormalImage:@"resumeButton.png" selectedImage:@"resumeButton.png" disabledImage:@"resumeButton.png" target:game selector:@selector(resumeGame)];
    CCMenuItemImage *homeButton= [[CCMenuItemImage alloc] initWithNormalImage:@"homeButton.png" selectedImage:@"homeButton.png" disabledImage:@"homeButton.png" target:game selector:@selector(mainMenu)];
    CCMenuItemImage *restartButton= [[CCMenuItemImage alloc] initWithNormalImage:@"restartButton.png" selectedImage:@"restartButton.png" disabledImage:@"restartButton.png" target:game selector:@selector(restartGame)];
    
    
    resumeButton.position = ccp(10,100);
    restartButton.position = ccp(80,100);
    homeButton.position = ccp(150,100);
    menu = [CCMenu menuWithItems:resumeButton,homeButton,restartButton, nil];
    menu.position = ccp(160,60);
    menu.tag = 5;
    
    background = [[CCSprite alloc] initWithFile:@"menuBackground.png"];
    background.position = ccp(240,160);
    background.tag = 6;
    background.scaleY = 0.7;
    background.scaleX = 1.2;

    [game addChild:menu z:11];
    [game addChild:background z:10];
}
@end
