extends Node2D
func _ready() -> void: queue_redraw()
func _draw() -> void:
    draw_rect(Rect2(0,0,2600,1080),Color("#071027"))
    draw_circle(Vector2(1580,150),70,Color("#cad8ff"))
    draw_circle(Vector2(1610,130),68,Color("#071027"))
    for i in range(13):
        var x := float(i*205)
        var h := float(270+(i%5)*70)
        var top := 900.0-h
        draw_rect(Rect2(x,top,190,h),Color("#0c1834") if i%2==0 else Color("#111d3d"))
        for row in range(3,int(h/65.0)):
            for col in range(1,5):
                var p:=Vector2(x+col*35.0,top+row*52.0)
                draw_rect(Rect2(p,Vector2(17,25)),Color("#ffcb65") if (row+col+i)%4!=0 else Color("#142651"))
    draw_rect(Rect2(0,860,2600,220),Color("#111522"))
    draw_rect(Rect2(0,900,2600,15),Color("#252b3b"))
    for x in range(0,2600,220): draw_rect(Rect2(x+35,985,120,10),Color("#c9c7a4"))
