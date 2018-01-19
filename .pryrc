# prompt
Pry.config.color = true

Pry.config.prompt_name = ''
Pry.config.prompt = proc do |obj, nest_level, _pry_|
  version = ''
  version << "\001\e[0;31m\002"
  version << "#{RUBY_VERSION}"
  version << "\001\e[0m\002"
  if defined?(Rails)
    version << ':'
    version << "\001\e[0;91m\002"
    version << "#{Rails.version}"
    version << "\001\e[0m\002"
  end
  "#{version}:#{Pry.config.prompt_name}[#{Pry.view_clip(obj)}]> "
end

# pry-byebug alias
if defined?(PryByebug)
  Pry.config.commands.alias_command 'c', 'continue'
  Pry.config.commands.alias_command 's', 'step'
  Pry.config.commands.alias_command 'n', 'next'
  Pry.config.commands.alias_command 'f', 'finish'
  Pry.config.commands.alias_command 'ss', 'show-source'
end

Pry.config.commands.alias_command 'w', 'whereami'
Pry.config.commands.alias_command '.cls', '.clear'
