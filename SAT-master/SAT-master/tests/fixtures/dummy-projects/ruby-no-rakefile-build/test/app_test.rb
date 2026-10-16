# frozen_string_literal: true

require 'simplecov'
SimpleCov.start { add_filter '/test/' }
require 'minitest/autorun'
require_relative '../lib/app'

class AppTest < Minitest::Test
  def test_add
    assert_equal 3, add(1, 2)
  end
end
