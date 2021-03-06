//
//  IIIWeatherViewController.m
//  WeatherObjC
//
//  Created by Ilgar Ilyasov on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

#import "JACWeatherViewController.h"
#import "JACWeatherCollectionViewCell.h"
#import "JACWeatherController.h"
#import "JACWeather.h"

@interface JACWeatherViewController ()

@property JACWeather *weather;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JACWeatherViewController

JACWeatherController *controller;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        controller = [[JACWeatherController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar setDelegate:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *zipCode = [f numberFromString:[searchBar text]];
    
    if (zipCode) {
        [controller fetchWeatherByZip:zipCode completion:^(JACWeather *weather, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.weather = weather;
                    self.cityNameLabel.text = weather.name;
                    [self.collectionView reloadData];
                });
                
            }
        }];
    } else {
        NSLog(@"zipCode was not valid");
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.weather.temperature.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JACWeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@", [self.weather.imageName objectAtIndex:[indexPath row]]];
    
    [cell updateImageWithName:imageName temperature:[NSString stringWithFormat:@"%@", [self.weather.temperature objectAtIndex:[indexPath row]]]];
    
    return cell;
}

@end
