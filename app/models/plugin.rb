class Plugin < ApplicationRecord
  belongs_to :url, default: nil

  def self.import_plugins(plugins, url_id, test_id)
    plugins_id = []
    plugins.each do |slug|
      _plugin = Plugin.where(plugin_slug: slug, url_id: url_id, status: true).first
      if _plugin 
        _version = _plugin.version
        if  _version != '1.1'
          _plugin.status = false
          _plugin.save
          plugin_name = PluginSlug.where(:slug => slug).first&.name || slug
          new_plugin = Plugin.create(:first_seen => test_id, :last_seen => test_id, :plugin_name => plugin_name, 
                                     plugin_slug: slug, url_id: url_id, status: true, version: '1.1')
          plugins_id << new_plugin.id
        else
          _plugin.update(:last_seen => test_id)
          plugins_id << _plugin.id
        end
      else
        plugin_name = PluginSlug.where(:slug => slug).first&.name || slug
        new_plugin = Plugin.create(:first_seen => test_id, :last_seen => test_id, plugin_name: plugin_name, 
                                   :plugin_slug => slug, url_id: url_id, status: true, version: '1.1')
        plugins_id << new_plugin.id
      end
    end
    last_plugins = Url.find(url_id).site_data_infos.last&.plugins
    done = inactive_removed_plugins(last_plugins, plugins_id) if last_plugins.present?
    return plugins_id
  end

  def self.inactive_removed_plugins(last_plugins, plugins_id)
    removed_plugins = last_plugins - plugins_id
    removed_plugins.each do |id|
      Plugin.find(id).update(:status => false)
    end
    return true
  end
end
