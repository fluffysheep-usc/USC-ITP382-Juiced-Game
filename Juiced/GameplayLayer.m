//
//  HelloWorldLayer.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/10/14.
//  Copyright Silly Landmine Studios 2014. All rights reserved.
//


// Import the interfaces
#import "GameplayLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "Disk.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameplayLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameplayLayer *layer = [GameplayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // All user-interactable objects
        objects = [[NSMutableArray alloc] init];
        
        // No selected sprite initially
        selectedSprite = NULL;
        
        // Add a some disks for testing
        Disk* disk1 = [Disk node];
        disk1.position = ccp(winSize.width/2 + 90, winSize.height/2);
        disk1.color = blue;
        [objects addObject:disk1];
        [self addChild:disk1];
        
        Disk* disk2 = [Disk node];
        disk2.position = ccp(winSize.width/2 - 90, winSize.height/2);
        disk2.color = red;
        [objects addObject:disk2];
        [self addChild:disk2];
        
        Disk* disk3 = [Disk node];
        disk3.position = ccp(winSize.width/2, winSize.height/2 + 90);
        disk3.color = yellow;
        [objects addObject:disk3];
        [self addChild:disk3];
        
        Disk* disk4 = [Disk node];
        disk4.position = ccp(winSize.width/2, winSize.height/2 - 90);
        disk4.color = green;
        [objects addObject:disk4];
        [self addChild:disk4];
        
        // This layer can receive touches
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
	}
	return self;
}

-(void)selectObjectForTouch:(CGPoint)touchLocation {
    for (Disk *d in objects) {
        if (CGRectContainsPoint([d rect], touchLocation)) {
            selectedSprite = d;
            break;
        }
    }
}

-(void)panForTranslation:(CGPoint)translation {
    if (selectedSprite) {
        CGPoint newPos = ccpAdd(selectedSprite.position, translation);
        selectedSprite.position = newPos;
    }
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectObjectForTouch:touchLocation];
    
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    selectedSprite = NULL;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [objects dealloc];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end