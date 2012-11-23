//
//  IKGotchaApi.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKGotchaApi.h"
#import "IKUserModel.h"
#import "JSON.h"

@implementation IKGotchaApi

+ (void) registerToken:(NSString*)token forUser:(NSString*)user
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://igotchaapp.com/dev/User/DeviceID"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"uid=%@&deviceToken=%@",user,token];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@", responseData);
}

+ (void) dropImage:(NSData*) image forUser:(NSString*)user
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://igotchaapp.com/dev/Game/Gotcha"]];
    [request setHTTPMethod:@"POST"];
    
//    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"%@", responseData);
    
    //Add content-type to Header. Need to use a string boundary for data uploading.
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
    //create the post body
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"uid"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",[IKUserModel sharedUserModel].profileId] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];

    [body appendData:[@"Content-Disposition: form-data; name=\"image\";fileName=\"gotcha.jpg\"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[NSData dataWithData:image]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];

    // set the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
        
    
}

+ (NSDictionary*) getPlayerInfoForUser:(NSString*)user
{
    NSString* urlString = [NSString stringWithFormat:@"http://igotchaapp.com/dev/game/getplayerinfo/?uid=%@", user];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
    return [NSDictionary dictionaryWithObject:[responseString JSONValue] forKey:@"Player"];
}


+ (void) confirmEliminationForUser:(NSString*)user
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://igotchaapp.com/dev/game/ConfirmElimination/"]]; 
    [request setHTTPMethod:@"POST"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"uid=%@",user];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@", responseData);
}

+ (void) denyEliminationForUser:(NSString*)user
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://igotchaapp.com/dev/game/DenyElimination/"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"uid=%@",user];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@", responseData);
}

@end
