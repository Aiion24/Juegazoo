extends CharacterBody2D
@export var speed: float = 430.0
@export var jump_velocity: float = -900.0
@export var gravity: float = 2300.0
var health: int = 100
var ammunition: int = 12
var maximum_ammunition: int = 12
var facing: int = 1
var attack_locked := false
var invulnerable := false
func _ready() -> void:
    add_to_group("player")
    var c:=CollisionShape2D.new(); var s:=CapsuleShape2D.new(); s.radius=37; s.height=170; c.shape=s; c.position=Vector2(0,-5); add_child(c)
    var cam:=Camera2D.new(); cam.position=Vector2(280,-170); cam.position_smoothing_enabled=true; cam.position_smoothing_speed=7.0; cam.limit_left=0; cam.limit_right=2600; cam.limit_top=0; cam.limit_bottom=1080; add_child(cam)
    Tilt.calibrate(); queue_redraw()
func _physics_process(delta: float) -> void:
    if not is_on_floor(): velocity.y += gravity*delta
    var axis:=Tilt.get_move_axis(delta)
    if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): axis=-1.0
    elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): axis=1.0
    if not attack_locked:
        velocity.x=axis*speed
        if abs(axis)>0.08: facing=1 if axis>0 else -1
    move_and_slide(); queue_redraw()
func action(kind:String)->void:
    match kind:
        "jump": if is_on_floor() and not attack_locked: velocity.y=jump_velocity
        "punch": if not attack_locked: _melee_attack(150.0,20)
        "kick": if not attack_locked: _melee_attack(205.0,28)
        "dodge": if not attack_locked: invulnerable=true; velocity.x=facing*850.0; _unlock_later(0.32)
        "shoot": if not attack_locked and ammunition>0: ammunition-=1; _ranged_attack()
        "reload": if not attack_locked: ammunition=maximum_ammunition
func _melee_attack(distance:float,damage:int)->void:
    for enemy in get_tree().get_nodes_in_group("enemy"):
        if is_instance_valid(enemy):
            var d:Vector2=enemy.global_position-global_position
            if abs(d.x)<=distance and abs(d.y)<=120 and sign(d.x)==facing and enemy.has_method("take_damage"): enemy.take_damage(damage)
func _ranged_attack()->void:
    for enemy in get_tree().get_nodes_in_group("enemy"):
        if is_instance_valid(enemy):
            var d:Vector2=enemy.global_position-global_position
            if sign(d.x)==facing and abs(d.x)<800 and abs(d.y)<150 and enemy.has_method("take_damage"): enemy.take_damage(35); break
func _unlock_later(t:float)->void:
    attack_locked=true
    await get_tree().create_timer(t).timeout
    attack_locked=false; invulnerable=false
func take_damage(amount:int)->void:
    if invulnerable: return
    health=max(health-amount,0); invulnerable=true
    await get_tree().create_timer(0.45).timeout
    invulnerable=false
    if health<=0: health=100; global_position=Vector2(350,800)
func _draw()->void:
    var o:=Color("#091020"); var skin:=Color("#d97a48"); var body:=Color("#f2f0ec"); var pants:=Color("#1651a1")
    draw_circle(Vector2(0,82),50,Color(0,0,0,0.35))
    draw_line(Vector2(-17,20),Vector2(-30,78),o,34); draw_line(Vector2(-17,20),Vector2(-30,78),pants,25)
    draw_line(Vector2(17,20),Vector2(32,78),o,34); draw_line(Vector2(17,20),Vector2(32,78),pants,25)
    draw_rect(Rect2(-40,-62,80,90),o); draw_rect(Rect2(-33,-57,66,80),body)
    draw_circle(Vector2(0,-92),32,o); draw_circle(Vector2(0,-88),26,skin)
    draw_line(Vector2(-27,-40),Vector2(-48,5),o,22); draw_line(Vector2(27,-40),Vector2(48,5),o,22)
