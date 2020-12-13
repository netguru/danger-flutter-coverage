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
          parsed_lint
              .select { |line| line.start_with? "info" }
              .length
      end

      def errors
          parsed_lint
              .select { |line| line.start_with? "error" }
              .length
      end
      
      def code_coverage
        LF = 0
        LH = 0

        input = File.open(coverage_report_path).read

        input.each_line do |line|
            if line.start_with?('LF')
                LF += line.sub('LF:', '').to_f
            elsif line.start_with?('LH')
                LH += line.sub('LH:', '').to_f
            end
        end
        LH / LF
      end
      
    def code_coverage_message
        markdown("## Code coverage: #{code_coverage.round(2)}% ✅")
    end
  end
end
