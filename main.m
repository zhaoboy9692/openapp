#include <stdio.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>

typedef int (*LaunchAppType)(CFStringRef, Boolean);

void printHelp() {
    printf("使用方法:\n");
    printf("  openapp <包名>\n");
    printf("参数:\n");
    printf(" openapp 要启动的应用程序的包名，例如 com.apple.springboard\n");
}

int main(int argc, char *argv[], char *envp[]) {
    // 检查命令行参数
    if (argc < 2) {
        printHelp();  // 输出帮助信息
        return 1;  // 使用 1 表示错误退出
    }

    @autoreleasepool {
        // 加载 SpringBoardServices 框架
        void *sbServices = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
        if (!sbServices) {
            printf("Failed to load SpringBoardServices: %s\n", dlerror());
            return -1;
        }

        // 获取 SBSLaunchApplicationWithIdentifier 函数的地址
        LaunchAppType openApp = (LaunchAppType)dlsym(sbServices, "SBSLaunchApplicationWithIdentifier");
        if (!openApp) {
            printf("Failed to find SBSLaunchApplicationWithIdentifier: %s\n", dlerror());
            dlclose(sbServices);
            return -1;
        }

        // 调用函数并处理返回值
        NSString *appIdentifier = [NSString stringWithUTF8String:argv[1]];
        CFStringRef cfAppIdentifier = (__bridge CFStringRef)appIdentifier;

        int result = openApp(cfAppIdentifier, false);
        if (result != 0) {
            printf("Failed to launch application, error code: %d\n", result);
        } else {
            printf("Application launched successfully.\n");
        }

        // 关闭库句柄
        dlclose(sbServices);
    }
    return 0;
}
