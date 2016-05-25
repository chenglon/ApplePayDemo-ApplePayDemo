//
//  ViewController.m
//  ApplePay
//
//  Created by lanmao on 16/5/25.
//  Copyright © 2016年 小霸道. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

//@property (nonatomic,strong)PKPaymentRequest *paymentRequest;
//@property (nonatomic,strong)PKPaymentAuthorizationViewController *AuthorizationViewController;

@property (nonatomic,strong) PKPaymentSummaryItem *subtotal;

@property (nonatomic,strong) PKPaymentSummaryItem *disCount;

@property (nonatomic,strong) PKPaymentSummaryItem *total;

@property (nonatomic,strong) NSArray *summaryItems;


@end

@implementation ViewController

//- (PKPaymentRequest *)paymentRequest
//{
//    if (!_paymentRequest) {
//        _paymentRequest = [[PKPaymentRequest alloc] init];
//    }
//    return _paymentRequest;
//}
//- (NSArray *)summaryItems
//{
//    if (!_summaryItems) {
//        _summaryItems = [NSArray array];
//    }
//    return _summaryItems;
//}
- (void)viewDidLoad {
    
    [super viewDidLoad];
/**
 PKPaymentButtonTypePlain = 0,
 PKPaymentButtonTypeBuy,
 PKPaymentButtonTypeSetUp
    */
    PKPaymentButton *payButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleWhiteOutline];
    payButton.frame = CGRectMake(30, 150, 100, 30);
    [payButton addTarget:self action:@selector(pay_button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    PKPaymentButton *setPayButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
    setPayButton.frame = CGRectMake(150, 150, 100, 30);
    [setPayButton addTarget:self action:@selector(SETbuttonPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setPayButton];
}
- (void)SETbuttonPay:(UIButton *)btn
{
    
}
- (void)pay_button:(UIButton *)sender {
/*
 *NSString * const PKPaymentNetworkAmex;
 NSString * const PKPaymentNetworkDiscover;
 NSString * const PKPaymentNetworkMasterCard;
 NSString * const PKPaymentNetworkPrivateLabel;
 NSString * const PKPaymentNetworkVisa;
 */
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
         NSLog(@"支持apple ——pay");
        
        if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkAmex,PKPaymentNetworkDiscover,PKPaymentNetworkMasterCard,PKPaymentNetworkPrivateLabel,PKPaymentNetworkVisa]]) {
            NSLog(@"支持的网络环境");
            PKPaymentRequest *paymentRequest = [[PKPaymentRequest  alloc] init];
            paymentRequest.countryCode = @"US";
            paymentRequest.currencyCode = @"USD";
            paymentRequest.merchantIdentifier= @"merchant.com.chenglong.project";
            
            NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1233 exponent:-2 isNegative:NO];
            self.subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"Subtotal" amount:subtotalAmount];
        
            NSDecimalNumber *disCount = [NSDecimalNumber decimalNumberWithMantissa:200 exponent:-2 isNegative:YES];
            self.disCount = [PKPaymentSummaryItem summaryItemWithLabel:@"disCount" amount:disCount];
            
            
            NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
            totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
            totalAmount = [totalAmount decimalNumberByAdding:disCount];
            
            self.total = [PKPaymentSummaryItem summaryItemWithLabel:@"My Company Name" amount:totalAmount];
            NSArray *summaryItems = [NSArray arrayWithObjects:self.subtotal,self.disCount,self.total, nil];
//            self.summaryItems = @[self.subtotal,self.disCount,self.total];
            
            paymentRequest.paymentSummaryItems = summaryItems;
            
           paymentRequest.merchantCapabilities =  PKMerchantCapability3DS;
            
           paymentRequest.requiredBillingAddressFields = PKAddressFieldEmail;
            paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkDiscover, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
            PKContact *contact = [[PKContact alloc] init];
            
            NSPersonNameComponents *name = [[NSPersonNameComponents alloc] init];
            name.givenName = @"john";
            name.familyName = @"app";
            contact.name = name;
            
            CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
            address.street = @"1234 laurel street";
            address.city = @"china";
            address.state = @"bj";
            address.postalCode = @"10020";
            contact.postalAddress = address;
            paymentRequest.shippingContact = contact;
            
            NSLog(@"%@",paymentRequest);
            PKPaymentAuthorizationViewController *AuthorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
            if (!AuthorizationViewController) {
                NSLog(@"nil");
            }
                AuthorizationViewController.delegate = self;
                [self presentViewController:AuthorizationViewController animated:YES completion:nil];
            
            
        }
        
    }
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"1%s",__func__);
    completion(PKPaymentAuthorizationStatusSuccess);
}
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
     NSLog(@"2%s",__func__);
    [controller dismissViewControllerAnimated:YES completion:nil];
}
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
     NSLog(@"3%s",__func__);
}
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
     NSLog(@"4%s",__func__);
}
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
     NSLog(@"5%s",__func__);
    NSArray *summaryItems = [NSArray arrayWithObjects:self.subtotal,self.disCount,self.total, nil];
    completion(summaryItems);
}


@end
