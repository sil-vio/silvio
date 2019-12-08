+++
title = "Golang: File upload and download (Part 2)" 
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
date = "2019-11-24"
categories = [
    "Development",
    "golang",
]
series = ["golang"]
[ author ]
  name = "Silvio Giannini"
+++

## Golang: File download
In the [first part] ({{< ref "golang-upload-download-file-part1.md" >}}) we have written a golang program that receive a file and save to the disk. 

In this second part of the article we want to create a service that allows the user to download the previously uploaded files, to do this it is necessary to create a new endpoint which, based on the name of a requested file, returns its content.


**GET http://host:port/download?filename=test.txt**

We can configure our server to handle the new request at the context "/download" 

```go
http.HandleFunc("/download", downloadHandler)
```

The download's handler must be parse the query param and open the requested file.
If the param is not specified or the file don't exist we must return an error to the caller with the http code 400 (BadRequest).


```go
queryParam := r.URL.Query()
filename := queryParam.Get("filename")
if filename == "" {
    log.Printf("No filename specified")
    http.Error(w, "No filename specified", http.StatusBadRequest)
    return
}
// open the requested file
log.Println("File requested: ", filename)
file, err := os.Open("./" + filename)
if err != nil {
    log.Printf("can't find requested file: %v", err)
    http.Error(w, "can't find requested file", http.StatusBadRequest)
    return
}
```

In the response header we want to set the following header :

* **Content-Disposition**: in a regular HTTP response, the Content-Disposition response header is a header indicating if the content is expected to be displayed inline in the browser, that is, as a Web page or as part of a Web page. In our case is an attachment, that must be downloaded and saved locally. Most browsers will be presenting a 'Save as' dialog, prefilled with the value of the filename parameters if present.
* **Content-Type**: header tells the client what the content type of the returned content actually is.
* **Content-Length**: entity header indicates the size of the entity-body, in bytes, sent to the recipient.

For the header **content disposition** we can set the file name as follows
```go
contentDisposition := "attachment; filename=" + filename
w.Header().Set("Content-Disposition", contentDisposition)
```

For the **content type** we must discover the mimetype of the file, to do this we can use the external package "h2non/filetype".

```bash
go get github.com/h2non/filetype
```

The package "github.com/h2non/filetype" is a small and dependency free Go package to infer file and MIME type checking the magic numbers signature.
To check the mimetype only first 262 bytes representing the max file header is required, so we can just pass a slice.

```go
// To calculate the mimetype we only have to pass the file header = first 262 bytes
head := make([]byte, 261)
file.Read(head)
mimetype, err := filetype.Get(head)
if err != nil {
    log.Printf("Error in mimetype detection: %v", err)
    http.Error(w, "Error in mimetype detection", http.StatusBadRequest)
    return
}
// prepare to response, set the offset to zero for the next Read 
file.Seek(0,0)
```


For the **content length** we can use the function Stat of the os interface. 

```go
info, _ := file.Stat()
w.Header().Set("Content-Length", fmt.Sprintf("%d", info.Size()))
```

Now we can finnaly stream the file to the client

```go
//stream the body to the client without fully loading it into memory
io.Copy(w, file)
```

In the next part we will realize a simple gui to upload, list and download file.