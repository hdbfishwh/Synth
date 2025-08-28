-- ForgeUI Theme System
-- This is the heart of the UI library. Define all styles and visuals here.
-- Version: 1.0

local Theme = {}

--== PRIVATE INTERNAL STATE ==--
-- These are not part of the public API, just for internal theming logic.
local _private = {
    current_theme = 'light', -- Default theme
    fonts = {} -- Font cache
}

--== PUBLIC THEME DEFINITION ==--
-- This is the table users can configure.

Theme.properties = {
    -- Available themes: 'light', 'dark', 'custom'
    -- User can set this with Theme.setTheme(theme_name)
    theme = _private.current_theme,

    -- Color Palettes
    -- Define colors for each theme. Access via Theme.getColor('primary')
    colors = {
        light = {
            primary    = {0.26, 0.53, 0.96, 1.0}, -- Nice blue
            secondary  = {0.61, 0.33, 0.72, 1.0}, -- Purple
            success    = {0.22, 0.66, 0.37, 1.0}, -- Green
            danger     = {0.91, 0.30, 0.24, 1.0}, -- Red
            warning    = {0.95, 0.61, 0.07, 1.0}, -- Orange
            info       = {0.16, 0.63, 0.69, 1.0}, -- Teal

            background = {0.95, 0.95, 0.95, 1.0}, -- Light grey
            surface    = {1.00, 1.00, 1.00, 1.0}, -- White
            text       = {0.13, 0.13, 0.13, 1.0}, -- Near black
            text_light = {0.95, 0.95, 0.95, 1.0}, -- Near white
            border     = {0.80, 0.80, 0.80, 1.0}, -- Light grey border
            shadow     = {0.00, 0.00, 0.00, 0.2}, -- Subtle shadow
        },
        dark = {
            primary    = {0.36, 0.63, 1.00, 1.0},
            secondary  = {0.71, 0.43, 0.82, 1.0},
            success    = {0.32, 0.76, 0.47, 1.0},
            danger     = {1.00, 0.40, 0.34, 1.0},
            warning    = {1.00, 0.71, 0.27, 1.0},
            info       = {0.26, 0.73, 0.79, 1.0},

            background = {0.13, 0.13, 0.13, 1.0}, -- Dark grey
            surface    = {0.18, 0.18, 0.18, 1.0}, -- Slightly lighter
            text       = {0.95, 0.95, 0.95, 1.0}, -- Near white
            text_light = {0.13, 0.13, 0.13, 1.0}, -- Near black
            border     = {0.35, 0.35, 0.35, 1.0}, -- Dark grey border
            shadow     = {0.00, 0.00, 0.00, 0.4}, -- Stronger shadow
        }
    },

    -- Typography
    -- Define fonts and sizes. Access via Theme.getFont('body')
    typography = {
        fonts = {
            header  = {name = nil, size = 24}, -- Will be set dynamically if love.graphics exists
            title   = {name = nil, size = 20},
            body    = {name = nil, size = 16},
            caption = {name = nil, size = 12},
            small   = {name = nil, size = 10}
        },
        line_height = 1.4 -- Multiplier for font size
    },

    -- Spacing & Sizing System (in pixels)
    -- Use for padding, margins, etc. Access via Theme.spacing.medium
    spacing = {
        none   = 0,
        tiny   = 2,
        small  = 4,
        medium = 8,
        large  = 16,
        xl     = 24,
        xxl    = 32
    },

    -- Border & Rounding
    borders = {
        width = {
            none = 0,
            thin = 1,
            thick = 2
        },
        radius = {
            none = 0,
            small = 2,
            medium = 4,
            large = 8,
            pill = 999 -- Arbitrarily large value for pill shapes
        }
    },

    -- Animation & Transition Settings (for smoothness)
    animations = {
        duration = {
            instant = 0,
            fast = 0.15,
            normal = 0.3,
            slow = 0.5
        },
        easing = "smooth" -- Placeholder for easing functions
    },

    -- Component-Specific Styles
    -- These are templates used when creating components
    components = {
        button = {
            padding = {x = 16, y = 8},
            default_color = 'primary',
            text_color = 'text_light',
            border_width = 'none',
            border_radius = 'medium',
            -- States
            states = {
                hover = {lighten = 0.1}, -- Lighten color by 10%
                pressed = {darken = 0.1}, -- Darken color by 10%
                disabled = {saturation = 0.5, alpha = 0.7} -- Desaturate and make translucent
            }
        },
        panel = {
            background_color = 'surface',
            border_color = 'border',
            border_width = 'thin',
            border_radius = 'medium',
            padding = 'medium'
        },
        slider = {
            track_height = 4,
            thumb_size = 20,
            track_color = 'border',
            fill_color = 'primary',
            thumb_color = 'surface',
            border_radius = 'pill'
        }
        -- We will add more components here: label, checkbox, input, etc.
    }
}

