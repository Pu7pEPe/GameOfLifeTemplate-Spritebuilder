//
//  Grid.m
//  GameOfLife
//
//  Created by Home iMac on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
//these are private variables
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {

    //2d array taht will store all the creatures in our grid
    NSMutableArray *_gridArray;
    
    //Used to place the creatures on our grid correctly in the method ?
    float _cellWidth;
    float _cellHeight;
}

- (void)onEnter
{
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}


- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid properly
            //creature.isAlive = YES;
            
            x+=_cellWidth;
        }
        
        y += _cellHeight;
    }
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert it's state - kill it if it's alive, bring it to life if it's dead.
    creature.isAlive = !creature.isAlive;
}


- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Creature inside the corresponding cell

    int row = touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;
    
    return _gridArray[row][column];

}


-(void)evolveStep
{
    //update each neightbour count
    [self countNeighbors];
    
    //update each Creature's State
    [self updateCreatures];
    
    //update the generation so the label's text will display correctly
    _generation++;
}

-(void)countNeighbors
{
    //iterate through the rows
    for (int i = 0; i < [_gridArray count]; i++)
    {
        //iterate through the column
        for (int j = 0; j < [_gridArray[i] count]; j++)
        {
            //access the creature in this cell.
            Creature *currentCreature = _gridArray[i][j];
            
            //setup the neightbours property
            currentCreature.livingNeighbors = 0;
            
            //examine the neighbouring cells on to of the current
            
            //go through the row on top, the current row, and the row past it.
            for (int x = (i-1); x<= (i+1); x++)
            {
                //go through the column to the left, current column, column on the right
                for (int y = (j-1); y <= (j+1); y++)
                {
                    //check that the cell isn't off screen.
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen and the cell that contains current creature
                    if(!((x == i) && (y == j)) && isIndexValid)
                    {
                        Creature *neighbour = _gridArray[x][y];
                        if (neighbour.isAlive)
                        {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
    
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}

- (void)updateCreatures {
    _totalAlive = 0;
    
    for (int i = 0; i < [_gridArray count]; i++) {
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = YES;
            } else if ( (currentCreature.livingNeighbors <= 1) || (currentCreature.livingNeighbors >= 4)) {
                currentCreature.isAlive = NO;
            }
            
            if (currentCreature.isAlive) {
                _totalAlive++;
            }
        }
    }
}





@end
