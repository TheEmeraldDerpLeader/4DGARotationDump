-- MultivectorTest

EvenM = class()
--Ignore the ignorant default constructors C++ is best langage
function setup()
    r1 = EvenM()
    r2 = EvenM()
    RDM = math.random
    
    r1 = r1:GenRot(vec4(RDM(),RDM(),RDM(),RDM()),vec4(RDM(),RDM(),RDM(),RDM()),45)
    r2 = r2:GenRot(vec4(RDM(),RDM(),RDM(),RDM()),vec4(RDM(),RDM(),RDM(),RDM()),60)
    r1 = r1:MultEven(r2)
    rots = {}
    r1:DecompOrtho(rots)
    r1 = rots[0]:SetRotorAngle(RDM()*180):MultEven(rots[1]:SetRotorAngle(RDM()*180))
    print(r1:RotateVec(vec4(1,0,0,0)))
    r1 = r1:AngleLerp(0.2)
    a = vec4(1,0,0,0)
    for i=1,5 do
        a = r1:RotateVec(a)
    end
    print(a)
    r2 = EvenM(1,0,0,0,0,0,0,0)
    for i=1,5 do
        r2 = r1:MultEven(r2)
    end
    print(r2:RotateVec(vec4(1,0,0,0)))
end

function EvenM:init()
    self.s = 1
    self.xy = 0
    self.xz = 0
    self.xw = 0
    self.yz = 0
    self.yw = 0
    self.zw = 0
    self.xyzw = 0
end
function EvenM:init(sVal,xyVal,xzVal,xwVal,yzVal,ywVal,zwVal,xyzwVal)
    self.s = sVal
    self.xy = xyVal
    self.xz = xzVal
    self.xw = xwVal
    self.yz = yzVal
    self.yw = ywVal
    self.zw = zwVal
    self.xyzw = xyzwVal
end
function EvenM:Print()
    print("s = "..self.s)
    print("xy = "..self.xy)
    print("xz = "..self.xz)
    print("xw = "..self.xw)
    print("yz = "..self.yz)
    print("yw = "..self.yw)
    print("zw = "..self.zw)
    print("xyzw = "..self.xyzw)
end
function EvenM:Shal()
    local hold = EvenM(self.s,self.xy,self.xz,self.xw,self.yz,self.yw,self.zw,self.xyzw)
    return hold
end
function EvenM:Plane()
    local hold = EvenM(0,self.xy,self.xz,self.xw,self.yz,self.yw,self.zw,0)
    return hold
end
function EvenM:ScaleMult(val)
    return EvenM(self.s*val,self.xy*val,self.xz*val,self.xw*val,self.yz*val,self.yw*val,self.zw*val,self.xyzw*val)
end
--mult doesn't preserve mag
function EvenM:TetMag()
    return (self.s^2)+(self.xy^2)+(self.xz^2)+(self.xw^2)+(self.yz^2)+(self.yw^2)+(self.zw^2)-(self.xyzw^2)
end
function EvenM:Mag()
    return (self.s^2)+(self.xy^2)+(self.xz^2)+(self.xw^2)+(self.yz^2)+(self.yw^2)+(self.zw^2)+(self.xyzw^2)
end
function EvenM:Normal()
    return(self:ScaleMult(math.sqrt(1/self:Mag())))
end
function EvenM:Conjugate()
    return EvenM(self.s,-self.xy,-self.xz,-self.xw,-self.yz,-self.yw,-self.zw,-self.xyzw)
end
function EvenM:Reverse()
    return EvenM(self.s,-self.xy,-self.xz,-self.xw,-self.yz,-self.yw,-self.zw,self.xyzw)
end
function EvenM:Stabilize()
    local max = 0
    if self.s > max then
        max = self.s
    end
    if self.xy > max then
        max = self.xy
    end
    if self.xz > max then
        max = self.xz
    end
    if self.xw > max then
        max = self.xw
    end
    if self.yz > max then
        max = self.yz
    end
    if self.yw > max then
        max = self.yw
    end
    if self.zw > max then
        max = self.zw
    end
    if self.xyzw > max then
        max = self.xyzw
    end
    return self:ScaleMult(1/max)
