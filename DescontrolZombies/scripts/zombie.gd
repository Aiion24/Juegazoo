extends CharacterBody2D
@export var speed: float = 105.0
@export var maximum_health: int = 70
@export var damage: int = 8
var health:int
var gravity:=2300.0
var attack_cooldown:=0.0
func _ready()->void:
    add_to_group("enemy"); health=maximum_health
    var c:=CollisionShape2D.new(); var s:=CapsuleShape2D.new(); s.radius=36; s.height=160; c.shape=s; add_child(c); queue_redraw()
func _physics_process(delta:float)->void:
    if not is_on_floor(): velocity.y+=gravity*delta
    attack_cooldown=max(attack_cooldown-delta,0.0)
    var p:=get_tree().get_first_node_in_group("player")
    if p and is_instance_valid(p):
        var d:Vector2=p.global_position-global_position
        if abs(d.x)>86: velocity.x=sign(d.x)*speed
        else:
            velocity.x=move_toward(velocity.x,0,600*delta)
            if attack_cooldown<=0 and p.has_method("take_damage"): p.take_damage(damage); attack_cooldown=0.85
    move_and_slide(); queue_redraw()
func take_damage(amount:int)->void:
    health-=amount
    if health<=0: queue_free()
func _draw()->void:
    var skin:=Color("#9ab56e"); var clothes:=Color("#5b3049"); var o:=Color("#130d1d")
    draw_circle(Vector2(0,78),48,Color(0,0,0,0.3)); draw_line(Vector2(-14,20),Vector2(-26,78),o,33); draw_line(Vector2(14,20),Vector2(30,78),o,33)
    draw_rect(Rect2(-38,-56,76,82),o); draw_rect(Rect2(-31,-49,62,69),clothes); draw_circle(Vector2(0,-84),31,o); draw_circle(Vector2(0,-82),24,skin)
    draw_circle(Vector2(-9,-87),4,Color("#ff273b")); draw_circle(Vector2(10,-87),4,Color("#ff273b"))
