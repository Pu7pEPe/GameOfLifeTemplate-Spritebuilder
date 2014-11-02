//
//  Grid.h
//  GameOfLife
//
//  Created by Home iMac on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite

-(void)evolveStep;
-(void)countNeighbors;


@property (nonatomic, assign) int totalAlive;
@property (nonatomic, assign) int generation;

@end