end
function EvenM:MultEven(evenM)
    local hold = EvenM()
    hold.s = (self.s*evenM.s)-(self.xy*evenM.xy)-(self.xz*evenM.xz)-(self.xw*evenM.xw)-(self.yz*evenM.yz)-(self.yw*evenM.yw)-(self.zw*evenM.zw)+(self.xyzw*evenM.xyzw)
    hold.xy = (self.s*evenM.xy)+(self.xy*evenM.s)-(self.xz*evenM.yz)-(self.xw*evenM.yw)+(self.yz*evenM.xz)+(self.yw*evenM.xw)-(self.zw*evenM.xyzw)-(self.xyzw*evenM.zw)
    hold.xz = (self.s*evenM.xz)+(self.xy*evenM.yz)+(self.xz*evenM.s)-(self.xw*evenM.zw)-(self.yz*evenM.xy)+(self.yw*evenM.xyzw)+(self.zw*evenM.xw)+(self.xyzw*evenM.yw)
    hold.xw = (self.s*evenM.xw)+(self.xy*evenM.yw)+(self.xz*evenM.zw)+(self.xw*evenM.s)-(self.yz*evenM.xyzw)-(self.yw*evenM.xy)-(self.zw*evenM.xz)-(self.xyzw*evenM.yz)
    hold.yz = (self.s*evenM.yz)-(self.xy*evenM.xz)+(self.xz*evenM.xy)-(self.xw*evenM.xyzw)+(self.yz*evenM.s)-(self.yw*evenM.zw)+(self.zw*evenM.yw)-(self.xyzw*evenM.xw)
    hold.yw = (self.s*evenM.yw)-(self.xy*evenM.xw)+(self.xz*evenM.xyzw)+(self.xw*evenM.xy)+(self.yz*evenM.zw)+(self.yw*evenM.s)-(self.zw*evenM.yz)+(self.xyzw*evenM.xz)
    hold.zw = (self.s*evenM.zw)-(self.xy*evenM.xyzw)-(self.xz*evenM.xw)+(self.xw*evenM.xz)-(self.yz*evenM.yw)+(self.yw*evenM.yz)+(self.zw*evenM.s)-(self.xyzw*evenM.xy)
    hold.xyzw = (self.s*evenM.xyzw)+(self.xy*evenM.zw)-(self.xz*evenM.yw)+(self.xw*evenM.yz)+(self.yz*evenM.xw)-(self.yw*evenM.xz)+(self.zw*evenM.xy)+(self.xyzw*evenM.s)
    return hold
end
function EvenM:MultOdd(oddM)
    local hold = OddM()
    hold.x = (self.s*oddM.x)+(self.xy*oddM.y)+(self.xz*oddM.z)+(self.xw*oddM.w)-(self.yz*oddM.xyz)-(self.yw*oddM.xyw)-(self.zw*oddM.xzw)-(self.xyzw*oddM.yzw)
    hold.y = (self.s*oddM.y)-(self.xy*oddM.x)+(self.xz*oddM.xyz)+(self.xw*oddM.xyw)+(self.yz*oddM.z)+(self.yw*oddM.w)-(self.zw*oddM.yzw)+(self.xyzw*oddM.xzw)
    hold.z = (self.s*oddM.z)-(self.xy*oddM.xyz)-(self.xz*oddM.x)+(self.xw*oddM.xzw)-(self.yz*oddM.y)+(self.yw*oddM.yzw)+(self.zw*oddM.w)-(self.xyzw*oddM.xyw)
    hold.w = (self.s*oddM.w)-(self.xy*oddM.xyw)-(self.xz*oddM.xzw)-(self.xw*oddM.x)-(self.yz*oddM.yzw)-(self.yw*oddM.y)-(self.zw*oddM.z)+(self.xyzw*oddM.xyz)
    hold.xyz = (self.s*oddM.xyz)+(self.xy*oddM.z)-(self.xz*oddM.y)+(self.xw*oddM.yzw)+(self.yz*oddM.x)-(self.yw*oddM.xzw)+(self.zw*oddM.xyw)+(self.xyzw*oddM.w)
    hold.xyw = (self.s*oddM.xyw)+(self.xy*oddM.w)-(self.xz*oddM.yzw)-(self.xw*oddM.y)+(self.yz*oddM.xzw)+(self.yw*oddM.x)-(self.zw*oddM.xyz)-(self.xyzw*oddM.z)
    hold.xzw = (self.s*oddM.xzw)+(self.xy*oddM.yzw)+(self.xz*oddM.w)-(self.xw*oddM.z)-(self.yz*oddM.xyw)+(self.yw*oddM.xyz)+(self.zw*oddM.x)+(self.xyzw*oddM.y)
    hold.yzw = (self.s*oddM.yzw)-(self.xy*oddM.xzw)+(self.xz*oddM.xyw)-(self.xw*oddM.xyz)+(self.yz*oddM.w)-(self.yw*oddM.z)+(self.zw*oddM.y)-(self.xyzw*oddM.x)
    return hold
end
function EvenM:Add(evenM)
    local hold = EvenM()
    hold.s = self.s + evenM.s
    hold.xy = self.xy + evenM.xy
    hold.xz = self.xz + evenM.xz
    hold.xw = self.xw + evenM.xw
    hold.yz = self.yz + evenM.yz
    hold.yw = self.yw + evenM.yw
    hold.zw = self.zw + evenM.zw
    hold.xyzw = self.xyzw + evenM.xyzw
    return hold
end
function EvenM:Sub(evenM)
    local hold = EvenM()
    hold.s = self.s - evenM.s
    hold.xy = self.xy - evenM.xy
    hold.xz = self.xz - evenM.xz
    hold.xw = self.xw - evenM.xw
    hold.yz = self.yz - evenM.yz
    hold.yw = self.yw - evenM.yw
    hold.zw = self.zw - evenM.zw
    hold.xyzw = self.xyzw - evenM.xyzw
    return hold
end
function EvenM:Inverse()
    local hold = self:MultEven(self:Reverse()):Conjugate()
    if math.abs(hold.s) == math.abs(hold.xyzw) then
        print("No inverse")
        hold = EvenM(0,0,0,0,0,0,0,0)
        return hold
    end
    hold = self:Reverse():MultEven(hold:ScaleMult(1/hold:TetMag()))
    return hold
