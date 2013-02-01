require 'helper'

class PipelineTest < Vault::TestCase
  include Vault

  # create a Module, Class, and lambda
  def setup
    super
    @append_a = Module.new
    @append_a.define_singleton_method(:call) do |thing|
      thing << 'a'
      thing
    end

    @append_b = Class.new
    @append_b.define_singleton_method(:call) do |thing|
      thing << 'b'
      thing
    end

    @append_c = lambda do |thing|
      thing << 'c'
      thing
    end
  end

  # No shirt, no shoes, no problem
  def test_noops_with_no_composites
    pipeline = Class.new(Pipeline)
    result = pipeline.process([])
    assert_equal([], result)
  end

  # #filters returns the filters
  def test_filters_accessor
    pipeline = Class.new(Pipeline)
    pipeline.use @append_a, @append_b
    assert_equal([@append_a, @append_b], pipeline.filters)
  end

  # Single call to ::use
  def test_with_one_composite
    pipeline = Class.new(Pipeline)
    pipeline.use @append_a
    result = pipeline.process([])
    assert_equal(['a'], result)
  end

  # Single call to ::use with multiple classes
  # are chained in the order they are added
  def test_with_multiple_composites
    pipeline = Class.new(Pipeline)
    pipeline.use @append_a, @append_b
    result = pipeline.process([])
    assert_equal(['a', 'b'], result)
  end

  # Multiple calls to ::use are chained in
  # the order they are added
  def test_with_multiple_compositions
    pipeline = Class.new(Pipeline)
    pipeline.use @append_a, @append_b
    pipeline.use @append_c
    result = pipeline.process([])
    assert_equal(['a', 'b', 'c'], result)
  end
end
