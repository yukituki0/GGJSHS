extends CanvasLayer
## F4: 성능 표시 (버벅임 원인 찾기용, 어느 화면에서나)
## FPS / 최근 2초 중 가장 느린 프레임 / 화면 주사율 / 그림 메모리(VRAM) / 메모리 / 한 프레임 게임 처리 시간

var _label: Label
var _worst := 0.0
var _worst_shown := 0.0
var _timer := 0.0
var _hitches := 0               # 지난 2초 동안 33ms(2프레임) 넘게 걸린 프레임 수
var _hitches_shown := 0


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_label = Label.new()
	_label.position = Vector2(8, 8)
	_label.add_theme_font_size_override("font_size", 16)
	_label.add_theme_color_override("font_color", Color(0.4, 1, 0.4))
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 4)
	_label.visible = false
	add_child(_label)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_F4:
		_label.visible = not _label.visible


func _process(delta: float) -> void:
	_worst = maxf(_worst, delta)
	if delta > 0.033:
		_hitches += 1
	_timer += delta
	if _timer >= 2.0:
		_worst_shown = _worst
		_hitches_shown = _hitches
		_worst = 0.0
		_hitches = 0
		_timer = 0.0
	if not _label.visible:
		return
	var vram := Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576.0
	var mem := Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	_label.text = "FPS %d   가장 느린 프레임 %.0fms   멈칫 %d번 (2초)\n화면 %dHz   VSync %s   그림 메모리 %.0fMB   메모리 %.0fMB\n게임 처리 %.1fms   그리기 처리 %.1fms   %s" % [
		Engine.get_frames_per_second(), _worst_shown * 1000.0, _hitches_shown,
		maxi(0, int(DisplayServer.screen_get_refresh_rate())), ["끔", "켬", "적응", "메일박스"][DisplayServer.window_get_vsync_mode()],
		vram, mem,
		Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0,
		Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0,
		"디버그(에디터) 실행" if OS.is_debug_build() else "내보낸 실행 파일",
	]