end
function EvenM:GenFromVec(v1, v2)
    self.s = v1:dot(v2)
    self.xy = (v1.x*v2.y)-(v1.y*v2.x)
    self.xz = (v1.x*v2.z)-(v1.z*v2.x)
    self.xw = (v1.x*v2.w)-(v1.w*v2.x)
    self.yz = (v1.y*v2.z)-(v1.z*v2.y)
    self.yw = (v1.y*v2.w)-(v1.w*v2.y)
    self.zw = (v1.z*v2.w)-(v1.w*v2.z)
    self.xyzw = 0
end
function EvenM:GenRot(v1,v2,ang)
    local o1 = OddM()
    local o2 = OddM()
    o1 = o1:Vector(v1:normalize())
    o2 = o2:Vector(v2:normalize())
    local hold = o2:MultOdd(o1)
    if ang == nil then
        ang = math.acos(hold.s)/2
    else
        ang = (ang/360)*math.pi
    end
    hold.s = 0
    hold = hold:Normal()
    hold = hold:ScaleMult(math.sin(ang))
    hold.s = math.cos(ang)
    return hold
end
function EvenM:SetRotorAngle(ang)
    ang = ang*math.pi/360
    if math.abs(self.xyzw) > 0.000001 then
        print("not a rotor")
        return
    end
    local hold = self:Shal()
    hold.s = 0
    hold = hold:ScaleMult((1/math.sin(math.acos(self.s)))*math.sin(ang))
    hold.s = math.cos(ang)
    return hold
end
function EvenM:RotateVec(v1)
    local hold = OddM()
    hold = hold:Vector(v1)
    hold = self:MultOdd(hold)
    local inverse = self:Inverse()
    --local inverse = self:Reverse() use only if spinor is normalized
    hold = hold:MultEven(inverse)
    return vec4(hold.x,hold.y,hold.z,hold.w)
end
function EvenM:Renormalize()
    local holdVec = OddM(1,0,0,0,0,0,0,0)
    local hold = self:MultOdd(holdVec)
    holdVec.x = hold.x
    holdVec.y = hold.y
    holdVec.z = hold.z
    holdVec.w = hold.w
    holdVec = holdVec:Normal()
    hold = hold:MultOdd(holdVec)
    hold = hold:Normal()
    return hold:MultOdd(holdVec):MultOdd(OddM( 1,0,0,0,0,0,0,0))
end
function EvenM:Decompose(out,guess)
    local holdVec = OddM() --d
    holdVec = holdVec:Vector(guess)
    holdVec = holdVec:Normal()
    out[3] = holdVec:GetVec()
    local hold = self:MultOdd(holdVec)
    out[2] = hold:GetVec()
    out[2] = out[2]:normalize() --c
    holdVec = holdVec:Vector(out[2])
    hold = hold:MultOdd(holdVec)
    local holdPlane = hold:Shal()
    holdPlane.s = 0
    holdPlane = holdPlane:Normal()
    hold = hold:Normal()
    local guess2
    if (math.abs(holdPlane.xy) > 0.000001 or math.abs(holdPlane.xz) > 0.000001 or math.abs(holdPlane.xw) > 0.000001) then
        guess2 = OddM(1,0,0,0,0,0,0,0)
    elseif (math.abs(holdPlane.yz) > 0.000001 or math.abs(holdPlane.yw) > 0.000001) then
        guess2 = OddM(0,1,0,0,0,0,0,0)
    else
        guess2 = OddM(0,0,1,0,0,0,0,0)
    end
    holdVec = holdPlane:MultOdd(guess2)
    out[0] = holdVec:GetVec()
    out[0] = out[0]:normalize() --a
    holdVec = holdVec:Vector(out[0])
    holdVec = holdVec:MultEven(hold) --b
    out[1] = holdVec:GetVec()
    out[1] = out[1]:normalize()
end
function EvenM:DecompOrtho(out)
    local hold = EvenM(0,self.xy,self.xz,self.xw,self.yz,self.yw,self.zw,0)
    local holdSqr = hold:MultEven(hold)
    local b = (0.5)*(holdSqr.s+math.sqrt((holdSqr.s^2)-(holdSqr.xyzw^2)))
    local holdPlane = (EvenM(b,0,0,0,0,0,0,holdSqr.xyzw/2):MultEven(hold:Inverse())):Plane()
    local guess = OddM()
    if (math.abs(holdPlane.xy) > 0.000001 or math.abs(holdPlane.xz) > 0.000001 or math.abs(holdPlane.xw) > 0.000001) then
        guess = OddM(1,0,0,0,0,0,0,0)
    elseif (math.abs(holdPlane.yz) > 0.000001 or math.abs(holdPlane.yw) > 0.000001) then
        guess = OddM(0,1,0,0,0,0,0,0)
    else
        guess = OddM(0,0,1,0,0,0,0,0)
    end
    guess = holdPlane:MultOdd(guess)
    guess = guess:Vector(guess:GetVec())
    vecs = {}
    self:Decompose(vecs,guess:GetVec())
    --Desparate memory reuse
    out[0] = OddM:Vector(vecs[0]):MultOdd(OddM:Vector(vecs[1]))
    out[1] = OddM:Vector(vecs[2]):MultOdd(OddM:Vector(vecs[3]))
