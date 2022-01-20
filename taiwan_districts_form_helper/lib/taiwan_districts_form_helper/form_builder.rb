require "json"

class TWRegionCityAndDistrict < ActionView::Helpers::FormBuilder
  def self.json_data
    File.read(File.join(File.dirname(__FILE__), "location.json"))
  end

  def region_select(attribute, selected: nil, **options)
    data = load_data

    selected = selected || ""
    select(
      attribute,
      data.map { |d| d["region"] },
      { selected: selected, disabled: "", prompt: "請選擇區域" },
      **options
    )
  end

  def city_select(attribute, selected: nil, region: nil, **options)
    cities = []
    if region
      data = load_data
      found_region = data.find { |d| d["region"] == region }
      cities = found_region["cities"].map { |r| r["name"] }
    end

    selected = selected || ""

    select(
      attribute,
      cities,
      { selected: selected, disabled: "", prompt: "請先選擇區域" },
      **options
    )
  end

  def district_select(attribute, selected: nil, city: nil, **options)
    districts = []

    if city
      data = load_data
      found_city = nil
      data.each do |d|
        found_city = d["cities"].find { |c| c["name"] == city }
        if found_city
          districts = found_city["districts"]
        end
      end
    end

    selected = selected || ""

    select(
      attribute,
      districts,
      { selected: selected, disabled: "", prompt: "請先選擇縣市" },
      **options
    )
  end

  private

  def load_data
    @data ||= JSON.parse(File.read(File.join(File.dirname(__FILE__), "location.json")))
  end
end
