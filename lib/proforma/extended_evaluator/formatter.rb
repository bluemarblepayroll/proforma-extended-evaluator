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
      DEFAULT_CURRENCY_ROUND    = 2
      DEFAULT_DATE_FORMAT       = '%Y-%m-%d'
      DEFAULT_MASK_CHAR         = 'X'
      THOUSANDS_WITH_DECIMAL    = /(\d)(?=\d{3}+\.)/.freeze
      THOUSANDS_WITHOUT_DECIMAL = /(\d)(?=\d{3}+$)/.freeze

      attr_reader :date_format,
                  :currency_code,
                  :currency_round,
                  :currency_symbol

      def initialize(
        date_format: DEFAULT_DATE_FORMAT,
        currency_code: '',
        currency_round: DEFAULT_CURRENCY_ROUND,
        currency_symbol: ''
      )
        @date_format     = date_format
        @currency_code   = currency_code
        @currency_round  = currency_round
        @currency_symbol = currency_symbol
      end

      def left_mask_formatter(value, arg)
        keep_last = arg.to_s.empty? ? 4 : arg.to_s.to_i

        string_value = value.to_s

        return ''     if null_or_empty?(string_value)
        return value  if string_value.length <= keep_last

        masked_char_count = string_value.size - keep_last
        unmasked_part = string_value[-keep_last..-1]

        (DEFAULT_MASK_CHAR * masked_char_count) + unmasked_part
      end

      def date_formatter(value, _arg)
        return '' if null_or_empty?(value)

        date = Date.strptime(value.to_s, DEFAULT_DATE_FORMAT)

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

      private

      def null_or_empty?(val)
        val.nil? || val.to_s.empty?
      end
    end
  end
end
