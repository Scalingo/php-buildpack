package main

/* This program is used to tail log files since.
 * This will read the a FIFO and forward logs in this FIFO to stdout/stderr
 * If you want to packge this file, use the `support/package_reader` file
 * (more informations on how to read them are available in `CONTRIBUTING.md`)
 */

import (
	"fmt"
	"io"
	"os"
	"time"
)

func printHelp() {
	fmt.Fprintf(os.Stderr, "Usage: %s FILE {stdout|stderr}\n", os.Args[0])
	os.Exit(-1)
}

func main() {
	if len(os.Args) != 3 {
		printHelp()
	}

	if os.Args[2] != "stdout" && os.Args[2] != "stderr" {
		printHelp()
	}

	filename := os.Args[1]
	outWriter := os.Stdout
	if os.Args[2] == "stderr" {
		outWriter = os.Stderr
	}

	for {
		file, err := os.Open(filename)
		if err != nil {
			fmt.Printf("Error while opening: %s\n", err.Error())
			time.Sleep(1 * time.Second)
			continue
		}
		tailFile(file, outWriter)
		file.Close()
	}

}

func tailFile(file *os.File, outWriter io.Writer) {
	for {
		_, err := io.Copy(outWriter, file)
		if err != nil {
			if err != io.EOF {
				fmt.Printf("Error while reading on : %s\n", err.Error())
				return
			}
		} else {
			// https://stackoverflow.com/questions/45443414/read-continuously-from-a-named-pipe
			time.Sleep(50 * time.Millisecond)
		}
	}
}
