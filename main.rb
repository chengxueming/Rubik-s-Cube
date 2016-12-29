#require __FILE__.join("..\model.rb")
require File.join(__FILE__,"../model")

#获得中棱

#还原顶面
#遍历每一个面
=begin
for k in @maps
	#遍历一个面的每一条边
	k[1][1].each_byte{|e|
		#当前的面
		face = k[0]
		#当前的边
		edge = e.chr
		#当前的边数据
		l = get(face,edge)
		#puts k[0] + "," + e.chr + ":" + l[0]
		#puts l.to_s
		#侧边的数据
		stand = get(edge,face)
		#puts stand.to_s
		if get_face(l[0]) == U
			#边是符合的
			if face == U and get_face(stand[0]) == edge
				puts "good"
			end
		end


	}
end
=end
#判断一个面是否完成
def judge_1_floor(face)
@maps[face][0].each{|e|
	if get_face(e) != face
		return false
	end
}
@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	#当前的边数据
	l = get(face,edge)
	#puts k[0] + "," + e.chr + ":" + l[0]
	#puts l.to_s
	#侧边的数据
	stand = get(edge,face)
	#puts stand.to_s
	stand.each{|e|
		if get_face(e) != edge
			return false
		end
	}
	return true
}
end
#判断一个十字是否完成
def judge_1_cross(face)
@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	#当前的边数据
	l = get(face,edge)
	if get_face(l[1]) != face
		return false
	end
	#puts k[0] + "," + e.chr + ":" + l[0]
	#puts l.to_s
	#侧边的数据
	stand = get(edge,face)
	#puts stand.to_s
	if get_face(stand[1]) != edge
		return false
	end
}
return true
end
#判断某个面四个角是否完成
def judge_4_corner(face)
@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	#当前的边数据
	l = get(face,edge)
	if get_face(l[0]) != face or get_face(l[2]) != face
		return false
	end
	#puts k[0] + "," + e.chr + ":" + l[0]
	#puts l.to_s
	#侧边的数据
	stand = get(edge,face)
	#puts stand.to_s
	if get_face(stand[0]) != edge or get_face(stand[2]) != edge
		return false
	end
}
return true
end
#判断中间面四个角是否完成
def judge_second_floor_4_corner(face)
@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	get_left_and_right(face,edge).each{|ele|
		if get_face(get(edge,ele)[1]) != edge 
			return false
		end
	}
	}
return true
end



=begin
count = 1
while true do
	if judge_1_cross U
		if judge_4_corner U
			if judge_second_floor_4_corner U
			else
				#完成第二层的代码
			end
		else
			#完成第一个四个角的代码
		end
	else
		#完成十字架的代码
	end
end
=end

#还原十字
=begin
	
rescue Exception => e
	
end
def back_single_cross(face)
other = get_face_to_face(face)
@maps[other][1].each_byte{|e|
edge = e.chr
if get_face(get(other,edge)[0]) == face
	#目标旋转面
	destin = get_face(get(edge,other)[0])
	while get_face(get(destin,other)[0]) != destin
		rotate_by_command edge
	end
	rotate_by_command destin+destin,""
	return
end
}
end

def back_stand_cross(face)
other = get_face_to_face(face)
@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	get_left_and_right(face,edge).each{|ele|
		if get_face(get(edge,ele)[1]) == face 
			if !get_is_clock(ele,edge,other)
				ele += "'"
			rotate_by_command ele
			return
		end
	}
	}
