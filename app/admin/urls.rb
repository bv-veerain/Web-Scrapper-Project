ActiveAdmin.register Url do
  actions :index, :show
  filter :id
  filter :site_data_infos_last_id
  controller do 
    def scoped_collection
      Url.site_data_info
    end
  end
  index do
    column :id
    column 'Versions' do |url|
      link_to 'versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
    end
    column :url
    column 'Plugins' do |url|
      plugins = url.site_data_infos.last.plugins
      if JSON::parse(plugins).size > 0
        link_to 'plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1), style: "color:green; text:bold"
      else
        "plugin not found"
      end
    end
    column 'Themes' do |url|
      themes = url.site_data_infos.last.themes
      if JSON::parse(themes).size > 0
        link_to 'themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
      else
        "themes not found"
      end
    end
    column 'Js' do |url|
      link_to 'js_info', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
    end
    column 'Cloudflare' do |url|
      div (SiteDataInfo::STATUS[url.site_data_infos.last.cloudflare])
    end
    column 'LastTest' do |url|
      link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
    end

  end

  show do 
    attributes_table do
      row :url
      row 'Site Data Info' do |url|
        link_to url.site_data_infos.last, admin_site_data_info_path(url.site_data_info_id)
      end
    end
  end
end
