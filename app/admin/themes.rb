ActiveAdmin.register_page "Themes" do
  sidebar :filters do
    render partial: 'filter'
  end


  content do 
    args = {}
    if params["q"]
      args[:id.in] = params["q"]["id_in"] if params["q"]["id_in"].present?
      args[:website_id] = params["q"]["website_id_equals"] if params["q"]["website_id_equals"].present?
    end
    manual_checks = ["created_from", "created_to", "updated_from", "updated_to"]
    time_frame = {:created_at => ["created_from", "created_to"], :updated_at => ["updated_from", "updated_to"]}
    sidebar_filters = params["sidebar_filters"]
    if sidebar_filters.present?
      sidebar_filters.each do |key, value|
        if !manual_checks.include?key and value.present?
          args[key] = value
        end
      end
      time_frame.each do |key, value|
        from = sidebar_filters[value[0]].present? ? sidebar_filters[value[0]] : V2::Test.first.created_at
        to = sidebar_filters[value[1]].present? ? sidebar_filters[value[1]] : Time.now
        args[key] = from..to
      end
    end

    panel "Themes" do
      table_for V2::Theme.where(args) do

        column :id
        column :theme_name
        column "Usage" do |theme|
          args = Hash.new
          args[:theme_slug] = theme.theme_slug 
          if params["test_id"]
            args[:first_test] = -Float::INFINITY..params['test_id'].to_i
            args[:last_test] = params['test_id'].to_i..Float::INFINITY
          end
          website_ids = V2::Theme.where(args).pluck(:website_id)
          link_to "#{website_ids.count} :: urls", admin_websites_path("q[id_in]" => website_ids)
        end
        column 'First Test' do |js|
          "Test #{js.first_test}"
        end
        column 'Last Test' do |js|
          "Test #{js.last_test}"
        end

        if params[:q]
          column 'Status' do |theme|
            status = theme.is_active ? "ACTIVE" : "INACTIVE"
            color = theme.is_active ? "green" : "red"
            div status, style: "color: #{color}"
          end
        end
      end
    end
  end
end
