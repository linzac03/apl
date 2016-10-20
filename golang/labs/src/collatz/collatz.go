package collatz

import (
	"fmt"
)

func Collatz() {
	var in int
	seq := make([]int, 0)
	fmt.Println("\nEnter a number")
	fmt.Scanf("%d", &in)
	for in > 1 {
		seq = append(seq, in)
		if in%2 == 0 {
			in = in / 2
		} else {
			in = 3*in + 1
		}
	}
	seq = append(seq, in)
	fmt.Println("Collatz Sequence:", seq)
}
