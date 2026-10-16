// @ts-check

/**
 * Sum of prices, rounded to cents.
 * @param {number[]} prices
 * @returns {number}
 */
function total(prices) {
  return Math.round(prices.reduce((a, b) => a + b, 0) * 100) / 100;
}

/**
 * Amount after a percent discount (0-100).
 * @param {number} amount
 * @param {number} percent
 * @returns {number}
 */
function applyDiscount(amount, percent) {
  if (percent < 0 || percent > 100) {
    throw new Error("percent must be between 0 and 100");
  }
  return Math.round(amount * (100 - percent)) / 100;
}

/** @type {number} */
const shippingCost = "free"; // type error: a string is not a number

module.exports = { total, applyDiscount };
