+++
title = "Svelte: How to make a Web Components"
description = ""
type = ["posts","post"]
comments = true
tags = [
    "svelte",
    "javascript",
    "Development",
    "Web Components",
    "html",
]
date = "2020-01-04"
categories = [
    "Development",
    "svelte",
		"web Components"
]
series = ["svelte", "web Components"]
[ author ]
  name = "Silvio Giannini"
+++


In this article we will see how to create a web components using the Svelte framework.
Before we start writing the code, let's first see what a web components is.

## Intro to Web Components

Web components are a set of web platform APIs that allow you to create new custom, reusable and encapsulated HTML tags for use in web pages and web apps. Custom components and widgets are based on web component standards, work on modern browsers and they can be used with any HTML-compatible JavaScript library or framework.

Web components are based on four main specifications:

### Custom Elements

Custom elements provide a way to build own fully-featured DOM elements. By defining a custom element, authors can inform the parser how to properly construct an element and how elements of that class should react to changes. Custom elements contain their own semantics, behaviors, markup and can be shared across frameworks and browsers.

### Shadow DOM

The shadow DOM specification defines how to use encapsulated style and markup in web components. Being able to keep the markup structure, style, and behavior hidden and separate from other code on the page so that different parts do not clash.

### ES Modules

The ES Modules specification defines the inclusion and reuse of JS documents in a standards based, modular, performant way. The JavaScript specification defines a syntax for modules, as well as some host-agnostic parts of their processing model. The specification defines the rest of their processing model: how the module system is bootstrapped, via the script element with type attribute set to "module", and how modules are fetched, resolved, and executed

### HTML Template

The HTML template element specification defines how to declare fragments of markup that go unused at page load, but can be instantiated later on at runtime. 

Web Components technology can be used independently or collectively.

### How do I use a web component?

Using a web components is very simple. For example, it is possible to use the component present in the library of web components released from polymer, such as the following component:

https://www.webcomponents.org/element/@polymer/paper-button

Starting from a simple web page:

```html
<!doctype html>
<html>
  <head>
    <title>This is the title of the webpage!</title>
  </head>
  <body>
      <h1>Test Page</h1>
      <p>This is an example paragraph.</p>
  </body>
</html>
```

It's possible to import the script that contains the web components to start using the library component as if this were a simple html element.

```html
<html>
  <head>
    <title>This is the title of the webpage!</title>
    <script type="module" src="https://npm-demos.appspot.com/@polymer/paper-button@3.0.1/paper-button.js?@polymer/paper-button@3.0.1"></script>
  </head>
  <body>
      <h1>Test Page</h1>
      <p>This is an example paragraph.</p>
      <paper-button raised class="indigo">button</paper-button>
  </body>
</html>

```

## What is Svelte?

Svelte is a JavaScript framework written by Rich Harris. Svelte applications do not include framework references. 
Whereas traditional frameworks like React, Vue or Angular do the bulk of their work in the browser, Svelte shifts that work into a compile step that happens when you build your app.
Svelte generates code to manipulate the DOM, which may give better client run-time performance.

Instead of using techniques like virtual DOM diffing, Svelte writes code that surgically updates the DOM when the state of your app changes.

> The Svelte implementation of TodoMVC weighs 3.6kb zipped. For comparison, React plus ReactDOM without any app code weighs about 45kb zipped. It takes about 10x as long for the browser just to evaluate React as it does for Svelte to be up and running with an interactive TodoMVC.
> - Introducing Svelte: Frameworks without the framework

### How to make a simple svelte web applications

To create a new svelte project we can start from the official template https://github.com/sveltejs/template. 

To create a new project in the my-svelte-project directory, install its dependencies, and start a server you can type the following commands:

```bash
npx degit sveltejs/template my-svelte-project
cd my-svelte-project
npm install
npm run dev
```

By accessing the url http://localhost:5000 you will see the hello-world web app.

For this example we will create a clock component, you can copy the content of the file app.svelte from this link: https://svelte.dev/examples#clock.

### Compiling to a custom elements (aka web components)

Svelte components can also be compiled to custom elements (aka web components) using the customElement: true compiler option. You should specify a tag name for the component using the <svelte:options> element.

```html
<svelte:options tag="my-element">
```	

By default custom elements are compiled with accessors: true, which means that any props are exposed as properties of the DOM element. To prevent this, add accessors={false} to <svelte:options>.

To build to custom element we must:

