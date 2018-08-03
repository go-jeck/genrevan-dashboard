class LxdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'httparty'
  require 'json'

  LXD_ENDPOINT = "http://localhost:8000/lxd"
  def index
    @lxds = Array.new
    response = HTTParty.get(LXD_ENDPOINT)
    json_lxds = JSON.parse(response.body)
    for lxd_json in json_lxds do
      lxd = Lxd.new(lxd_json["id"], lxd_json["name"], lxd_json["ip_address"])
      @lxds.push(lxd)
    end
  end
  def detail
    puts params[:id]
  end
end
