## Ramp up with the WRAP Stack!
### `react-native-`[`W`](https://github.com/necolas/react-native-web)`eb` + Relay + Absinthe + PostgreSQL
#### (+ Jest + [Brunch](http://brunch.io/))
At a bare minimum, I'd go through:
1. [Learn Elixir](https://elixir-lang.org/getting-started/introduction.html) (**free!**)
2. [Learn Phoenix](https://pragprog.com/book/phoenix/programming-phoenix) (**$23**, Kindle-compatible)
3. [Learn Absinthe](https://pragprog.com/book/wwgraphql/craft-graphql-apis-in-elixir-with-absinthe) (**$18**, w/ 30% discount code in the back of any PragProg book)
4. [WRAP Stack Walkthrough](https://medium.com/@english3000.org/starting-a-new-project-with-absinthe-relay-be9a127b8f63) (**free**; how to put all of these technologies--[react-native-Web](https://github.com/necolas/react-native-web/blob/master/website/guides/getting-started.md), Relay, Absinthe, & Postgres--together for your first project with this stack)
5. [Learn Relay](https://www.howtographql.com/react-relay/0-introduction/) (**free**; skip Step 5--use Ch. 8 of *Learn Absinthe* instead)

### _Why WRAP?_
1. **performance _(backend)_:** Absinthe is ~10x faster than NodeJS, Python, Ruby, and (probably even more for) PHP because it can use multiple cores concurrently
2. **performance _(API)_:** GraphQL (Relay + Absinthe) allows for more efficient communication between your frontend and backend than REST
3. **productivity _(backend)_:** Absinthe is built on top of Phoenix, Elixir's main framework, which provides a Rails-like developer experience for the backend
4. **productivity _(frontend)_:** `react-native-web` will save you time with cross-platform apps and make it easier to reason about your component hierarchy; Relay allows you to put your API with its component--a dramatic timesaver and bug-reducer compared with Redux
5. **platform:** Elixir _(Absinthe is an implementation of GraphQL written in Elixir)_ is built on top of the Erlang VM, which allows for fault-tolerant apps using the OTP API and live uploads to your production app; Phoenix's channels make setting up websockets easy--Absinthe leverages this to allow for real-time apps via subscriptions

Love every part of your stack! Try WRAP:

### _Why Elixir?_
* [Creator José Valim explains...](https://softwareengineeringdaily.com/2016/04/18/elixir-erlang-jose-valim/)
* **GO DEEPER:** [Elixir vs. Go](https://blog.codeship.com/comparing-elixir-go/)

### _Getting Started_
* [Learn Elixir](https://elixir-lang.org/getting-started/introduction.html)
  * [On performance](https://medium.com/learn-elixir/speed-up-data-access-in-elixir-842617030514)
* [Practice problems](http://exercism.io/languages/elixir/about)
* **GO DEEPER:** [Learn Functional Programming with Elixir](https://pragprog.com/book/cdc-elixir/learn-functional-programming-with-elixir)

_More fundamentals:_
  * [Exercises for Programmers](https://www.amazon.com/Exercises-Programmers-Challenges-Develop-Coding-ebook/dp/B0170Q50LK/ref=mt_kindle?_encoding=UTF8&me=) (**$15.50, refundable**)
  * [A Common-Sense Guide to Data Structures and Algorithms](https://pragprog.com/book/jwdsal/a-common-sense-guide-to-data-structures-and-algorithms) (**$17.50**, w/ aforementioned 30% discount)

### _Phoenix (framework)_
* [Learn Phoenix](https://pragprog.com/book/phoenix/programming-phoenix)
  * [Updates to Phoenix](https://medium.com/wemake-services/why-changes-in-phoenix-1-3-are-so-important-2d50c9bdabb9) (just do `⌘ + f` for _Creating schema_--the rest is dated)
    > Because Elixir is a functional programming language, Phoenix uses schemas rather than models. A schema defines a struct's fields, its relationships to other structs, and changeset(s) for it (which handle validations and constraints). 
    >
    > [`mix phx.gen.context`](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Context.html) generates a context which holds the API for all schemas within that context (in an object-oriented language, these functions would be defined within each model). For example, instead of defining functions for user authentication within `/lib/<APP>_web/models/user.ex`, one should generate an `Accounts` context and write the functions in `/lib/<APP>/accounts/accounts.ex` (`User` will be passed as an argument).
  * [Webpack setup](https://medium.com/@kimlindholm/adding-webpack-3-to-phoenix-e6633dbc2bc4) _(if you need to process [images or fonts...](https://vuejsdevelopers.com/2017/08/20/vue-js-brunch/))_
  * [`babel-brunch`](https://github.com/babel/babel-brunch#babel-brunch) setup for React
  * [`hmr-brunch`](https://github.com/brunch/hmr-brunch)
    * [Hot Module Replacement API](https://webpack.js.org/api/hot-module-replacement/)
> ["`dependencies` are used for direct usage in your codebase, things that usually end up in the production code, or chunks of code](https://stackoverflow.com/questions/18875674/whats-the-difference-between-dependencies-devdependencies-and-peerdependencies)
>
> ["`devDependencies` are used for the build process, tools that help you manage how the end code will end up, third party test modules, (ex. webpack stuff)"](https://stackoverflow.com/questions/18875674/whats-the-difference-between-dependencies-devdependencies-and-peerdependencies)

  * [JSON API example](https://robots.thoughtbot.com/building-a-phoenix-json-api)
* **GO DEEPER:** [Learn Metaprogramming in Elixir](https://pragprog.com/book/cmelixir/metaprogramming-elixir)

* [React setup](https://medium.com/@diamondgfx/phoenix-v1-1-2-and-react-js-3dbd195a880a) _(you can skip the [whitelist](https://github.com/brunch/brunch/blob/master/CHANGELOG.md#brunch-22-jan-22-2016) &_ `$ brunch build` _steps)_
* [`react-native-web`](https://github.com/necolas/react-native-web/blob/master/website/guides/getting-started.md#getting-started) for [cross-platform](https://github.com/necolas/react-native-web#react-native-for-web) React components, with option to server-side render
  > **Note:** I haven't found clear/explicit [documentation](http://phoenixframework.org/blog/static-assets) for using `react-native-web` SSR with Phoenix.

### _Absinthe (GraphQL backend)_
* ["Getting" GraphQL](https://medium.com/@english3000.org/getting-graphql-40dd48dd53a1)
* [Intro to Absinthe](https://www.howtographql.com/graphql-elixir/0-introduction/)
  * [another free tutorial](https://hexdocs.pm/absinthe/start.html#content)
* [Learn Absinthe](https://pragprog.com/book/wwgraphql/craft-graphql-apis-in-elixir-with-absinthe)

* **[Putting it all together ("WRAP" stack)](https://medium.com/@english3000.org/starting-a-new-project-with-absinthe-relay-be9a127b8f63)**
  > WRAP = react-native-Web + Relay + Absinthe + Postgres

* ["Getting" Relay (GraphQL frontend)](https://www.reindex.io/blog/redux-and-relay/)
  * [Relay over Redux](https://medium.com/@matt.krick/replacing-redux-with-relay-47ed085bfafe)
* [Thinking in Relay](https://facebook.github.io/relay/docs/en/thinking-in-relay.html)
  > "Relay only allows components to access data they specifically ask for in GraphQL fragments — nothing more."
  * **GO DEEPER:** [Relay Deep Dive](https://www.youtube.com/watch?v=oPSuvaYmXBY)
* [Relay tutorial](https://www.howtographql.com/react-relay/0-introduction/) -- **NOTE:** Skip *Step 5: Authentication*; the strategy used is insecure. *Ch. 8* of the Absinthe book provides secure auth.
  * [Relay docs](http://facebook.github.io/relay/docs/en/introduction-to-relay.html)
    * [Example App](https://github.com/relayjs/relay-examples/blob/master/todo/js/app.js)
  * [`Absinthe.Relay` docs](https://hexdocs.pm/absinthe/relay.html)
  * [Sending a request with variables](https://github.com/absinthe-graphql/absinthe-socket/tree/master/packages/socket#send) (not covered in the book)
* [Testing Relay Components I](https://medium.com/entria/relay-integration-test-with-jest-71236fb36d44) & [II](https://medium.com/@mikaelberg/writing-simple-unit-tests-with-relay-707f19e90129)
* [Mocking a GraphQL server](http://graphql.org/blog/mocking-with-graphql/#mocking-is-easy-with-a-type-system)

### _Deploying Your App_
* [Heroku](https://hexdocs.pm/phoenix/heroku.html) has some limitations
* [Gigalixir](http://gigalixir.readthedocs.io/en/latest/main.html) is a platform-as-a-service without those limitations
> ["I chose to use Gigalixir for hosting my application so that I could get the Heroku-like ease-of-use that it provides, while being able to still learn and use features of Elixir that make it special (like ETS and hot upgrades)."](https://medium.com/@b1ackmartian/deployment-to-gigalixir-using-travis-ci-46329167082e)
* If you are deploying to a cloud platform ([AWS EC2](https://www.google.com/search?client=firefox-b-1-ab&ei=fuvDWuncNOKP0wLzl5ywBw&q=distillery+cloud+deploy+aws&oq=distillery+cloud+deploy+aws&gs_l=psy-ab.3...7076.7546.0.7790.4.4.0.0.0.0.200.452.0j2j1.3.0....0...1..64.psy-ab..1.2.302...33i160k1j33i21k1.0.rhnwg9WMOPk), [Google Cloud](https://cloud.google.com/community/tutorials/elixir-phoenix-on-google-app-engine)), use [Distillery](https://hexdocs.pm/distillery/phoenix-walkthrough.html#content)
> ["Distillery is a release tool. It builds a deployable artifact."](https://elixirforum.com/t/devops-ci-cd-cd-for-elixir-phoenix-best-practice/13189)
* **GO DEEPER:** [Continuous Integration & Delivery](https://hackernoon.com/state-of-the-art-in-deploying-elixir-phoenix-applications-fe72a4563cd8)
  * [Travis CI](https://medium.com/@devenney/phoenix-framework-travis-ci-a46a0dbfecd7)
  * [Semaphore CI](https://semaphoreci.com/docs/languages/elixir/setting-up-continuous-integration-for-an-elixir-project-on-semaphore.html)
    * [Semaphore + Docker](https://semaphoreci.com/docs/docker.html)
  * Docker [tutorial](https://docker-curriculum.com/) & [resources](https://github.com/veggiemonk/awesome-docker#what-is-docker)
> ["Ansible isn't meant to be a continuous integration engine."](https://stackoverflow.com/questions/25842718/is-ansible-a-replacement-for-a-ci-tool-like-hudson-jenkins?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
* [DevOps 2.0](https://leanpub.com/the-devops-2-toolkit) (check out the free sample)

### _Advanced_
* [Intro to Memory](https://www.cs.cornell.edu/courses/cs3110/2014sp/lectures/26/memory.html)
* **GO DEEPER:** [Erlang VM Garbage Collection](https://www.erlang-solutions.com/blog/erlang-garbage-collector.html)
* [Intro to Assembly (if accessible)](https://vimeo.com/175634887)
* **GO DEEPER:** [The Erlang Runtime System](https://happi.github.io/theBeamBook/#P-ERTS)

* [Even more...](https://blog.bradfieldcs.com/learn-how-computers-work-e7d33dba0238)
  * [_The Elements of Computing Systems_ course](https://www.coursera.org/learn/build-a-computer)
  * [Berkeley's "Great Ideas in Computer Architecture](http://inst.eecs.berkeley.edu/~cs61c/sp15/)
    * [lecture videos](https://www.youtube.com/watch?v=9y_sUqHeyy8&list=PLhMnuBfGeCDM8pXLpqib90mDFJI-e1lpk)

### _Bleeding Edge_
* [Dgraph](https://github.com/dgraph-io/dgraph#quick-install)
  * [Dgraph vs. SQL](https://blog.dgraph.io/post/sql-vs-dgraph/)
  * [Dgraph vs. Neo4j](https://blog.dgraph.io/post/benchmark-neo4j/)
* [ExDgraph](https://github.com/ospaarmann/exdgraph)

### Plugs
* [SSL](https://spin.atomicobject.com/2018/03/07/force-ssl-phoenix-framework/?utm_campaign=elixir_radar_135&utm_medium=email&utm_source=RD+Station)
* [OAuth2](https://github.com/scrogson/oauth2)
* [Arc **(uploading)**](https://github.com/stavro/arc)

* [Dialxyr](https://github.com/jeremyjh/dialyxir)
* [MonadEx](https://github.com/rob-brown/MonadEx)


Oh, and a shameless plug, [Object-Oriented vs. Functional Interviewing](https://medium.com/@english3000.org/object-oriented-vs-functional-interviewing-a383cf87bcf8)!

## Elixir Cheatsheet (in progress)

#### Note: This material is intended as *complementary* to the resources above.

### Intro

Elixir is built on top of the Erlang VM, which powers something like 50% of the phone system. This means Elixir code is compiled into Erlang VM code, which is then transpiled into assembly code for your machine.

Elixir builds upon the Erlang VM. The Erlang VM supports zero-downtime upgrades, runs isolated processes (so if one crashes, none of the others do and the one that crashed is restarted by a *Supervisor* process), and--while not the fastest of all programming languages--is an order of magnitude faster than PHP, Python, Ruby, and Node.js because it leverages multicore processors to run processes in parallel. As of the mid-2000s, computers' processing power has remained stagnant and the trend has been to include more cores in computers. As this trend continues, the speed of concurrent languages like Elixir over single-threaded languages will only grow.

Elixir also emerged out of the Rails community. José Valim, the author/creator of the language, was part of the Rails core team. In my view, he took the best of both Erlang and Ruby on Rails to produce Elixir. Same for Chris McCord's Phoenix framework and the whole ecosystem.

It is important to note Elixir is a functional programming language. This means any data stored in memory is immutable. If you no longer use it, it becomes "garbage" to be cleared. Additionally, developers think in terms of steps of functions rather than aspects of objects. Instead of calling a function on a datum, the datum is passed as an argument to the function.

### Datatypes

Elixir is a server-side scripting language, meaning it handles requests from the browser and returns responses.

Now let's delve into its datatypes:

**Basic**
* integer
* float
* boolean
* atom

Integers are numbers. Floats are numbers with decimal points. Booleans consist of `true` and `false`. All expressions of code (which are like clauses in sentences) have a `true` boolean value, except `false` (which is a boolean value) and `nil` which is what some functions return on failure. An atom begins (or, as we'll see later, can end) with `:`. It is intended for use as a unique value.

**Advanced**
* string
* tuple
* list
* keyword list
* map

You'll notice I did not include strings (words/letters/anything in double-quotes) under Basic.

When code is compiled to assembly (for the machine to understand), everything is converted to binary. Binary means base 2. That means all code is represented as a series of `0`s and `1`s. Why? Computers work because they have transistors which can store a charge. If a transistor is off (it does not have a charge), this can be represented as `0`.

Numbers are simply converted from base 10 to base 2. Booleans are binary. Floats and atoms are more complicated, but each is a single value. By contrast, a series of contiguous values can also be used to represent data. A string is a series of numbers which have been converted into human-readable characters. AKA, all of the characters in a string can be converted into base 10 numbers, which can then be converted to binary (likely implemented with a special leading binary sequence to differentiate them from integers). The series of continguous values can be represented as a tuple or a (linked) list. A tuple is represented as `{}`. A list is represented as `[]`. Tuples are used to store short series. Lists are for series that are long enough that they may not be stored continguously in a computer's memory. Memory comes in units of bytes, which are 8 bits. A bit is a binary unit (a `0` or a `1`). So a short value can fit in a byte. A longer value needs to be split across bytes.

The most common use of tuples in Elixir is pattern-matching. Often, the tuple will have only 2 values. The first is an atom. You set cases for each possible atom where you do something with the second value of the tuple. Linked lists perform the function of arrays in other languages: storing series of values which you can go through or alter via functions.

There is a third data structure called a keyword list, which is a linked list of 2-value tuples: `[{}, {}]`. The first value of the tuple must be an atom (a key). Additionally, keyword lists can be represented as `{key: value, key2: value2}`. Keyword lists are often defined as the last argument of a function. Because a keyword list is a set of values, this means you can pass a ranging number of arguments, each of which has a specific use in the function as identified by its key.

Lastly, there are maps, `%{}`. In a keyword list, the first value of the tuple must be an atom and the list is ordered. A map is unordered and the key of the key-value pair can be any basic datatype (*literals*) or a string. The value can be any datatype.

The language has additional datatypes but these are generally the most relevant.

### Operations (SOON)

### Logic (AFTER)
