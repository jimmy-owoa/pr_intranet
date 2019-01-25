json.extract! admin_section, :id, :title, :description, :location, :url, :created_at, :updated_at
json.url admin_section_url(admin_section, format: :json)