--== PUBLIC API METHODS ==--

-- Sets the current active theme ('light', 'dark', or a custom one)
function Theme.setTheme(theme_name)
    if Theme.properties.colors[theme_name] then
        _private.current_theme = theme_name
        print("ForgeUI: Theme set to '" .. theme_name .. "'")
    else
        print("ForgeUI: Warning! Theme '" .. tostring(theme_name) .. "' not found. Using default.")
    end
    return Theme
end

-- Gets a color value based on the current theme
function Theme.getColor(color_key)
    local theme_colors = Theme.properties.colors[_private.current_theme]
    if not theme_colors then
        print("ForgeUI: ERROR! Current theme '" .. _private.current_theme .. "' has no color definitions.")
        return {1, 0, 1, 1} -- Magenta for errors
    end

    local color = theme_colors[color_key]
    if not color then
        print("ForgeUI: WARNING! Color key '" .. tostring(color_key) .. "' not found in theme. Returning primary.")
        return theme_colors.primary or {1, 0, 0, 1}
    end

    return color
end

-- Gets a spacing value
function Theme.getSpacing(size_key)
    local spacing = Theme.properties.spacing[size_key]
    if not spacing then
        print("ForgeUI: WARNING! Spacing key '" .. tostring(size_key) .. "' not found. Returning 'medium'.")
        return Theme.properties.spacing.medium
    end
    return spacing
end

-- Gets a border radius value
function Theme.getBorderRadius(radius_key)
    local radius = Theme.properties.borders.radius[radius_key]
    if not radius then
        print("ForgeUI: WARNING! Radius key '" .. tostring(radius_key) .. "' not found. Returning 'medium'.")
        return Theme.properties.borders.radius.medium
    end
    return radius
end

-- Initializes fonts if running in a Love2D environment
function Theme.initFonts()
    if not love or not love.graphics then
        print("ForgeUI: Not in a Love2D environment. Fonts will need to be set manually.")
        return
    end

    for font_type, font_info in pairs(Theme.properties.typography.fonts) do
        local font = love.graphics.newFont(font_info.size)
        _private.fonts[font_type] = font
        print("ForgeUI: Loaded font for '" .. font_type .. "' at size " .. font_info.size)
    end
end

-- Gets a font by its type
function Theme.getFont(font_type)
    local font = _private.fonts[font_type]
    if not font then
        print("ForgeUI: WARNING! Font type '" .. tostring(font_type) .. "' not found. Returning default.")
        -- Try to create a default font if in Love2D
        if love and love.graphics then
            return love.graphics.newFont(Theme.properties.typography.fonts.body.size)
        end
        return nil
    end
    return font
end

-- Applies a state modification to a base color (e.g., hover, pressed)
function Theme.applyState(base_color, state_key)
    local state_rules = Theme.properties.components.button.states[state_key]
    if not state_rules or not base_color then return base_color end

    local r, g, b, a = unpack(base_color)
    local new_color = {r, g, b, a}

    -- Apply state transformations
    if state_rules.lighten then
        for i = 1, 3 do new_color[i] = math.min(1.0, new_color[i] + state_rules.lighten) end
    end
    if state_rules.darken then
        for i = 1, 3 do new_color[i] = math.max(0.0, new_color[i] - state_rules.darken) end
    end
    if state_rules.saturation then
        -- A simple desaturation formula
        local gray = 0.3 * r + 0.59 * g + 0.11 * b
        for i = 1, 3 do new_color[i] = new_color[i] * (1 - state_rules.saturation) + gray * state_rules.saturation end
    end
    if state_rules.alpha then
        new_color[4] = new_color[4] * state_rules.alpha
    end

    return new_color
end

--== INITIALIZATION ==--
-- Auto-initialize if we're in Love2D
if love and love.graphics then
    Theme.initFonts()
end

print("ForgeUI: Theme system loaded successfully. Current theme: '" .. _private.current_theme .. "'")

return Theme
