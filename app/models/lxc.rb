class Lxc
  attr_reader :id, :name, :ip_address, :image, :status, :lxd_id

  def initialize(id, name, ip_address, image, status, lxd_id)
    @id = id
    @name = name
    @ip_address = ip_address
    @image = image
    @status = status
    @lxd_id = lxd_id
  end
end
