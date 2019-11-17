+++
title = "Golang: File upload and download (Part 1)" 
description = ""
type = ["posts","post"]
comments = true
tags = [
    "go",
    "golang",
    "Development",
    "upload",
    "download",
]
date = "2019-11-17"
categories = [
    "Development",
    "golang",
]
series = ["golang"]
[ author ]
  name = "Silvio Giannini"
+++

## Golang: File upload and download
In Golang we can create a simple service to upload and download files without utilizing any external package.

**Web Services: the basics**

We can create a service with the net/http package, here an example of a simple "hello world" web service.

```go
package main

import (
    "fmt"
    "log"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "hello %s!", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```
The main function begins with a call to http.HandleFunc, which tells the http package to handle all requests to the web root ("/") with handler.
It then calls http.ListenAndServe, specifying that it should listen on port 8080 on any interface (":8080"). 

**Streaming Multipart Requests**

We can read a file in our service using the function MultipartReader that returns a MIME multipart reader if this is a multipart/form-data or a multipart/mixed POST request.

We will use this function instead of ParseMultipartForm to process the request body as a stream.


```go
func uploadHandler(w http.ResponseWriter, r *http.Request) {
	// grab the request.MultipartReader
    reader, err := r.MultipartReader()
    ...
}
```

Reader is an iterator over parts in a MIME multipart body. Reader's underlying parser consumes its input as needed.

A Part represents a single part in a multipart body. In our case we can iterate on the parts and save the uploaded file on the disk.


```go
func uploadHandler(w http.ResponseWriter, r *http.Request) {
    ...
    for {
        part, err := reader.NextPart()
        if err == io.EOF {
            break
        }
        // if part.FileName() is empty, skip this iteration.
        if part.FileName() == "" {
            continue
        }
        // create the destination file 
        dst, err := os.Create("./" + part.FileName())
        defer dst.Close()
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }

        // copy the part to dst
        if _, err := io.Copy(dst, part); err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }
    }
}
```

We can now configure our server to handle the request at the context "/upload" with the handler function the we have written above.

```go
package main

import (
    "log"
    "io"
    "os"
    "net/http"
)

func uploadHandler(w http.ResponseWriter, r *http.Request) {
    // grab the request.MultipartReader
    reader, err := r.MultipartReader()
    if err != nil {
    	http.Error(w, err.Error(), http.StatusInternalServerError)
	return
    }
    for {
        part, err := reader.NextPart()
        if err == io.EOF {
            break
        }
        // if part.FileName() is empty, skip this iteration.
        if part.FileName() == "" {
            continue
        }
        // create the destination file 
        dst, err := os.Create("./" + part.FileName())
        defer dst.Close()
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }

        // copy the part to dst
        if _, err := io.Copy(dst, part); err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }
    }
}

func main() {
    http.HandleFunc("/upload", uploadHandler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```
Now we can test the upload of a file with the following command:

```bash
curl -vvv -X POST http://127.0.0.1:8080/upload -H 'Content-Type: multipart/form-data' -F file=@/path/to/file.pdf
```

As result of the invocation we will find the uploaded file in the go program's folder.

In **part 2** we will see how to create the download files service.