* add customElement: true, to the rollup.config.js file:
```javascript
	plugins: [
		svelte({
			customElement: true,
``` 
* add <svelte:options tag="svelte-clock"> in App.svelte. In case you not define this svelte:option the compiler will warning you with the following message
```bash
svelte plugin: No custom element 'tag' option was specified. To automatically register a custom element, specify a name with a hyphen in it, e.g. <svelte:options tag="my-thing"/>. To hide this warning, use <svelte:options tag={null}/
```
* run "npm run build"


During development (npm run dev), live reloading will be enabled. This means that any changes made to your custom-element or the HTML will be immediately reflected in the browser.

Once the web components is ready we can run “npm run build” which will compile a minified, production-ready version of your custom element in the public/bundle.js file.
The compiler will take care of creating the Shadow DOM, applying attributes/properties, and defining your custom element.

To test the web components created we can utilize the http-server.
To install we can execute the following command:

```bash
npm install http-server -g
```

Then we can create in the public directory the index.html, importing the bundle.js and declaring the custom element “svelte-clock”:

```html
<!doctype html>
<html>
  <head>
    <title>This is the title of the webpage!</title>
    <script src="bundle.js"></script>
  </head>
  <body>
      <h1>Test Page</h1>
      <p>This is an example paragraph.</p>
      <svelte-clock/>
  </body>
</html>
```

Executing the following command we can see the components in action:

```bash
> http-server -p 8080 -c-1 public/
Starting up http-server, serving public/
Available on:
  http://127.0.0.1:8080
```

### Svelte Web Components Features

#### Properties

Any props that your custom element accepts will automatically be transformed to element attributes at compile time. It is recommended to stick with lowercase attribute names as naming conventions like camelCase or PascalCase will not work in HTML.

To test we can add a simple properties to the custom element.

```html
<script>
	...
 	export let clocktitle = "Svelte Clock"
	...
</script>
...
<h1>{clocktitle}</h1>
...
```

In our index.html we can now set the value

```html
<svelte-clock clocktitle="My Clock"></svelte-clock>
```

#### Events

Custom events emitted from within a Svelte 3 wrapped as a web-component do not bubble up to the web-component itself as normal DOM events (the custom event by default does not go past the boundaries of the shadowDom) and can not be handled in the usual manner within the template.

```html
<svelte-clock custom-event="handler()">    
```

Link to the issue https://github.com/sveltejs/svelte/issues/3119.
To make it cross the boundaries of shadowDom we have to create a Custom Event as mentioned in the v2 docs for svelte. Custom events can be created in your Svelte component using the CustomEvent api. After defining a custom event, you can dispatch that event by calling this.dispatchEvent(event) in response to changes in your component.
Custom events cannot be dispatched in response to lifecycle methods. For instance, if you try to dispatch a custom event in your onMount lifecycle method, your event will not be dispatched.

To add a events we can add a button:

```html
<button on:click="{dispatchSavedDateEvent}">Save Date</button>
```

when is clicked we can emit a custom event:

```javascript
function dispatchSavedDateEvent(e) {
   console.log("[dispatchSecondIsElapsedEvent] time: ", time);
   // 1. Create the custom event.
   const event = new CustomEvent("savedData", {
     detail: time,
     bubbles: true,
     cancelable: true,
     composed: true // makes the event jump shadow DOM boundary
   });
 
   // 2. Dispatch the custom event.
   this.dispatchEvent(event);
 }
```

The read-only composed property of the Event interface returns a Boolean which indicates whether or not the event will propagate across the shadow DOM boundary into the standard DOM.

An alternative method is to utilize createEventDispatcher

```javascript
import { createEventDispatcher } from 'svelte'; 
const dispatch = createEventDispatcher();
...
dispatch('second', {
       text: '10 seconds elapsed!'
     });
...
```
In the index.html we must subscribe to the new event in the following way:
```javascript
document.querySelector('svelte-clock')
	.$on('second', (e) => { console.log("[index.html][second]", e)})
```

#### Imports

To import Svelte components we must declare each nested elements with the <svelte:option tag="my-nested-element”>  tag. Declaring child components as custom elements, these elements are also available to the consumer.
The nested element use the same Shadow DOM as the parent, there is no way to set the Shadow DOM mode to "closed" for the nested element.


## Conclusion
The main advantage in using Svelte.js for creating web components is that the final component has very small dimensions. In our small example the web component packaged in the bundle.js weighs only 7170 bytes, dimensions that if compared with web components created by other frameworks make our web components tens of times smaller and faster to be executed by the browser.