end
function EvenM:AngleLerp(scaleAmount)
    local hold = {}
    self:DecompOrtho(hold)
    hold[0] = hold[0]:SetRotorAngle(math.acos(hold[0].s)*scaleAmount*360/math.pi)
    hold[1] = hold[1]:SetRotorAngle(math.acos(hold[1].s)*scaleAmount*360/math.pi)
    return hold[0]:MultEven(hold[1])
end

OddM = class()
function OddM:init()
    self.x = 0
    self.y = 0
    self.z = 0
    self.w = 0
    self.xyz = 0
    self.xyw = 0
    self.xzw = 0
    self.yzw = 0
end
function OddM:init(xVal,yVal,zVal,wVal,xyzVal,xywVal,xzwVal,yzwVal)
    self.x = xVal
    self.y = yVal
    self.z = zVal
    self.w = wVal
    self.xyz = xyzVal
    self.xyw = xywVal
    self.xzw = xzwVal
    self.yzw = yzwVal
end
function OddM:Print()
    print("x = "..self.x)
    print("y = "..self.y)
    print("z = "..self.z)
    print("w = "..self.w)
    print("xyz = "..self.xyz)
    print("xyw = "..self.xyw)
    print("xzw = "..self.xzw)
    print("yzw = "..self.yzw)
end
function OddM:Shal()
    local hold = OddM(self.x,self.y,self.z,self.w,self.xyz,self.xyw,self.xzw,self.yzw)
    return hold
end
function OddM:ScaleMult(val)
    return OddM(self.x*val,self.y*val,self.z*val,self.w*val,self.xyz*val,self.xyw*val,self.xzw*val,self.yzw*val)
end
--mult doesn't preserve mag
function OddM:Mag()
    return (self.x^2)+(self.y^2)+(self.z^2)+(self.w^2)+(self.xyz^2)+(self.xyw^2)+(self.xzw^2)+(self.yzw^2)
end
function OddM:Normal()
    return(self:ScaleMult(math.sqrt(1/self:Mag())))
end
function OddM:Conjugate()
    return EvenM(-self.x,-self.y,-self.z,-self.w,-self.xyz,-self.xyw,-self.xzw,-self.yzw)
end
function OddM:Reverse()
    return OddM(self.x,self.y,self.z,self.w,-self.xyz,-self.xyw,-self.xzw,-self.yzw)
end
function OddM:MultOdd(oddM)
    local hold = EvenM()
    hold.s = (self.x*oddM.x)+(self.y*oddM.y)+(self.z*oddM.z)+(self.w*oddM.w)-(self.xyz*oddM.xyz)-(self.xyw*oddM.xyw)-(self.xzw*oddM.xzw)-(self.yzw*oddM.yzw)
    hold.xy = (self.x*oddM.y)-(self.y*oddM.x)+(self.z*oddM.xyz)+(self.w*oddM.xyw)+(self.xyz*oddM.z)+(self.xyw*oddM.w)-(self.xzw*oddM.yzw)+(self.yzw*oddM.xzw)
    hold.xz = (self.x*oddM.z)-(self.y*oddM.xyz)-(self.z*oddM.x)+(self.w*oddM.xzw)-(self.xyz*oddM.y)+(self.xyw*oddM.yzw)+(self.xzw*oddM.w)-(self.yzw*oddM.xyw)
    hold.xw = (self.x*oddM.w)-(self.y*oddM.xyw)-(self.z*oddM.xzw)-(self.w*oddM.x)-(self.xyz*oddM.yzw)-(self.xyw*oddM.y)-(self.xzw*oddM.z)+(self.yzw*oddM.xyz)
    hold.yz = (self.x*oddM.xyz)+(self.y*oddM.z)-(self.z*oddM.y)+(self.w*oddM.yzw)+(self.xyz*oddM.x)-(self.xyw*oddM.xzw)+(self.xzw*oddM.xyw)+(self.yzw*oddM.w)
    hold.yw = (self.x*oddM.xyw)+(self.y*oddM.w)-(self.z*oddM.yzw)-(self.w*oddM.y)+(self.xyz*oddM.xzw)+(self.xyw*oddM.x)-(self.xzw*oddM.xyz)-(self.yzw*oddM.z)
    hold.zw = (self.x*oddM.xzw)+(self.y*oddM.yzw)+(self.z*oddM.w)-(self.w*oddM.z)-(self.xyz*oddM.xyw)+(self.xyw*oddM.xyz)+(self.xzw*oddM.x)+(self.yzw*oddM.y)
    hold.xyzw = (self.x*oddM.yzw)-(self.y*oddM.xzw)+(self.z*oddM.xyw)-(self.w*oddM.xyz)+(self.xyz*oddM.w)-(self.xyw*oddM.z)+(self.xzw*oddM.y)-(self.yzw*oddM.x)
    return hold
