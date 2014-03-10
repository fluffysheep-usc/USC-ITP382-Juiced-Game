//
//  StateAchievements.m
//  Juiced
//
//  Created by David on 3/8/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateAchievements.h"
#import "StateTimeAttackGame.h"
#import "StateSurvivalGame.h"
#import "StateEliminationGame.h"

@implementation StateAchievements

-(void) update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for(int i = 0; i < m_manager.disks.count; i++) {
        Disk* d = m_manager.disks[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [m_manager getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Handle menu selection
                [self handleMenuSelection:d Quadrant:intersectedCQ];
            }
        }
    }
}

-(void) handleMenuSelection : (Disk*) disk Quadrant : (CornerQuadrant*) quad {
    //Handle collisions here.
    [m_manager setGameState:[[StateMainMenu alloc] init]];
}

-(void) enter {
    [m_manager changeColorOfAllQuadrantsTo:red];
    [self scheduleOnce:@selector(spawnCenterDisk) delay:2.0];
    [m_manager.UI hideIntroLabel];
}

-(void) spawnCenterDisk {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [m_manager spawnDiskAtLocation:ccp(winSize.width / 2, winSize.height / 2) withColor:red];
}

-(void) exit {
    [m_manager clearAllDisks];
}

@end
