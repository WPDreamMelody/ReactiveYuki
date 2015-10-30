//
//  ViewController.m
//  ReactiveYuki
//
//  Created by Yuki on 15/10/9.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NVCricleView.h"

@interface ViewController ()
@property (nonatomic,strong) UITextField *passwordlbl;
@property (nonatomic,strong) UITextField *namelbl;
@property (nonatomic,strong) UILabel *warninglbl;

@property (nonatomic,assign) BOOL isCanDisplay;
@property (nonatomic,strong) UIButton *loginbtn;
@end

@implementation ViewController

- (void)initBaseView{
    self.namelbl = [UITextField new];
    self.namelbl.frame = CGRectMake(10, 40, 200, 40);
    self.namelbl.text = @"Defual-Name";
    [self.view addSubview:self.namelbl];
    
    self.passwordlbl = [UITextField new];
    self.passwordlbl.frame = CGRectMake(10, 80, 200, 40);
    self.passwordlbl.text = @"Defual-PassWord";
    [self.view addSubview:self.passwordlbl];
    
    self.loginbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 120,self.view.frame.size.width, 40)];
    [self.loginbtn setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.loginbtn];
    
    self.isCanDisplay = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    //RACCommand
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            [subscriber sendNext:@"Login-In:"];
//            [subscriber sendCompleted];
//            return nil;
//        }];
        return [RACSignal return:@"Login-Out"];
        return [RACSignal empty];
    }];
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(NSString *name) {
            NSString *str = [NSString stringWithFormat:@"%@ %@",name,[NSDate date]];
            [self.loginbtn setTitle:str forState:UIControlStateNormal];
        }];
    }];
    self.loginbtn.rac_command = command;
    //RAC
    RAC(self.namelbl, textColor) = [
                                    self.namelbl.rac_textSignal map:^id(NSString *value) {
                                        return value.length == 2 ? [UIColor redColor]:[UIColor blueColor];
                                    }];
    RAC(self.passwordlbl, textColor) = [
                                        self.passwordlbl.rac_textSignal map:^id(NSString *value) {
                                            return value.length == 2 ? [UIColor redColor]:[UIColor blueColor];
                                        }];
    RAC(self.loginbtn, hidden) = [RACSignal combineLatest:@[
                                                            self.namelbl.rac_textSignal,
                                                            self.passwordlbl.rac_textSignal,
                                                            RACObserve(self, isCanDisplay)
                                                            ] reduce:^id(NSString *nameTxt, NSString*passwordTxt, NSNumber *display){
                                                                if([nameTxt isEqual:@"Defual-Name"] && [passwordTxt isEqual:@"Defual-PassWord"] && ![display boolValue]){
                                                                    return @(NO);
                                                                }
                                                                else{
                                                                    return @(YES);
                                                                }
                                                            }];
    //then & subscribeNext & createSignal & RACDisposable
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"triggered");
        [subscriber sendNext:@"foobar"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    [[signal then:^RACSignal *{
        return signal;//self.namelbl.rac_textSignal;
    }]
     subscribeNext:^(id x) {
         NSLog(@"RACSignal Output is  : %@",x);
     }];
    NSLog(@"%@",signal);
    //rac_willDeallocSignal
    NSArray *arr = @[@"head",@"foot"];
    [[arr rac_willDeallocSignal] subscribeCompleted:^{
        NSLog(@"oops,i will be gone!");
    }];
    arr = nil;
    
    //RACSubject
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSignal *merged = [RACSignal merge:@[letters,numbers]];
    
    [merged subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [letters sendNext:@"A"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"B"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"1"];
    
    
    
}

- (void)doTest
{
    RACSubject *subject = [self doRequest];
    
    [subject subscribeNext:^(NSString *value){
        NSLog(@"value:%@", value);
    }];
}

- (RACSubject *)doRequest
{
    RACSubject *subject = [RACSubject subject];
    [[[[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] take:1] map:^id(id _){
        // the value is from url request
        NSString *value = @"content fetched from web";
        [subject sendNext:value];
        return nil;
    }] subscribeNext:^(id value){
    //此方法必须调用，不然方法不执行
    }];
    return subject;
}

- (void)rac_array{
    NSString *url = @"http://img.name2012.com/uploads/allimg/2015-06/30-023131_451.jpg";
    NSArray *arr = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    id newArr = [[[arr rac_sequence] filter:^BOOL(id value) {
        NSInteger v =  [((NSString*)value) integerValue];
        NSError *error = nil;
        __block NSData *dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&error];
        if(error){
            NSLog(@">>>>>>%@",error);
            [[[RACSignal interval:0.5 onScheduler:[RACScheduler scheduler]] take:1]subscribeNext:^(id x) {
                NSString *url = @"http://m1.s1.dpfile.com/sc/api_res/eleconfig/20150512174625watch.jpg";
                NSData *newData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                dt = newData;
            }];
            NSLog(@"%@",dt);
        }else{
            NSLog(@">>>>>>%li",(long)v);
        }
        return v;
    }].signal subscribeCompleted:^{
        NSLog(@">>>>>>>>>>END>>>>>>>>>>>");
    }];
    
    NSLog(@"%@",newArr);
}

- (NSData *)retryOnceRACSignal:(NSString*)url{
    __block NSData *result = nil;
    [[[RACSignal interval:1  onScheduler:[RACScheduler scheduler]] take:1]subscribeNext:^(id x) {
       NSData *dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        result = dt;
    }];
     return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
