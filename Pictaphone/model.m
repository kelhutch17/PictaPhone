//
//  model.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "model.h"

static NSString * const filename = @"model.archive";

@interface model ()

@property (nonatomic,assign) bool initialization;

// Game Settings Properties
@property (nonatomic, assign) NSInteger numPlayers;
@property (nonatomic, assign) NSInteger totalNumTurns;
@property (nonatomic, assign) NSString *firstRoundType;
@property (nonatomic, assign) BOOL autoGenerateFirstRound;

@property (nonatomic, assign) NSInteger completedRounds;
@property (nonatomic, assign) NSInteger currentRound;

@property (nonatomic, assign) NSInteger completedTurns;
@property (nonatomic, assign) NSInteger currentTurn;
@property (nonatomic, assign) NSInteger currentPlayer;

@property (nonatomic, assign) UIImage *randomImageVar;
@property (nonatomic, assign) NSString *randomPhraseVar;

@property (nonatomic, assign) BOOL isSetRandomImageVar;
@property (nonatomic, assign) BOOL isSetRandomPhraseVar;

@property (nonatomic, strong) NSMutableArray *contentsOfTurn;

@property NSDictionary* infoPList;

@end

@implementation model

+(id)sharedInstance {
    static id singleton;
    @synchronized(self) {
        if (!singleton) {
            singleton = [[self alloc] init];
        }
    }
    return singleton;
}

-(id)init {
    self = [super init];
    if (self)
    {
        self.initialization = YES;
        [self loadInfoPList];
        
        self.isSetRandomImageVar = NO;
        self.isSetRandomPhraseVar = NO;
    }
    self.initialization = NO;
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadInfoPList
{
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"game_info" ofType:@"plist"];
    self.infoPList = [NSDictionary dictionaryWithContentsOfFile:infoPath];
}

-(void)initializeGameSettings
{
    self.completedTurns = 0;
    self.completedRounds = 0;
    self.currentRound = 1;
    self.currentTurn = 1;
    self.currentPlayer = 1;
}

#pragma mark - Instructions Array
// returns an array of Instruction dictionaries
- (NSArray*)instructionsArray
{
    return [self.infoPList valueForKey:@"Instructions"];
}

// Returns number of instructions "pages" there are for the game
-(NSInteger)instructionPageCount
{
    return [[self instructionsArray] count];
}

// Returns Instruction Title for page
-(NSString*)instructionTitleForPage:(NSInteger)pageNumber
{
    NSDictionary *instructions = [[self instructionsArray] objectAtIndex:pageNumber];
    return [instructions valueForKey:@"Title"];
}

// Returns Instruction Line One for page
-(NSString*)instructionLineOneForPage:(NSInteger)pageNumber
{
    NSDictionary *instructions = [[self instructionsArray] objectAtIndex:pageNumber];
    return [instructions valueForKey:@"Line One"];
}

// Returns Instruction Line Two for page
-(NSString*)instructionLineTwoForPage:(NSInteger)pageNumber
{
    NSDictionary *instructions = [[self instructionsArray] objectAtIndex:pageNumber];
    return [instructions valueForKey:@"Line Two"];
}


#pragma mark - Game Modes Dictionary
// returns a dictionary of Game Mode dictionaries
-(NSDictionary*)gameModesDictionary
{
    return [self.infoPList valueForKey:@"Game_Modes"];
}

// returns a game mode dictionary
-(NSDictionary*)gameModeDictionaryForMode:(NSString*)gameMode
{
    NSDictionary *gameModeDictionary = [self gameModesDictionary];
    return [gameModeDictionary valueForKey:gameMode];
}

// returns the title of the specified game mode
-(NSString*)titleForGameMode:(NSString*)gameMode
{
    NSDictionary *dictionary = [self gameModeDictionaryForMode:gameMode];
    return [dictionary valueForKey:@"title"];
}

// returns the description of the specified game mode
-(NSString*)descriptionForGameMode:(NSString*)gameMode
{
    NSDictionary *dictionary = [self gameModeDictionaryForMode:gameMode];
    return [dictionary valueForKey:@"description"];
}


#pragma mark - File System
-(NSString*)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSString *)filePath {
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:filename];
}