end
function OddM:MultEven(evenM)
    local hold = OddM()
    hold.x = (self.x*evenM.s)-(self.y*evenM.xy)-(self.z*evenM.xz)-(self.w*evenM.xw)-(self.xyz*evenM.yz)-(self.xyw*evenM.yw)-(self.xzw*evenM.zw)+(self.yzw*evenM.xyzw)
    hold.y = (self.x*evenM.xy)+(self.y*evenM.s)-(self.z*evenM.yz)-(self.w*evenM.yw)+(self.xyz*evenM.xz)+(self.xyw*evenM.xw)-(self.xzw*evenM.xyzw)-(self.yzw*evenM.zw)
    hold.z = (self.x*evenM.xz)+(self.y*evenM.yz)+(self.z*evenM.s)-(self.w*evenM.zw)-(self.xyz*evenM.xy)+(self.xyw*evenM.xyzw)+(self.xzw*evenM.xw)+(self.yzw*evenM.yw)
    hold.w = (self.x*evenM.xw)+(self.y*evenM.yw)+(self.z*evenM.zw)+(self.w*evenM.s)-(self.xyz*evenM.xyzw)-(self.xyw*evenM.xy)-(self.xzw*evenM.xz)-(self.yzw*evenM.yz)
    hold.xyz = (self.x*evenM.yz)-(self.y*evenM.xz)+(self.z*evenM.xy)-(self.w*evenM.xyzw)+(self.xyz*evenM.s)-(self.xyw*evenM.zw)+(self.xzw*evenM.yw)-(self.yzw*evenM.xw)
    hold.xyw = (self.x*evenM.yw)-(self.y*evenM.xw)+(self.z*evenM.xyzw)+(self.w*evenM.xy)+(self.xyz*evenM.zw)+(self.xyw*evenM.s)-(self.xzw*evenM.yz)+(self.yzw*evenM.xz)
    hold.xzw = (self.x*evenM.zw)-(self.y*evenM.xyzw)-(self.z*evenM.xw)+(self.w*evenM.xz)-(self.xyz*evenM.yw)+(self.xyw*evenM.yz)+(self.xzw*evenM.s)-(self.yzw*evenM.xy)
    hold.yzw = (self.x*evenM.xyzw)+(self.y*evenM.zw)-(self.z*evenM.yw)+(self.w*evenM.yz)+(self.xyz*evenM.xw)-(self.xyw*evenM.xz)+(self.xzw*evenM.xy)+(self.yzw*evenM.s)
    return hold
end
function OddM:Add(oddM)
    local hold = OddM()
    hold.x = self.x + oddM.x
    hold.y = self.y + oddM.y
    hold.z = self.z + oddM.z
    hold.w = self.w + oddM.w
    hold.xyz = self.xyz + oddM.xyz
    hold.xyw = self.xyw + oddM.xyw
    hold.xzw = self.xzw + oddM.xzw
    hold.yzw = self.yzw + oddM.yzw
    return hold
end
function OddM:Sub(oddM)
    local hold = OddM()
    hold.x = self.x - oddM.x
    hold.y = self.y - oddM.y
    hold.z = self.z - oddM.z
    hold.w = self.w - oddM.w
    hold.xyz = self.xyz - oddM.xyz
    hold.xyw = self.xyw - oddM.xyw
    hold.xzw = self.xzw - oddM.xzw
    hold.yzw = self.yzw - oddM.yzw
    return hold
end
function OddM:Inverse()
    local hold = self:MultOdd(self:Reverse()):Conjugate()
    if math.abs(hold.s) == math.abs(hold.xyzw) then
        print("No inverse")
        hold = OddM(0,0,0,0,0,0,0,0)
        return hold
    end
    hold = self:Reverse():MultEven(hold:ScaleMult(1/hold:TetMag()))
    return hold
end
function OddM:Vector(v)
    local hold = OddM(v.x,v.y,v.z,v.w,0,0,0,0)
    return hold
end
function OddM:GenFromVec(v1,v2,v3)
    local hold = EvenM()
    hold:GenFromVec(v1,v2)
    local hold2 = OddM()
    hold2 = hold2:Vector(v3)
    hold2 = hold:MultOdd(hold2)
    self.x = hold2.x
    self.y = hold2.y
    self.z = hold2.z
    self.w = hold2.w
    self.xyz = hold2.xyz
    self.xyw = hold2.xyw
    self.xzw = hold2.xzw
    self.yzw = hold2.yzw
end
function OddM:GetVec()
    return vec4(self.x,self.y,self.z,self.w)
end

Octonion = class()

function Octonion:init()
    self.s = 0
    self.i = 0
    self.j = 0
    self.k = 0
    self.l = 0
    self.m = 0
    self.n = 0
    self.o = 0
end
function Octonion:init(sVal,iVal,jVal,kVal,lVal,mVal,nVal,oVal)
    self.s = sVal
    self.i = iVal
    self.j = jVal
    self.k = kVal
    self.l = lVal
    self.m = mVal
    self.n = nVal
    self.o = oVal
