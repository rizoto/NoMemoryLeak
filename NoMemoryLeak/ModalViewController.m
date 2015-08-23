//
//  ModalViewController.m
//  NoMemoryLeak
//
//  Created by Lubor Kolacny on 7/08/2015.
//  Copyright (c) 2015 Lubor Kolacny. All rights reserved.
//

#import "ModalViewController.h"
#import "RSEnvironment.h"

@interface ModalViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    UIAlertController *alert;
    UIPopoverController *popOver;
    UIImagePickerController *_picker;
    __weak IBOutlet UIButton *pickerButton;
    __weak IBOutlet UINavigationItem *bar;
}

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (RSEnvironment.system.version.major >= 8) {
        [bar.leftBarButtonItem setEnabled:YES];
    }
    if (RSEnvironment.UI.isIdiomIPad) {
        [pickerButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeMe:(UIBarButtonItem *)sender {
    alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                message:@"This is an alert."
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    __weak id weakSelf = self;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alert addAction:defaultAction];
    alert.popoverPresentationController.barButtonItem = bar.leftBarButtonItem;
    alert.popoverPresentationController.sourceView = self.view;

    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)close2:(UIBarButtonItem *)sender {
    __weak id weakSelf = self;
    UIActionSheet *alert2 = [[UIActionSheet alloc] initWithTitle:@"Hej" delegate:weakSelf cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destruct" otherButtonTitles:@"hej", nil];
    [alert2 showFromBarButtonItem:bar.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imagePickerTapped:(UIButton *)sender {
    _picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    popOver = [[UIPopoverController alloc]initWithContentViewController:_picker];
    popOver.delegate = self;
    [popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [popOver dismissPopoverAnimated:YES];
    [popOver.delegate popoverControllerDidDismissPopover:popOver];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [popOver dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [popOver.delegate popoverControllerDidDismissPopover:popOver];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControllerDidDismissPopover");
    _picker = nil;
    popOver = nil;
}

- (void)dealloc {
    NSLog(@"ModalViewController - dealloc");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
