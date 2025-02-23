# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  # It matches only the first sequence of characters that match the regex pattern
  # and stops when it encounters a character that doesn't match the pattern.

  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal  "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------
  # These return the substring matched, if nothing then empty string.
  # If there's no match, it will return nil.

  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/] # matches a or a followed by optional b
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/] # matches b followed by one or more cs
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/] # matches a followed by zero or more bs
    assert_equal "a", "abbcccddddeeeee"[/az*/] # matches a followed by zero or more zs
    assert_equal "", "abbcccddddeeeee"[/z*/] # matches zero or more zs

    # THINK ABOUT IT:
    #
    # When would * fail to match?
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why? they take as much as they can match, that's not really greedy.

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/] # matches a before az
  end

  # ------------------------------------------------------------------
  # The select method returns an array of the elements that match the regex.
  # The |a| part is the parameter that represents each element of the array as select iterates through it.
  # /[cbr]at/: This is the regular expression (regex) pattern used to match the string.
  # not like a[0] or a[1], a[] means apply regex in brackets to preceding string

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/] # \n is also whitespace
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/] # one or more non-newline
  end

  # Negated character classes in regular expressions are used to match characters
  # that do not belong to a certain set or group of characters. Essentially,
  # they allow you to specify "everything except" a particular pattern.
  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/] # not 0-9
  end

  # Negated Character Classes with Specific Shorthands:
  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "the number is ", "the number is 42"[/\D+/] # everything except the digits "42"
    assert_equal "space:", "space: \t\n"[/\S+/] # not whitespace
    # ... a programmer would most likely do
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal " = ", "variable_1 = 42"[/\W+/] # not words
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/] #
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/] # one or more occurrences of the string "ha" in a given text.
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1] # position of word
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/] # 2 words separated by a comma
    assert_equal "Gray", $1 # $1 refers to the first capture group from the last successful regular expression match.
    assert_equal "James", $2 # second capture group from the last successful regular expression match.
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    # This pattern matches:
    # Either "James", "Dana", or "Summer" followed by a space and then "Gray".
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "James Gray", "James Gray lives here"[/(James|Dana|Summer) Gray/]
    assert_equal "Summer", "Summer Gray"[grays, 1] # the text that results from the capture group
    assert_equal "Summer2", "Summer1 Summer2 Gray"[/(James|Dana|Summer1) (James|Dana|Summer2) Gray/, 2]
    puts "Summer1 Summer2 Gray"[/(James|Dana|Summer1) (James|Dana|Summer2) Gray/, 2]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  # A character class allows you to match any one character from a set of characters inside the square brackets.
  # Alternation is used to match one of several patterns, essentially acting like a logical "OR".
  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal  ["one", "two", "three"], "one two-three".scan(/\w+/) # returns a list
  end

  def test_sub_is_like_find_and_replace
    # \w means one acceptable character not a whole word
    puts "one two-three"[/(t\w*)/]
    puts "one two-three"[/(t\w)/]
    # $1[0, 1] - slicing
    # The first number (0) is the starting index in the string (or array).
    # The second number (1) is the length of the substring (or array slice) to extract, starting from the index specified.
    # The sub method replaces the first match of the pattern (t\w*) with the result of the block.
    # The block gives us "t", so the substring "two" is replaced by "t".
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    # global substitute not just the first one encountered
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