return true
end
=end
def back_son_cross(face)
	#判断底面有没有可以还原的
	p "D have"
	other = get_face_to_face(face)
	@maps[other][1].each_byte{|e|
	edge = e.chr
	if get_face(get(other,edge)[1]) == face
		#目标旋转面
		destin = get(edge,other)[1]
		destin_face = get_face(get(edge,other)[1])
		p "edge=" + edge+" " +"other=" +other+" "  +"destin="+get_face(destin)+" " 
		while get(destin_face,other)[1] != destin do
			p "bug"
			rotate_by_command other
		end
		p "remove bug"
		rotate_by_command [destin_face,destin_face].join(" ")
		return
	end
	}
	p "stand have"
	#判断每个侧棱有没有可以变成底面的
	@maps[face][1].each_byte{|e|
		#当前的边
		edge = e.chr
		puts "face =>" + face + "edge =>" + edge + "two face:" + get_left_and_right(face,edge).to_s
		get_left_and_right(face,edge).each{|ele|
			if get_face(get(edge,ele)[1]) == face 
				if !get_is_clock(ele,edge,other)
					ele += "'"
				end
				#p ele + other + get_reverse_face(ele),""
				rotate_by_command [ele,other,get_reverse_face(ele)].join(" ")
				return
			end
		}
	}
	p "top have"
	#判断每个顶面有没有可以变成底面的
	@maps[face][1].each_byte{|e|
	edge = e.chr
	if get_face(get(face,edge)[1]) == face and get_face(get(edge,face)[1]) != edge
		#目标旋转面
		rotate_by_command [edge,edge].join(" ")
		return
	end
	}
	p "up and down have"
	#判断每个上下侧面有没有可以变成侧棱的
	@maps[face][1].each_byte{|e|
	#当前的边
	edge = e.chr
	[face,other].each{|ele|
		value = get(edge,ele)[1]
		if get_face(get(edge,ele)[1]) == face 
		if ele == other
			cur = get_value_of_face value
			

		end
		rotate_by_command edge
		return
		end
	}
	}
	p "break"
end

def back_cross(face)
	count = 0
	until  judge_1_cross face do
		back_son_cross face
	count += 1
	if count > @max_step
		return
	end
	end
end


def back_four_corner_son(face)
	other = get_face_to_face(face)
	#对于底下的两个角
@maps[face][1].each_byte{|e|
#当前的边
edge = e.chr
puts "1 face =>" + face + "edge =>" + edge + "two face:" + get_left_and_right(face,edge).to_s
get_left_and_right(face,edge).each{|ele|
	corner_value = get_corner_value(edge,other,ele)
		p "a #{corner_value}"
		if get_face(corner_value) == face 
			stands = get_stand_value(corner_value,other)
			p "b #{corner_value}"
			while get_face(stands[1]) != stands[0] do
				rotate_by_command other
				stands = get_stand_value(corner_value,other)
			end
			p stands
			cur = get_value_of_face(corner_value)
			if get_is_clock(face,stands[0],cur)
				command = translate cur, "F D F'"
				rotate_by_command command
			else
				command = translate stands[0], "R' D' R"
				rotate_by_command command
			end
			return
		end
	}
}
	#判断顶层的stand面有没有face的
@maps[face][1].each_byte{|e|
#当前的边
edge = e.chr
puts "2 face =>" + face + "edge =>" + edge + "two face:" + get_left_and_right(face,edge).to_s
get_left_and_right(face,edge).each{|ele|
		corner_value = get_corner_value(edge,face,ele)
		p "d #{corner_value} #{edge} #{face} #{ele}"
		if get_face(corner_value) == face
			p "stand and up #{edge},#{ele}"
			dest = edge
			if !get_is_clock(edge,ele,other)
				dest += "'"
			end
			rotate_by_command dest
			 another = escape_edge(corner_value,other,dest[0])
			p ":haha:#{corner_value},#{other},#{dest[0]} #{another}"
			rotate_by_command [another,get_reverse_face(dest)].join(" ")
			p "something not well"
			return
		end
	}
}
#判断顶层的顶面有没有face的
@maps[face][1].each_byte{|e|
#当前的边
edge = e.chr
puts "3 face =>" + face + "edge =>" + edge + "two face:" + get_left_and_right(face,edge).to_s
get_left_and_right(face,edge).each{|ele|
		
		corner_value = get_corner_value(face,edge,ele)
		if get_face(corner_value) == face and !(get_face(get_stand_value(corner_value,edge)[1]) == ele and get_face(get_stand_value(corner_value,ele)[1]) == edge)
			if !get_is_clock(ele,face,edge)
				ele += "'"
			end
			rotate_by_command [ele,other,get_reverse_face(ele)].join(" ")
			return
		end
	}
}
#判断底层的底面有没有face的
@maps[face][1].each_byte{|e|
#当前的边
edge = e.chr
puts "4 face =>" + face + "edge =>" + edge + "two face:" + get_left_and_right(face,edge).to_s
	get_left_and_right(face,edge).each{|ele|
		
		corner_value = get_corner_value(other,edge,ele)
		if get_face(corner_value) == face
			while get_face(get_otehr_face_value(corner_value)) == face do
				rotate_by_command other
			end
			des = get_value_state(corner_value)[1]
			dirct = des[0]
			if !get_is_clock(des[0],des[1],other)
				dirct += "'"
			end
			rotate_by_command [dirct,other,get_reverse_face(dirct)].join(" ")
		end
	}
}
end

