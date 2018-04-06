## Ramping up with Elixir/Phoenix & Absinthe/Relay
At a bare minimum, I'd go through [Learn Elixir](https://elixir-lang.org/getting-started/introduction.html) **(free!)**, [Learn Phoenix](https://www.amazon.com/Programming-Phoenix-Productive-Reliable-Fast-ebook/dp/B01FRIOYEC/ref=sr_1_1) **($24)**, and [Learn Absinthe](https://pragprog.com/book/wwgraphql/craft-graphql-apis-in-elixir-with-absinthe) **($26, Kindle-compatible)**.

### _Why Elixir?_
* [Creator José Valim explains...](https://softwareengineeringdaily.com/2016/04/18/elixir-erlang-jose-valim/)
* **GO DEEPER:** [Elixir vs. Go](https://blog.codeship.com/comparing-elixir-go/)

### _Getting Started_
* [Learn Elixir](https://elixir-lang.org/getting-started/introduction.html)
* [Practice problems](http://exercism.io/languages/elixir/about)
* **GO DEEPER:** [Learn Functional Programming with Elixir](https://pragprog.com/book/cdc-elixir/learn-functional-programming-with-elixir)

### _Phoenix (framework)_
* [Learn Phoenix](https://www.amazon.com/Programming-Phoenix-Productive-Reliable-Fast-ebook/dp/B01FRIOYEC/ref=sr_1_1)
* [React setup](https://medium.com/@diamondgfx/phoenix-v1-1-2-and-react-js-3dbd195a880a)
* [Reph, for server-side rendering in React](https://github.com/reph-stack/reph)
> My suggestion is to just use HTML on the server-side. Rendering React with SSR uses more server resources. By server-side rendering with HTML, you still get the benefits of faster load time to first byte and an SEO-friendly website. Then, you can client-side hydrate your React for interactivity.
>
> This isn't a hard rule, just my current thinking.
* **GO DEEPER:** [Learn Metaprogramming in Elixir](https://www.amazon.com/Metaprogramming-Elixir-Write-Less-Code-ebook/dp/B00U1VU2GA/ref=pd_sim_351_1?_encoding=UTF8&psc=1&refRID=WC6E4JWN3VQF8713QY76)

### _Absinthe (GraphQL backend)_
* ["Getting" GraphQL](https://medium.com/@english3000.org/getting-graphql-40dd48dd53a1)
* [Intro to Absinthe](https://www.howtographql.com/graphql-elixir/0-introduction/)
  * [another free tutorial](https://hexdocs.pm/absinthe/start.html#content)
* [Learn Absinthe](https://pragprog.com/book/wwgraphql/craft-graphql-apis-in-elixir-with-absinthe)

* ["Getting" Relay (GraphQL frontend)](https://www.reindex.io/blog/redux-and-relay/)
  * [Relay over Redux](https://medium.com/@matt.krick/replacing-redux-with-relay-47ed085bfafe)
  * **GO DEEPER:** [Relay Deep Dive](https://www.youtube.com/watch?v=oPSuvaYmXBY)
* [Relay tutorial](https://www.howtographql.com/react-relay/0-introduction/)
  * [Relay docs](http://facebook.github.io/relay/docs/en/introduction-to-relay.html)
  * [`Absinthe.Relay` docs](https://hexdocs.pm/absinthe/relay.html)
  * [Sending a request with variables](https://github.com/absinthe-graphql/absinthe-socket/tree/master/packages/socket#send) (not covered in the book)
  * [`react-native-web`](https://github.com/necolas/react-native-web/blob/master/website/guides/getting-started.md#getting-started) for [cross-platform](https://github.com/necolas/react-native-web#react-native-for-web) React components

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

### Plugs
* [SSL](https://spin.atomicobject.com/2018/03/07/force-ssl-phoenix-framework/?utm_campaign=elixir_radar_135&utm_medium=email&utm_source=RD+Station)
* [OAuth2](https://github.com/scrogson/oauth2)
* [Arc **(uploading)**](https://github.com/stavro/arc)

* [Dialxyr](https://github.com/jeremyjh/dialyxir)
* [MonadEx](https://github.com/rob-brown/MonadEx)


Oh, and a shameless plug, [Object-Oriented vs. Functional Interviewing](https://medium.com/@english3000.org/object-oriented-vs-functional-interviewing-a383cf87bcf8)!

### Cheatsheet SOON...
