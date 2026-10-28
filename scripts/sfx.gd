extends Node
## 효과음 / 배경음 재생 (Autoload 싱글톤, 이름: Sfx)
##
## assets/sound/<이름>.ogg / .wav / .mp3 를 이름으로 찾아서 재생한다. 파일이 없으면 조용히 넘어간다.
## 지금 들어 있는 효과음은 tools/make_sfx.py로 합성한 임시 소리. 같은 이름의 파일로 덮어쓰면 바뀐다.
## 배경음: bgm_menu (메뉴 화면), bgm_battle1, bgm_battle2 ... (대전, 경기마다 하나를 무작위로) - 파일을 넣으면 반복 재생된다
## 곡 출처·라이선스는 README.md의 "음악 출처"

const POOL_SIZE := 12           # 동시에 날 수 있는 효과음 수

var _players: Array[AudioStreamPlayer] = []
var _next := 0
var _cache := {}
var _bgm: AudioStreamPlayer
var _bgm_name := ""


## 재생기 만들기. _ready()보다 먼저 불릴 수 있어서(첫 화면의 _enter_tree 등) 처음 쓸 때 만든다
func _setup() -> void:
	if _bgm != null:
		return
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	_bgm = AudioStreamPlayer.new()
	_bgm.volume_db = -8.0
	_bgm.finished.connect(func(): _bgm.play())  # 끝나면 처음부터 다시 (반복)
	add_child(_bgm)
	# 효과음은 작으니 처음에 다 불러 둔다 (처음 나는 순간 파일을 읽느라 멈칫하지 않게)
	for f in ResourceLoader.list_directory("res://assets/sound/"):
		if f.ends_with(".wav"):
			_stream(f.get_basename())


func _stream(sound: String) -> AudioStream:
	if _cache.has(sound):
		return _cache[sound]
	var found: AudioStream = null
	for ext in ["ogg", "wav", "mp3"]:
		var path := "res://assets/sound/%s.%s" % [sound, ext]
		if ResourceLoader.exists(path):
			found = load(path)
			break
	_cache[sound] = found
	return found


## 효과음 재생. pitch_jitter를 주면 매번 음높이가 살짝 달라져서 덜 반복적으로 들린다
func play(sound: String, volume_db := 0.0, pitch_jitter := 0.0) -> void:
	_setup()
	var stream := _stream(sound)
	if stream == null:
		return
	var p := _players[_next]
	_next = (_next + 1) % POOL_SIZE
	p.stream = stream
	p.volume_db = volume_db
	p.pitch_scale = 1.0 + randf_range(-pitch_jitter, pitch_jitter)
	p.play()


## 배경음 바꾸기. 같은 곡이 이미 나오고 있으면 그대로 둔다. 파일이 없으면 멈춤
## prefix1, prefix2 ... 중 있는 파일 하나를 무작위로 틀기 (없으면 prefix 이름 그대로)
func play_bgm_random(prefix: String) -> void:
	var names: Array[String] = []
	var i := 1
	while _stream("%s%d" % [prefix, i]) != null:
		names.append("%s%d" % [prefix, i])
		i += 1
	play_bgm(names.pick_random() if not names.is_empty() else prefix)


func play_bgm(sound: String) -> void:
	_setup()
	if sound == _bgm_name and _bgm.playing:
		return
	_bgm_name = sound
	var stream := _stream(sound)
	if stream == null:
		_bgm.stop()
		return
	_bgm.stream = stream
	_bgm.play()
