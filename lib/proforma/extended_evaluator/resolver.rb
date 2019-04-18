# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class ExtendedEvaluator
    # This class is also meant to be plugged into Stringento to provide value resolution.
    class Resolver
      DOT_NOTATION_SEPARATOR = '.'

      def resolve(value, input)
        traverse(input, value.to_s.split(DOT_NOTATION_SEPARATOR))
      end

      private

      def traverse(object, through)
        pointer = object

        through.each do |t|
          next unless pointer

          pointer = get(pointer, t)
        end

        pointer
      end

      def get(object, key)
        if object.is_a?(Hash)
          indifferent_hash_get(object, key)
        elsif object.respond_to?(key)
          object.send(key)
        end
      end

      def indifferent_hash_get(hash, key)
        if hash.key?(key.to_s)
          hash[key.to_s]
        elsif hash.key?(key.to_s.to_sym)
          hash[key.to_s.to_sym]
        end
      end
    end
  end
end
