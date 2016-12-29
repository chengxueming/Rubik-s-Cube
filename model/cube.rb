def rotate(en3,point,v,a = Math::PI / 2)
ents = Sketchup.active_model.entities
tr = Geom::Transformation.rotation(point,v,a)
#ents.transform_entities tr, en3
#UI.start_timer(1, false) { ents.transform_entities tr, en3;en3.explode }

view = Sketchup.active_model.active_view
number_of_frames = 500
angle_change = a / number_of_frames.to_f
rotform = Geom::Transformation.rotation( point, v, angle_change )
number_of_frames.times do
  en3.move! rotform * en3.transformation
  view.refresh
end
en3.explode
end
#v represent which dirction to rotate while one is plus toward big than 0 face deside which face to rotate in the same axis
def rotate_more(v,face)
  ents = Sketchup.active_model.entities
  l = []
  #ents[0].bounds.center.to_a[1]
  #l.insert(-1,ents[0])
  limit = 0
  if face == 1
  limit = 5
  else
  limit = 2
  end
  index = 0
  #v.each{|single| if single != 0;index =i;i=i +1;end}
  while index < v.length
  	if v[index] != 0;break;end
  	index=index +1
  end
  ents.each{|g| 
    #roup=g.instances[0] if g.instances[0].name==name 
    if face == 1
    if g.bounds.center.to_a[index] > limit;l.insert(-1,g)
    end
    else
    if g.bounds.center.to_a[index] < limit;l.insert(-1,g)
    end
    end
  }
  
  group = ents.add_group l
  #l.each{|ent|group.entities.add_group ent}
  #group = find_group("yellow") 
  rotate(group,group.bounds.center,v)
end
def find_group(name)
model=Sketchup.active_model 
groups=[] 
model.definitions.each{|d| 
  groups << d if d.group? 
} 
group=nil 
groups.each{|g| 
  group=g.instances[0] if g.instances[0].name==name 
}
return group
end

F = "F"
R = "R"
L = "L"
B = "B"
U = "U"
D = "D"
@str = ""
def randmofang(times)
l = [[0,0,1],[1,0,0],[0,1,0],[0,0,-1],[-1,0,0],[0,-1,0]]
i = 0
while i < times do
out = ""
x = rand(6)
y = rand(2)
@str += getCommand(x,y) + " "
rotate_more(l[x],y)
i = i + 1
end
end

def getCommand(x,y)
l = [[0,0,1],[1,0,0],[0,1,0],[0,0,-1],[-1,0,0],[0,-1,0]]
out = ""
if x == 0 or x - 3 == 0
	if y == 1 
	out = U  + "'"
	else
	out = D
	end
elsif x == 1 or x - 3 == 1
	if y == 1
	out = R + "'"
	else
	out = L
	end
elsif x == 2 or x - 3 == 2
	if y == 1
	out = B + "'"
else
	out = F
end
end

if x >= 3
    if out[1] == "'"
    out = out[0]
    else
    out += "'"
    end
end
return out
end

def moveMofang(str)
ma = {U => 3,R => 4,B => 5,D => 0,L => 1,F =>2}
m = str.split(" ")
l = [[0,0,1],[1,0,0],[0,1,0],[0,0,-1],[-1,0,0],[0,-1,0]]
l_r = [[0,0,-1],[-1,0,0],[0,-1,0],[0,0,1],[1,0,0],[0,1,0]]
m.each{|d|
if d[1] == "'"
m_l = l_r
else
m_l = l
end

if d[0] == U or d[0] == R or d[0] == B
out = 1 
else
out = 0
end
rotate_more(m_l[ma[d[0]]],out)
}
end

#randmofang(5)
moveMofang "R L' D L' U'"
#Sketchup.active_model.add_note(@str,0.01,0.02)



