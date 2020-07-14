//
//  ViewController.m
//  NativeToFlutterDemo
//
//  Created by lvjianxiong on 2020/7/14.
//  Copyright © 2020 lvjianxiong. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()

@property (nonatomic, strong) FlutterEngine *engine;
@property (nonatomic, strong) FlutterViewController *flutterViewController;
@property (nonatomic, strong) FlutterBasicMessageChannel *messageChannel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.flutterViewController = [[FlutterViewController alloc] initWithEngine:self.engine nibName:nil bundle:nil];
    self.flutterViewController.modalPresentationStyle = 0;
    
    
    self.messageChannel  = [FlutterBasicMessageChannel messageChannelWithName:@"message_channel" binaryMessenger:self.flutterViewController];
    [self.messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"收到Flutter发过来的消息%@",message);
    }];
    
}


- (FlutterEngine *)engine{
    if (!_engine){
        FlutterEngine *flutterEngine = [[FlutterEngine alloc] initWithName:@"lvjianxiongdemo"];
        if (flutterEngine.run) {
            _engine = flutterEngine;
        }
    }
    return _engine;
}

- (IBAction)pushFirstFlutterPage:(id)sender {
    //此处需要注意：methodChannelWithName需要与Flutter中的methodChannelName一致
    FlutterMethodChannel *firstChannel = [FlutterMethodChannel methodChannelWithName:@"first_channel" binaryMessenger:self.flutterViewController];
    [firstChannel invokeMethod:@"first" arguments:nil];//invoke的名字需要与Flutter中接收到的名字一致
    [self presentViewController:self.flutterViewController animated:true completion:nil];
    [firstChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //call.method方法名称是Flutter中的名字，此处需一致，否则无法通信
        if ([call.method isEqualToString:@"exit"]) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)pushSecondFlutterPage:(id)sender {
    //此处需要注意：methodChannelWithName需要与Flutter中的methodChannelName一致
    FlutterMethodChannel *secondChannel = [FlutterMethodChannel methodChannelWithName:@"second_channel" binaryMessenger:self.flutterViewController];
    [secondChannel invokeMethod:@"second" arguments:nil];//invoke的名字需要与Flutter中接收到的名字一致
    [self presentViewController:self.flutterViewController animated:true completion:nil];
    [secondChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //call.method方法名称是Flutter中的名字，此处需一致，否则无法通信
        if ([call.method isEqualToString:@"exit"]) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int a = 0;
    [self.messageChannel sendMessage:[NSString stringWithFormat:@"%d",a++]];
}

@end
