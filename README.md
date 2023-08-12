# @johnlindquist/mac-frontmost

Get the frontmost application on macOS

```js
import { getFrontmostApp } from "@johnlindquist/mac-frontmost"

console.log(getFrontmostApp())
```

```js
/* Example return type:
{
  localizedName: 'iTerm2',
  bundleIdentifier: 'com.googlecode.iterm2',
  bundleURLPath: '/Applications/iTerm.app',
  executableURLPath: '/Applications/iTerm.app/Contents/MacOS/iTerm2',
  isFinishedLaunching: true,
  processIdentifier: 92918,
  x: 45,
  y: 72,
  width: 885,
  height: 849
}
*/
```
