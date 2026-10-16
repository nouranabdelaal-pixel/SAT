// Tiny demo linter: fails if any file in src/ uses `var`.
const fs = require("fs");
const path = require("path");
let problems = 0;
for (const name of fs.readdirSync("src")) {
  const lines = fs.readFileSync(path.join("src", name), "utf8").split("\n");
  lines.forEach((line, i) => {
    if (/\bvar\s/.test(line)) {
      console.log(`src/${name}:${i + 1}  no-var  use let or const instead of var`);
      problems++;
    }
  });
}
console.log(`${problems} problem(s)`);
process.exit(problems ? 1 : 0);
