return {
 cmd = { "yaml-language-server", "--stdio" },
 filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
 settings = {
  redhat = { telemetry = { enabled = false } },
  yaml = {
   format = {
    enable = true,
   },
  },
 },
}
