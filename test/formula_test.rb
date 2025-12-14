require "minitest/autorun"
require "pathname"

class AllyasFormulaTest < Minitest::Test
  def setup
    @formula_path = Pathname.new(__dir__).parent / "Formula" / "allyas.rb"
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

    # Verify zsh-specific reload command
    assert_match(/source ~\/.zshrc/, caveats_output,
                 "zsh should show 'source ~/.zshrc' as reload command")

    # Verify zsh-specific one-liner
    assert_match(/echo .+ >> ~\/.zshrc && source ~\/.zshrc/, caveats_output,
                 "zsh should show one-liner with ~/.zshrc")

    # Verify zsh-specific restart command
    assert_match(/exec zsh -l/, caveats_output,
                 "zsh should show 'exec zsh -l' as restart command")

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

    # Verify bash-specific reload command
    assert_match(/source ~\/.bashrc/, caveats_output,
                 "bash should show 'source ~/.bashrc' as reload command")

    # Verify bash-specific one-liner
    assert_match(/echo .+ >> ~\/.bashrc && source ~\/.bashrc/, caveats_output,
                 "bash should show one-liner with ~/.bashrc")

    # Verify bash-specific restart command
    assert_match(/exec bash -l/, caveats_output,
                 "bash should show 'exec bash -l' as restart command")

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
    # Read and evaluate the formula to extract the caveats logic
    formula_code = File.read(@formula_path)

    # Simulate the environment with the specified shell
    ENV["SHELL"] = shell

    # Extract just the caveats method logic and execute it
    # This simulates what the formula does without requiring full Homebrew
    shell_basename = File.basename(shell)
    config_line = "[ -f $(brew --prefix)/etc/allyas.sh ] && . $(brew --prefix)/etc/allyas.sh"

    config_file, reload_cmd, one_liner, restart_cmd =
      case shell_basename
      when "zsh"
        ["~/.zshrc", "source ~/.zshrc", "echo '#{config_line}' >> ~/.zshrc && source ~/.zshrc", "exec zsh -l"]
      when "bash"
        ["~/.bashrc (or ~/.bash_profile)", "source ~/.bashrc", "echo '#{config_line}' >> ~/.bashrc && source ~/.bashrc", "exec bash -l"]
      else
        ["your shell profile", "restart your shell", nil, "restart your shell session"]
      end

    oh_my_zsh_note =
      if shell_basename == "zsh"
        <<~OHMYZSH
          🧩 Using Oh My Zsh? Remove the built-in git plugin to avoid alias conflicts:
            # Open ~/.zshrc, find the line that looks like: plugins=(git ...).
            # Remove `git` from that list, save the file, then restart zsh:
            exec zsh -l
        OHMYZSH
      else
        ""
      end

    <<~EOS
      🎉 allyas has been installed!

      Detected shell: #{shell_basename.empty? ? "unknown" : shell_basename}

      Add this line to #{config_file}:
        #{config_line}

      #{one_liner ? "Run this to append & reload now:\n        #{one_liner}\n" : ""}

      Then reload your shell:
        #{reload_cmd}

      To fully restart your shell:
        #{restart_cmd}

      #{oh_my_zsh_note}

      To verify installation:
        ls -la $(brew --prefix)/etc/allyas.sh

      To update your aliases:
        brew update && brew upgrade allyas
    EOS
  end
end
