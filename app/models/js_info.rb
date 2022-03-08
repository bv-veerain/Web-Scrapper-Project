class JsInfo < ApplicationRecord

  belongs_to :url , default: nil

  def self.import_js(all_js, _url, test_id)
    js_id = []
    all_js.each do |js|
      _js = JsInfo.where(js_lib: js[0], url_id: _url, status: true).first
      if _js
        _version = _js.version
        # version 1.1 is used for testing only
        # finding better way to find js version
        if  _version != js[1]
          _js.status = false
          _js.save
          new_js = JsInfo.create(:first_seen => test_id, :last_seen => test_id, :js_lib => js[0], 
                                 :url_id => _url, :status => true, :version => js[1] )
          js_id << new_js.id
        else
          _js.update(:last_seen => test_id)
          js_id << _js.id
        end
      else
        new_js = JsInfo.create(:first_seen => test_id, :last_seen => test_id, :js_lib => js[0], 
                               :url_id => _url, :status => true, :version => js[1] )
        js_id << new_js.id
      end
    end
    last_js = Url.find(_url)&.site_data_infos.last&.js
    done = inactive_removed_js(last_js, js_id) if last_js.present?
    return js_id
  end

  def self.inactive_removed_js(last_js, js_id)
    removed_js = last_js - js_id
    removed_js.each do |id|
      JsInfo.find(id).update(:status => false)
    end
    return true
  end
end
