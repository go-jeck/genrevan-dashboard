class LxcsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'httparty'
  require 'json'

  LXC_ENDPOINT = "http://localhost:8000/lxc"

  def index
    @lxcs = Array.new
    response = HTTParty.get(LXC_ENDPOINT)
    lxcs_json = JSON.parse(response.body)
    for lxc_json in lxcs_json do
      lxc = Lxc.new(lxc_json["id"], lxc_json["name"], lxc_json["ip_address"], lxc_json["image"], lxc_json["status"], lxc_json["lxd_id"])
      @lxcs.push(lxc)
    end
  end
end