end
function Octonion:Mult(oct)
    local hold = Octonion()
    hold.s = (self.s*oct.s)-(self.i*oct.i)-(self.j*oct.j)-(self.k*oct.k)-(self.l*oct.l)-(self.m*oct.m)-(self.n*oct.n)-(self.o*oct.o)
    hold.i = (self.s*oct.i)+(self.i*oct.s)+(self.j*oct.k)-(self.k*oct.j)+(self.l*oct.m)-(self.m*oct.l)-(self.n*oct.o)+(self.o*oct.n)
    hold.j = (self.s*oct.j)-(self.i*oct.k)+(self.j*oct.s)+(self.k*oct.i)+(self.l*oct.n)+(self.m*oct.o)-(self.n*oct.l)-(self.o*oct.m)
    hold.k = (self.s*oct.k)+(self.i*oct.j)-(self.j*oct.i)+(self.k*oct.s)+(self.l*oct.o)-(self.m*oct.n)+(self.n*oct.m)-(self.o*oct.l)
    hold.l = (self.s*oct.l)-(self.i*oct.m)-(self.j*oct.n)-(self.k*oct.o)+(self.l*oct.s)+(self.m*oct.i)+(self.n*oct.j)+(self.o*oct.k)
    hold.m = (self.s*oct.m)+(self.i*oct.l)-(self.j*oct.o)+(self.k*oct.n)-(self.l*oct.i)+(self.m*oct.s)-(self.n*oct.k)+(self.o*oct.j)
    hold.n = (self.s*oct.n)+(self.i*oct.o)+(self.j*oct.l)-(self.k*oct.m)-(self.l*oct.j)+(self.m*oct.k)+(self.n*oct.s)-(self.o*oct.i)
    hold.o = (self.s*oct.o)-(self.i*oct.n)+(self.j*oct.m)+(self.k*oct.l)-(self.l*oct.k)-(self.m*oct.j)+(self.n*oct.i)+(self.o*oct.s)
    return hold
end
function Octonion:AltMult(oct)
    local hold = Octonion()
    hold.s = (self.s*oct.s)-(self.i*oct.i)-(self.j*oct.j)-(self.k*oct.k)+(self.l*oct.l)-(self.m*oct.m)-(self.n*oct.n)-(self.o*oct.o)
    hold.i = (self.s*oct.i)+(self.i*oct.s)+(self.j*oct.k)-(self.k*oct.j)-(self.l*oct.m)-(self.m*oct.l)-(self.n*oct.o)+(self.o*oct.n)
    hold.j = (self.s*oct.j)-(self.i*oct.k)+(self.j*oct.s)+(self.k*oct.i)+(self.l*oct.n)-(self.m*oct.o)+(self.n*oct.l)+(self.o*oct.m)
    hold.k = (self.s*oct.k)+(self.i*oct.j)-(self.j*oct.i)+(self.k*oct.s)-(self.l*oct.o)-(self.m*oct.n)+(self.n*oct.m)-(self.o*oct.l)
    hold.l = (self.s*oct.l)+(self.i*oct.m)-(self.j*oct.n)+(self.k*oct.o)+(self.l*oct.s)+(self.m*oct.i)-(self.n*oct.j)+(self.o*oct.k)
    hold.m = (self.s*oct.m)-(self.i*oct.l)+(self.j*oct.o)+(self.k*oct.n)-(self.l*oct.i)+(self.m*oct.s)-(self.n*oct.k)-(self.o*oct.j)
    hold.n = (self.s*oct.n)+(self.i*oct.o)+(self.j*oct.l)-(self.k*oct.m)+(self.l*oct.j)+(self.m*oct.k)+(self.n*oct.s)-(self.o*oct.i)
    hold.o = (self.s*oct.o)-(self.i*oct.n)-(self.j*oct.m)-(self.k*oct.l)-(self.l*oct.k)+(self.m*oct.j)+(self.n*oct.i)+(self.o*oct.s)
    return hold
end
function Octonion:DaltMult(oct)
    local hold = Octonion()
    hold.s = (self.s*oct.s)-(self.i*oct.i)-(self.j*oct.j)-(self.k*oct.k)-(self.l*oct.l)-(self.m*oct.m)-(self.n*oct.n)-(self.o*oct.o)
    hold.i = (self.s*oct.i)+(self.i*oct.s)+(self.j*oct.k)-(self.k*oct.j)+(self.l*oct.m)-(self.m*oct.l)-(self.n*oct.o)+(self.o*oct.n)
    hold.j = (self.s*oct.j)-(self.i*oct.k)+(self.j*oct.s)+(self.k*oct.i)+(self.l*oct.n)+(self.m*oct.o)-(self.n*oct.l)-(self.o*oct.m)
    hold.k = (self.s*oct.k)+(self.i*oct.j)-(self.j*oct.i)+(self.k*oct.s)+(self.l*oct.o)-(self.m*oct.n)+(self.n*oct.m)-(self.o*oct.l)
    hold.l = (self.s*oct.l)-(self.i*oct.m)-(self.j*oct.n)-(self.k*oct.o)+(self.l*oct.s)+(self.m*oct.i)+(self.n*oct.j)+(self.o*oct.k)
    hold.m = (self.s*oct.m)+(self.i*oct.l)-(self.j*oct.o)+(self.k*oct.n)-(self.l*oct.i)+(self.m*oct.s)-(self.n*oct.k)+(self.o*oct.j)
    hold.n = (self.s*oct.n)+(self.i*oct.o)+(self.j*oct.l)-(self.k*oct.m)-(self.l*oct.j)+(self.m*oct.k)+(self.n*oct.s)-(self.o*oct.i)
    hold.o = (self.s*oct.o)-(self.i*oct.n)+(self.j*oct.m)+(self.k*oct.l)-(self.l*oct.k)-(self.m*oct.j)+(self.n*oct.i)+(self.o*oct.s)
    
    hold.s = hold.s + 2*((self.l*oct.l))
    hold.i = hold.i - 2*((self.l*oct.m))
    hold.j = hold.j + 2*((self.n*oct.l)+(self.o*oct.m)-(self.m*oct.o))
    hold.k = hold.k - 2*((self.l*oct.o))
    hold.l = hold.l + 2*((self.i*oct.m)+(self.k*oct.o)-(self.n*oct.j))
    hold.m = hold.m + 2*((self.j*oct.o)-(self.i*oct.l)-(self.o*oct.j))
    hold.n = hold.n + 2*((self.l*oct.j))
    hold.o = hold.o + 2*((self.m*oct.j)-(self.j*oct.m)-(self.k*oct.l))
    return hold
