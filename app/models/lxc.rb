class Lxc
  attr_reader :id, :name, :ip_address, :image, :status, :lxd_id, :host_port, :container_port, :error_message

  def initialize(id, name, ip_address, image, status, lxd_id, host_port, container_port, error_message)
    @id = id
    @name = name
    @ip_address = ip_address
    @image = image
    @status = status
    @lxd_id = lxd_id
    @host_port = host_port
    @container_port = container_port
    @error_message = error_message
  end
end
