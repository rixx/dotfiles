#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["inquirer"]
# ///
"""
Interactive color selection tool for fish shell host prompt colors.
Loops through terminal colors and lets you categorize them for user/root prompts.

Usage:
    ./select-host-colours.py              # Run on all colors 1-255
    ./select-host-colours.py 13 52 100    # Run on specific colors only
"""

import sys
import inquirer

# Powerline separator character
SEPARATOR = "\ue0b0"

# ANSI escape helpers
def fg(color):
    return f"\033[38;5;{color}m"

def bg(color):
    return f"\033[48;5;{color}m"

def reset():
    return "\033[0m"


# Prompt color (matches PROMPT_COLOUR in prompt.fish)
PROMPT_COLOUR = 6
GIT_CLEAN_BG = 7


def show_sample(host_bg, host_fg):
    """Display a full sample prompt line."""
    fg_name = "light" if host_fg == 15 else "dark"

    # Host segment
    prompt = f"{bg(host_bg)}{fg(host_fg)} rixx@hostname "

    # Separator: host -> path
    prompt += f"{bg(PROMPT_COLOUR)}{fg(host_bg)}{SEPARATOR}"

    # Path segment
    prompt += f"{fg(15)} ~/.config/dotfiles "

    # Separator: path -> git
    prompt += f"{bg(GIT_CLEAN_BG)}{fg(PROMPT_COLOUR)}{SEPARATOR}"

    # Git segment (clean state)
    prompt += f"{fg(0)} \ue0a0 master \u2714 \u267b "

    # Separator: git -> subdir
    prompt += f"{bg(PROMPT_COLOUR)}{fg(GIT_CLEAN_BG)}{SEPARATOR}"

    # Subdir segment
    prompt += f"{fg(15)} / "

    # Final separator
    prompt += f"{reset()}{fg(PROMPT_COLOUR)}{SEPARATOR}{reset()}"

    # Label
    prompt += f"  ({fg_name})"

    return prompt


def main():
    # Results storage
    user_light = []  # bg colors with light (white) foreground for users
    user_dark = []   # bg colors with dark (black) foreground for users
    root_light = []  # bg colors with light foreground for root
    root_dark = []   # bg colors with dark foreground for root

    choices = [
        ("user-light", "user-light"),
        ("user-dark", "user-dark"),
        ("root-light", "root-light"),
        ("root-dark", "root-dark"),
        ("skip", "skip"),
    ]

    # Determine which colors to process
    if len(sys.argv) > 1:
        colors = [int(c) for c in sys.argv[1:]]
        print(f"Processing {len(colors)} specified colors: {colors}")
    else:
        colors = list(range(1, 256))
        print("Processing all colors 1-255")

    print("Fish Host Color Selection Tool")
    print("=" * 40)
    print("For each color, choose how to categorize it.")
    print("Press Ctrl+C at any time to finish early and see results.\n")

    for color in colors:
        print(f"\n{reset()}Color {color}:")
        print()
        print(f"  {show_sample(color, 15)}")
        print()
        print(f"  {show_sample(color, 0)}")
        print()

        try:
            questions = [
                inquirer.List(
                    "choice",
                    message=f"Categorize color {color}",
                    choices=choices,
                    carousel=True,
                )
            ]

            answer = inquirer.prompt(questions, raise_keyboard_interrupt=True)
            choice = answer["choice"]

            if choice == "user-light":
                user_light.append(color)
            elif choice == "user-dark":
                user_dark.append(color)
            elif choice == "root-light":
                root_light.append(color)
            elif choice == "root-dark":
                root_dark.append(color)
            # skip does nothing

        except KeyboardInterrupt:
            print(f"\n\nInterrupted at color {color} - showing results...")
            break

    # Build pairs: (bg, fg)
    user_pairs = [(c, 15) for c in user_light] + [(c, 0) for c in user_dark]
    root_pairs = [(c, 15) for c in root_light] + [(c, 0) for c in root_dark]

    # Output results
    print("\n" + "=" * 60)
    print("RESULTS - Copy these into fish/conf.d/prompt.fish")
    print("=" * 60 + "\n")

    if user_pairs:
        print("# User (non-root) colors")
        print("set -g USER_HOST_PAIRS \\")
        for i, (bg_col, fg_col) in enumerate(user_pairs):
            end = " \\" if i < len(user_pairs) - 1 else ""
            print(f"    {bg_col} {fg_col}{end}")
    else:
        print("# No user colors selected")

    print()

    if root_pairs:
        print("# Root colors")
        print("set -g ROOT_HOST_PAIRS \\")
        for i, (bg_col, fg_col) in enumerate(root_pairs):
            end = " \\" if i < len(root_pairs) - 1 else ""
            print(f"    {bg_col} {fg_col}{end}")
    else:
        print("# No root colors selected")

    print("\n" + "=" * 60)

    # Summary
    print(f"\nSummary:")
    print(f"  User colors: {len(user_pairs)} ({len(user_light)} light, {len(user_dark)} dark)")
    print(f"  Root colors: {len(root_pairs)} ({len(root_light)} light, {len(root_dark)} dark)")


if __name__ == "__main__":
    main()
