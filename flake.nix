{
  description = "Structured markdown harness for driving autonomous coding agents";

  outputs =
    { self }:
    {
      templates.default = {
        path = ./template;
        description = "Agentic harness — specs, rules, TDD loop, backpressure via Nix";
        welcomeText = ''

          # Agentic Harness initialized

          Next steps:

            1. Allow direnv:           direnv allow
            2. Bootstrap the harness:  cat BOOTSTRAP.md | claude-code
            3. Write specs:            claude-code  (describe what you want to build)
            4. Run the loop:           ./scripts/ralph.sh

          See HUMAN.md for the full lifecycle guide.

        '';
      };
    };
}
