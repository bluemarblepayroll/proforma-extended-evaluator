# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class ExtendedEvaluator
    # This library uses Stringento for its string-based formatting.  This class is meant to be
    # plugged into Stringento to provide formatting for data types, such as: strings, dates,
    # currency, numbers, etc.
    class Formatter < Stringento::Formatter
      DEFAULTS = {
        currency_code: 'USD',
        currency_round: 2,
        currency_symbol: '$',
        date_format: '%m/%d/%Y',
        mask_char: 'X',
        false_value: 'No',
        null_value: 'Unknown',
        true_value: 'Yes'
      }.freeze

      ISO_DATE_FORMAT           = '%Y-%m-%d'
      NULLISH                   = /(nil|null)$/i.freeze
      THOUSANDS_WITH_DECIMAL    = /(\d)(?=\d{3}+\.)/.freeze
      THOUSANDS_WITHOUT_DECIMAL = /(\d)(?=\d{3}+$)/.freeze
      TRUTHY                    = /(true|t|yes|y|1)$/i.freeze

      attr_reader :currency_code,
                  :currency_round,
                  :currency_symbol,
                  :date_format,
                  :false_value,
                  :mask_char,
                  :null_value,
                  :true_value

      def initialize(opts = {})
        opts = DEFAULTS.merge(opts)

        @currency_code   = opts[:currency_code]
        @currency_round  = opts[:currency_round]
        @currency_symbol = opts[:currency_symbol]
        @date_format     = opts[:date_format]
        @false_value     = opts[:false_value]
        @mask_char       = opts[:mask_char]
        @null_value      = opts[:null_value]
        @true_value      = opts[:true_value]
      end

      def left_mask_formatter(value, arg)
        keep_last = arg.to_s.empty? ? 4 : arg.to_s.to_i

        string_value = value.to_s

        return ''     if null_or_empty?(string_value)
        return value  if string_value.length <= keep_last

        mask(string_value, keep_last)
      end

      def date_formatter(value, _arg)
        return '' if null_or_empty?(value)

        date = Date.strptime(value.to_s, ISO_DATE_FORMAT)

        date.strftime(date_format)
      end

      def currency_formatter(value, _arg)
        return '' if null_or_empty?(value)

        prefix = null_or_empty?(currency_symbol) ? '' : currency_symbol
        suffix = null_or_empty?(currency_code) ? '' : " #{currency_code}"

        formatted_value = number_formatter(value, currency_round)

        "#{prefix}#{formatted_value}#{suffix}"
      end

      def number_formatter(value, arg)
        decimal_places = arg.to_s.empty? ? 6 : arg.to_s.to_i

        regex = decimal_places.positive? ? THOUSANDS_WITH_DECIMAL : THOUSANDS_WITHOUT_DECIMAL

        format("%0.#{decimal_places}f", value || 0).gsub(regex, '\1,')
      end

      def boolean_formatter(value, arg)
        nullable = arg.to_s == 'nullable'

        if nullable && nully?(value)
          null_value
        elsif truthy?(value)
          true_value
        else
          false_value
        end
      end

      private

      def mask(string, keep_last)
        unmasked_part     = string[-keep_last..-1]
        masked_char_count = string.size - keep_last

        (mask_char * masked_char_count) + unmasked_part
      end

      def null_or_empty?(val)
        val.nil? || val.to_s.empty?
      end

      # rubocop:disable Style/DoubleNegation
      def nully?(val)
        null_or_empty?(val) || !!(val.to_s =~ NULLISH)
      end

      def truthy?(val)
        !!(val.to_s =~ TRUTHY)
      end
      # rubocop:enable Style/DoubleNegation
    end
  end
end
