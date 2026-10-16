const { total, applyDiscount } = require("../src/cart");

test("total", () => {
  expect(total([1.5, 2.25])).toBe(3.75);
});

test("discount", () => {
  expect(applyDiscount(200, 10)).toBe(180);
});

test("bad discount throws", () => {
  expect(() => applyDiscount(100, 150)).toThrow();
});
