class LxcsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'httparty'
  require 'json'

  LXC_ENDPOINT = "http://localhost:8000/lxc"

  def index
    @lxcs = Array.new
    
    begin
      response = HTTParty.get(LXC_ENDPOINT)
      lxcs_json = JSON.parse(response.body)
      for lxc_json in lxcs_json do
        lxc = Lxc.new(lxc_json["id"], lxc_json["name"], lxc_json["ip_address"], lxc_json["image"], lxc_json["status"], lxc_json["lxd_id"])
        @lxcs.push(lxc)
      end
    rescue Errno::ECONNREFUSED
      render :file => 'public/503.html', :status => :error, :layout => false
    end
  end

  def new
  end

  def create
    req_body = {
      "name" => "#{params["name"]}",
      "image" => "#{params["image"]}"
    }

    response = HTTParty.post(LXC_ENDPOINT,
      :body => req_body,
      :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })

    case response.code
    when 201
      puts "success"
    when 400
      puts "bad request"
    when 500
      puts "internal server error"
    end
    
    redirect_to "/lxc"
  end
end
