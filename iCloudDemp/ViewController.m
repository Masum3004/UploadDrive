//
//  ViewController.m
//  iCloudDemp
//
//  Created by Masum Chauhan on 12/12/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ViewController.h"
#import "iCloud.h"
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>
#import "SCRFTPRequest.h"
#define FTP_URL @"ftp://ws-srv-php/drupal/amgsales2/sites/default/files/userfile/"

#define FTP_USERNAME @"projects"

#define FTP_PASSWORD @"projects"

@interface ViewController ()<iCloudDelegate, UIDocumentPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

//    CKContainer * container = [CKContainer containerWithIdentifier:@"iCloud.com.identifier"];
    //NSLog(@"--%@",[self publicCloudDatabase]);
//    [[iCloud sharedCloud] setDelegate:self];
//    [[iCloud sharedCloud] setVerboseLogging:YES];
//    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:nil];
//    
//    [self showiCloudFiles];
}
- (CKDatabase *)publicCloudDatabase {
    return [[CKContainer defaultContainer] publicCloudDatabase];
}

- (IBAction)openImportDocumentPicker:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}


/*
 *
 * Handle Incoming File
 *
 */
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [url lastPathComponent]];
        NSLog(@"Imported ::>> %@",url);
        [self uploadImageAtPath:[NSString stringWithFormat:@"%@",url]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

/*
 *
 * Export Document Picker
 *
 */
- (IBAction)openExportDocumentPicker:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"image" withExtension:@"jpg"]
                                                                                                  inMode:UIDocumentPickerModeExportToService];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

/*
 *
 * Cancelled
 *
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Cancelled");
}
- (IBAction)btnUpload:(id)sender {
    

}

-(void) uploadImageAtPath :(NSString *)path {
    
    ///drupal/amgsales2/sites/default/files/userfile/
    NSLog(@"fullPAth...... %@",[path stringByReplacingOccurrencesOfString:@"file:///private/" withString:@""]);
      dispatch_async(dispatch_get_main_queue(), ^{
        
        SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:FTP_URL] toUploadFile:[path stringByReplacingOccurrencesOfString:@"file:///private/" withString:@""]];
        
        ftpRequest.username = FTP_USERNAME;
        ftpRequest.password = FTP_PASSWORD;
        //ftpRequest.customUploadFileName = @"ConductCare3.png";
        ftpRequest.delegate = self;
        [ftpRequest startAsynchronous];
        
    });
    
    
}
- (void)ftpRequestWillStart:(SCRFTPRequest *)request
{
    NSLog(@"started");
}

- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status

{
    NSLog(@"didChanged");
}

- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten
{
     NSLog(@"didWrited");
}
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request

{
    NSLog(@"Did finish");
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
    
    
}

@end
