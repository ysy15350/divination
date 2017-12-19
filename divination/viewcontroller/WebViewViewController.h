//
//  WebViewViewController.h
//  MHRoadMobile
//
//  Created by 杨世友 on 16/10/31.
//
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocol <JSExport>

-(void)ChoosePhoto:(NSString *)params;

-(void)TestMethod;

@end

@interface WebViewViewController : UIViewController<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JSObjectProtocol>
{
    NSString *filePath;
    UITextView *_textEditor;
}

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *webUrl;

@property (nonatomic,copy) NSString *paramStr;

@end
