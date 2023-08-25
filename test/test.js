import { getFrontmostApp } from "../index.js"

setInterval(() => {
  let frontmost = getFrontmostApp()

  console.log(`id: ${frontmost?.windowID}: ${frontmost?.localizedName} -> ${frontmost?.windowTitle}`)
}, 1000)
