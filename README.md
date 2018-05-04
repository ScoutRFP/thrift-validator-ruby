# Thrift::Validator

Recursive [thrift][] struct validator. The thrift library out of the box does
not validated nested structs; This library fixes that problem. Rather than
monkey-patching Thrift, this library includes a class to validate objects
recursively.

Here's an example from this library's tests. Given the following schema:

```thrift
struct SimpleStruct  {
  1: required string required_string,
  2: optional string optional_string,
}

struct NestedExample {
  1: required SimpleStruct required_struct,
  2: optional SimpleStruct optional_struct,
}
```

This library provides:

```ruby
struct = SimpleStruct.new
nested = NestedStruct.new(required_struct: struct)

# Method defined by the Thrift library
struct.validate # => Thrift::ProtocolException

# Thrift only validates fields set as required on this instance. Since
# `required_struct` is non-nil, validation succeeds. Also note that Thrift
# does not validate semantics of the assigned objects, so assigning an
# invalid struct will pass its validation method.
nested.validate # => true

# With the validator
Thrift::Validator.new.validate(nested) # => Thrift::ProtocolException
```

## Semantics enforced

* all original Thrift validation semantics
* `optional` or `required` `struct` types
* `optional` or `required` `list<struct>` items
* `optional` or `required` `set<struct>` items
* `optional` or `required` `map` types with `struct` keys and/or values

## Exception handling

Due to the recursive nature of `thrift-validator`, the validation
errors raised by Thrift become less than helpful. In order
to provide more information, the resulting `Thrift::ProtocolException`
message is prefixed with the type where the error occurred. For
example:

```ruby
# Without thrift-validator
> struct.validate
Thrift::ProtocolException: Required field required_string is unset!

# With thrift-validator
> Thrift::Validator.new.validate(struct)
Thrift::ProtocolException: SimpleStruct: Required field required_string is unset!
```

This feature becomes especially useful with nested structs, where validation
may fail at any depth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thrift-validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thrift-validator

## Testing

First, install a `thrift` compiler on your platform (e.g., `brew install
thrift`, `sudo apt install thrift`). Then run:

    $ rake test

## Contributing

1. Fork it ( https://github.com/saltside/thrift-validator-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[thrift]: https://thrift.apache.org
