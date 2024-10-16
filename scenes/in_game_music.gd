extends Node
@onready var ongoing_wave_audio_stream_player_2d: AudioStreamPlayer2D = $OngoingWaveAudioStreamPlayer2D
@onready var in_between_waves_audio_stream_player_2d_2: AudioStreamPlayer2D = $InBetweenWavesAudioStreamPlayer2D2

const BETWEEN_WAVES = preload("res://assets/Sound/in_game/between_waves.ogg")
const FIRST_ONGOING_WAVE_MUSIC = preload("res://assets/Sound/in_game/first_ongoing_wave_music.ogg")
const ONGOING_WAVE_MUSIC = preload("res://assets/Sound/in_game/ongoing_wave_music.ogg")

@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager


func _ready() -> void:
	ongoing_wave_audio_stream_player_2d.bus = "Music"
	in_between_waves_audio_stream_player_2d_2.bus = "Music"

	ongoing_wave_audio_stream_player_2d.stream = FIRST_ONGOING_WAVE_MUSIC
	ongoing_wave_audio_stream_player_2d.play()
	wave_manager.end_of_wave.connect(play_between_waves)
	wave_manager.new_wave_started.connect(play_ongoing_wave)
	
func play_ongoing_wave(wave: int) -> void:
	if wave == 1: return
	ongoing_wave_audio_stream_player_2d.stream = ONGOING_WAVE_MUSIC
	ongoing_wave_audio_stream_player_2d.play()
	in_between_waves_audio_stream_player_2d_2.stop()

	
func play_between_waves(_time_until_next_wave: float) -> void:
	in_between_waves_audio_stream_player_2d_2.stream = BETWEEN_WAVES
	in_between_waves_audio_stream_player_2d_2.play()
	ongoing_wave_audio_stream_player_2d.stop()
	
