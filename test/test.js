import { getFrontmostApp } from "../index.js"

setInterval(() => {
  console.log(getFrontmostApp())
}, 1000)
