//
//  ViewController.m
//  大文件下载
//
//  Created by 李胜营 on 16/5/17.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/* filedata */
@property (strong, nonatomic) NSMutableData* fileData;
/* length */
@property (assign, nonatomic) NSInteger contentLength;
/* length */
@property (assign, nonatomic) NSInteger currentLength;
/* fileHandle */
@property (strong, nonatomic) NSFileHandle * fileHandle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  创建请求路径
     *  发送请求
     *  实现代理方法进行获取数据
     */
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_15.mp4"];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.contentLength = [response.allHeaderFields[@"Content-Length"] integerValue];
    
    self.fileData = [NSMutableData data];
    //获取沙盒路径 expandTilde 是否利用～代替/User/userName,no表示代替
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //文件保存到cache下的那个文件中。获取全路径
    NSString *file = [cache stringByAppendingString:@"minion_15.mp4"];
    //一接到响应体就创建对应的存储路径的文件夹
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    
    //创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:file];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //句柄写入文件位置。
    [self.fileHandle seekToEndOfFile];
    //写入数据
    [self.fileHandle writeData:data];
    //拼接总长
    self.currentLength += data.length;
    
    //计算进度
    CGFloat progress = 1.0 * self.currentLength / self.contentLength;
    
    self.progressView.progress = progress;
}
//finished 后存储数据到沙盒
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  
   

    
    //关闭句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    self.currentLength = 0;
    
}

@end