end
function Octonion:Print()
    print("s = "..self.s)
    print("i = "..self.i)
    print("j = "..self.j)
    print("k = "..self.k)
    print("l = "..self.l)
    print("m = "..self.m)
    print("n = "..self.n)
    print("o = "..self.o)
end
function Octonion:AltPrint()
    print("s = "..self.s)
    print("k = "..self.k)
    print("j = "..self.j)
    print("m = "..self.m)
    print("i = "..self.i)
    print("n = "..self.n)
    print("o = "..self.o)
    print("l = "..self.l)
end

function draw()
    
end

--[[ evenM'th
tester = EvenM(1,-2,3,5,11,-13,17,23)
result = tester:MultEven(tester:Reverse())
result = result:MultEven(result:Conjugate():ScaleMult(1/result:TetMag()))
result = tester:MultEven(tester:Reverse()):Conjugate()
result = tester:BiConjugate():MultEven(result:ScaleMult(1/result:TetMag()))
result = tester:MultEven(result)
--result:Print()
tester = EvenM(1,1,1,0,1,0,0,0)
tester = tester:Normal()
tester = tester:MultEven(tester:Reverse())
--tester:Print()

o1 = Octonion(1,1,1,1,1,1,1,1)
o2 = Octonion(1,2,-1,-2,3,5,-3,7)
o3 = Octonion(3,-5,7,3,-2,1,1,-3)
--o1:Mult(o2):Print()
print("1----------")
o1:AltMult(o2):AltMult(o3):Print()
print("2----------")
o1:AltMult(o2:AltMult(o3)):Print()

o1 = Octonion(1,5,3,2,8,4,6,7)
o2 = Octonion(-7,1,13,-11,-5,17,2,3)
o3 = Octonion(4,-3,2,-5,6,1,8,5)
o1:AltMult(o2):AltMult(o3):AltPrint()
s1 = EvenM(1,2,3,4,5,6,7,8)
s2 = EvenM(-7,-11,13,17,1,2,3,-5)
s3 = EvenM(4,-5,2,1,-3,8,5,6)
s1:MultEven(s2):MultEven(s3):Print()

A = 0.35355339
--Find one without inverse
s1 = EvenM(A,A,A,-A,A,A,-A,A)
s1:Print()
print("inverse---------")
s1:Inverse():Print()
print("identity--------")
s1:MultEven(s1:Inverse()):Print()

r1 = EvenM(1,1,1,1,1,1,1,1)
r2 = EvenM(1,2,2,2,2,2,2,1)
r1:GenFromVec(vec4(1,1,1,1),vec4(1,0,0,0))
r2:GenFromVec(vec4(-1,-4,6,3),vec4(1,1,0,0))
r1 = r2:MultEven(r1)
for i=1,60 do
    r1=r1:MultEven(r1)
    r1 = r1:Stablize()
end
r1:Print()
print(r1:RotateVec(vec4(1,0,0,0)):len())

r1 = EvenM(0,0,0,-0.22941573,0,0.6882472,-0.6882472,0)
r1 = r1:ScaleMult(0.195720340315)
r1.s = math.cos(0.098914756299)
r2 = EvenM(0,0.918329032,-0.3638326,0,0.15592826,0,0,0)
r2 = r2:ScaleMult(0.863884324554)
r2.s = math.cos(2.09017487292)
--r1:Print()
--r2:Print()
r1 = r1:MultEven(r2)
--result:Sub(r1):Print()
r2 = EvenM(1,-3,1,-1,4,2,-2,2)
r1:GenFromVec(vec4(0,-1/3,1/3,1/3), vec4(0,3,0,0))
r2:GenFromVec(vec4(1,0,1,0),vec4(2,3,0,0))
res = r2:MultEven(r1)
r2 = EvenM(1,-1/12,-7/30,13/60,1/60,2/15,5/12,0)
r1:GenFromVec(vec4(-195/137,-35/137,-1,-221/137),vec4(-7/30,1/60,0,-5/12))

r2:GenFromVec(vec4(-5,5,1,3),vec4(1,0,0,0))
r1:Print()
--r1:MultEven(r2):Sub(res):Print()

r1:GenFromVec(vec4(0.70710678,0.7071068,0,0),vec4(1,0,0,0))
r2:GenFromVec(vec4(0,0,0,1),vec4(0,0,1,0))
r1:GenFromVec(vec4(0,0,-0.70710678, 0.70710678),vec4(0.5,0.5,0.5,0.5))
r2:GenFromVec(vec4(-0.5,0.5,0.5,0.5), vec4(0,1,0,0))
--r1:Print()
l = r1:RotateVec(vec4(1.7,0.4,-0.8,1))
l = r2:RotateVec(l)
print(l)
--[[r1:GenFromVec(vec4(0.92387953,0.38268342,0,0),vec4(1,0,0,0))
r2:GenFromVec(vec4(0,0,0.70710678,0.70710678),vec4(0,0,1,0))
r1=EvenM(0.8660254,-0.28867513,0,0,-0.28867513,-0.2886751,0,0)
r2=EvenM(0.70710678,0,0.25,-0.25,0.25,-0.25,-0.5,0)
--r1:Print()
r2:MultEven(r1):Print()--]]

--[[
--Grade 1
local hold = EvenM()
hold.s = (self.s*v1.x)+(self.xy*v1.y)+(self.xz*v1.z)+(self.xw*v1.w)
hold.xy = (self.s*v1.y)-(self.xy*v1.x)+(self.yz*v1.z)+(self.yw*v1.w)
hold.xz = (self.s*v1.z)-(self.xz*v1.x)-(self.yz*v1.y)+(self.zw*v1.w)
hold.xw = (self.s*v1.w)-(self.xw*v1.x)-(self.yw*v1.y)-(self.zw*v1.z)
--Grade 3
hold.yz = (self.xy*v1.z)-(self.xz*v1.y)+(self.yz*v1.x)+(self.xyzw*v1.w)
hold.yw = (self.xy*v1.w)-(self.xw*v1.y)+(self.yw*v1.x)-(self.xyzw*v1.z)
hold.zw = (self.xz*v1.w)-(self.xw*v1.z)+(self.zw*v1.x)+(self.xyzw*v1.y)
hold.xyzw = (self.yz*v1.w)-(self.yw*v1.z)+(self.zw*v1.y)-(self.xyzw*v1.x)
--Grade 3
--print("e")
--hold:Print()
local inverse = self:Inverse()
local outVec = vec4()
outVec.x = (hold.s*inverse.s)-(hold.xy*inverse.xy)-(hold.xz*inverse.xz)-(hold.xw*inverse.xw)-(hold.yz*inverse.yz)-(hold.yw*inverse.yw)-(hold.zw*inverse.zw)+(hold.xyzw*inverse.xyzw)
outVec.y = (hold.s*inverse.xy)+(hold.xy*inverse.s)-(hold.xz*inverse.yz)-(hold.xw*inverse.yw)+(hold.yz*inverse.xz)+(hold.yw*inverse.xw)-(hold.zw*inverse.xyzw)-(hold.xyzw*inverse.zw)
outVec.z = (hold.s*inverse.xz)+(hold.xy*inverse.yz)+(hold.xz*inverse.s)-(hold.xw*inverse.zw)-(hold.yz*inverse.xy)+(hold.yw*inverse.xyzw)+(hold.zw*inverse.xw)+(hold.xyzw*inverse.yw)
outVec.w = (hold.s*inverse.xw)+(hold.xy*inverse.yw)+(hold.xz*inverse.zw)+(hold.xw*inverse.s)-(hold.yz*inverse.xyzw)-(hold.yw*inverse.xy)-(hold.zw*inverse.xz)-(hold.xyzw*inverse.yz)
return outVec

d = OddM(0.57735027,0.57735027,0.57735027,0,0,0,0,0)
local holdVec = OddM(0.57735027,0.57735027,0.57735027,0,0,0,0,0) --d
local hold = r1:MultOdd(holdVec)
holdVec.x = hold.x
holdVec.y = hold.y
holdVec.z = hold.z
holdVec.w = hold.w
holdVec = holdVec:Normal() --c
hold = hold:MultOdd(holdVec)
holdhold = hold:ScaleMult(1)
holdhold.s = 0
holdhold = holdhold:Normal()
hold = hold:Normal()
--hold:Print()
--holdVec:Print()
l = OddM(0,1,0,0,0,0,0,0)
h = holdhold:MultOdd(l)
l.x = h.x
l.y = h.y
l.z = h.z
l.w = h.w
l = l:Normal() --a
h = l:MultEven(hold) --b
--l:Print()
h:Print()
--l:MultOdd(h):Sub(hold):Print()
--h:MultOdd(l):Print()
--hold = l:MultOdd(OddM(0,1,0,0,0,0,0,0)):MultOdd(holdVec):MultOdd(OddM(0.57735027,0.57735027,0.57735027,0,0,0,0,0))
hold = l:MultOdd(h):MultOdd(holdVec):MultOdd(d)
--hold:Sub(r1):Print()
--OddM(-0.57735027,0,0.577350270,0.57735027,0,0,0,0):MultEven(EvenM(0.5,-0.5,0,0,-0.5,-0.5,0,0)):Print()
--]]

--bung thing
