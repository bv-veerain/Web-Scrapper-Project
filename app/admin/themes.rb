ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :url_id
  filter :status, as: :select, collection: [["ACTIVE", true], ["INACTIVE", false]]
  filter :first_test
  filter :last_test
  filter :created_at
  filter :updated_at

  scope '', :default => true do |themes|
    themes.group(:theme_slug)
  end

  index do 
    id_column
    column :theme_name
    column "Usage" do |theme|
      args = Hash.new
      args[:theme_slug] = theme.theme_slug 
      if params["test_id"]
        args[:first_test] = -Float::INFINITY..params['test_id'].to_i
        args[:last_test] = params['test_id'].to_i..Float::INFINITY
      end
      url_ids = Theme.where(args).pluck(:url_id)
      link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
    end
    column 'First Test' do |js|
      "Test #{js.first_test}"
    end
    column 'Last Test' do |js|
      "Test #{js.last_test}"
    end

    if params[:q]
      column 'Status' do |theme|
        status = theme.status ? "ACTIVE" : "INACTIVE"
        color = theme.status ? "green" : "red"
        div status, style: "color: #{color}"
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :theme_name
      row "Usage" do |theme|
        url_ids = Theme.where(:theme_name => theme.theme_name, :status => true).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
      row :first_test
      row :last_test
      if params[:q]
        row 'Status' do |theme|
          status = theme.status ? "ACTIVE" : "INACTIVE"
          color = theme.status ? "green" : "red"
          div status, style: "color: #{color}"
        end
      end
    end
  end

end