def back_four_corner(face)
	count = 0
	until  judge_4_corner face do
		back_four_corner_son face
	count += 1
	if count > @max_step
		return
	end
	end
end





def back_second_floor_son(face)
other = get_face_to_face(face)
@maps[other][1].each_byte{|e|
#当前的边
	edge = e.chr
	#上面的值
	valueU = get(other,edge)[1]
	#侧面的值
	valueF = get(edge,other)[1]
	if get_face(valueU) == other or get_face(valueF) == other
		next
	end
	while get_face(valueF) != get_value_of_face(valueF) do
		#旋转
		rotate_by_command other
	end
	valueU = get(other,get_face(valueF))[1]
	get_left_and_right(other,get_face(valueF)).each{|ele|
		if get_face(valueU) == ele
			if  get_is_clock(other,get_face(valueF),ele)
				command = translate ele, "U' F' U F U R U' R'",true
				rotate_by_command command
			else
				p "tell me truth #{get_face(valueF)}"
				command = translate get_face(valueF), "F U F U F U' F' U' F'",true
				rotate_by_command command
			end
			return
		end
	}
}
@maps[other][1].each_byte{|e|
#当前的边
	edge = e.chr
	#上面的值
	get_left_and_right(other,edge).each{|ele|
		if get_face(get_edge_stand(get(edge,ele)[1])) != ele and get_face(get(edge,ele)[1]) != edge
			if get_face(get_edge_stand(get(edge,ele)[1])) != other and get_face(get(edge,ele)[1]) != other
=begin
				p "second #{get_face(get_edge_stand(get(edge,ele)[1]))} #{get_face(get(edge,ele)[1])}"
				p "#{edge} #{ele}"
				as_F = edge
				as_F = ele if !get_is_clock(U,edge,ele)
				p "as_F is #{as_F} edge is #{edge} "
				command = translate ele, "U' F' U F U R U' R'",true
				rotate_by_command command
				return
=end
			if  get_is_clock(U,edge,ele)
				command = translate edge, "U' F' U F U R U' R'",true
				rotate_by_command command
			else
				command = translate ele, "F U F U F U' F' U' F'",true
				rotate_by_command command
			end
			end
		end
	}
}
end

def back_second_floor(face)
	count = 0
	until  judge_second_floor_4_corner face do
		back_second_floor_son face
	count += 1
	if count > @max_step
		return
	end
	end
end

#判断某一个面的十字有无还原
def judge_cross_of_face(face)
	@maps[face][1].each_byte{|e|
#当前的边
	edge = e.chr
	if get_face(get(face,edge)[1]) != face
		return false
	end
}
return true
end

def judge_four_corner_of_face(face)
	@maps[face][1].each_byte{|e|
#当前的边
	edge = e.chr
	if get_face(get(face,edge)[0]) != face or get_face(get(face,edge)[2]) != face
		return false
	end
}
return true
end

def back_third_floor_cross_condition(face,edge)
		#情况1
	other = face
	if get_face(get(edge,other)[1]) == face
	nex = get_next(edge)
	if get_face(get(nex,other)[1]) == other
		nex2 = get_next(nex)
		if get_face(get(other,nex2)[1]) == other
			#情况1
			p "condation1 third floor #{edge}"
			return true
		end
	end
	end
	#情况2
	if get_face(get(other,edge)[1]) == other
	nex = get_next(edge)
	p "look get_next #{other},#{edge}"
	p "look next #{nex}"
	if get_face(get(nex,other)[1]) == other
	nex2 = get_next(nex)
	if get_face(get(other,nex2)[1]) == other
		#情况2
		p "condation2 third floor #{edge}"
		return true
	end
	end

	end
	#情况3
	if get_face(get(edge,other)[1]) == face
	nex = get_next(edge)
	if get_face(get(nex,other)[1]) == other
		#情况3
		p "condation3 third floor #{edge}"
		return true
	end
	end
