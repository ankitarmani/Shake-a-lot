//
//  Tutorial.m
//  Shake a Lot
//
//  Created by Artin Daniel Hariri on 10.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"
#import "MainMenu.h"


@implementation Tutorial

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tutorial *layer = [Tutorial node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	
	if( (self=[super init]) ) {
        [CCVideoPlayer setDelegate:self];
        [CCVideoPlayer playMovieWithFile:@"AppTutorial.mov"];
    }
return self;
}

- (void) moviePlaybackFinished
{   	
     [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];
}
- (void) movieStartsPlaying
{

}

@end
