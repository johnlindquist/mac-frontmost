#include <napi.h>
#include <ApplicationServices/ApplicationServices.h>
#include <AppKit/AppKit.h>

Napi::Value GetFrontmostApp(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
  NSDictionary* activeAppDict = [[NSWorkspace sharedWorkspace] activeApplication];
  NSRunningApplication *frontmostApplication = [NSRunningApplication runningApplicationWithProcessIdentifier:[[activeAppDict objectForKey:@"NSApplicationProcessIdentifier"] intValue]];


  Napi::Object result = Napi::Object::New(env);
  result.Set("localizedName", Napi::String::New(env, [frontmostApplication.localizedName UTF8String]));
  result.Set("bundleIdentifier", Napi::String::New(env, [frontmostApplication.bundleIdentifier UTF8String]));
  result.Set("bundleURLPath", Napi::String::New(env, [frontmostApplication.bundleURL.path UTF8String]));
  result.Set("executableURLPath", Napi::String::New(env, [frontmostApplication.executableURL.path UTF8String]));
  result.Set("isFinishedLaunching", Napi::Boolean::New(env, frontmostApplication.isFinishedLaunching));
  result.Set("processIdentifier", Napi::Number::New(env, frontmostApplication.processIdentifier));

  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
  for (CFIndex i = 0; i < CFArrayGetCount(windowList); i++) {
    CFDictionaryRef window = (CFDictionaryRef)CFArrayGetValueAtIndex(windowList, i);
    NSNumber *ownerPID = (NSNumber *)CFDictionaryGetValue(window, kCGWindowOwnerPID);
    if ([ownerPID intValue] == frontmostApplication.processIdentifier) {
      CGRect bounds;
      CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)CFDictionaryGetValue(window, kCGWindowBounds), &bounds);
      result.Set("x", Napi::Number::New(env, bounds.origin.x));
      result.Set("y", Napi::Number::New(env, bounds.origin.y));
      result.Set("width", Napi::Number::New(env, bounds.size.width));
      result.Set("height", Napi::Number::New(env, bounds.size.height));

      // Getting the window name
      CFStringRef windowName = (CFStringRef)CFDictionaryGetValue(window, kCGWindowName);
      if (windowName != NULL) {
        result.Set("windowTitle", Napi::String::New(env, [(__bridge NSString *)windowName UTF8String]));
      }

      // You can add more window attributes here as needed
      break;
    }
  }

  CFRelease(windowList);

  return result;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "getFrontmostApp"), Napi::Function::New(env, GetFrontmostApp));
  return exports;
}

NODE_API_MODULE(addon, Init)
