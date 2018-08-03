class LxdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'httparty'
  require 'json'

  LXD_ENDPOINT = "http://localhost:8000/lxd"
  LXC_OF_LXD_ENDPOINT = "http://localhost:8000/lxc/lxd"

  def index
    begin
      @lxds = Array.new
      response = HTTParty.get(LXD_ENDPOINT)
      lxds_json = JSON.parse(response.body)
      for lxd_json in lxds_json do
        lxd = Lxd.new(lxd_json["id"], lxd_json["name"], lxd_json["ip_address"])
        @lxds.push(lxd)
      end
    rescue Errno::ECONNREFUSED
      render :file => 'public/503.html', :status => :error, :layout => false
    end
  end

  def detail
    begin
      lxd_id = params[:id]
      lxd_response = HTTParty.get(LXD_ENDPOINT + "/#{lxd_id}")
      lxd_json = JSON.parse(lxd_response.body)
      @lxd = Lxd.new(lxd_json["id"], lxd_json["name"], lxd_json["ip_address"])

      @lxcs = Array.new
      lxcs_response = HTTParty.get(LXC_OF_LXD_ENDPOINT + "/#{lxd_id}")
      lxcs_json = JSON.parse(lxcs_response.body)
      for lxc_json in lxcs_json do
        lxc = Lxc.new(lxc_json["id"], lxc_json["name"], lxc_json["ip_address"], lxc_json["image"], lxc_json["status"], lxc_json["lxd_id"])
        @lxcs.push(lxc)
      end
    rescue Errno::ECONNREFUSED
      render :file => 'public/503.html', :status => :error, :layout => false
    end
  end
end
