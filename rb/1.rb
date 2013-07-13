require 'net/http'

url=URI.parse('https://10.32.1.106:443/2/files/xsync/hash/new.txt')
STDOUT << url.host
STDOUT << url.port
Net::HTTP.start(url.host,url.port) do |http|
	request = Net::HTTP::Get.new url.request_uri
	response = http.request request

	case response
	when Net::HTTPSuccess, Net::HTTPRedirection
		#OK
	else
		response.value
	end
end
