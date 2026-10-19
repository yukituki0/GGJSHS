extends Node2D
## 대전 화면의 HUD/연출 글자를 캐릭터보다 위에 그리기 위한 노드 (z_index가 높음)
## 실제 그리는 내용은 Match.draw_overlay()에 있다


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	get_parent().draw_overlay(self)
