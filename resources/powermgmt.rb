actions :poweron, :poweroff, :resetsys, :resetilo
property :username, String
property :password, String
property :ilo_names, [Array,Symbol]
include RestAPI::Helper
include ::ILOINFO

action :poweron do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono[ilo]
      cur_val = get_power_state(machine)
      next if cur_val == "On"
      converge_by "Powering on #{ilo} ... " do
        power_on(machine)
      end
    end
  else
    ilono.each do |name,site|
      cur_val = get_power_state(site)
      next if cur_val == "On"
      converge_by "Powering on #{site} ... " do
        power_on(site)
      end
    end
  end
end

action :poweroff do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono[ilo]
      cur_val = get_power_state(machine)
      next if cur_val == "Off"
      converge_by "Powering Off #{ilo} ... " do
        power_off(machine)
      end
    end
  else
    ilono.each do |name,site|
      cur_val = get_power_state(site)
      next if cur_val == "Off"
      converge_by "Powering Off #{site} ... " do
        power_off(site)
      end
    end
  end
end


action :resetsys do
  if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_server(machine)
    end
  else
    ilono.each do |name,site|
      reset_server(site)
    end
  end
end

action :resetilo do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_ilo(machine)
    end
  else
    ilono.each do |name,site|
      reset_ilo(site)
    end
  end
end