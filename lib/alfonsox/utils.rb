# frozen_string_literal: true

# A Alfonso X module
module AlfonsoX
  # Utils for Alfonso X
  module Utils
    # Returns an absolute path to the root of the repository.
    #
    # Stolen from Overcommit::Utils#repo_root
    #
    # We do this ourselves rather than call `git rev-parse --show-toplevel` to
    # solve an issue where the .git directory might not actually be valid in
    # tests.
    #
    # @return [String] GIT root file path
    def repo_root
      result = `git rev-parse --show-toplevel`
      raise 'Not in git repository' unless result.success?
      result.stdout.chomp("\n")
    end
  end
end