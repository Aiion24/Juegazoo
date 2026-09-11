extends CanvasLayer
var health_label:Label
var ammo_label:Label
func _ready()->void:
    var ui:=Control.new(); ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(ui)
    health_label=_label(ui,"VIDA: 100",Vector2(45,35),32); ammo_label=_label(ui,"MUNICIÓN: 12/12",Vector2(45,85),27)
    _btn(ui,"CALIBRAR",Vector2(45,900),Vector2(230,105),"calibrate"); _btn(ui,"SALTAR",Vector2(300,900),Vector2(220,105),"jump"); _btn(ui,"RECARGA",Vector2(1030,900),Vector2(205,105),"reload"); _btn(ui,"ESQUIVA",Vector2(1250,820),Vector2(205,105),"dodge"); _btn(ui,"DISPARO",Vector2(1470,900),Vector2(205,105),"shoot"); _btn(ui,"PATADA",Vector2(1690,780),Vector2(190,105),"kick"); _btn(ui,"GOLPE",Vector2(1690,920),Vector2(190,105),"punch")
func _process(_d:float)->void:
    var p:=get_tree().get_first_node_in_group("player")
    if p: health_label.text="VIDA: %d"%p.health; ammo_label.text="MUNICIÓN: %d/%d"%[p.ammunition,p.maximum_ammunition]
func _label(parent:Control,t:String,pos:Vector2,fs:int)->Label:
    var l:=Label.new(); l.text=t; l.position=pos; l.size=Vector2(500,60); l.add_theme_font_size_override("font_size",fs); parent.add_child(l); return l
func _btn(parent:Control,t:String,pos:Vector2,size:Vector2,a:String)->void:
    var b:=Button.new(); b.text=t; b.position=pos; b.size=size; b.add_theme_font_size_override("font_size",24); b.pressed.connect(func(): _send(a)); parent.add_child(b)
func _send(a:String)->void:
    if a=="calibrate": Tilt.calibrate(); return
    var p:=get_tree().get_first_node_in_group("player")
    if p: p.action(a)
