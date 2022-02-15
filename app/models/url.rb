class Url < ApplicationRecord
  has_many :plugins
  has_many :themes
  belongs_to :site_data_info,required: false


  def self.import_url(url)
    _url = Url.create(url: url, site_data_info_id: nil)
    return _url.id
  end

  def self.import_urls(data)
    data.each do |key, value|
      _url = Url.where(url: key).first
      if !_url
        _url = Url.create(url: key, site_data_info_id: nil)
      end
      # later need to add some code
      # _url will be used here
    end
  end

end
