//
//  CustomTableViewCell.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _firestImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firestImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_firestImage];
        
        _secondImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_secondImage];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGFloat cellHeight = self.contentView.bounds.size.height;
    _firestImage.frame = CGRectMake(10, -5, 65, cellHeight);
    _secondImage.frame = CGRectMake(cellWidth - 100, -12, 80, cellHeight +30);
    _title.frame = CGRectMake(120, 5, cellWidth - 100, cellHeight - 5);
    _title.font = [UIFont systemFontOfSize:20];

}

@end
