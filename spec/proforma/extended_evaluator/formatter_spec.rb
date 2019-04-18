# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Proforma::ExtendedEvaluator::Formatter do
  describe '#left_mask_formatter' do
    specify 'returns empty string if value is null' do
      expect(subject.left_mask_formatter(nil, '')).to eq('')
    end

    specify 'returns empty string if value is empty string' do
      expect(subject.left_mask_formatter('', '')).to eq('')
    end

    context 'when arg is blank' do
      let(:arg) { '' }

      specify 'returns value if length is less than or equal to mask length' do
        expect(subject.left_mask_formatter('a',       arg)).to eq('a')
        expect(subject.left_mask_formatter('ab',      arg)).to eq('ab')
        expect(subject.left_mask_formatter('abc',     arg)).to eq('abc')
        expect(subject.left_mask_formatter('abcd',    arg)).to eq('abcd')
        expect(subject.left_mask_formatter('abcde',   arg)).to eq('Xbcde')
        expect(subject.left_mask_formatter('abcdef',  arg)).to eq('XXcdef')
      end
    end

    context 'when arg is populated' do
      let(:arg) { '2' }

      specify 'returns value if length is less than or equal to mask length (arg)' do
        expect(subject.left_mask_formatter('a',       arg)).to eq('a')
        expect(subject.left_mask_formatter('ab',      arg)).to eq('ab')
        expect(subject.left_mask_formatter('abc',     arg)).to eq('Xbc')
        expect(subject.left_mask_formatter('abcd',    arg)).to eq('XXcd')
        expect(subject.left_mask_formatter('abcde',   arg)).to eq('XXXde')
        expect(subject.left_mask_formatter('abcdef',  arg)).to eq('XXXXef')
      end
    end
  end

  describe '#date_formatter' do
    subject do
      described_class.new(
        date_format: '%m/%d/%Y'
      )
    end

    let(:arg) { '' }

    specify 'returns empty string if value is null' do
      expect(subject.date_formatter(nil, '')).to eq('')
    end

    specify 'returns empty string if value is empty string' do
      expect(subject.date_formatter('', '')).to eq('')
    end

    specify 'returns formatted date' do
      expect(subject.date_formatter('2018-01-02', arg)).to eq('01/02/2018')
    end
  end

  describe '#currency_formatter' do
    subject do
      described_class.new(
        currency_code: 'USD',
        currency_round: 2,
        currency_symbol: '$'
      )
    end

    let(:arg) { '' }

    specify 'returns empty string if value is null' do
      expect(subject.currency_formatter(nil, '')).to eq('')
    end

    specify 'returns empty string if value is empty string' do
      expect(subject.currency_formatter('', '')).to eq('')
    end

    specify 'returns formatted currency' do
      expect(subject.currency_formatter('12345.67', arg)).to eq('$12,345.67 USD')
    end
  end

  describe '#number_formatter' do
    subject do
      described_class.new(
        currency_code: 'USD',
        currency_round: 2,
        currency_symbol: '$'
      )
    end

    let(:arg) { '3' }

    specify 'returns empty string if value is null' do
      expect(subject.currency_formatter(nil, '')).to eq('')
    end

    specify 'returns empty string if value is empty string' do
      expect(subject.currency_formatter('', '')).to eq('')
    end

    specify 'returns formatted number' do
      expect(subject.number_formatter('12345.67899', arg)).to eq('12,345.679')
    end
  end
end