end

def back_third_floor_cross(face)
other = get_face_to_face(face)
count = 0
until judge_cross_of_face other do
	@maps[other][1].each_byte{|e|
	edge = e.chr
	if true == back_third_floor_cross_condition(other,edge)
		p "hahahhahah #{edge}"
		command = translate edge, "R' U' F' U F R",true
		rotate_by_command command
		count += 1
		if count > @max_step
		return
		end
		break
	end
}
end
end



def back_four_corner_of_third_floor_son(face)
	other = get_face_to_face(face)
	@maps[other][1].each_byte{|e|
	edge = e.chr
	lr = get_left_and_right_another(edge,other)
	face_back = get_face_to_face(edge)
#表示上面每个面的点
	face_LD = get_face(get_corner_value(other,edge,lr[0]))
	face_RD = get_face(get_corner_value(other,edge,lr[1]))
	face_LU = get_face(get_corner_value(other,face_back,lr[0]))
	face_RU = get_face(get_corner_value(other,face_back,lr[1]))
#表示侧面每个面的点
	#上下的侧面
	_face_LD = get_face(get_corner_value(edge,other,lr[0]))
	_face_RD = get_face(get_corner_value(edge,other,lr[1]))
	_face_LU = get_face(get_corner_value(face_back,other,lr[0]))
	_face_RU = get_face(get_corner_value(face_back,other,lr[1]))
	#左右的侧面
	_face_DL = get_face(get_corner_value(lr[0],edge,other))
	_face_DR = get_face(get_corner_value(lr[1],edge,other))
	_face_UL = get_face(get_corner_value(lr[0],face_back,other))
	_face_UR = get_face(get_corner_value(lr[1],face_back,other))
	p "#{edge}"
	p "face_LD:#{face_LD}face_RD:#{face_RD}face_LU:#{face_LU}face_RU:#{face_RU}"
	p "_face_LD:#{_face_LD}_face_RD:#{_face_RD}_face_LU:#{_face_LU}_face_RU:#{_face_RU}"
	p "_face_DL:#{_face_DL}_face_DR:#{_face_DR}_face_UL:#{_face_UL}_face_UR:#{_face_UR}"
#情况1
	if edge == L
		p "talk face_LU:#{get_color_by_face(face_LU)},_face_RU:#{get_color_by_face(_face_RU)},_face_DR:#{get_color_by_face(_face_DR)},_face_LD:#{get_color_by_face(_face_LD)}"
	end
	if face_LU == other and _face_RU == other and _face_DR == other and _face_LD == other
		p "state 1"
		command = translate edge, "R' U' R U' R' U' U' R U' U'",true
		rotate_by_command command
		return
	end
#情况2
	
	if face_LD == other and _face_LU == other and _face_DR == other  and _face_RD == other
		p "state 2"
		command = translate edge, "R U R' U R U U R' U U",true
		rotate_by_command command
		return
	end


#使用公式b的情况
	if _face_LU == other and _face_LD == other and face_RU == other and face_RD == other
		p "state b1 #{edge}"
		command = translate edge, "R U R' U R U U R' U U",true
		rotate_by_command command
		return
	end

	if _face_LD == other and _face_UR == other and face_RD == other and face_LU == other
		p "state b2"
		command = translate edge, "R U R' U R U U R' U U",true
		rotate_by_command command
		return
	end

	if _face_LD == other and _face_LU == other and _face_UR == other and _face_RD == other
		p "state b3"
		command = translate edge, "R U R' U R U U R' U U",true
		rotate_by_command command
		return
	end
#使用公式a的情况
	if face_LD == other and _face_RU == other and face_RD == other and _face_LU == other
		p "state a1"
		command = translate edge, "R U R' U R U2 R' U U",true
		rotate_by_command command
		return
	end

	if _face_DL == other and _face_DR == other and _face_UL == other and _face_UR == other
		p "state a2"
		command = translate edge, "R U R' U R U2 R' U U",true
		rotate_by_command command
		return
	end
	}
