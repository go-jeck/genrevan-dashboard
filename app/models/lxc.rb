class Lxc
  attr_reader :id, :name, :ip_address, :image, :status, :lxd_id, :host_port, :container_port

  def initialize(id, name, ip_address, image, status, lxd_id, host_port, container_port)
    @id = id
    @name = name
    @ip_address = ip_address
    @image = image
    @status = status
    @lxd_id = lxd_id
    @host_port = host_port
    @container_port = container_port
  end
end
