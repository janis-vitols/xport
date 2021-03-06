# frozen_string_literal: true

module Xport
  module CSV
    extend ActiveSupport::Concern

    included do
      require 'csv'
    end

    def to_csv(&block)
      formatter = Xport::CSV::Formatter.new(self)
      to_file(formatter, &block)
    end

    class Formatter
      def initialize(export)
        @io  = StringIO.new
        @csv = ::CSV.new(@io)
      end

      def to_file
        @io.rewind
        @io
      end

      def add_worksheet
        yield
      end

      def add_row(worksheet, row)
        values = row.map { |v| v.is_a?(Xport::Cell) ? v.value : v }
        @csv << values
      end
      alias_method :add_header_row, :add_row

      def merge_header_cells(worksheet, range); end
      def column_widths(worksheet, *widths); end
    end
  end
end
