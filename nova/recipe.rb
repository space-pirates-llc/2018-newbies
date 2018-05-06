require 'pathname'

module RecipeHelper
  ITAMAE_DIR = Pathname('..').expand_path(__FILE__)

  def include_role(name)
    recipe_file = 'default.rb'

    if name.match(%r{::})
      name, recipe_file = name.split('::', 2)
      recipe_file << '.rb'
    end

    include_recipe ITAMAE_DIR.join('roles', name, recipe_file).to_s
  end

  def include_cookbook(name)
    recipe_file = 'default.rb'

    if name.match(%r{::})
      name, recipe_file = name.split('::', 2)
      recipe_file << '.rb'
    end

    include_recipe ITAMAE_DIR.join('cookbooks', name, recipe_file).to_s
  end
end
Itamae::Recipe::EvalContext.send(:include, RecipeHelper)
Itamae::Resource::Template::RenderContext.send(:include, RecipeHelper)

execute 'apt-get update' do
  action :nothing
end

execute 'systemctl daemon-reload' do
  action :nothing
end

include_cookbook 'libmysqlclient-dev'
include_cookbook 'nginx'
