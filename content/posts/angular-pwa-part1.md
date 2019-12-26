+++
title = "How to make a PWA in Angular (Part 1)" 
description = ""
type = ["posts","post"]
comments = true
tags = [
    "angular",
    "pwa",
    "Development",
    "service worker",
    "manifest",
]
date = "2019-12-21"
categories = [
    "Development",
    "golang",
]
series = ["angular"]
[ author ]
  name = "Silvio Giannini"
+++

## Progressive Web App
A Progressive Web App (PWA) is a web application that uses modern Web features to offer users an experience very similar to a native app.

Unlike traditional web apps, progressive web apps are a hybrid between regular web pages and mobile applications. The term "progressive" refers to the fact that initially they are perceived as normal websites but progressively behave more and more like mobile apps, among other things cross-platform.


The basic technical criteria for a site to be considered a Progressive Web App by the browser are:

* They are hosted in HTTPS;
* They can be loaded and executed even while the user's device is offline (even if it is only a page created for the purpose). To obtain this functionality, Progressive Web Apps require Service Workers;
* We have a reference Web App Manifest with at least four key properties: name, short_name, start_url, and display.
* Have an icon at least 144 × 144 pixels in png format.

## Manifest e Service Workers

The browser features that allow normal websites to become PWAs are the "manifest" and the "service workers".

### Manifest

It is a simple JSON file that defines the basic parameters of the PWA, to control how the app should look to the user and define its appearance at launch: icons, other basic features such as colors, fonts, screen orientation and possibility of being installed on the home screen.

### Service Workers

Technically, Service Workers provide a network proxy implemented as JavaScript script in the web browser to manage web / HTTP requests programmatically. Service workers are interposed between the network connection and the terminal providing the content. They are able to use cache mechanisms efficiently and allow error-free behavior during long periods of offline use.
Today, SWs already include features such as push notifications and background sync. The main function is the ability to intercept and manage network requests, including programmatic management of a response cache. It is an API that allows you to support offline experiences by giving developers complete control of the experience.

#### App Shell

For fast loading, service workers store the basic interface or "shell" of the web application in Responsive Web Design mode. This shell provides an initial static frame, layout or architecture in which content can be loaded both progressively and dynamically, allowing users to interact with the app despite the different levels of connection quality they have. Technically, the shell is a code that is stored locally in the mobile terminal browser cache.


## Angular & PWA

To create a PWA in Angular we must first create a normal web application. To do this we have to create a new project through the CLI provided by Angular.

To install the cli you can run the following command:

```bash
~$ npm install -g @angular/cli
```

Once installed you can check the version:

```bash
~$ ng version

     _                      _                 ____ _     ___
    / \   _ __   __ _ _   _| | __ _ _ __     / ___| |   |_ _|
   / △ \ | '_ \ / _` | | | | |/ _` | '__|   | |   | |    | |
  / ___ \| | | | (_| | |_| | | (_| | |      | |___| |___ | |
 /_/   \_\_| |_|\__, |\__,_|_|\__,_|_|       \____|_____|___|
                |___/
    

Angular CLI: 8.3.21
Node: 13.3.0
OS: linux x64
```

To create a new application, called my-pwa, you need to run the following command:

```bash
$ ng new my-pwa
```

During the creation process you will be asked whether to add the routing component (answer yes) and which stylesheet format we want to use in our project (answer scss).

Now we can move on to transforming our angular web app into a Progressive Web App.

### How to add a Service Worker

To add a service worker to the project you can use the angular CLI using the ng add @ angular / pwa command. The CLI will take care of enabling the application to use a service worker.


```bash
$ ng add @angular/pwa --project my-pwa
```

The command will perform the following actions:

* adds the @ angular / service-worker package to the project in package.json
* enable service worker support at build time in angular.json
* import and register the service worker in app.module.ts
* Update the index.html file:
    * include the ilnk to the manifest.json file
    * adds the meta theme-color tag
* Create a folder to place icons to support PWA installation
* Create the service worker configuration file ngsw-config.json


Since the ng serve command is not compatible with the sw it is not possible to test the functionality of a PWA in development mode, but it is necessary to start an external http server to test our PWA locally.

In order to test if the configuration was successful we must now build our application for the production profile:

```bash
$ ng build --prod
```


As a local server we will use http-server, given its ease of use.
To install it you need to run the following command:

```bash
$ npm install http-server -g
```

To make PWA available we can now run the following command:

```bash
$ http-server -p 8080 -c-1 dist/my-pwa
```

Once the server is started, at the url http://localhost:8080, we can access our application and, if everything went ok, we should see the "+" button for installation in the address bar of our browser.

{{< image src="/img/my-pwa.png" alt="our simple page" position="center" style="height:250px;">}}

As we can see from the image above, our web application is installable and available offline. All the files that the browser needs to use the applications are already in the cache, the ngsw-config.json file generated by the CLI in the previous steps contains the configuration of the cache policies and resources to be cached.

By default the cached resources are:

* index.html.
* favicon.ico.
* Build artifact (JS and CSS bundles).
* The files in the assets folder.
* Image and font in the build path (e.g. ./dist/my-pwa/)


In the second part of the guide we will optimize our's PWA.
