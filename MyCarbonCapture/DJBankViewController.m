//
//  DJtreeStorageViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 19/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJBankViewController.h"
#import "Tree.h"
#import "TreeStorage.h"

@interface DJBankViewController ()
@property(nonatomic,strong) NSFetchedResultsController * frc;


@end

@implementation DJBankViewController

static NSString *CELL_IDENTIFIER = @"CELL_IDENTIFER";
static NSString *TREE_IDENTITY = @"Tree";
static NSString *TREE_STORAGE = @"TreeStorage";



-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  UICollectionViewFlowLayout *gridLayout = [[UICollectionViewFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:gridLayout];
  if (self) {
    gridLayout.itemSize = CGSizeMake(23, 33);
    gridLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [gridLayout setSectionInset:UIEdgeInsetsMake(5, 5, 10, 5)];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
  Tree *tree = [self.frc objectAtIndexPath:indexPath];
  [cell.contentView addSubview:[[UIImageView alloc] initWithImage:tree.image]];
  return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
  NSLog(@"the count of kck is %d",[sectionInfo numberOfObjects]);
  return [sectionInfo numberOfObjects];
}


-(void)viewDidAppear:(BOOL)animated {
  NSLog(@"hehehe");
}


-(NSFetchedResultsController *)frc {
  if (_frc) {
    return _frc;
  }

  NSError * error = nil;
  NSFetchRequest *treeStorageReq = [NSFetchRequest fetchRequestWithEntityName:TREE_STORAGE];
  TreeStorage * treeStorage = [[self.moc executeFetchRequest:treeStorageReq error:nil] lastObject];
  NSLog(@"The pre-existing treeStorage is: %@",treeStorage);

  if (!treeStorage) {
    treeStorage = [NSEntityDescription insertNewObjectForEntityForName:TREE_STORAGE inManagedObjectContext:self.moc];
    [self seedTreesForTreeStorage:treeStorage];
  }

  [self.moc save:&error];

  NSLog(@"The the MOC is %@",self.moc);

  NSFetchRequest * req = [NSFetchRequest fetchRequestWithEntityName:TREE_IDENTITY];
  // req.predicate = [NSPredicate predicateWithFormat:@"storage ==  %@",treeStorage.objectID];

  if (error) {
    NSLog(@"Error creating a new treeStorage and NSFetched Results Controller: %@",error);
  }

  req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
  _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                             managedObjectContext:self.moc
                                               sectionNameKeyPath:nil
                                                        cacheName:nil];
  _frc.delegate = self;

  if (![_frc performFetch:&error]) {
    abort();
  }



  return _frc;
}

-(void)seedTreesForTreeStorage:(TreeStorage*)treeStorage {
  NSError *error = nil;
  Tree * tree = nil;
  NSString *imgName = nil;
  for (int i = 1; i <=5; i++) {

    tree = [NSEntityDescription insertNewObjectForEntityForName:TREE_IDENTITY inManagedObjectContext:self.moc];
    imgName = [NSString stringWithFormat:@"MCC_BankTree#%d",i];
    NSLog(@"the image name is %@",imgName);
    tree.image = [UIImage imageNamed:imgName];
    tree.name = [NSString stringWithFormat:@"The tree name is tree%d",i];
    tree.info = [NSString stringWithFormat:@"The tree infomation is tree %d",i];
    tree.storage = treeStorage;
  }
  [self.moc save:&error];
  if (error)
    NSLog(@"The found error is %@",error);
}

@end
