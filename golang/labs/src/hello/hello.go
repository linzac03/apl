package main

import (
	"collatz"
	"fmt"
	"stringutil"
)

func main() {
	fmt.Printf(stringutil.Reverse("\nHello, world.\n"))
	collatz.Collatz()
}
