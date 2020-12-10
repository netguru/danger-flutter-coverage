module Danger
  class DangerFlutterCoverage < Plugin
      
      attr_accessor :lint_report_path
      attr_accessor :coverage_report_path
      
      def parse_lint
          input = File.open(lint_report_path)
          filtered_input = input.each_line.map(&:strip).reject(&:empty?)

          if filtered_input.detect { |element| element.include? "No issues found!" }
              0
          else
              filtered_input
          end
      end

      def warnings
          filtered_input
              .select { |line| line.start_with? "info" }
              .length
      end

      def errors
          filtered_input
              .select { |line| line.start_with? "error" }
              .length
      end
  end
end
