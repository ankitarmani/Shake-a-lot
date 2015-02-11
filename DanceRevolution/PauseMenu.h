//
//  PauseMenu.h
//  DanceRevolution
//
//  Created by Artin Daniel Hariri on 25.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

@interface PauseMenu : CCLayer {
    
    Game *game;
    
}
-(id)initWithGame:(Game*)danceGame;
-(void)openMenu;
-(void)closeMenu;
-(void)gameOver;
@end
