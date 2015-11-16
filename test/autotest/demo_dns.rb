require 'watir-webdriver'
require 'win32ole'
require 'Dnsruby'
require 'timeout'
require 'net/ssh'
require 'net/sftp'
require 'gen_named'

module KR
    module DNS
        extend self
        attr_accessor :context
        def self.set(context) 
        end
        def self.popwin
            KR.browser.div(:id, "popWin")
        end
        def self.close_popwin
            sleep 1
            popwin.button(:class, "cancel").click
        end
        def self.open_dns_page
            sleep 0.5
            KR.browser.link(:class, "dns").click
            sleep 1
        end
        def self.open_share_rr_page
            open_dns_page
            KR.browser.link(:class, "shared-rrs").click
            sleep 2
        end
        def self.open_search_page
            open_dns_page
            KR.browser.link(:class, "search").click
            sleep 2
        end
        def self.open_acl_page
            open_dns_page
            KR.browser.link(:class, "acls").click
            sleep 2
        end
        def self.open_selected_elem_page
            KR.browser.div(:id, "mainTable").table(:index, 1).div(:index, 0).click
            waiting_operate_finished
        end
        def self.open_view_page
            open_selected_elem_page
        end
        def self.open_zone_page
            open_selected_elem_page
        end
        def self.open_domain_page
            open_selected_elem_page
        end
        def self.popup_right_menu(operation="create", selected=false)
            if selected
                KR.browser.div(:id, "mainTable").checkbox(:class, "checkAll").set
            end
            KR.browser.div(:id, "toolsBar").button(:class, operation).click
            sleep 1
        end
        def self.del_current_elem(id="ok")
            KR.browser.table(:index, 1).checkbox(:index, 0).set
            #KR.browser.div(:id, "mainTable").checkbox(:class, "checkAll").set
            KR.browser.div(:id, "toolsBar").button(:class, "del").click
            sleep 1
            DNS.popwin.button(:class, id).click
            waiting_operate_finished
        end
        def self.search_elem(elem_name)
            KR.browser.div(:id, "search").text_field(:class, "search").set(elem_name)
            KR.browser.div(:id, "search").button(:class, "searchBut").click
        end
        def self.elem_exists?(elem_name)
            search_elem(elem_name)
            result = get_cur_elem_string.to_s.include?(elem_name)
            return result
        end
        def self.view_exists?(view_name)
            return elem_exists?(view_name)
        end
        def self.zone_exists?(zone_name)
            return elem_exists?(zone_name)
        end
        def self.domain_exists?(domain_name)
            return elem_exists?(domain_name)
        end
        def self.acl_exists?(acl_name)
            return elem_exists?(acl_name)
        end
        def self.get_index(elem_name, pos=1)
            elem_name = elem_name[0..-2] if elem_name[-1] == '.'
            puts "get elem #{elem_name}"
            content = KR.browser.div(:id, "mainTable").table(:index, 1).strings
            content.each_index { |i|
                content[i][pos] = content[i][pos][0..-2] if content[i][pos][-1] == '.'
                return i if content[i][pos] == elem_name
            }
            return nil
        end
        def self.share_rr_exists?(share_rr_name)
            return elem_exists?(share_rr_name)
        end
        def self.search_exists?(name)
            return elem_exists?(name)
        end
        def self.get_elem_num
            return get_cur_elem_string.length
        end
        def self.get_cur_elem_string(name="NULL")
            if name != "NULL"
                KR.browser.div(:id, "search").text_field(:class, "search").set(name)
            end
            KR.browser.div(:id, "search").button(:class, "searchBut").click
            content = KR.browser.div(:id, "mainTable").table(:index, 1).strings
            if !content
               content = get_cur_elem_string(name)
            end
            return content
        end
        def self.get_acl_network
            return context[0][3]
        end
        def self.get_view_priorty
            return context[0][3]
        end
        def self.get_view_acl
            return context[0][5]
        end
        def self.get_view_dns64
            return context[0][6]
        end
        def self.get_view_device
            return context[0][2]
        end
        def self.get_zone_device
            return context[0][2]
        end
        def self.get_zone_ttl
            return context[0][3]
        end
        def self.get_domain_ttl
            return context[0][2]
        end
        def self.get_domain_rtype
            return context[0][3]
        end
        def self.get_domain_rdata
            return context[0][4]
        end
        def self.get_share_rr_owner
            return context[0][5]
        end
        def self.get_search_rname
            return context[0][4]
        end
        def self.get_search_ttl
            return context[0][5]
        end
        def self.get_search_rdata
            return context[0][7]
        end
        def self.get_soa_ttl
            return context[0][2]
        end
        def self.get_soa_rdata
            return context[0][4]
        end
        def self.waiting_operate_finished(args=nil)
            begin
                Timeout::timeout(120) {
                while DNS.popwin.present? do
                    sleep 1
                    if args && args[:error_type]
                        case args[:error_type].downcase
                        when "invalid"
                            if DNS.popwin.span(:class, "redtip").present?
                                r = "succeed to check error input #{args}\n error: invalid input\n"
                            else
                                r = "failed to check error input #{args}\n"
                            end
                            DNS.popwin.button(:class, "cancel").click
                            puts r
                            return r
                        when "exist"
                            begin
                            DNS.popwin.button(:class, "save").click
                            content = DNS.popwin.div(:class, "flashError").text
                            DNS.popwin.button(:class, "cancel").click
                                r = "succeed to check error input #{args}\n error: #{content}\n"
                            rescue
                                r = "failed to check error input #{args}\n"
                            end
                            puts r
                            return r
                        end
                    else
                         if DNS.popwin.present?
                             DNS.popwin.button(:class, "save").click
                             #KR.screen("saving.png")
                             while DNS.popwin.present?
                                 sleep 1
                             end
                         end
                         #while KR.browser.element(:id, "masker").present?
                         #     puts "master..."
                         #    sleep 1
                         #end
                    end
                 end
                sleep 1
            }
            rescue Timeout::Error
                content = DNS.popwin.div(:class, "flashError").text
                puts content
                if content.include?("已存在")
                    puts "skip this case..."
                    DNS.popwin.button(:class, "cancel").click
                else
                    waiting_operate_finished
                end
            end
            return nil
        end
        def self.send_enter
            KR.browser.send_keys("\r\n")
        end
        def self.send_newline
            KR.browser.send_keys("\n")
        end
        def self.open_dialog(file_path)
            autoit = WIN32OLE.new('AutoItX3.Control')    #init autoit
            autoit.WinWaitActive("打开", "", 9)    #acitve choose file window
            sleep 1
            autoit.ControlSetText("打开", "", "Edit1", file_path)    #input zone file path
            sleep 1
            autoit.ControlClick("打开", "", "Button2")    #click open button
            sleep 1
        end
        def self.goto_specify_page(view_name, zone_name=nil)
            r = false
            sleep 1
            open_dns_page
            if view_exists?(view_name)
                sleep 1
                open_view_page
                r = true
                if (zone_name && zone_exists?(zone_name))
                    open_zone_page
                elsif (zone_name && !zone_exists?(zone_name))
                    r = false
                end
            else
                r = false 
            end
            return r
        end
        def self.add_rr(domain, set_name=true)
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(domain["rname"]) if set_name
            DNS.popwin.select(:name, "type").select(domain["rtype"])
            sleep 1
            DNS.popwin.text_field(:name, "rdata").set(domain["rdata"])
            sleep 1
            DNS.popwin.text_field(:name, "ttl").set(domain["ttl"])
            DNS.popwin.checkbox(:name, "link_ptr").set if domain["auto_ptr"]
            err = DNS.waiting_operate_finished(domain)
            return err if err
            return nil
        end
        def self.start_other_bind
            conf =KR::NAMED.gen_named_conf(:dir=>REMOTE_NAMED_DIR, :ip=>SLAVE_IP, :port=>TRANFER_PORT, :client_network=>LOCAL_NETWORK)
            File.open(LOCAL_NAMED_DIR + '/named.conf', 'w') {|file| file.puts conf}
            Net::SSH.start(SLAVE_IP, USER, :password => PASSWD_S) do|ssh|
                ssh.exec!("mkdir -p #{REMOTE_NAMED_DIR}")
                ssh.sftp.connect do |sftp|
                    sftp.upload!(LOCAL_NAMED_DIR, REMOTE_NAMED_DIR)
                end 
                ssh.exec!("named -c #{REMOTE_NAMED_DIR}/named.conf")
            end 
            puts "upload named and start named ok"
        end
        def self.stop_other_bind
            Net::SSH.start(SLAVE_IP, USER, :password => PASSWD_S) do|ssh|
                ssh.exec!("ps axu|grep named_etc|grep -v grep|awk '{print $2}' |xargs kill -9")
            end 
        end
        class ACL
            def create_acl(args)
                @acl_name = args[:acl_name]
                @acl_list = args[:acl_list]
                @file_path = args[:filename]

                DNS.open_acl_page
                DNS.popup_right_menu

                DNS.popwin.text_field(:name, "name").set(@acl_name)
                if @file_path
                    DNS.popwin.file_field(:id, "networksFile").click
                    DNS.open_dialog(@file_path)
                else
                    @acl_list.each { |acl|
                        DNS.popwin.textarea(:name, "networks").append(acl)
                        DNS.send_newline
                    }
                end
                err = DNS.waiting_operate_finished(args)
                return err if err
                r = ""
                if DNS.acl_exists?(@acl_name)
                    r += "succeed to create acl: #{@acl_name}\n"
                else
                    r += "failed to create acl: #{@acl_name}\n"
                end
                puts r
                return r
            end
            def edit_acl(args)
                r = ""
                @acl_name = args[:acl_name]
                @del_ip = args[:del_ip]
                @add_ip = args[:add_ip]
                DNS.open_acl_page
                if DNS.acl_exists?(@acl_name)
                    DNS.popup_right_menu("edit", true)
                    acl_list = DNS.popwin.textarea(:name, "networks").value.split("\n")
                    acl_list -= @del_ip
                    acl_list += @add_ip
                    DNS.popwin.textarea(:name, "networks").set(acl_list.join("\n"))
                    DNS.popwin.button(:class, "save").click
                    err = DNS.waiting_operate_finished(args)
                    return err if err
                    DNS.context = DNS.get_cur_elem_string
                    acl_list.each {|acl|
                        if !DNS.get_acl_network.include?(acl)
                            r += "failed to edit acl: #{@acl_name}\n"
                        end
                    }
                    r += "succeed to edit acl: #{@acl_name}\n" if !r.match("failed")
                else
                    r += "not find acl: #{@acl_name}\n"
                end
                puts r
                return r
            end
            def del_acl(acl_list)
                r = ""
                DNS.open_acl_page
                acl_list.each { |acl_name|
                    if DNS.acl_exists?(acl_name)
                        DNS.del_current_elem("ok")
                        r += "succeed to del acl: #{acl_name}\n"
                    else
                        r += "not find acl: #{acl_name}\n"
                    end
                }
                puts r
                return r
            end
        end
        class VIEW
            def create_view(args)
                @view_name = args[:view_name]
                @acl_list= args[:acl_list]
                @dns64_list= args[:dns64_list]
                @owner_list = args[:owner_list]
                DNS.open_dns_page
                DNS.popup_right_menu

                DNS.popwin.text_field(:name, "name").set(@view_name)
                @owner_list.each { |owner|
                    DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                    DNS.send_enter
                }
                @acl_list.each { |acl|
                    DNS.popwin.text_field(:value, "选择访问控制以启用视图").set(acl)
                    DNS.send_enter
                }
                @dns64_list.each {|dns64|
                    DNS.popwin.textarea(:name, "dns64s").append(dns64)
                    DNS.send_newline
                }
                err = DNS.waiting_operate_finished(args)
                return err if err
                return check_view
            end
            
            def order_view(args)
                @view_name = args[:view_name]
                @priority = args[:priority]
                DNS.open_dns_page
                if DNS.view_exists?(@view_name)
                    DNS.popup_right_menu("reorder", true)
                    DNS.popwin.text_field(:name, "priority").set(@priority)
                    DNS.popwin.button(:class, "save").click
                    DNS.waiting_operate_finished
                else
                    r = "failed reorder view #{@view_name} due to not exits\n"
                end
                DNS.context = DNS.get_cur_elem_string(@view_name)
                if DNS.get_view_priorty == @priority
                    r = "succeed to reorder view: #{@view_name} priority: #{@priority}\n"
                else
                    r = "failed to reorder view: #{@view_name} priority: #{@priority}\n"
                end
                puts r
                return r
            end
            def edit_view(args)
                @view_name = args[:view_name]
                @add_acl = args[:add_acl]
                @del_acl = args[:del_acl]
                @dns64_list= args[:dns64_list]
                DNS.open_dns_page
                if DNS.view_exists?(@view_name) then
                    DNS.popup_right_menu("edit", true)
                    DNS.popwin.text_field(:name, "dns64s").clear
                    @dns64_list.each { |dns64|
                        DNS.popwin.textarea(:name, "dns64s").append(dns64)
                        DNS.send_newline
                    }
                    @add_acl.each {|acl|
                        DNS.popwin.text_field(:value, "选择访问控制以启用视图").set(acl)
                        DNS.send_enter
                    }
                    err = DNS.waiting_operate_finished(args)
                    return err if err
                    return check_view("edit")
                end
            end

            def check_view(operation="create")
                r = ""
                bsucc = true
                DNS.context = DNS.get_cur_elem_string(@view_name)
                if operation == "create" || operation == "modify" 
                    @owner_list.each {|e|
                        if !DNS.get_view_device.include?(e)
                            bsucc = false
                            break
                        end
                    }
                    r += bsucc ?  "succeed" :  "failed"
                else
                    if DNS.get_view_acl.include?(@add_acl.join(', ')) && DNS.get_view_dns64.include?(@dns64_list.join(', ').downcase)
                        r += "succeed"
                    else
                        r += "failed"
                    end
                end
                r += " to #{operation} view: #{@view_name}\n"
                puts r
                return r
            end
            def modify_view(args)
                DNS.open_dns_page
                @view_name = args[:view_name]
                @owner_list = args[:owner_list]
                if DNS.view_exists?(@view_name)
                    DNS.popup_right_menu("modifyByMembers", true)
                    @owner_list.each_index { |i|
                        next if i == 0
                        DNS.popwin.text_field(:value, "选择设备节点").set(@owner_list[i])
                        DNS.send_enter
                    }
                    DNS.popwin.button(:class, "save").click
                    DNS.waiting_operate_finished
                end
                return check_view("modify")
            end
            def del_view(view_list)
                r = ""
                DNS.open_dns_page
                view_list.each { |view_name|
                    if DNS.view_exists?(view_name)
                        DNS.del_current_elem
                    end
                }
                view_list.each { |view_name|
                    if !DNS.view_exists?(view_name)
                        r += "succeed to del view: #{view_name}\n"
                    else
                        r += "failed to del view: #{view_name}\n"
                    end
                }
                puts r
                return r
            end
        end

        class ZONE
            def create_zone(args)
                @zone_type = args[:zone_type]
                @view_name = args[:view_name]
                @zone_name = args[:zone_name]
                @owner_list = args[:owner]
                @ad_acl = args[:ad_acl]
                r = ""
                if DNS.goto_specify_page(@view_name)
                    DNS.popup_right_menu
                    if @zone_type == "slave"
                        DNS.popwin.select(:name, "server_type").select("辅区")
                        DNS.popwin.textarea(:name, "masters").set(SLAVE_IP + "#" + TRANFER_PORT)
                    elsif @zone_type == 'in-addr'
                        DNS.popwin.select(:name, "type").select("反向区")
                    end
                    if @zone_type == 'in-addr'
                        DNS.popwin.text_field(:name, "network").set(@zone_name)
                        subnet = @zone_name.split(".") 
                        mask = subnet[-1].split("/")[-1].to_i / 8
                        prefix = subnet[0..mask-1].reverse.join(".")
                        @zone_name =  prefix + ".in-addr.arpa"
                    else
                        DNS.popwin.text_field(:name, "name").set(@zone_name)
                    end
                    sleep 1
                    @owner_list.each { |owner|
                        DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                        DNS.send_enter
                    }
                    if @ad_acl
                        DNS.popwin.text_field(:value, "选择访问控制").set(@ad_acl)
                        DNS.send_enter
                    end

                    err = DNS.waiting_operate_finished(args)
                    return err if err
                else
                    r += "no find view: #{@view_name}"
                end
                r += check_zone("create")
                return r
            end
            def create_slave_zone(args)
                DNS.start_other_bind
                begin
                    r = create_zone(args)
                    puts "start check slave zone"
                    r += DOMAIN.check_domain(args[:view_name], args[:zone_name], args[:domain_list], "check domain in slave zone", reopen=true)
                    puts r
                rescue
                    puts "#{$!} at: #{$@}"
                    r = "failed test slave zone"
                ensure
                    DNS.stop_other_bind
                end
                return r
            end
            def create_zone_from_file(args)
                @view_name = args[:view_name]
                @zone_name = args[:zone_name]
                @zone_file = args[:zone_file]
                @owner_list = args[:owner]
                r = ""
                if DNS.goto_specify_page(@view_name)
                    DNS.popup_right_menu
                    DNS.popwin.radio(:value, "zone_file").set
                    DNS.popwin.text_field(:name, "name").set(@zone_name)
                    sleep 1
                    @owner_list.each { |owner|
                        DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                        DNS.send_enter
                    }
                    DNS.popwin.file_field(:name, "zone_file").click
                    sleep 1
                    DNS.open_dialog(@zone_file)
                    err = DNS.waiting_operate_finished(args)
                    return err if err
                else
                    r += "no find view: #{@view_name}"
                end
                r += check_zone("create_from_file")
                return r
            end
            def create_zone_from_copy(args)
                @src_view = args[:src_view]
                @view_name = args[:dst_view]
                @zone_name = args[:zone_name]
                @owner_list = args[:owner]
                r = ""
                if DNS.goto_specify_page(@view_name)
                    DNS.popup_right_menu
                    DNS.popwin.radio(:value, "zone_copy").set
                    sleep 1
                    @owner_list.each { |owner|
                        DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                        DNS.send_enter
                    }
                    DNS.popwin.select(:name, "view_and_zone").select(@zone_name)
                    sleep 1
                    err = DNS.waiting_operate_finished(args)
                    return err if err
                else
                    r += puts "failed find view: #{@view_name}"
                end
                r += check_zone("create_from_copy")
                return r
            end
            def create_zone_from_transfer(args)
                DNS.start_other_bind
                @view_name = args[:view_name]
                @zone_name = args[:zone_name]
                @owner_list = args[:owner]
                @domain_list = args[:domain_list]
                r = ""
                begin
                    if DNS.goto_specify_page(@view_name)
                        DNS.popup_right_menu
                        DNS.popwin.radio(:value, "zone_transfer").set
                        sleep 1
                        DNS.popwin.text_field(:name, "name").set(@zone_name)
                        @owner_list.each { |owner|
                            DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                            DNS.send_enter
                        }
                        DNS.popwin.text_field(:name, "zone_owner_server").set(SLAVE_IP+ '#' + TRANFER_PORT)
                        sleep 1
                        err = DNS.waiting_operate_finished(args)
                        return err if err
                    else
                        r += puts "failed to find view: #{@view_name}"
                    end
                    r += check_zone("create_from_transter")
                    r += DOMAIN.check_domain(@view_name, @zone_name, @domain_list, "check domain in transfer zone", reopen=true)
                rescue
                    puts "#{$!} at: #{$@}"
                    r = "failed test transfer zone"
                ensure
                    DNS.stop_other_bind
                end
                puts r
                return r
            end
            def check_zone(operation="create")
                r = ""
                DNS.context = DNS.get_cur_elem_string(@zone_name)
                @zone_name = '.' if @zone_name == '@'
                if DNS.get_zone_device.include?(@owner_list.join('. ')) && DNS.get_zone_ttl.to_i != 0
                    r += "succeed to #{operation} zone: #{@zone_name} in view: #{@view_name} owner_list: #{@owner_list}\n"
                else
                    failed = false
                    @owner_list.each_index {|i|
                        if !DNS.get_zone_device.include?(@owner_list[i])
                           r += "failed to #{operation} zone: #{@zone_name} in view: #{@view_name} in device: #{@owner_list[i]}\n"
                           failed = true 
                        end
                    }
                    if !failed
                        r += "succeed to #{operation} zone: #{@zone_name} in view: #{@view_name} owner_list: #{@owner_list}\n"
                    end
                end
                puts r
                return r
            end
            def modify_zone(args)
                r = ""
                DNS.open_dns_page
                @view_name = args[:view_name]
                @zone_name = args[:zone_name]
                @owner_list = args[:owner_list]
                if DNS.goto_specify_page(@view_name)
                    if DNS.zone_exists?(@zone_name)
                        DNS.popup_right_menu("modifyByMembers", true)
                        @owner_list.each_index { |i|
                            next if i == 0
                            DNS.popwin.text_field(:value, "选择设备节点").set(@owner_list[i])
                            DNS.send_enter
                        }
                        DNS.popwin.button(:class, "save").click
                        DNS.waiting_operate_finished
                    else
                        r += "not find zone: #{@zone_name} in view: #{@view_name}"
                    end
                else
                    r += "no find view: #{@view_name}\n"
                end
                r += check_zone("modify")
                return r
            end
            def delete_zone(args)
                view_name = args[:view_name] 
                zone_list = args[:zone_list] 
                if DNS.goto_specify_page(view_name)
                    sleep 1
                    zone_list.each { |zone_name|
                        if DNS.zone_exists?(zone_name)
                            DNS.del_current_elem
                        end
                    }
                end
                r = ""
                zone_list.each { |zone_name|
                    if !DNS.zone_exists?(zone_name)
                        r += "succeed to del zone: #{zone_name} in view: #{view_name}\n"
                    else
                        r += "failed to del zone: #{zone_name}\n"
                    end
                }
                puts r
                return r
            end
            def edit_soa(args)
                view_name = args[:view_name] 
                zone_name = args[:zone_name] 
                if DNS.goto_specify_page(view_name, zone_name)
                    DNS.popup_right_menu("edit-SOA")
                    @new_serial = DNS.popwin.text_field(:name, "serial").value.to_i + 1
                    DNS.popwin.text_field(:name, "ttl").set(args[:ttl])
                    DNS.popwin.text_field(:name, "rname").set(args[:rname])
                    DNS.popwin.text_field(:name, "serial").set(@new_serial)
                    DNS.popwin.text_field(:name, "refresh").set(args[:refresh])
                    DNS.popwin.text_field(:name, "retry").set(args[:retry])
                    DNS.popwin.text_field(:name, "expire").set(args[:expire])
                    DNS.popwin.text_field(:name, "minimum").set(args[:minimum])
                    err = DNS.waiting_operate_finished(args)
                    return err if err
                end
                r = ""
                if DNS.goto_specify_page(view_name, zone_name)
                    DNS.popup_right_menu("edit-SOA")
                    ttl = DNS.popwin.text_field(:name, "ttl").value
                    rname = DNS.popwin.text_field(:name, "rname").value
                    serial = DNS.popwin.text_field(:name, "serial").value
                    refresh = DNS.popwin.text_field(:name, "refresh").value
                    retry1 = DNS.popwin.text_field(:name, "retry").value
                    expire = DNS.popwin.text_field(:name, "expire").value
                    minimum  = DNS.popwin.text_field(:name, "minimum").value
                    #puts "get: #{ttl} rname: #{rname} serial: #{serial} refresh: #{refresh} retry: #{retry1} expire: #{expire} minimum: #{minimum}"
                    if ttl == args[:ttl] && rname == args[:rname] && serial >= @new_serial.to_s && refresh == args[:refresh] && retry1 == args[:retry] && expire == args[:expire] && minimum == args[:minimum]
                        r += "succeed to edit soa: #{args}\n"
                    else
                        r += "failed to edit soa: #{args}\n"
                    end
                    DNS.popwin.button(:class, "cancel").click
                end
                puts r
                return r
            end
        end
        class DOMAIN 
            def self.check_domain(view_name, zone_name, domain_list, operation='create', reopen=false)
                if reopen
                    if DNS.goto_specify_page(view_name, zone_name)
                        return  _check_domain(view_name, zone_name, domain_list, operation)
                    else
                        r = "failed to open zone: #{zone_name} in view: #{view_name}"
                        return r
                    end
                else
                    return _check_domain(view_name, zone_name, domain_list, operation)
                end
            end
            def self._check_domain(view_name, zone_name, domain_list, operation)
                r = ""
                domain_list.each {|domain_name|
                    if domain_name["rname"] == "127.0.0.1"
                        d_name = domain_name["rdata"]
                    else
                        d_name = domain_name["rname"] + '.' + zone_name
                    end
                    if operation != "delete" and DNS.domain_exists?(d_name)
                        DNS.context = DNS.get_cur_elem_string
                        if domain_name['rtype'].upcase == "NAPTR"
                             if DNS.get_domain_ttl == domain_name['ttl']
                                 r += "succeed to #{operation} "
                             else
                                 r += "failed to #{operation} "
                             end
                        elsif DNS.get_domain_ttl == domain_name['ttl'] and DNS.get_domain_rtype.upcase == domain_name['rtype'].upcase and DNS.get_domain_rdata.upcase.include?(domain_name['rdata'].upcase)
                            r += "succeed to #{operation} "
                        else
                            r += "failed to #{operation} "
                        end
                    elsif operation == "delete" and !DNS.domain_exists?(d_name)
                        r += "succeed to delete"
                    else
                        r += "failed to #{operation} "
                    end
                    r += " domain: #{d_name} in view: #{view_name}, rr_info: #{domain_name}\n"
                }
                puts r
                return r
            end
            def create_domain(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                domain_list = args[:domain_list]
                if DNS.goto_specify_page(view_name, zone_name)
                    domain_list.each { |domain|
                       r = DNS.add_rr(domain)
                       return r if r
                    }
                end
                return DOMAIN.check_domain(view_name, zone_name, domain_list)
            end
            def create_batch_domain(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                file_name = args[:file_name]
                domain_list = args[:domain_list]
                example_domain = args[:example_domain]
                if file_name
                    if DNS.goto_specify_page(view_name, zone_name)
                        sleep 1
                        DNS.popup_right_menu("batchCreate")
                        DNS.popwin.file_field(:name, "zone_file").click
                        DNS.open_dialog(file_name)
                        sleep 1
                        err = DNS.waiting_operate_finished(args)
                        return err if err
                        sleep 1
                    end
                    example_domain.each { |domain_name|
                        if !DNS.goto_specify_page(view_name, zone_name) or !DNS.domain_exists?(domain_name)
                            r = "failed to create batch domain in zone: #{zone_name}, in view: #{view_name}\n"
                            puts r
                            return r
                        end
                    }
                else
                    if DNS.goto_specify_page(view_name, zone_name)
                        sleep 1
                        DNS.popup_right_menu("batchCreate")
                        sleep 1
                        domain_list.each {|domain|
                            rr_info = domain["rname"] + " " + domain["ttl"] + " " + domain["rtype"] + " " + domain["rdata"]
                            DNS.popwin.textarea(:name, "zone_content").append(rr_info)
                            DNS.send_newline
                        }
                        err = DNS.waiting_operate_finished(args)
                        return err if err
                    end
                    return DOMAIN.check_domain(view_name, zone_name, domain_list, "batch create domain")
                end
                r = "succeed to create batch domain in zone: #{zone_name}, in view: #{view_name}\n"
                puts r
                return r
            end
            def edit_domain(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                zone_name = '.' if zone_name == '@'
                domain_list = args[:domain_list]
                if DNS.goto_specify_page(view_name, zone_name)
                    domain_list.each { |domain|
                        if domain["rname"] == "127.0.0.1"
                            domain_name_ = "127.0.0.1"
                        elsif zone_name == "."
                            domain_name_ = domain["rname"] 
                        else
                            domain_name_ = domain["rname"] + '.' + zone_name
                        end
                        if DNS.domain_exists?(domain_name_)
                            DNS.popup_right_menu("edit", selected=true)
                            DNS.popwin.text_field(:name, "ttl").set(domain["ttl"])
                            DNS.popwin.text_field(:name, "rdata").set(domain["rdata"])
                            DNS.popwin.button(:class, "save").click
                            DNS.waiting_operate_finished
                        end
                    }
                end
                return DOMAIN.check_domain(view_name, zone_name, domain_list, 'edit')
            end
            def edit_batch_domain(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                domain_list = args[:domain_list]
                ttl = domain_list[0]["ttl"]
                rdata = domain_list[0]["rdata"]
                r = ""
                if DNS.goto_specify_page(view_name, zone_name)
                    domain_list.each {|domain|
                        d_name = domain["rname"] + "." + zone_name
                        index = DNS.get_index(d_name)
                        KR.browser.table(:index, 1).checkbox(:index, index).set
                    }
                    DNS.popup_right_menu("edit")
                    DNS.popwin.text_field(:name, "ttl").set(ttl)
                    DNS.popwin.text_field(:name, "rdata").set(rdata)
                    DNS.popwin.button(:class, "save").click
                    DNS.waiting_operate_finished
                end
                r+= DOMAIN.check_domain(view_name, zone_name, domain_list, 'batchedit')
                puts r
                return r
            end
            def del_domain(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                domain_list = args[:domain_list]
                if DNS.goto_specify_page(view_name, zone_name)
                    domain_list.each { |domain|
                        if DNS.domain_exists?(domain)
                            DNS.del_current_elem
                        end
                    }
                end
                r = ""
                if DNS.goto_specify_page(view_name, zone_name)
                    domain_list.each { |domain|
                        if !DNS.domain_exists?(domain)
                            r += "succeed to del domain: #{domain}\n"
                        else
                            r += "failed to del domain: #{domain}\n"
                        end
                    }
                end
                puts r
                return r
            end
        end
        class SHARERR
            def create_share_rr(args)
                @domain_list = args[:domain_list]
                @share_owner = args[:share_owner]
                DNS.open_share_rr_page
                DNS.popup_right_menu
                @domain_list.each {|domain|
                    DNS.popwin.text_field(:name, "name").set(domain["rname"])
                    DNS.popwin.select(:name, "type").select(domain["rtype"])
                    DNS.popwin.text_field(:name, "ttl").set(domain["ttl"])
                    DNS.popwin.text_field(:name, "rdata").set(domain["rdata"])
                    sleep 1
                    @share_owner.each { |owner|
                        DNS.popwin.text_field(:value, "选择共享区").set(owner)
                        DNS.send_enter
                    }
                    DNS.popwin.button(:class, "save").click
                    DNS.waiting_operate_finished
                }
                return check_share_rr
            end
            def edit_share_rr(args)
                @domain_list = args[:domain_list]
                @share_owner = args[:share_owner]
                DNS.open_share_rr_page
                DNS.popup_right_menu("edit", true)
                @domain_list.each {|domain|
                    DNS.popwin.text_field(:name, "ttl").set(domain['ttl'])
                    DNS.popwin.text_field(:name, "rdata").set(domain['rdata'])
                    DNS.popwin.button(:class, "save").click
                    DNS.waiting_operate_finished
                }
                return check_share_rr("edit")
            end
            def check_share_rr(operation="create")
                r = ""
                @share_owner.each {|owner|
                    view_name, zone_name = owner.split('/', 2)
                    result = DOMAIN.check_domain(view_name, zone_name, @domain_list, operation, reopen=true)
                    if result.match("succeed")
                        r += result
                        r += "succeed to #{operation}"
                    else
                        r += result
                        r += "failed to #{operation}"
                    end
                    result = ""
                    r += " share rr: #{@domain_list} in zone: #{zone_name} in view: #{view_name}\n"
                }
                puts r
                return r
            end
            def del_share_rr(args)
                @domain_list = args[:domain_list]
                @share_owner = args[:share_owner]
                DNS.open_share_rr_page
                @domain_list.each { |domain|
                   if DNS.share_rr_exists?(domain['rname'])
                       DNS.del_current_elem
                   end
                }
                return check_share_rr("delete")
            end
            def modify_share_rr(args)
                r = ""
                share_rr_list = args[:share_rr_list]
                add_owner = args[:add_owner]
                DNS.open_share_rr_page
                share_rr_list.each { |share_rr|
                    if DNS.share_rr_exists?(share_rr)
                        DNS.popup_right_menu("modifyByOwner", true)
                        add_owner.each {|owner|
                            DNS.popwin.text_field(:value, "选择成员").set(owner)
                            DNS.send_enter
                        }
                        DNS.popwin.button(:class, "save").click
                        DNS.waiting_operate_finished
                        DNS.context = DNS.get_cur_elem_string
                        if DNS.get_share_rr_owner.include?(add_owner.join(" ")) 
                            r += "succeed " 
                        else
                            r += "failed "
                        end
                        r += " to modify owner of share_rr: #{share_rr} modify owner: #{add_owner}"

                    end
                }
                puts r
                return r
            end
        end
       class SEARCH
            def _match_search_result(search_item)
                DNS.open_search_page
                DNS.search_elem(search_item)
                bfuzzy_matching = search_item.include?("*")
                DNS.context = DNS.get_cur_elem_string
                search_item = search_item.gsub("*", "") if bfuzzy_matching
                if search_item =~/\d\.\d\.\d\.\d/
                    bfind = DNS.context.find {|e| !e[7].include?(search_item)}
                else
                    bfind = DNS.context.find {|e| !e[4].include?(search_item)}
                end
                bfind = bfind ? false : true
                return bfind
            end
            def search_domain(args)
                domain_name = args[:domain_name]
                bfind = _match_search_result(domain_name)
                if bfind && ( DNS.context.length != 0)
                    r = "succeed to search domain: #{domain_name}, find num: #{DNS.context.length}\n"
                else
                    r = "failed to search domain: #{domain_name}, search result: #{DNS.context}\n"
                end
                puts r
                return r
            end
            def search_edit_and_verify(search, ttl, rdata, operation="edit", type="domain")
                r = ""
                DNS.open_search_page
                if DNS.search_exists?(search)
                    DNS.popup_right_menu(operation, true)
                    DNS.popwin.text_field(:name, "ttl").set(ttl)
                    DNS.popwin.text_field(:name, "rdata").set(rdata)
                    DNS.popwin.button(:class, "save").click
                    sleep 1
                    DNS.waiting_operate_finished
                    if type == "ip"
                        DNS.open_search_page
                        if !DNS.search_exists?(rdata)
                            r += "failed "
                        end
                    end
                    DNS.context = DNS.get_cur_elem_string
                    sleep 1
                    if DNS.get_search_ttl == ttl and DNS.get_search_rdata == rdata
                        r += "succeed "
                    else
                        r += "failed "
                    end
                    r += " to #{operation} search: #{search} in search block, rdata: #{rdata}, ttl: #{ttl}\n"
                end
                puts r
                return r
            end
            def search_domain_edit(args)
                r = ""
                DNS.open_search_page
                domain_name = args[:domain_name]
                ttl = args[:ttl]
                rdata = args[:rdata]
                return search_edit_and_verify(domain_name, ttl, rdata, "edit")
            end
            def search_domain_batch_edit(args)
                DNS.open_search_page
                domain_name = args[:domain_name]
                rdata = args[:rdata]
                ttl = args[:ttl]
                return search_edit_and_verify(domain_name, ttl, rdata, "edit")
            end
            def search_ip(args)
                DNS.open_search_page
                ip = args[:ip]
                bfind = _match_search_result(ip)
                if bfind
                    r = "succeed to search ip: #{ip}, find num: #{DNS.context.length}\n"
                else
                    r = "failed to search ip: #{ip}, search result: #{DNS.context}\n"
                end
                puts r
                return r
            end
            def search_ip_batch_edit(args)
                ip = args[:ip]
                ttl = args[:ttl]
                rdata = args[:rdata]
                return search_edit_and_verify(ip, ttl, rdata, "edit", "ip")
            end
	   end
       class SYNCDATA
            def initialize
                @retry=0
            end
            def sync_data(args)
                owner= args[:owner_list]
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                zone_file = args[:zone_file]
                zone = KR::DNS::ZONE.new
                if not zone_file
                    zone.create_zone(args)
                else
                    zone.create_zone_from_file(args)
                end
            end
            def compare_domain(args)
                sleep 3
                server_list = args[:server_list]
                domain_name = args[:domain_name]
                rtype = args[:rtype]
                port = args[:port]
                actual_rdata = args[:actual_rdata]
                message = Dnsruby::Message.new(domain_name, rtype)
                message.header.rd = 1
                r = ""
                server_list.each { |server|
                    res = Dnsruby::Resolver.new({:nameserver => server})
                    res.port = port
                    ret, error = res.send_plain_message(message)
                    puts "---> from: #{server} get: #{ret.answer} with error: #{error.inspect}"
                    bfind = ret.answer.find {|rrs| rrs.to_s.include?(actual_rdata)} 
                    if bfind
                        r += "succeed to verify domain #{domain_name} in server #{server} answer: #{ret.answer.to_s}\n"
                    else
                        r += "failed to verify domain #{domain_name} in server #{server} answer: #{ret.answer.to_s}\n"
                    end
                }
                puts r
                return r
            end
            def compare_zone_data(args)
                sleep 3
                server_list = args[:server_list]
                domain_name = args[:domain_name]
                rtype = args[:rtype]
                port = args[:port]
                res = Dnsruby::Resolver.new({:nameserver => server_list[0] })
                res.port = port
                message = Dnsruby::Message.new(domain_name, rtype)
                message.header.rd = 1
                ret, error = res.send_plain_message(message)
                answer = ret.answer.to_s
                puts "---> from: #{server_list[0]} get: #{answer} with error: #{error.inspect}"
                for i in 1..server_list.length-1 do
                    res2 = Dnsruby::Resolver.new({:nameserver => server_list[i] })
                    ret2, error2 = res2.send_plain_message(message)
                    answer2 = ret2.answer.to_s
                    puts "---> from: #{server_list[i]} get: #{answer2} with error: #{error2.inspect}"
                    r = ""
                    if ret2.rcode == ret.rcode and answer == answer2 
                        r += "succeed "
                    else
                        r += "failed " 
                    end
                    r += "to verify data sync in zone: #{domain_name} between server: #{server_list[0]} and #{server_list[i]}\n"
                end
                puts r
                return r
            end
            def sync_data_by_stop_service(args)
                owner = args[:owner_list]
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                KR::CLOUD.open_cloud_page
                zone = KR::DNS::ZONE.new
                zone.create_zone(args)
            end
       end
    end
end
