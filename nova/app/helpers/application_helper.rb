# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      title: default_meta('title'),
      description: default_meta('description'),
      site: 'Nova',
      separator: '-',
      canonical: canonical_href,
      reverse: true,
    }
  end

  def default_meta(key)
    scopes = (controller_path.split('/') + [action_name]).select(&:present?)

    defaults = scopes.map.with_index do |_scope, index|
      scope = scopes[0..index]
      (scope.join('.') + ".#{key}").to_sym
    end
    defaults.reverse!
    defaults.push('')

    scope = defaults.shift.to_s
    t(scope, default: defaults)
  end

  def html_classes
    [
      "#{controller_path.tr('/', '-')}-controller",
      "#{action_name}-action",
    ].reject { |klass| klass.start_with?('-') }
  end
end