-(BOOL)fileExists {
    NSString *path = [self filePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - Random Assets

-(NSDictionary*)randomAssetsDictionary
{
     return [self.infoPList valueForKey:@"Random_Assets"];
}

// returns an array of random phrases
-(NSArray*)phrasesArray
{
    NSDictionary *phrasesDict = [self randomAssetsDictionary];
    return [phrasesDict valueForKey:@"Phrases"];
}

// returns an array of random image Names
-(NSArray*)imageNamesArray
{
    NSDictionary *imageNamesDict = [self randomAssetsDictionary];
    return [imageNamesDict valueForKey:@"Images"];
}

// returns an image Name from the imageNames Array
-(NSString*)imageNameForIndex:(NSInteger)index {
    NSArray *imageNames = [self imageNamesArray];
    return [imageNames objectAtIndex:index];
}

// returns a phrase from the Phrases Array
-(NSString*)phraseForIndex:(NSInteger)index {
    NSArray *phrases = [self phrasesArray];
    return [phrases objectAtIndex:index];
}

// returns the number of entries in the phrases array
-(NSInteger)phraseArrayCount
{
    return [self phrasesArray].count;
}

// returns the number of entries in the image names array
-(NSInteger)imageNameArrayCount
{
    return [self imageNamesArray].count;
}

-(UIImage*)randomImage
{
    NSInteger arrayCount = [self imageNameArrayCount];
    NSInteger randomIndex = arc4random_uniform((u_int32_t)arrayCount);
    
    NSString *imageName = [self imageNameForIndex:randomIndex];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageName, @".jpg"]];
    
    return image;
}

-(NSString*)randomPhrase
{
    NSInteger arrayCount = [self phraseArrayCount];
    NSInteger randomIndex = arc4random_uniform((u_int32_t)arrayCount);
    
    NSString *phrase = [self phraseForIndex:randomIndex];
    return phrase;
}

-(void)storeChosenRandomPhrase:(NSString*)phrase
{
    // PHRASE
    self.randomPhraseVar = phrase;
    self.isSetRandomPhraseVar = YES;
}

-(void)storeChosenRandomImage:(UIImage*)image
{
    // IMAGE
    self.randomImageVar = image;
    self.isSetRandomImageVar = YES;
}

-(void)setRandomImageStatus:(BOOL)status
{
    self.isSetRandomImageVar = status;
}

-(void)setRandomPhraseStatus:(BOOL)status
{
    self.isSetRandomPhraseVar = status;
}

-(BOOL)isSetRandomPhrase
{
    return (self.isSetRandomPhraseVar);
}

-(BOOL)isSetRandomImage
{
    return (self.isSetRandomImageVar);
}

-(UIImage*)valueOfRandomImage
{
    return self.randomImageVar;
}

-(NSString*)valueOfRandomPhrase
{
    return self.randomPhraseVar;
}

#pragma mark - Contents Array Functions

-(void)initializeContentsArray
{
    NSInteger totalTurns = self.totalNumTurns;
    self.contentsOfTurn = [[NSMutableArray alloc] initWithCapacity:totalTurns];
}

-(void)populateContentsArrayWithImage:(UIImage*)drawing
{
    [self.contentsOfTurn addObject:drawing];
}

-(void)populateContentsArrayWithPhrase:(NSString*)phrase
{
    [self.contentsOfTurn addObject:phrase];
}

-(NSInteger)contentsArrayCount
{
    return self.contentsOfTurn.count;
}

-(id)valueOfContentsArrayAtIndex:(NSInteger)index
{
    return [self.contentsOfTurn objectAtIndex:index];
}


#pragma mark - Game Settings
-(void)storePlayerCount:(NSInteger)count
{
    self.numPlayers = count;
}

-(void)storeTurnCount:(NSInteger)count
{
    self.totalNumTurns = count;
}

-(void)storeFirstRoundType:(NSString*)type
{
    self.firstRoundType = type;
}

-(void)storeAutoGeneratedFirstRoundType:(BOOL)autoGenerated
{
    self.autoGenerateFirstRound = autoGenerated;
}

-(BOOL)isFirstRoundAutoGenerated
{
    return self.autoGenerateFirstRound;
}

-(void)trackFinishedTurn
{
    self.completedTurns++;
    self.currentTurn++;
    self.currentPlayer++;
    
    if((self.completedTurns % self.numPlayers) == 0)
    {
        self.completedRounds++;
        self.currentRound++;
        self.currentPlayer = 1;
    }
}

-(NSInteger)currentTurn
{
    return _currentTurn;
}

-(NSInteger)currentRound
{
    return _currentRound;
}

-(NSInteger)currentPlayer
{
    return _currentPlayer;
}

-(NSInteger)turnsRemaining
{
    return (_totalNumTurns - _completedTurns);
}

-(NSInteger)turnsCompleted
{
    return _completedTurns;
}

-(NSInteger)turnsPerRound
{
    return _numPlayers;
}

@end
