//
//  ViewController.m
//  LGScrollingPerformanceMonitor
//
//  Created by liuge on 8/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+LGPerformanceMonitor.h"
#import "UIView+Snapshot.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addObserver:self forKeyPath:@"averageFPS" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.tableView && [keyPath isEqualToString:@"averageFPS"]) {
        
        NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setRoundingMode:NSNumberFormatterRoundHalfUp];
        [format setMaximumFractionDigits:2];
        [format setMinimumFractionDigits:2];
        
        NSNumber *number = [change valueForKey:NSKeyValueChangeNewKey];
        
        [_barButtonItem setTitle:[format stringFromNumber:number]];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarButtonItem) object:nil];
        [self performSelector:@selector(hideBarButtonItem) withObject:nil afterDelay:1.5];
    }
}

- (void)hideBarButtonItem {
    _barButtonItem.title = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    UIImage *image = [tableView toImage];
    
    cell.imageView.image = image;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"     This is Cell:   %ld", (long)indexPath.row];
    
    return cell;
}

@end
