ActiveAdmin.register SiteDataInfo do

  actions :index, :show

  filter :id
  filter :test_id
  filter :Url
  filter :cloudflare, :as => :select, :collection => SiteDataInfo::STATUS.invert


  index do 
    column :id
    column "Test" do |site_data|
      link_to site_data.test.id, admin_test_path(site_data.test)
    end
    column "Url" do |site_data|
      link_to "#{site_data.url.id}:  #{site_data.url.url}", admin_url_path(site_data.url)
    end 
    column "Plugins" do |site|
      link_to 'plugins', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column "Js" do |site|
      link_to 'js', admin_js_infos_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column "Themes" do |site|
      link_to 'themes', admin_themes_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column 'Cloudflare' do |site|
      div (SiteDataInfo::STATUS[site.cloudflare])
    end
  end

  show do
    attributes_table do
      row :id
      row 'url' do |site|
        link_to "#{site.url.id}:: #{site.url.url}", admin_url_path(site.url) 
      end
      row :test
      row :cms_type
      row :cms_version
      row "Plugins" do |site|
        link_to 'plugins', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row "Themes" do |site|
        link_to 'themes', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row "Js" do |site|
        link_to 'js', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row 'Cloudflare' do |site|
        div (SiteDataInfo::STATUS[site.cloudflare])
      end
    end

  end
end
