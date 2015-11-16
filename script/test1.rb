####################################
# # 定义类
# class Box
#    # 构造器方法
#    def initialize(w,h)
#       @width, @height = w, h
#    end
#    # 实例方法
#    def getArea
#       @width * @height
#    end
# end

# # 定义子类
# class BigBox < Box

#    # 添加一个新的实例方法
#    def printArea
#       @area = @width * @height
#       puts "Big box area is : #@area"
#    end
# end

# # 创建对象
# box = BigBox.new(10, 20)

# # 输出面积
# box.printArea()
###################################
def del_cookies
	reset_session
    cookies.delete(".36kr.com")
    redirect_to root_url
end
del_cookies

