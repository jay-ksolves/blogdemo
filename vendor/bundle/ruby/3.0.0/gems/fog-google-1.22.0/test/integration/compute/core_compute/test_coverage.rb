require "helpers/integration_test_helper"

# This is a simple coverage helper that helps differentiate
# the tests when run in parallel so the final coverage report
# can be properly combined together from multiple runners
SimpleCov.command_name "test:compute-core_compute" if ENV["COVERAGE"]
