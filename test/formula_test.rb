require "minitest/autorun"
require "pathname"

# Minimal Formula base class mock to load the formula
class Formula
  attr_reader :pkgshare, :etc

  def initialize
    @pkgshare = Pathname.new("/mock/pkgshare")
    @etc = Pathname.new("/mock/etc")
  end

  # Mock DSL methods used in the formula
  def self.desc(description); end
  def self.homepage(url); end
  def self.url(url); end
  def self.sha256(hash); end
  def self.version(ver); end
  def self.license(lic); end
  def self.test(&block); end
end

# Load the actual formula
require_relative "../Formula/allyas"

class AllyasFormulaTest < Minitest::Test
  def setup
    @formula = Allyas.new
  end

  def test_oh_my_zsh_note_shown_for_zsh
    caveats_output = run_caveats_with_shell("/bin/zsh")

    assert_match(/Using Oh My Zsh\?/, caveats_output,
                 "oh_my_zsh_note should be shown when shell is zsh")
    assert_match(/Remove the built-in git plugin/, caveats_output,
                 "oh_my_zsh_note should contain git plugin removal instructions")
  end

  def test_zsh_shows_correct_zsh_specific_messages
    caveats_output = run_caveats_with_shell("/bin/zsh")

    # Verify zsh-specific config file is mentioned
    assert_match(/Add this line to ~\/.zshrc:/, caveats_output,
                 "zsh should show ~/.zshrc as config file")

    # Verify zsh-specific one-liner
    assert_match(/echo .+ >> ~\/.zshrc && source ~\/.zshrc/, caveats_output,
                 "zsh should show one-liner with ~/.zshrc")

    # Verify zsh-specific restart command
    assert_match(/exec zsh -l/, caveats_output,
                 "zsh should show 'exec zsh -l' as restart command")

    # Verify restart recommendation is shown
    assert_match(/IMPORTANT: Restart your shell/, caveats_output,
                 "zsh should show restart recommendation")

    # Verify detected shell is zsh
    assert_match(/Detected shell: zsh/, caveats_output,
                 "zsh should be detected as the shell")
  end

  def test_oh_my_zsh_note_not_shown_for_bash
    caveats_output = run_caveats_with_shell("/bin/bash")

    refute_match(/Using Oh My Zsh\?/, caveats_output,
                 "oh_my_zsh_note should NOT be shown when shell is bash")
    refute_match(/Remove the built-in git plugin/, caveats_output,
                 "oh_my_zsh_note should NOT contain git plugin instructions for bash")
  end

  def test_bash_shows_correct_bash_specific_messages
    caveats_output = run_caveats_with_shell("/bin/bash")

    # Verify bash-specific config file is mentioned
    assert_match(/~\/.bashrc \(or ~\/.bash_profile\)/, caveats_output,
                 "bash should show ~/.bashrc (or ~/.bash_profile) as config file")

    # Verify bash-specific one-liner
    assert_match(/echo .+ >> ~\/.bashrc && source ~\/.bashrc/, caveats_output,
                 "bash should show one-liner with ~/.bashrc")

    # Verify bash-specific restart command
    assert_match(/exec bash -l/, caveats_output,
                 "bash should show 'exec bash -l' as restart command")

    # Verify restart recommendation is shown
    assert_match(/IMPORTANT: Restart your shell/, caveats_output,
                 "bash should show restart recommendation")

    # Verify detected shell is bash
    assert_match(/Detected shell: bash/, caveats_output,
                 "bash should be detected as the shell")
  end

  def test_oh_my_zsh_note_not_shown_for_unknown_shell
    caveats_output = run_caveats_with_shell("/bin/fish")

    refute_match(/Using Oh My Zsh\?/, caveats_output,
                 "oh_my_zsh_note should NOT be shown when shell is unknown")
    refute_match(/Remove the built-in git plugin/, caveats_output,
                 "oh_my_zsh_note should NOT contain git plugin instructions for unknown shell")
  end

  def test_oh_my_zsh_note_not_shown_when_shell_empty
    caveats_output = run_caveats_with_shell("")

    refute_match(/Using Oh My Zsh\?/, caveats_output,
                 "oh_my_zsh_note should NOT be shown when shell is empty")
  end

  private

  def run_caveats_with_shell(shell)
    # Set the SHELL environment variable and call the actual formula's caveats method
    original_shell = ENV["SHELL"]
    begin
      ENV["SHELL"] = shell
      @formula.caveats
    ensure
      ENV["SHELL"] = original_shell
    end
  end
end
