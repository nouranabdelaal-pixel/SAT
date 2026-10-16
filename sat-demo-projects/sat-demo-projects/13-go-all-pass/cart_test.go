package cart

import "testing"

func TestTotal(t *testing.T) {
	if got := Total([]int{150, 225}); got != 375 {
		t.Fatalf("Total = %d, want 375", got)
	}
}

func TestDiscount(t *testing.T) {
	got, err := ApplyDiscount(20000, 10)
	if err != nil || got != 18000 {
		t.Fatalf("ApplyDiscount = %d, %v; want 18000", got, err)
	}
}
