# streaming-scuttlebutttttt

The best project ever.

## Chalice - The Holy Grail

#### Quick Start:
You need `node` installed first. After that you can run:
```
  npm install -g grunt-cli
  npm install
  grunt
  open http://localhost:3000
```

---

### What is the holy grail of web development?
I'm sure everyone has a different view but heres mine:

- Share code across the client/server seamlessly
- Boot application on the server to generate the html
- Boot application on client to progressively enhance
- Dont block the critical rendering path to [break the 1s time to glass barrier](http://www.igvita.com/slides/2013/breaking-1s-mobile-barrier.pdf)
- Snappy [Jank Free](http://www.jankfree.com/) Applications
- 100/100 page speed

And for development:

- CoffeeScript + SourceMap debugging
- `commonJS` modules and  `npm` for package management
- Rebuild on file change (selectively rebuild js or css when source files change)
- `live-reload` out of the box
- All `node.js` tool chain
- Not implemented yet: [Stylus Source Maps](https://github.com/LearnBoost/stylus/pull/886)

for debugging in chrome dev tools.

---

### Thin Libraries
This documentation site and the libraries (backbone + chalice + handlebars + zepto) are only 29kb gzip/compressed.
![thin-libraries](http://f.cl.ly/items/0Q292M0K1x153N2a2M2B/Screen%20Shot%202013-04-02%20at%2011.27.18%20PM.png)

### String Concatenation and Dom Creation Speed
Dom creation libraries are getting [faster](http://jsperf.com/dom-creation-libs). But the clear winner is still concatenating strings. This also makes it easier to work with views on the server.


### Don't block rendering path and Progressive Enhancement Speed Gains
By having the markup served on the server and loading javascript asynchronously you take it out of the critical
rendering path, this gives you 5x faster perceived loading time. From [the twitter
blog](http://engineering.twitter.com/2012/05/improving-performance-on-twittercom.html)
> There are a variety of options for improving the performance of our JavaScript, but we wanted to do even better. We took the execution of JavaScript completely out of our render path. By rendering our page content on the server and deferring all JavaScript execution until well after that content has been rendered, we've dropped the time to first Tweet to one-fifth of what it was.

### The Approach
I'm pretty opinionated with my CommonJS dependencies here but it just makes sense
if the end goal is to get Backbone running on the server. My approach is
to provide a thin layer on top of Backbone that allows it to run fast
and seamless inside `node.js`. The templates are [handlebars]() and the
language is [coffeescript](). This approach differs from [rendr]() in
that I'm not rewriting the routing layer. Simply overwriting
`Backbone.Router::route` to make an express route and call the same
route on the server. Something like:

        Backbone.Router::route = (route, name) ->
          app.get '/' + route, (req, res) =>
            @[name] _.values(req.params)

This leaves the `MV*` implementation up to the developer.
The [backbone docs](http://backbonejs.org) say it best:
>References between Models and Views can be handled several ways. Some people like to have direct pointers, where views correspond 1:1 with models (model.view and view.model). Others prefer to have intermediate "controller" objects that orchestrate the creation and organization of views into a hierarchy. Others still prefer the evented approach, and always fire events instead of calling methods directly. All of these styles work well.


### How The View Works
The `View` overrides `_ensureElement` to try to first get the element
out of the DOM.  Calling super wont create anything if `@el` is defined but when
it isn't it will create the element using jQuery. This method does nothing on
the server.

        _ensureElement: ->
          if Backbone.$?
            @el = @getElFromDom()
            super

When calling render on the view, on the server it will return a wrapped
string, and on the client side it will return `this` as usual.

        render: ->
          unless @$el?.html @toHTML(no)
            return @toHTML(yes)
          @afterRender()
          this

##### Usage:

        View = require 'chalice-view'
        view = new View
        # client side
        view.render()
        => view object
        # server side
        view.render()
        => '<div class=\'view\' data-cid=\'view1\' ></div>'


## Styles
[semantic.gs](http://semantic.gs) is used as well as media queries to
get some pretty nice syntax for layout:

    // device media queries
    tablet = "(min-width: 768px) and (max-width: 979px)"
    phone = "(max-width: 767px)"


    // layout
    .navbar-view
      row()
      nav > a
        column(2)
        @media phone
          column(12)

---

## The Grunt Build System
Grunt is becoming a popular build tool, and for good reason. If you
haven't seen grunt before, check the [getting started guide](). Running
`grunt` out of the box will give you a dev server on `localhost:3000`
that will selectively rebuild and livereload in the browser when `.coffee` or
`.styl` files change.

- `grunt` - Alias for "default" task
- `grunt default` - Alias for "clean", "stylus:dev", "browserify2:dev", "express:app", "livereload-start", "regarde" tasks.
- `grunt build` - Alias for "clean", "stylus:build", "browserify2:build".
- `grunt serve` - Alias for "express:app", "express-keepalive" tasks.
- `grunt clean` - Clean files and folders.
- `grunt devtools` - A GUI For grunt in chrome devtools

![grunt-devtools](http://cloud.shanejon.as/image/3s0l2X3J0I1f/Screen%20Shot%202013-03-31%20at%2011.00.08%20PM.png)

### Generators
You can use the following grunt tasks to generate new views/models/routers:
- `grunt generate:view --name=MyView`
- `grunt generate:model --name=MyModel`
- `grunt generate:router --name=MyRouter`
- `grunt delete:view --name=MyView`
- `grunt delete:model --name=MyModel`
- `grunt delete:router --name=MyRouter`

Sample output:
```
$ grunt generate:router --name=MyRouter
Running "generate:router" (generate) task
File written to: ./src/routers/myrouter.coffee
File written to: ./test/routers/myrouter.coffee

Done, without errors.

$ grunt delete:router --name=MyRouter
Running "delete:router" (delete) task
File deleted: ./src/routers/myrouter.coffee
File deleted: ./test/routers/myrouter.coffee

Done, without errors.
```

You can get a list of all the tasks by running `grunt --help`.

---

### Parts of the Library
The libraries live on `npm` and [github](http://github.com/shanejonas).

- [View](https://github.com/shanejonas/chalice-view)
- [CompositeView](https://github.com/shanejonas/chalice-compositeview)
- [Client](https://github.com/shanejonas/chalice-client)
- [Server](https://github.com/shanejonas/chalice-server)

---

#### Examples Applications:
- [Blog Example](https://github.com/shanejonas/chalice-blog)
- [Documentation Site](https://github.com/shanejonas/chalice-docs)

