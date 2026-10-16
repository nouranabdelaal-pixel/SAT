const test = require("node:test");
const assert = require("node:assert");
const { add } = require("../src/app.js");

test("add works", () => {
  // Pretend secret in the output: the report must show API_KEY=***
  console.log("connecting with API_KEY=sk-demo-123456");
  assert.strictEqual(add(2, 3), 5);
});
