from unittest import TestCase
import time
import pty
import subprocess


class TestDotfiles(TestCase):
    def test_git(self):
        """
        By now, we should have access to zsh, git, an alias for git, and git
        aliases.

        """

        g_d = subprocess.check_output(["zsh", "-i", "-c", "g d --help"])
        self.assertIn(
            "`git d' is aliased to "
            "`diff --ignore-all-space --ignore-blank-lines --word-diff=color'",
            g_d,
        )

