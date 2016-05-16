actions :upgrade

property :ilos, Array, :required => true
property :fw_uri, String, :required => true
property :fw_version, Float, :required => true

include IloHelper

action :upgrade do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_fw_version.split(" ").first.to_f
    next if cur_val == fw_version
    converge_by "Upgrade ilo #{client.host} firmware to '#{fw_version.to_s}'" do
      client.set_fw_upgrade(fw_uri)
    end
  end
end