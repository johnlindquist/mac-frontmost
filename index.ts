import bindings from "bindings"
const addon = bindings("mac-frontmost.node")

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

export type FrontmostApp = {
  localizedName: string
  bundleIdentifier: string
  bundleURLPath: string
  executableURLPath: string
  isFinishedLaunching: boolean
  processIdentifier: number
  x: number
  y: number
  width: number
  height: number
}

export const getFrontmostApp = (): FrontmostApp => {
  return addon.getFrontmostApp()
}
