# Succinctness is Power

[Paul Graham](http://www.paulgraham.com/power.html)


## It's not about succinct programs …

    with(m=Math)C=cos,S=sin,P=pow;O=a.getImageData(0,0,c.height=f=W=256,f);U=O.data;D={};F=[];function J(p){p[5]=Q=0;for(j=3;j--;)if(!D[Q=(p[j]>>=2)+Q*f])D[Q]=F.push(p)}setInterval(function(){for(i=1e3;i--;){c=i%42*1.35;H=T;T=m.random();A=H*2-1;B=T*2-1;J([S(H*7)*(o=13+5/(.2+P(T*4,4)))-T*50,T*550+500,(l=C(H*7))*o,(G=l/7+.5)-T/4,G]);

    // etc, etc!


## … although they can have beautiful output

![js1k submission by @romancortes](media/js1k-rose.png)

[http://js1k.com/2012-love/demo/1100](http://js1k.com/2012-love/demo/1100)


## It's about _expressive quality_

![The Mandelbrot Set](media/mandelbrot-formula.png)

![Mandelbrot Visualization](media/mandelbrot-visual.gif)


## A Thought Experiment

> CoffeeScript is a simple thought experiment to imagine a language that exposes a minimal syntax for the beautiful object model that underlies JavaScript.

– Jeremy Ashkenas, creator of CoffeeScript


## A little language that compiles to JavaScript

* December 2009 – [Initial commit](https://github.com/jashkenas/coffee-script/commit/8e9d637985d2dc9b44922076ad54ffef7fa8e9c2) of the mystery language
* December 2010 – Version 1.0
* April 2011 – CoffeeScript is the default in Rails 3.1
* 2012 – CoffeeScript is the [#12 most popular language on Github](https://github.com/languages/CoffeeScript)


## Goals

1. Have a lighter syntax
2. Clean up the semantics of broken JavaScript constructs
3. Provide bonus language features for common JavaScript patterns
4. The best from JavaScript, Ruby, Python, Haskell, Groovy, YAML, etc.


## It's Just Plain JavaScript

* All JS Platforms – back to IE6
* What you'd write by hand – or better
* It's a thin layer – experiments are possible, no committee
  * [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/), a fork
  * CSS Preprocessors like [Sass](http://sass-lang.com/) or [Less](http://lesscss.org/)
* It's available … today!


# Let's Code!


## No `var`, no problem

No global variables by accident

    a = 2
    b = 3
    log(a * b)


## No `var`, no problem

    :::javascript
    // i is a global now!
    for (i = 0; i < arr.length; i++) {
      var a = 3;
    }

## Module Pattern For Free
    
    :::javascript
    (function() {
      var a, b;
      a = 2;
      b = 3;
      log(a * b);
    }).call(this); // e.g. `window`

(use `-b` command line argument to prevent wrapping)


## No Semicolons

No problems with automatic semicolon insertion.

## No Semicolons

No problems with automatic semicolon insertion.

But they're useful for one-liners, if you must:

    a = 1; b = 3; c = a + b


## Hello World

    sayHello = (name) ->
      return "Hello, " + name

    #- return
    #- whitespace
    #- parens
    #- strings


## Significant Whitespace

    fn1 = ->
    "Hello"

    # versus

    fn2 = ->
      "Hello"


## Implicit Parentheses

    say = (message) -> log message

    say "Hi!"
    say "Bye"


## Default Arguments

    pow = (x, p = 2) -> Math.pow x, p

    pow 3
    pow 3, 3


## Functions are easy

* Create smaller functions instead of nesting hell
* Create smaller functions instead of lots of parentheses


## Equality in Javascript

    :::javascript
    '' == '0' // false
    0  == ''  // true
    0  == '0' // true

CoffeeScript has strict equality:
    
    0  is '0' # false
    0  == '0' # false


# Objects & Arrays


## Objects

    singers = {Ella: "Rhythm", Etta: "Blues"}


## Objects

    throwSnowBalls = -> # Use physics

    throwSnowBalls 3, at: "Calvin", allAtOnce: true


## Objects

    kids =
      brother:
        name: "Calvin"
        age:  6
      tiger:
        name: "Hobbes"
        age:  7

    #- multi-line


## Objects

    cop     = "Starsky"
    partner = "Hutch"
    duo     = {cop, partner}


## Arrays

    song = ["do", "re", "mi", "fa", "so"]

    bitlist = [
      1, 0, 1
      0, 0, 1
      1, 1, 0
    ]


## Ranges

    [1..5]  # [1, 2, 3, 4, 5] (inclusive)
    [1...5] # [1, 2, 3, 4]    (exclusive)

    [5..1]  # [5, 4, 3, 2, 1]


## Slices

    ['a', 'b', 'c', 'd'][0...3] # ['a', 'b', 'c']
    ['a', 'b', 'c', 'd'][1..]   # ['b', 'c', 'd']
    "Mr. Tureaud"[..4]          # Mr. T

## Clone an array

    arr = ['a', 'b', 'c', 'd']
    copyOfArr = arr[0..]


# Number Crunching


## Iteration: `of` and `in`

    chairs = office: 'Chair', home: 'Chaise Longue'
    
    # Objects
    for key, value of chairs
      log "I have a #{value} at #{key}"

---

    # Arrays
    for value in [1,2,3]
      log value


## Iterate only `own` properties
    
    # Object has an extension
    Object.prototype.niceExtension = -> # do stuff


## Iterate only `own` properties
    
    # Object has an extension
    Object.prototype.niceExtension = -> # do stuff

    chairs = office: 'Chair', home: 'Chaise Longue'

    for own key, value of chairs
      log "I have a #{value} at #{key}"


## Iterate with `by`

    for person in people by 10
      encourage person


## Iteration with `when`

    for id, employee of employees when employee.age > 50
      payMoreSalary employee


## Includes?

    fruits = ['apple', 'cherry', 'tomato']
    'tomato' in fruits               # true

---

    germanToEnglish = ja: 'yes', nein: 'no'
    'ja' of germanToEnglish          # true
    'vielleicht' of germanToEnglish  # false

    #- Includes IE fallback


## Iteration Context

    for x in [1, 2]
      setTimeout (-> log x), 50

    #- We need to use `do`


## Comprehensions

Everything is an expression:

    even = (num for num in [0..10] when num % 2 is 0)

---

    negative = (-num for num in [1, 2, 3, 4])


## Comprehensions

    # Make small functions
    isEven = (num) -> num % 2 is 0
    even = (num for num in [0..10] when isEven num)


## Conditionals

    if age > 18
      driveCar()
    else
      rideBike()

## Conditionals
    
    if age > 18 then driveCar() else rideBike()

---
    
    driveCar() if age > 18
    askForPermission() unless age > 20


## Conditionals Are Expressions Too

    lunch = if friday then 'Risotto' else 'Pasta'

---
    #- defaults = {}
    options or= defaults


## Chained Comparisons

    healthy = 200 > cholesterol > 60


## Existential Operator `?`

    test = (a) -> log "OK: #{a}" if a?
    #- Try this with `if a` instead, it'll give unexpected results

    test "Hello"
    test 0
    test false


## Existential Operator

    speed ?= 75

---

    footprints = yeti ? "bear"


## Soaks

    name = person?.name ? 'Anonymous'

---

    cats?['Garfield']?.eat?() if lasagna?


## Switch

    loudness = 0
    switch artist
      when 'Patti'
        loudness = 100
      when 'Neil'
        loudness = 90


## Switch

* No errors because of forgotten `break`
* Result is returned


## Switch

    loudness = switch artist
      when 'Patti' then 100
      when 'Neil'  then 90


## Switch

    loudness = switch artist
      when 'Patti', 'Neil' then 100
      when 'Britney' then 0
      else 50


## Splats

    artists = (favorite, others...) ->
      log "My favorite artist: #{favorite}"
      log "I also like #{others.join(", ")}"

    artists 'Patti', 'Neil', 'Jimi', 'Miles'


## Splats

    itinerary = (beginning, middle..., end) ->
      log "From: #{beginning}"
      log "Via:  #{middle.join(", ")}" if middle.length
      log "To:   #{end}"

    itinerary("Zürich", "Paris")
    # itinerary("Zürich", "Genève", "Lyon", "Marseille")


## Destructuring Assignments

    [x, y] = circle.getCenter()

    circle.setCenter x + speedX, y + speedY


## Swapping

    [newBoss, oldBoss] = [oldBoss, newBoss]


## Destructuring Assignments

    birds = ['duck', 'duck', 'duck', 'duck', 'goose']
    [ducks..., goose] = birds

## Destructuring Assignments

    arr = [1,2,3]
    log arr, 4
    log arr..., 4


## Destructuring Objects

    sprite = x: 100, y: 200

    {x: spriteX, y: spriteY} = sprite

    log spriteX, spriteY


## Destructuring Objects

    sprite = x: 100, y: 200

    {x, y} = sprite
    log x, y

## Destructuring Objects
    
    resume =
      name: "Peter Gassner"
      lang: ["German", "English", "French", "Italian"]

    {name, lang: [motherTongue, others...]} = resume

    #- log "#{name}s mother tongue is #{motherTongue}"
    #- log "He speaks #{others.length} other languages"


## heredoc

    book = "A long book
    with quite some text
    over several lines."


## heredoc

    """
    <ul class="a">
      <li>1</li>
      <li>2</li>
    </ul>
    """


## herecomment

    ###
         _[_]_
          (")
      `--( : )--'
        (  :  )
      ""`-...-'""
    ###


## heregex

    OPERATOR = /// ^ (
      ?: [-=]>             # function
       | [-+*/%<>&|^!?=]=  # compound assign / compare
       | >>>=?             # zero-fill right shift
       | ([-+:])\1         # doubles
       | ([&|<>])\2=?      # logic / shift
       | \?\.              # soak access
       | \.{2,3}           # range or splat
    ) ///


# Classes

### Classes, The Prototype Way

    class Animal
      constructor: (name) ->
        this.name = name


### Classes, The Prototype Way

    class Animal
      constructor: (name) ->
        @name = name


### Classes, The Prototype Way

    class Animal
      constructor: (@name) ->


### Classes, The Prototype Way

    class Animal
      constructor: (@name) ->
      move: (meters) ->
        log "#{@name} moved #{meters}m."


### Classes, The Prototype Way

    class Animal
      constructor: (@name) ->
      move: (meters) ->
        log "#{@name} moved #{meters}m."

    class Snake extends Animal
      move: ->
        log "Slithering..."
        super 5

    #- snake = new Snake "Sammy the Python"
    #- snake.move()


## `::` Is For Prototype Lovers

    class Animal
      constructor(@name) ->

    Animal::move ->
    Animal::eat ->
    Animal::sleep ->


## `->`

    Account = (@customer, @cart) ->
      $('.shopping_cart').bind 'click', (event) ->
        # Won't work!
        @customer.purchase @cart

## `=>`

    Account = (@customer, @cart) ->
      $('.shopping_cart').bind 'click', (event) =>
        # Correct `this`!
        @customer.purchase @cart


# Slippery Surface


## Understanding parentheses:

    myFunc(x) ->

is not the same as

    myFunc (x) ->


## Syntax Errors

Correct syntax, wrong result

    squares = n * n for n in [1,2,3]


## Syntax Errors

Correct syntax, wrong result

    squares = n * n for n in [1,2,3]

Compiles to:

    (squares = n * n) for n in names


## Debugging

* Compile errors: easy, it will tell you!
* Logic errors: PITA
  * Debugger shows error in compiled source only…
  * Solution on the horizon: [SourceMaps](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/)


## Hoisting

JavaScript grabs all functions and puts them at the beginning of the code

    :::javascript
    sin(1);
    function sin(x) {
      return Math.sin(x);
    }


## Hoisting

JavaScript grabs all functions and puts them at the beginning of the code

    :::javascript
    function sin(x) {
      return Math.sin(x);
    }
    sin(1);


## Hoisting

CoffeeScript always uses function assignment by `var`
    
    :::javascript
    var sin;
    sin(1);  // sin has not been defined yet!
    sin = function(x) {
      return Math.sin(x);
    }


## Hoisting
    
    sin = (x) -> Math.sin x
    sin(1)


## Omitting Parentheses

In Ruby this is the same:
    
    :::ruby
    def greet
      puts "Hi!"
    end

    greet   # "Hi!"
    greet() # "Hi!"


## Omitting Parentheses

In CoffeeScript, it means something else:

    greet = -> log "Hi!"
    greet   # [Function]
    greet() # "Hi!"


## Mixed Up Parentheses

    log Math.round 3.1, Math.round 5.2


## `unless`

Is powerful, but also confusing. Use it wisely!

    unless age > 18
      # do what?
    else
      # hmm?



## `unless`

    if age > 18
      # drive car
    else
      # ride bike

---

    greet(person) unless olderThan(person)


## Unchangeable Language Features

`parseInt` without radix means trouble:

    :::javascript
    parseInt("09");     // 0
    parseInt("09", 10); // 9


## Unchangeable Language Features

`parseInt` without radix means trouble:

    :::javascript
    parseInt("09");     // 0
    parseInt("09", 10); // 9

Long [discussion](https://github.com/jashkenas/coffee-script/issues/385) short:
    
    toInt = parseInt
    toInt "09"          #  No way to catch this!


## Dirty Secrets

Run any `jscode` with backticks:

    hi = `function() {
      return [document.title, "Hello JavaScript"].join(": ");
    }`


## Have Some Style

* http://arcturo.github.com/library/coffeescript/04_idioms.html
* https://github.com/polarmobile/coffeescript-style-guide
* https://github.com/styleguide/ruby
* http://www.python.org/dev/peps/pep-0008/


# Under The Hood

![](media/delorean-engine.jpg)


## Demo

    # Grammar
    "und"           return '+'
    "mal"           return '*'

    # Precedence
    %left '+' '-'
    %left '*' '/'


## Demo

    # Actions
    e '+' e
      {$$ = $1+$3;}
    e '*' e
      {$$ = $1*$3;}


## Demo

[Jison](http://zaach.github.com/jison) Demo


## Why This Demo?

* Hijacking JavaScript
* JS is a powerful platform that can be extended with your ideas!
* JS is ubiquitous
* Experiments influence future specs


## Performance

![http://iq12.com/blog/as3-benchmark/](media/v8-score.png)


## Languages That Compile To JavaScript

[altJS.org](http://altjs.org/)

* [Coco](https://github.com/satyr/coco)
* [Kaffeine](http://weepy.github.com/kaffeine)
* GWT
* HotRuby
* Pyjamas
* …


# Wrapping Up

## How To Get Started

* Try it on [CoffeeScript.org](http://coffeescript.org/)
* [CoffeeScript.js](https://github.com/jashkenas/coffee-script/blob/master/extras/coffee-script.js) to use scripts directly in browser
* [Node.js](http://nodejs.org): `npm install -g coffee-script`


## Use it in your own projects

As a command-line script

    #!/usr/bin/env coffee
    fs = require 'fs' # Look, an ordinary JS-Library!

    fs.readdir '.', (err, files) ->
      throw err if err
      copyFiles files


## Use it in your own projects

As a command-line script

On the front-end, the back-end or the [whole stack](http://towerjs.org/)!

As a [drum machine](http://www.youtube.com/watch?feature=player_embedded&v=qWKkEaKL6DQ)!


## Read More

* [Javascript Weekly](http://javascriptweekly.com/) newsletter
* [CoffeeScript: Accelerated JavaScript Development](http://pragprog.com/book/tbcoffee/coffeescript) – a must read!
* [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/) is a brief 5-chapter introduction
* [Smooth CoffeeScript](http://autotelicum.github.com/Smooth-CoffeeScript/) is a reimagination of Eloquent JavaScript
* [Meet CoffeeScript](https://peepcode.com/products/coffeescript) is a 75-minute long screencast by PeepCode.


# Discuss!