// index.ts
import bindings from "bindings";
var addon = bindings("mac-frontmost.node");
var getFrontmostApp = () => {
  return addon.getFrontmostApp();
};
export {
  getFrontmostApp
};
