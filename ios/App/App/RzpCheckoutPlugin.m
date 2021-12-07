//
//  RzpCheckoutPlugin.m
//  App
//
//  Created by Vivek Rajesh Shindhe on 07/12/21.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(RzpCheckoutPlugin, "Checkout", CAP_PLUGIN_METHOD(startPayment, CAPPluginReturnPromise);
           
           )
