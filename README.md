## Encase [![Build Status][1]][2] [![Code Climate][3]][4] [![Dependency Status][5]][6]

### Lightweight IOC Container for ruby.

Encase is a library for using dependency injection within ruby
applications. It provides a lightweight IOC Container that manages
dependencies between your classes. It was written to assist with wiring
of domain objects outside Rails applications to enable faster test
suites.

# Features

* Stores objects, factories, and singletons
* Declarative syntax for specifying dependencies
* Simple DSL for configuring the container
* Support for nested containers
* Support for lazy initialization

## Usage

Consider a `Worker` class that has a dependency on a `Logger`. We would
like this dependency to be available to the worker when it is created.

First we create a container object and declare the dependencies.

```ruby
require 'encase/container'

container = Container.new
container.configure do
  object :logger, Logger.new
  factory :worker, Worker
end
```

Then we declare the `logger` dependency in the Worker class by including
the `Encase` module into it and using the `needs` declaration.

```ruby
require 'encase'

class Worker
  include Encase

  needs :logger
end
```

That's it! Now we can create a new `Worker` by looking up the `:worker`
key on the Container.

```ruby
my_worker = container.lookup('worker')
my_worker.logger.is_a?(Logger) # true
```

## Container Configuration

Containers are configured using a mini DSL in a `configure` method.
Container items are stored with ruby `symbols` and are used to later lookup the object.

```ruby
container.configure do
  # declarations go here
end
```

The declarations supported are listed below.

### Object

Objects are pre existing entities that have already been created in your
system. They are stored and returned as is without any modification. To
store objects use the `object` declaration.

```ruby
container.configure do
  object :key, value
end
```

### Factory

A Factory can be stored with the container to create instances of a
class with it's dependencies auto-injected. On every lookup a new
instance of that class will be returned.

```ruby
container.configure do
  factory :key, TheClass
end
```

### Singleton

A Singleton is similar to a Factory. However it caches the instance
created on the first lookup and returns that instance on every
subsequent lookups.

```ruby
container.configure do
  singleton :key, TheSingletonClass
end
```

## Declaring Dependencies

To specify dependencies of a class, you use the `needs` declaration. It
takes an array of symbols corresponding to the keys of the dependencies
stored in the container. Multiple `needs` declarations are also supported.

```ruby
require 'encase'

class Worker
  include Encase

  needs :a, :b, :c
  needs :one
  needs :two
  needs :three
end
```

## Lazy Initialization

Encase allows storage of dependencies lazily. This can be useful if the
dependencies aren't ready at the time of container configuration. But
will ready before lookup.

Lazy initialization is done by passing a `block` to the DSL declaration
instead of a value. Here `:key`'s block will be evaluated before the
first lookup.

```ruby
container.configure do
  object :key do
    value
  end
end
```

The block can optionally take an argument equal to the container object
itself. You can use this to conditionally resolve the value based on
other objects in the container or elsewhere.

```ruby
container.configure do
  object :key do |c|
    value
  end
end
```

## Nested Containers

Containers can also be nested within other containers. This allows grouping
dependencies within different contexts of your application. When looking
up keys, parent containers are queried when a key is not found in a
child container.

```ruby
parent_container = Container.new
parent_container.configure do
  object :logger, Logger.new
  factory :worker, Worker
end

child_container = parent_container.child
child_container.configure do
  factory :worker, CustomWorker
end

child_container.lookup(:logger) # from parent_container
child_container.lookup(:worker) # CustomWorker
```

Here the `child_container` will use `CustomWorker` for resolving
`:worker`. While the `:logger` will be looked up from the
`parent_container`

## Accessors

Encase creates `accessor` methods corresponding to each declared `need`
in the class. A `container` accessor is also injected into the class for
looking up other dependencies at runtime.

```ruby
class Worker
  include Encase

  needs :one, :two, :three
end

worker = container.lookup('worker')
worker.one
worker.two
worker.three
worker.container
```

## Lifecycle

An `on_inject` event hook is provided to container items after their
dependencies are injected. Any post injection initialization can be
carried out here.

```ruby
class Worker
  include Encase

  needs :logger

  def on_inject
    logger.log('Worker is ready')
  end
end
```

## Testing

Encase significantly simplifies testability of objects. In the earlier
example in order to test that the logger is indeed called by the worker
we can register the worker as a `mock`. Then verify that this mock was called.

```ruby
describe Worker do
  let(:container) {
    container = Container.new
    container.configure do
      factory :worker, Worker
    end

    container
  }

  it 'logs message to the logger' do
    logger = double()
    logger.should_receive(:log).with(anything())

    container.object logger, double(:log => true)

    worker = container.lookup(:worker)
    worker.start()
  end
end
```

Using the Encase created `accessor` methods it is also possible to
manually assign the dependencies. Below `logger` is directly assigned to
the `worker` without requiring a container.

```ruby
  it 'logs message to the logger' do
    logger = double()
    logger.should_receive(:log).with(anything())

    worker = Worker.new
    worker.logger = logger
    worker.start()
  end
```

## Installation

Add this line to your application's Gemfile:

    gem 'encase'

And then execute:

    $ bundle install

# System Requirements

Encase has been tested to work on these platforms.

* ruby 1.9.2
* ruby 1.9.3
* ruby 2.0.0
* ruby 2.1.0

## Contributing

See contributing guidelines for Portkey.

[1]: https://travis-ci.org/dsawardekar/encase.png
[2]: https://travis-ci.org/dsawardekar/encase
[3]: https://codeclimate.com/github/dsawardekar/encase.png
[4]: https://codeclimate.com/github/dsawardekar/encase
[5]: https://gemnasium.com/dsawardekar/encase.png
[6]: https://gemnasium.com/dsawardekar/encase
