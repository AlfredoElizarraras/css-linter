#!/usr/bin/env ruby
require_relative '../lib/linter'

filename = ARGV.first
lint = Linter.new(filename)
lint.fill_checks('checks.yml')
lint.do_checks
lint.write_errors
