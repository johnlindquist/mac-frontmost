#include <napi.h>
#include <ApplicationServices/ApplicationServices.h>
#include <AppKit/AppKit.h>

Napi::Value GetFrontmostApp(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
  NSDictionary* activeAppDict = [workspace activeApplication];
  NSRunningApplication *frontmostApplication = [NSRunningApplication runningApplicationWithProcessIdentifier:[[activeAppDict objectForKey:@"NSApplicationProcessIdentifier"] intValue]];

  Napi::Object result = Napi::Object::New(env);
  result.Set("localizedName", Napi::String::New(env, [frontmostApplication.localizedName UTF8String]));
  result.Set("bundleIdentifier", Napi::String::New(env, [frontmostApplication.bundleIdentifier UTF8String]));
  result.Set("bundleURLPath", Napi::String::New(env, [frontmostApplication.bundleURL.path UTF8String]));
  result.Set("executableURLPath", Napi::String::New(env, [frontmostApplication.executableURL.path UTF8String]));
  result.Set("isFinishedLaunching", Napi::Boolean::New(env, frontmostApplication.isFinishedLaunching));
  result.Set("processIdentifier", Napi::Number::New(env, frontmostApplication.processIdentifier));

  CFArrayRef windows;
  AXUIElementRef frontmostApp = AXUIElementCreateApplication(frontmostApplication.processIdentifier);
  AXError err = AXUIElementCopyAttributeValues(frontmostApp, kAXWindowsAttribute, 0, 100, &windows);
  if (err == kAXErrorSuccess && CFArrayGetCount(windows) > 0) {
    for (CFIndex i = 0; i < CFArrayGetCount(windows); i++) {
      AXUIElementRef window = (AXUIElementRef)CFArrayGetValueAtIndex(windows, i);
      CFStringRef windowTitle = NULL;
      err = AXUIElementCopyAttributeValue(window, kAXTitleAttribute, (CFTypeRef *)&windowTitle);
      if (err == kAXErrorSuccess && windowTitle != NULL) {
        result.Set("windowTitle", Napi::String::New(env, [(__bridge NSString *)windowTitle UTF8String]));
        result.Set("windowIndex", Napi::Number::New(env, i));
        CFRelease(windowTitle);
      }

      break;
    }
  } else {
    result.Set("windowTitle", Napi::String::New(env, ""));
    result.Set("windowIndex", Napi::Number::New(env, -1));
  }

  if (frontmostApp) CFRelease(frontmostApp);
  if (windows) CFRelease(windows);

  // ...

CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
for (CFIndex i = 0; i < CFArrayGetCount(windowList); i++) {
  CFDictionaryRef window = (CFDictionaryRef)CFArrayGetValueAtIndex(windowList, i);
  NSNumber *ownerPID = (NSNumber *)CFDictionaryGetValue(window, kCGWindowOwnerPID);
  if ([ownerPID intValue] == frontmostApplication.processIdentifier) {
    NSNumber *windowID = (NSNumber *)CFDictionaryGetValue(window, kCGWindowNumber);
    if (windowID != nullptr) {
      result.Set("windowID", Napi::Number::New(env, [windowID intValue]));
    }
    CGRect bounds;
    CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)CFDictionaryGetValue(window, kCGWindowBounds), &bounds);
    result.Set("x", Napi::Number::New(env, bounds.origin.x));
    result.Set("y", Napi::Number::New(env, bounds.origin.y));
    result.Set("width", Napi::Number::New(env, bounds.size.width));
    result.Set("height", Napi::Number::New(env, bounds.size.height));
    break;
  }
}

// ...


  CFRelease(windowList);

  return result;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "getFrontmostApp"), Napi::Function::New(env, GetFrontmostApp));
  return exports;
}

NODE_API_MODULE(addon, Init)
