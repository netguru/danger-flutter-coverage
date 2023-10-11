module Danger
  class DangerFlutterCoverage < Plugin
      
      attr_accessor :lint_report_path
      attr_accessor :coverage_report_path
      
      def parsed_lint
          input = File.open(lint_report_path)
          filtered_input = input.each_line.map(&:strip).reject(&:empty?)

          if filtered_input.detect { |element| element.include? "No issues found!" }
              0
          else
              filtered_input
          end
      end

      def warnings
          if parsed_lint == 0
              0
          else
              parsed_lint
                  .select { |line| line.start_with? "info" }
                  .length
          end
      end

      def errors
          if parsed_lint == 0
              0
          else
              parsed_lint
                  .select { |line| line.start_with? "error" }
                  .length
          end
      end
      
      def code_coverage
        uncovered_lines = 0
        covered_lines = 0

        input = File.open(coverage_report_path).read

        input.each_line do |line|
            if line.start_with?('LF')
                uncovered_lines += line.sub('LF:', '').to_f
            elsif line.start_with?('LH')
                covered_lines += line.sub('LH:', '').to_f
            end
        end
        covered_lines / uncovered_lines * 100
      end

      def tests_context
        File.open(coverage_report_path).read
      end
      
    def code_coverage_message
        markdown("## Code coverage: #{code_coverage.round(2)}% ✅")
    end

    def tests_context_message
       markdown("## Code coverage context: #{tests_context} ✅")
    end
  end
end
