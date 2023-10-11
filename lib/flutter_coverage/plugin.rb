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
        
        coverage = covered_lines / uncovered_lines * 100
        
        if coverage < 70
          emoji = "🤔"
        elsif coverage <= 85
          emoji = "😀"
        else
          emoji = "🎉"
        end

        return "### Code coverage: #{coverage.round(2)}% #{emoji}"
      end

      def tests_context
        input = File.open(coverage_report_path).read
        input_lines = input.split("\n")

        files = input_lines.select do |line|
          line.start_with?('SF:')
        end

        covered_lines = input_lines.select do |line|
          line.start_with?('LH:')
        end

        uncovered_lines = input_lines.select do |line|
          line.start_with?('LF:')
        end
        
        table = "### Code coverage context: 👁️\n"
        table << "| File | Covered |\n"
        table << "| ---- | ------- |\n"
        
        files.each_with_index do | element, index |
           table << "| #{element.sub('SF:', '')} | #{(covered_lines[index].sub('LH:', '').to_f / uncovered_lines[index].sub('LF:', '').to_f * 100).round(2)}% |\n"
        end

        return table
      end
      
    def code_coverage_message
        markdown(code_coverage)
    end

    def tests_context_message
        markdown(tests_context)
    end
  end
end
