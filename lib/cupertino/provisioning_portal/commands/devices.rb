command :'devices:list' do |c|
  c.syntax = 'ios devices:list'
  c.summary = 'Lists the Name and ID of Devices in the Provisioning Portal'
  c.description = ''

  c.action do |args, options|
    devices = agent.list_devices

    say_ok "Devices:"
    devices.each do |device|
      log device.name, device.udid
    end
  end
end

alias_command :devices, :'devices:list'

command :'devices:add' do |c|
  c.syntax = 'ios devices:add DEVICE_NAME=DEVICE_ID [...]'
  c.summary = 'Adds the a device to the Provisioning Portal'
  c.description = ''

  c.action do |args, options|
    say_error "Missing arguments, expected DEVICE_NAME=DEVICE_ID" and abort if args.nil? or args.empty?

    devices = []
    args.each do |arg|
      components = arg.strip.gsub(/\"/, '').split(/\=/)
      device = Device.new
      device.name = components.first
      device.udid = components.last
      devices << device
    end

    agent.add_devices(*devices)

    say_ok "Added #{devices.length} #{devices.length == 1 ? 'device' : 'devices'}"
  end
end