end

def back_four_corner_of_third_floor(face)
other = get_face_to_face(face)
count = 0
until judge_four_corner_of_face other do
	back_four_corner_of_third_floor_son U
	count += 1
	if count > @max_step
	return
	end
end
end



def get_stand_face(face)
	def get_stand_face_son(face,other)
	@maps[other][1].each_byte{|e|
		edge = e.chr
		lr = get_left_and_right_another(edge,other)
		if get_face(get_corner_value(edge,other,lr[1])) == edge
			return edge
		end
		return nil
	}
	end
	other = get_face_to_face(face)
	edge = get_stand_face_son(face,other)
	while edge == nil do
		rotate_by_command other
		edge = get_stand_face_son(face,other)
	end
	return edge
end

def judge_four_stand_of_third_floor(face)
	other = get_face_to_face(face)
	@maps[other][1].each_byte{|e|
	edge = e.chr
	if get_face(get(edge,other)[0]) != edge or get_face(get(edge,other)[2]) != edge
		return false
	end
	}
	return true
end
	# other = get_face_to_face(face)
	# edge = get_stand_face face
def judge_one_stand_of_third_floor(face,from,to)
	if get_face(get_corner_value(from,face,to)) == from and get_face(get_corner_value(to,face,from)) == to
		return true
	end
	return false
end

def judge_four_edge_of_third_floor(face)
	other = get_face_to_face(face)
	@maps[other][1].each_byte{|e|
	edge = e.chr
	if get_face(get(edge,other)[1]) != edge
		return false
	end
	}
	return true
end

def back_four_stand_of_third_floor(face)
	other = get_face_to_face(face)
	edge = get_stand_face face
	p "edge #{edge}"
	count = 0
	until judge_four_stand_of_third_floor face do
		count = count + 1
		if count > @max_step
		return
		end
		lr = get_left_and_right_another(edge)

		face_back = get_face_to_face edge
		p "lr #{lr} face_back #{face_back}"
		#右上角已经完成
		if judge_one_stand_of_third_floor(other,face_back,lr[1])
			p "state 1 #{edge}"
			command = translate edge, "R U' L' U R' U U L U' L' U U L",true
			rotate_by_command command
			next
		end
		p "state 2"
		#如果左下角已经完成
		if judge_one_stand_of_third_floor(other,edge,lr[0])
			p "state 1 #{edge}"
			command = translate lr[0], "R U' L' U R' U U L U' L' U U L",true
			rotate_by_command command
			next
		end
		#右上和左下都未完成
		command = translate edge, "R U' L' U R' U U L U' L' U U L",true
		rotate_by_command command

		command = translate lr[0], "R U' L' U R' U U L U' L' U U L",true
		rotate_by_command command
	end
end


def back_four_edge_of_third_floor(face)
	ed = ""
	other = get_face_to_face(face)
	@maps[other][1].each_byte{|e|
		edge = e.chr
		lr = get_left_and_right_another(edge,other)
		if get_face(get(edge,face)[0]) == edge
			ed = edge
			break
		end
	}
	face_back = get_face_to_face(ed)
	until judge_four_edge_of_third_floor face
		command = translate face_back, "L' U L' U' L' U' L' U L U L L",true
		rotate_by_command command
	end
end

def back_mofang()
count = 1
while true do
	if judge_1_cross U
		if judge_4_corner U
			if judge_second_floor_4_corner U
				if judge_cross_of_face D
					if judge_four_corner_of_face D
						#完成第三层
						# if judge_four_stand_of_third_floor U
						# 	# if judge_four_edge_of_third_floor U
						# 	# 	return
						# 	# else
						# 	# 	back_four_edge_of_third_floor U
						# 	# end
						# 	return
						# else
						# 	back_four_stand_of_third_floor U
						# end
						return
					else
						back_four_corner_of_third_floor U
					end
				else
					back_third_floor_cross U
				end
			else
			back_second_floor U
			end
		else
			back_four_corner U#完成第一个四个角的代码
		end
	else
		back_cross U #完成十字架的代码
	end
end
end

#back_four_edge_of_third_floor U
back_mofang
puts @command[@init_command.length..@command.length]