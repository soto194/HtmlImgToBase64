require 'nokogiri'
require 'base64'
require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#input
f = File.open("input.txt", :encoding => Encoding::UTF_8)
html = f.read
f.close
#puts html

charset = nil
doc = Nokogiri::HTML.parse(html, nil, charset)
#puts doc

doc.css("img").each do |img|
	puts "---"
	imgSrc = img.attribute("src").to_s.strip
	puts imgSrc
	imgBase64 = Base64.strict_encode64(open(imgSrc).read)
	puts imgBase64.length

	extension = File.extname(imgSrc).downcase
	prefix = if (extension == ".gif") then
		"data:image/gif;base64,"
	elsif (extension == ".png") then 
		"data:image/png;base64,"
	else 
		"data:image/jpg;base64,"
	end
	puts prefix

	img["src"] = prefix + imgBase64
	#puts img
end
#puts doc


#output
File.open("output.txt", 'w') {|file|
 file.write doc
}
