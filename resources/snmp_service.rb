actions :configure

property :ilos, Array, :required => true
property :snmp_mode, String, :default => 'Agentless', :equal_to => ['Agentless', 'Passthru']
property :snmp_alerts, [TrueClass, FalseClass], :default => false

include IloHelper

action :configure do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val_mode = client.get_snmp_mode
    cur_val_alerts = client.get_snmp_alerts_enabled
    next if cur_val_mode == snmp_mode && cur_val_alerts == snmp_alerts
    converge_by "Set ilo #{client.host} snmp mode from '#{cur_val_mode}' to '#{snmp_mode}' and alerts enabled from '#{cur_val_alerts.to_s}' to '#{snmp_alerts.to_s}'" do
      client.set_snmp(snmp_mode, snmp_alerts)
    end
  end
end