class LxcsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'httparty'
  require 'json'

  LXC_ENDPOINT = "http://localhost:8000/lxc"
  IMAGE_ENDPOINT = "http://localhost:8000/images"

  def index
    @lxcs = Array.new
    
    begin
      response = HTTParty.get(LXC_ENDPOINT)
      lxcs_json = JSON.parse(response.body)
      for lxc_json in lxcs_json do
        if lxc_json["status"] != "deleted"
          lxc = Lxc.new(lxc_json["id"], lxc_json["name"], 
            lxc_json["ip_address"], lxc_json["image"], 
            lxc_json["status"], lxc_json["lxd_id"], 
            lxc_json["host_port"], lxc_json["container_port"], 
            lxc_json["error_message"])
          @lxcs.push(lxc)
        end
      end
    rescue Errno::ECONNREFUSED
      render :file => 'public/503.html', :status => :error, :layout => false
    end
  end

  def new
    response = HTTParty.get(IMAGE_ENDPOINT)
    image_list_json = JSON.parse(response.body)
    @image_list = Array.new
    image_list_json.each do |image|
      @image_list.push(image)
    end
  end

  def create
    req_body = {
      "name" => "#{params["name"]}",
      "image" => "#{params["image"]}",
      "containerPort" => "#{params["containerPort"]}"
    }

    response = HTTParty.post(LXC_ENDPOINT,
      :body => req_body,
      :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })

    case response.code
    when 201
      redirect_to "/lxc"
    when 400
      redirect_to "/lxc", danger: "bad request"
    when 500
      response_body = JSON.parse(response.body)
      error_message = response_body["error"]
      redirect_to "/lxc", danger: error_message
    end
  end
end
