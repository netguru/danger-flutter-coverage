# danger-flutter-coverage

Plugin that allows to count project code coverage

## Installation

    $ gem 'danger-flutter-coverage', git: 'https://github.com/netguru/danger-flutter-coverage'

## Usage

For code coverage:
```
require 'flutter_coverage/plugin'

# Show path to code coverage file generated with `flutter test --coverage`
flutter_coverage.coverage_report_path = "./coverage/lcov.info"

# Print the code coverage message
flutter_coverage.code_coverage_message

# Print the lcov table
flutter_coverage.tests_context_message
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
