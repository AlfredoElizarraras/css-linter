module Error
  ERROR = 0
  ERROR_NO_FILE = 'There was no file given.'.freeze
  ERROR_MISSING_SPACE = "There's a missing space at line: ".freeze
  ERROR_EXTRA_SPACE = "There's an extra space at line: ".freeze
  ERROR_MISSING_INDENTATION = "Theres's missing indentation of spaces at line: ".freeze
  ERROR_MISSING_SPACE_AFTER_COLON = "There's missing a space after colon at line: ".freeze
  WARNING = 1
  WARNING_NO_UPPCASE_SELECTORS = 'Detected uses of upper-case in selector at line: '.freeze
end
