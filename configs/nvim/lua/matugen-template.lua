-- lua/matugen-template.lua
-- Per Noctalia's own documented neovim-theming recipe
-- (docs.noctalia.dev/theming/program-specific/neovim). Noctalia's own
-- template engine renders THIS file's {{ colors.* }} placeholders into
-- lua/matugen.lua on every wallpaper/theme change, then reloads Neovim
-- (post_hook: pkill -SIGUSR1 nvim - see the noctalia user-templates.toml
-- entry deployed alongside this).
--
-- REQUIRES: RRethy/base16-nvim added as a plugin in your neovim config
-- (0xhealer/nvim-config) - NOT done here, since that's a separate repo
-- you own and I'm not silently adding a dependency to it. Add this to its
-- plugin spec yourself:
--   { 'RRethy/base16-nvim' }

local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '{{ colors.surface.default.hex }}',
    base01 = '{{ colors.surface_container.default.hex }}',
    base02 = '{{ colors.surface_container_high.default.hex }}',
    base03 = '{{ colors.outline.default.hex }}',
    base04 = '{{ colors.on_surface_variant.default.hex }}',
    base05 = '{{ colors.on_surface.default.hex }}',
    base06 = '{{ colors.on_surface.default.hex }}',
    base07 = '{{ colors.inverse_surface.default.hex }}',
    base08 = '{{ colors.error.default.hex }}',
    base09 = '{{ colors.tertiary.default.hex }}',
    base0A = '{{ colors.secondary.default.hex }}',
    base0B = '{{ colors.primary.default.hex }}',
    base0C = '{{ colors.tertiary_container.default.hex }}',
    base0D = '{{ colors.primary.default.hex }}',
    base0E = '{{ colors.secondary_container.default.hex }}',
    base0F = '{{ colors.error_container.default.hex }}',
  })
end

return M
