//
//  CustomTableViewCell.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property UIImageView * firestImage;
@property UIImageView * secondImage;
@property UILabel * title;
 

@end

NS_ASSUME_NONNULL_END
