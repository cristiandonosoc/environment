-- This file should go into %HOME%/AppData/Local/clink/flexprompt_config.lua

flexprompt = flexprompt or {}
flexprompt.settings = flexprompt.settings or {}
flexprompt.settings.charset = "unicode"
flexprompt.settings.connection = "dotted"
flexprompt.settings.flow = "concise"
flexprompt.settings.frame_color = "dark"
flexprompt.settings.heads = "pointed"
flexprompt.settings.left_frame = "none"
flexprompt.settings.left_prompt = "{battery}{histlabel}{cwd}{git}"
flexprompt.settings.lines = "two"
flexprompt.settings.nerdfonts_version = 3
flexprompt.settings.nerdfonts_width = 1
flexprompt.settings.powerline_font = true
flexprompt.settings.right_frame = "none"
flexprompt.settings.right_prompt = "{exit}{duration}{time:format=%H:%M:%S}"
flexprompt.settings.separators = "pointed"
flexprompt.settings.spacing = "sparse"
flexprompt.settings.style = "classic"
flexprompt.settings.symbols =
{
    prompt =
    {
        ">",
        winterminal = "❯",
    },
}
flexprompt.settings.tails = "slant"
flexprompt.settings.use_8bit_color = true
flexprompt.settings.use_icons = true
