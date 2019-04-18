# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Proforma::ExtendedEvaluator do
  describe '#initialize' do
    it 'should raise ArgumentError if formatter is null' do
      expect { described_class.new(formatter: nil) }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if resolver is null' do
      expect { described_class.new(resolver: nil) }.to raise_error(ArgumentError)
    end

    it 'should assign formatter and resolver' do
      formatter = Proforma::ExtendedEvaluator::Formatter.new
      resolver = Proforma::ExtendedEvaluator::Resolver.new

      instance = described_class.new(formatter: formatter, resolver: resolver)

      expect(instance.formatter).to equal(formatter)
      expect(instance.resolver).to equal(resolver)
    end
  end

  specify '#value is delegated to resolver#resolve' do
    resolver    = Proforma::ExtendedEvaluator::Resolver.new
    object      = { id: 1 }
    expression  = 'id'

    instance = described_class.new(resolver: resolver)

    expect(resolver).to receive(:resolve).with(expression, object)

    instance.value(object, expression)
  end

  specify '#text will use blank object if an array is passed in' do
    object      = [{ id: 1 }]
    expression  = '{id}'

    instance = described_class.new

    actual_text = instance.text(object, expression)

    expect(actual_text).to eq('')
  end

  specify '#text will use object if an object is passed in' do
    object      = { id: 1 }
    expression  = '{id}'

    instance = described_class.new

    actual_text = instance.text(object, expression)

    expect(actual_text).to eq('1')
  end
end
