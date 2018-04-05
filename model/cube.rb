# coding: utf-8
F = "F"
R = "R"
L = "L"
B = "B"
U = "U"
D = "D"

class CubeEntity

  attr_reader :last_path

  def initialize
    @outter_limit = 47
    @inner_limit = 7
    @frames_per_rotate = 50
    @last_path = ""
    @l = [[0,0,1],[1,0,0],[0,1,0],[0,0,-1],[-1,0,0],[0,-1,0]]
    @l_r = [[0,0,-1],[-1,0,0],[0,-1,0],[0,0,1],[1,0,0],[0,1,0]]
  end

  # 根据命令旋转
  def rotate_by_command(command)
    @last_path = command
    ma = {U => 3,R => 4,B => 5,D => 0,L => 1,F =>2}
    m = command.split(" ")
    m.each{|d|
      if d[1] == "'"
        m_l = @l_r
      else
        m_l = @l
      end

      if d[0] == U or d[0] == R or d[0] == B
        out = 1 
      else
        out = 0
      end
      _rotate_face(m_l[ma[d[0]]],out)
    }
  end

  # 指定次数随机打乱 
  def disrubt(times)
    @last_path = ""
    i = 0
    while i < times do
      out = ""
      x = rand(6)
      y = rand(2)
      @last_path += _get_command(x,y) + " "
      _rotate_face(@l[x],y)
      i = i + 1
    end
  end

  #v represent which dirction to rotate while one is plus toward big than 0 face deside which face to rotate in the same axis
  def _rotate_face(v,face)
    ents = Sketchup.active_model.entities
    l = []
    limit = 0
    if face == 1
      limit = @outter_limit
    else
      limit = @inner_limit
    end
    index = 0
    while index < v.length
      if v[index] != 0;break;end
      index=index +1
    end
    ents.each{|g| 
      if face == 1
        if g.bounds.center.to_a[index] > limit;l.insert(-1,g)
        end
      else
        if g.bounds.center.to_a[index] < limit;l.insert(-1,g)
        end
      end
    }
    group = ents.add_group l
    _rotate(group,group.bounds.center,v)
  end

  def _rotate(en3,point,v,a = Math::PI / 2)
    ents = Sketchup.active_model.entities
    tr = Geom::Transformation.rotation(point,v,a)
    #ents.transform_entities tr, en3
    #UI.start_timer(1, false) { ents.transform_entities tr, en3;en3.explode }

    view = Sketchup.active_model.active_view
    number_of_frames = @frames_per_rotate
    angle_change = a / number_of_frames.to_f
    rotform = Geom::Transformation.rotation( point, v, angle_change )
    number_of_frames.times do
      en3.move! rotform * en3.transformation
      view.refresh
    end
    en3.explode
  end



  def _get_command(x,y)
    out = ""
    if x == 0 or x == 3
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

end

cube = CubeEntity.new
cube.rotate_by_command "R L' D L' U'"
Sketchup.active_model.add_note(cube.last_path, 0.01, 0.02)



