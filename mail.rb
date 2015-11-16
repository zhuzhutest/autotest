require 'net/smtp'
require 'mailfactory'
module KR
    def self.send_mail(msg, from, to, attachment=nil)
        mail=MailFactory.new
        mail.to=['344264366@qq.com']
        mail.from='344264366@qq.com'
        mail.subject='krplus auto-test results'
        if attachment
            attachment.is_a?(Array) or attachment = [attachment] 
            attachment.each {|ele| mail.attach(ele) }
        end
        mail.text = msg
        Net::SMTP.start('smtp.qq.com', 25, '344264366@qq.com', '344264366@qq.com', 'bfi_322zgl', :plain) do |smtp|
            smtp.send_message mail.to_s, from, to 
        end
    end
end
if __FILE__ == $0
    msg = "china abc\nenglish    germney abc\ntest    info   def"
    KR::send_mail(msg, "344264366@qq.com", "344264366@qq.com")
end

