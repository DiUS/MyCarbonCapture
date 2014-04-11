//
//  DJForestViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Masonry/View+MASShorthandAdditions.h>
#import "DJForestViewController.h"
#import "DJForestScene.h"
#import "DJBankViewController.h"

@interface DJForestViewController ()

@property(nonatomic, strong) DJBankViewController *tileViewController;
@end

@implementation DJForestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
  }
  return self;
}


-(void)viewWillAppear:(BOOL)animated {
  SKView *spriteView = (SKView *) self.view;

  DJForestScene *forestScene = [[DJForestScene alloc] initWithSize:self.view.bounds.size];
  forestScene.moc = self.moc;
  forestScene.delegate = self;
  [spriteView presentScene:forestScene];

  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [backButton setTitle:@"Done" forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:backButton];

  backButton.translatesAutoresizingMaskIntoConstraints = NO;

  //Add the bank view to display pending trees
  self.tileViewController = [[DJBankViewController alloc] initWithCollectionViewLayout:nil];
  self.tileViewController.moc = self.moc;
  [self addChildViewController:self.tileViewController];
  self.tileViewController.collectionView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:.5];
  [self.view addSubview:self.tileViewController.view];

  [backButton makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view.right).offset(-20);
    make.bottom.equalTo(self.bottomLayoutGuide).offset(-20);
  }];
  [self.tileViewController.view makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view.bottom).offset(-40);
    make.left.equalTo(self.view.left);
  }];


}


-(void)goBack {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - Forest delegate

- (void)forestDidUpdateTreeCollection {
  [self.tileViewController refreshBankViewCollection];
}

@end
