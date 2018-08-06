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
        if lxc_json["status"] != "deleted"
          lxc = Lxc.new(lxc_json["id"], lxc_json["name"], lxc_json["ip_address"], lxc_json["image"], lxc_json["status"], lxc_json["lxd_id"])
          @lxcs.push(lxc)
        end
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

  def change_state
    lxc_id = params[:id]

    case params[:state]
    when "stop"
      lxc_new_state = "stopped"
    when "start"
      lxc_new_state = "started"
    when "delete"
      lxc_new_state = "deleted"
    end
    
    req_body = {
      "state" => "#{lxc_new_state}",
    }

    response = HTTParty.patch(LXC_ENDPOINT+"/"+lxc_id+"/state",
      :body => req_body,
      :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })

    case response.code
    when 204
      puts "update state to " + lxc_new_state + "success"
    else
      puts "something goes wrong!"
    end

    redirect_to "/lxc"
  end
end
