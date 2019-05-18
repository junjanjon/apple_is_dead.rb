require 'json'
require 'digest/md5'

HISTORY_FILE = 'history_hash_apple.txt'

def history_hash
	data = File.read(HISTORY_FILE)
	data.to_s
rescue
	''
end

def save_history_hash(hash)
	File.write(HISTORY_FILE, hash)
end

def notice(message)
	# notice
end

def main
	res = %x(curl -s 'https://www.apple.com/support/systemstatus/data/system_status_ja_JP.js')

	json = JSON.parse(res)
	File.write("raw_system_status_ja_JP.js", JSON.pretty_generate(json))

	targetServiceNames = ['App Store', 'Apple ID']
	serviceNames = json['services'].select {|d| targetServiceNames.include?(d['serviceName']) }.select {|d| d['events'].count != 0 }.map {|d| d['serviceName'] }
	p info = json['services'].select {|d| targetServiceNames.include?(d['serviceName']) }.select {|d| d['events'].count != 0 }.map {|d| "#{d['serviceName']}: #{d['events'].last['eventStatus']}" }.join(', ')
	info_hash = Digest::MD5.hexdigest(info)

	if history_hash != info_hash
		if serviceNames.count == 0
			notice("https://www.apple.com/support/systemstatus : All Green")
		else
			notice("https://www.apple.com/support/systemstatus : #{info}")
		end
		save_history_hash(info_hash)
	end
end

main
