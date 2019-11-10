+++
title = "Golang: how to set timeout with the context package"
description = ""
type = ["posts","post"]
comments = true
tags = [
    "go",
    "golang",
    "Development",
    "timeout",
    "context",
]
date = "2019-11-09"
categories = [
    "Development",
    "golang",
]
series = ["golang"]
[ author ]
  name = "Silvio Giannini"
+++

## Golang: how to set timeout with the package context 
The simplest way to define an execution timeout in golang is to utilize the package context.

As described in the official documentation "Package context defines the Context type, which carries deadlines, cancellation signals, and other request-scoped values across API boundaries and between processes"

**WithTimeout: the basics**

WithTimeout returns WithDeadline(parent, time.Now().Add(timeout)).

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // Pass a context with a timeout to tell a blocking function that it
    // should abandon its work after the timeout elapses.
    ctx, cancel := context.WithTimeout(context.Background(), 50*time.Millisecond)
    defer cancel()

    select {
    case <-time.After(1 * time.Second):
        fmt.Println("overslept")
    case <-ctx.Done():
        fmt.Println(ctx.Err()) // prints "context deadline exceeded"
    }
}
```

**Wrapping a function with no ctx parameter**

We can now wrap specific type of function (eg defining a type fn) to manage time out transparently

```go
package main

import (
	"context"
	"fmt"
	"time"
)


type fn func() string

func main() {

	ctx, cancel := context.WithTimeout(context.Background(), 500*time.Millisecond)
	defer cancel()
	
	wrapSlowFunction(ctx, slowFunction)

}

func wrapSlowFunction(ctx context.Context, f fn) {
	c := make(chan string, 1)
	defer close(c)

	go func() {
		res := f()
		c <- res
	}()

	select {
	case res := <-c:
		fmt.Println(res)
	case <-ctx.Done():
		fmt.Println(ctx.Err()) // prints "context deadline exceeded"
	}

}

func slowFunction() string {
	time.Sleep(1 * time.Second)
	return "execution end"
}
```