// Package cart has small shopping-cart helpers.
package cart

import "errors"

// Total returns the sum of prices in cents.
func Total(cents []int) int {
	sum := 0
	for _, c := range cents {
		sum += c
	}
	return sum
}

// ApplyDiscount returns the amount after a percent discount (0-100).
func ApplyDiscount(cents, percent int) (int, error) {
	if percent < 0 || percent > 100 {
		return 0, errors.New("percent must be 0-100")
	}
	return cents * (100 - percent) / 100, nil
}
