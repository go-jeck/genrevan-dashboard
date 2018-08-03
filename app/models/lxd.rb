class Lxd
  attr_reader :id, :name, :ip_address

  def initialize(id, name, ip_address)
    @id = id
    @name = name
    @ip_address = ip_address
  end
end
