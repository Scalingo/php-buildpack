package main

import (
	"fmt"
	"log"
	"os"
	"time"
)

func main() {
	for true {
		fd, err := os.OpenFile(os.Args[1], os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0700)
		if err != nil {
			log.Fatal(err)
		}
		_, err = fmt.Fprintf(fd, "Logging %v\n", time.Now())
		if err != nil {
			log.Fatal(err)
		}
		err = fd.Close()
		if err != nil {
			log.Fatal(err)
		}
		time.Sleep(50 * time.Millisecond)
	}
}
