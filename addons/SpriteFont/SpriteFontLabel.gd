@tool
@icon("res://addons/SpriteFont/SpriteFont.svg")
class_name SpriteFontLabel
extends Control

signal finished_typing

enum InspectorLanguage { ENGLISH, ESPANOL }

## Idioma de la interfaz del Inspector / Inspector UI Language
@export_enum("English", "Español") var inspector_language: int = 0:
	set(value):
		inspector_language = value
		notify_property_list_changed()
		update_minimum_size()
		queue_redraw()

# --- PROPIEDADES EN ESPAÑOL CON DOCUMENTACIÓN (DOCSTRINGS) ---

## Texto o diálogo a mostrar. Soporta etiquetas: [shake], [wave], [speed=0.1], [pause=1.5]
var texto: String:
	get: return text
	set(value): text = value

## Efecto de sonido (.wav / .ogg) reproducido al aparecer cada letra.
var sonido_escritura: AudioStream:
	get: return typewriter_sound
	set(value): typewriter_sound = value

## Variación aleatoria del tono (Pitch) para evitar repetición de audio (0.0 a 0.5).
var variacion_tono: float:
	get: return pitch_randomness
	set(value): pitch_randomness = value

## Si es verdadero, no reproduce sonido al escribir espacios en blanco.
var silenciar_en_espacios: bool:
	get: return silence_on_spaces
	set(value): silence_on_spaces = value

## Intensidad del temblor en píxeles para la etiqueta [shake].
var intensidad_temblor: float:
	get: return shake_intensity
	set(value): shake_intensity = value

## Amplitud u altura de la ola en píxeles para la etiqueta [wave].
var amplitud_ola: float:
	get: return wave_amplitude
	set(value): wave_amplitude = value

## Velocidad de oscilación de la ola para la etiqueta [wave].
var velocidad_ola: float:
	get: return wave_speed
	set(value): wave_speed = value

## Activa el salto de línea automático tras alcanzar cierto límite de palabras por renglón.
var limite_de_palabras: bool:
	get: return enable_word_limit
	set(value): enable_word_limit = value

## Cantidad máxima de palabras por línea antes de saltar automáticamente.
var max_palabras_por_linea: int:
	get: return max_words_per_line
	set(value): max_words_per_line = value

## Cantidad de caracteres visibles (-1 muestra todo el texto).
var caracteres_visibles: int:
	get: return visible_characters
	set(value): visible_characters = value

## Tiempo base en segundos por cada letra en la máquina de escribir.
var velocidad_escritura: float:
	get: return typewriter_speed
	set(value): typewriter_speed = value

## Inicia la animación de máquina de escribir automáticamente al cargar la escena.
var inicio_automatico: bool:
	get: return autostart
	set(value): autostart = value

## Textura o Spritesheet con la hoja de caracteres.
var textura_fuente: Texture2D:
	get: return font_texture
	set(value): font_texture = value

## Mapa de caracteres en el mismo orden que aparecen en la imagen.
var mapa_caracteres: String:
	get: return character_map
	set(value): character_map = value

## Cantidad de columnas (caracteres a lo ancho en la imagen).
var columnas: int:
	get: return columns
	set(value): columns = value

## Cantidad de filas (caracteres a lo alto en la imagen).
var filas: int:
	get: return rows
	set(value): rows = value

## Recorta automáticamente márgenes transparentes a lo ancho y alto por letra.
var proporcional: bool:
	get: return proportional
	set(value): proportional = value

## Espaciado horizontal adicional entre letras en píxeles.
var espaciado_letras: int:
	get: return letter_spacing
	set(value): letter_spacing = value

## Espaciado vertical adicional entre líneas en píxeles.
var espaciado_lineas: int:
	get: return line_spacing
	set(value): line_spacing = value

## Alineación horizontal del texto (Izquierda, Centro, Derecha).
var alineacion_horizontal: int:
	get: return horizontal_alignment
	set(value): horizontal_alignment = value

## Alineación vertical del texto dentro del contenedor (Arriba, Centro, Abajo).
var alineacion_vertical: int:
	get: return vertical_alignment
	set(value): vertical_alignment = value

## Mapea mayúsculas a minúsculas automáticamente si el sprite no incluye minúsculas.
var insensible_mayusculas: bool:
	get: return case_insensitive
	set(value): case_insensitive = value

## Suavizado de textura (Desactivado = Nearest Pixel Art, Activado = Linear).
var suavizar_texto: bool:
	get: return smooth_text
	set(value): smooth_text = value

# --- PROPIEDADES EN INGLÉS CON DOCUMENTACIÓN (DOCSTRINGS) ---

## Text to display. Supports tags: [shake], [wave], [speed=0.1], [pause=1.5]
var text: String = "":
	set(value):
		text = value
		_parse_text()
		update_minimum_size()
		queue_redraw()

## AudioStream (.wav / .ogg) played as each character appears.
var typewriter_sound: AudioStream = null

## Random pitch variation range to prevent repetitive sound (0.0 to 0.5).
var pitch_randomness: float = 0.0:
	set(value):
		pitch_randomness = clamp(value, 0.0, 0.5)

## If true, skips playing audio on space characters.
var silence_on_spaces: bool = false

## Pixel intensity offset for the [shake] tag effect.
var shake_intensity: float = 0.0:
	set(value):
		shake_intensity = value
		queue_redraw()

## Vertical wave amplitude in pixels for the [wave] tag effect.
var wave_amplitude: float = 0.0:
	set(value):
		wave_amplitude = value
		queue_redraw()

## Frequency speed for the [wave] tag oscillation.
var wave_speed: float = 0.0:
	set(value):
		wave_speed = value
		queue_redraw()

## Enables automatic line wrapping after reaching a specific word count per line.
var enable_word_limit: bool = false:
	set(value):
		enable_word_limit = value
		_parse_text()
		update_minimum_size()
		queue_redraw()

## Maximum number of words allowed per line before wrapping.
var max_words_per_line: int = 0:
	set(value):
		max_words_per_line = max(0, value)
		_parse_text()
		update_minimum_size()
		queue_redraw()

## Amount of visible characters (-1 displays full text).
var visible_characters: int = -1:
	set(value):
		visible_characters = value
		queue_redraw()

## Base time in seconds per character during typewriter animation.
var typewriter_speed: float = 0.0:
	set(value):
		typewriter_speed = max(0.0, value)

## Automatically starts the typewriter effect on scene load.
var autostart: bool = false

## Texture containing the character sheet.
var font_texture: Texture2D = null:
	set(value):
		font_texture = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Map of characters ordered as presented in the texture grid.
var character_map: String = "":
	set(value):
		character_map = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Number of columns in the sprite sheet.
var columns: int = 1:
	set(value):
		columns = max(1, value)
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Number of rows in the sprite sheet.
var rows: int = 1:
	set(value):
		rows = max(1, value)
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Enables automatic horizontal and vertical cropping of transparent pixels per glyph.
var proportional: bool = false:
	set(value):
		proportional = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Horizontal spacing between characters in pixels.
var letter_spacing: int = 0:
	set(value):
		letter_spacing = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Vertical spacing between lines in pixels.
var line_spacing: int = 0:
	set(value):
		line_spacing = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Horizontal text alignment (Left, Center, Right).
var horizontal_alignment: int = 0:
	set(value):
		horizontal_alignment = value
		queue_redraw()

## Vertical text alignment inside node container (Top, Center, Bottom).
var vertical_alignment: int = 0:
	set(value):
		vertical_alignment = value
		queue_redraw()

## Maps uppercase characters automatically to lowercase inputs.
var case_insensitive: bool = false:
	set(value):
		case_insensitive = value
		_recalculate_glyphs()
		update_minimum_size()
		queue_redraw()

## Smooth text rendering filter (Disabled = Nearest Pixel Art, Enabled = Linear).
var smooth_text: bool = false:
	set(value):
		smooth_text = value
		texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if smooth_text else CanvasItem.TEXTURE_FILTER_NEAREST
		queue_redraw()

# Estructuras internas
var _typewriter_timer: float = 0.0
var _pause_timer: float = 0.0
var _is_typing: bool = false
var _has_shake_effect: bool = false
var _has_wave_effect: bool = false
var _time_passed: float = 0.0
var _formatted_lines: Array = []
var _flat_tokens: Array = []
var _plain_char_count: int = 0
var _glyphs := {}
var _cell_w: int = 0
var _cell_h: int = 0
var _active_h: int = 0
var _audio_player: AudioStreamPlayer

# Habilitar el botón de restablecer al valor por defecto (↺)
func _property_can_revert(property: StringName) -> bool:
	match property:
		"text", "texto", "typewriter_sound", "sonido_escritura", \
		"pitch_randomness", "variacion_tono", "silence_on_spaces", "silenciar_en_espacios", \
		"shake_intensity", "intensidad_temblor", "wave_amplitude", "amplitud_ola", \
		"wave_speed", "velocidad_ola", "enable_word_limit", "limite_de_palabras", \
		"max_words_per_line", "max_palabras_por_linea", "visible_characters", "caracteres_visibles", \
		"typewriter_speed", "velocidad_escritura", "autostart", "inicio_automatico", \
		"font_texture", "textura_fuente", "character_map", "mapa_caracteres", \
		"columns", "columnas", "rows", "filas", "proportional", "proporcional", \
		"letter_spacing", "espaciado_letras", "line_spacing", "espaciado_lineas", \
		"horizontal_alignment", "alineacion_horizontal", "vertical_alignment", "alineacion_vertical", \
		"case_insensitive", "insensible_mayusculas", "smooth_text", "suavizar_texto":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"text", "texto", "character_map", "mapa_caracteres":
			return ""
		"typewriter_sound", "sonido_escritura", "font_texture", "textura_fuente":
			return null
		"silence_on_spaces", "silenciar_en_espacios", "enable_word_limit", "limite_de_palabras", \
		"autostart", "inicio_automatico", "proportional", "proporcional", \
		"case_insensitive", "insensible_mayusculas", "smooth_text", "suavizar_texto":
			return false
		"pitch_randomness", "variacion_tono", "shake_intensity", "intensidad_temblor", \
		"wave_amplitude", "amplitud_ola", "wave_speed", "velocidad_ola", \
		"typewriter_speed", "velocidad_escritura":
			return 0.0
		"letter_spacing", "espaciado_letras", "line_spacing", "espaciado_lineas", \
		"horizontal_alignment", "alineacion_horizontal", "vertical_alignment", "alineacion_vertical", \
		"max_words_per_line", "max_palabras_por_linea":
			return 0
		"columns", "columnas", "rows", "filas":
			return 1
		"visible_characters", "caracteres_visibles":
			return -1
	return null

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var is_es = (inspector_language == InspectorLanguage.ESPANOL)

	properties.append({ "name": "Contenido" if is_es else "Content", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "texto" if is_es else "text", "type": TYPE_STRING, "hint": PROPERTY_HINT_MULTILINE_TEXT, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Audio" if is_es else "Audio", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "sonido_escritura" if is_es else "typewriter_sound", "type": TYPE_OBJECT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": "AudioStream", "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "variacion_tono" if is_es else "pitch_randomness", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "silenciar_en_espacios" if is_es else "silence_on_spaces", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Efectos de Texto" if is_es else "Text Effects", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "intensidad_temblor" if is_es else "shake_intensity", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "amplitud_ola" if is_es else "wave_amplitude", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "velocidad_ola" if is_es else "wave_speed", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Límite de Palabras" if is_es else "Word Limit", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "limite_de_palabras" if is_es else "enable_word_limit", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "max_palabras_por_linea" if is_es else "max_words_per_line", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Animación de Texto" if is_es else "Typewriter Animation", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "caracteres_visibles" if is_es else "visible_characters", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "velocidad_escritura" if is_es else "typewriter_speed", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "inicio_automatico" if is_es else "autostart", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Spritesheet", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "textura_fuente" if is_es else "font_texture", "type": TYPE_OBJECT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": "Texture2D", "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "mapa_caracteres" if is_es else "character_map", "type": TYPE_STRING, "hint": PROPERTY_HINT_MULTILINE_TEXT, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Dimensiones del Spritesheet" if is_es else "Grid Dimensions", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "columnas" if is_es else "columns", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "filas" if is_es else "rows", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "Ajustes de Renderizado" if is_es else "Rendering Settings", "type": TYPE_NIL, "usage": PROPERTY_USAGE_GROUP })
	properties.append({ "name": "proporcional" if is_es else "proportional", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "espaciado_letras" if is_es else "letter_spacing", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "espaciado_lineas" if is_es else "line_spacing", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT })

	var h_hint = "Izquierda,Centro,Derecha" if is_es else "Left,Center,Right"
	properties.append({ "name": "alineacion_horizontal" if is_es else "horizontal_alignment", "type": TYPE_INT, "hint": PROPERTY_HINT_ENUM, "hint_string": h_hint, "usage": PROPERTY_USAGE_DEFAULT })

	var v_hint = "Arriba,Centro,Abajo" if is_es else "Top,Center,Bottom"
	properties.append({ "name": "alineacion_vertical" if is_es else "vertical_alignment", "type": TYPE_INT, "hint": PROPERTY_HINT_ENUM, "hint_string": v_hint, "usage": PROPERTY_USAGE_DEFAULT })

	properties.append({ "name": "insensible_mayusculas" if is_es else "case_insensitive", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })
	properties.append({ "name": "suavizar_texto" if is_es else "smooth_text", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT })

	return properties

func _set(property: StringName, value: Variant) -> bool:
	match property:
		"text", "texto": text = value; return true
		"typewriter_sound", "sonido_escritura": typewriter_sound = value; return true
		"pitch_randomness", "variacion_tono": pitch_randomness = value; return true
		"silence_on_spaces", "silenciar_en_espacios": silence_on_spaces = value; return true
		"shake_intensity", "intensidad_temblor": shake_intensity = value; return true
		"wave_amplitude", "amplitud_ola": wave_amplitude = value; return true
		"wave_speed", "velocidad_ola": wave_speed = value; return true
		"enable_word_limit", "limite_de_palabras": enable_word_limit = value; return true
		"max_words_per_line", "max_palabras_por_linea": max_words_per_line = value; return true
		"visible_characters", "caracteres_visibles": visible_characters = value; return true
		"typewriter_speed", "velocidad_escritura": typewriter_speed = value; return true
		"autostart", "inicio_automatico": autostart = value; return true
		"font_texture", "textura_fuente": font_texture = value; return true
		"character_map", "mapa_caracteres": character_map = value; return true
		"columns", "columnas": columns = value; return true
		"rows", "filas": rows = value; return true
		"proportional", "proporcional": proportional = value; return true
		"letter_spacing", "espaciado_letras": letter_spacing = value; return true
		"line_spacing", "espaciado_lineas": line_spacing = value; return true
		"horizontal_alignment", "alineacion_horizontal": horizontal_alignment = value; return true
		"vertical_alignment", "alineacion_vertical": vertical_alignment = value; return true
		"case_insensitive", "insensible_mayusculas": case_insensitive = value; return true
		"smooth_text", "suavizar_texto": smooth_text = value; return true
	return false

func _get(property: StringName) -> Variant:
	match property:
		"text", "texto": return text
		"typewriter_sound", "sonido_escritura": return typewriter_sound
		"pitch_randomness", "variacion_tono": return pitch_randomness
		"silence_on_spaces", "silenciar_en_espacios": return silence_on_spaces
		"shake_intensity", "intensidad_temblor": return shake_intensity
		"wave_amplitude", "amplitud_ola": return wave_amplitude
		"wave_speed", "velocidad_ola": return wave_speed
		"enable_word_limit", "limite_de_palabras": return enable_word_limit
		"max_words_per_line", "max_palabras_por_linea": return max_words_per_line
		"visible_characters", "caracteres_visibles": return visible_characters
		"typewriter_speed", "velocidad_escritura": return typewriter_speed
		"autostart", "inicio_automatico": return autostart
		"font_texture", "textura_fuente": return font_texture
		"character_map", "mapa_caracteres": return character_map
		"columns", "columnas": return columns
		"rows", "filas": return rows
		"proportional", "proporcional": return proportional
		"letter_spacing", "espaciado_letras": return letter_spacing
		"line_spacing", "espaciado_lineas": return line_spacing
		"horizontal_alignment", "alineacion_horizontal": return horizontal_alignment
		"vertical_alignment", "alineacion_vertical": return vertical_alignment
		"case_insensitive", "insensible_mayusculas": return case_insensitive
		"smooth_text", "suavizar_texto": return smooth_text
	return null

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if smooth_text else CanvasItem.TEXTURE_FILTER_NEAREST
	_recalculate_glyphs()
	_parse_text()
	update_minimum_size()
	
	if not _audio_player:
		_audio_player = AudioStreamPlayer.new()
		_audio_player.name = "TypewriterAudioPlayer"
		add_child(_audio_player)
	
	if not Engine.is_editor_hint() and autostart:
		start_typewriter()

func _process(delta: float) -> void:
	if _has_shake_effect or _has_wave_effect:
		_time_passed += delta
		queue_redraw()

	if not _is_typing or Engine.is_editor_hint():
		return

	if visible_characters >= _flat_tokens.size():
		_is_typing = false
		finished_typing.emit()
		return

	var current_token = _flat_tokens[visible_characters]

	if current_token["pause"] > 0.0:
		_pause_timer += delta
		if _pause_timer < current_token["pause"]:
			return
		else:
			_pause_timer = 0.0
			current_token["pause"] = 0.0

	var active_delay = typewriter_speed
	if current_token["speed"] > 0.0:
		active_delay = current_token["speed"]

	_typewriter_timer += delta
	if _typewriter_timer >= active_delay:
		_typewriter_timer = 0.0
		visible_characters += 1
		_play_typewriter_sound(current_token)
		
		if visible_characters >= _flat_tokens.size():
			_is_typing = false
			finished_typing.emit()

func _play_typewriter_sound(token: Dictionary) -> void:
	if Engine.is_editor_hint() or not typewriter_sound or not _audio_player:
		return
		
	if silence_on_spaces and token["code"] == 32:
		return
		
	_audio_player.stream = typewriter_sound
	if pitch_randomness > 0.0:
		_audio_player.pitch_scale = randf_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
	else:
		_audio_player.pitch_scale = 1.0
		
	_audio_player.play()

func start_typewriter() -> void:
	_parse_text()
	visible_characters = 0
	_typewriter_timer = 0.0
	_pause_timer = 0.0
	_is_typing = true

func stop_typewriter() -> void:
	_is_typing = false

func skip_typewriter() -> void:
	_is_typing = false
	visible_characters = _plain_char_count

func _parse_text() -> void:
	_formatted_lines.clear()
	_flat_tokens.clear()
	_plain_char_count = 0
	_has_shake_effect = false
	_has_wave_effect = false
	
	if text.is_empty():
		return

	var raw_paragraphs = text.split("\n")
	var parsed_paragraphs: Array = []

	for paragraph in raw_paragraphs:
		var tokens: Array = []
		var is_shaking: bool = false
		var is_waving: bool = false
		var current_speed: float = -1.0
		var next_pause: float = 0.0
		
		var i: int = 0
		while i < paragraph.length():
			var sub = paragraph.substr(i)

			if sub.begins_with("[shake]"):
				is_shaking = true
				_has_shake_effect = true
				i += 7
				continue
			elif sub.begins_with("[/shake]"):
				is_shaking = false
				i += 8
				continue
			elif sub.begins_with("[wave]"):
				is_waving = true
				_has_wave_effect = true
				i += 6
				continue
			elif sub.begins_with("[/wave]"):
				is_waving = false
				i += 7
				continue
			elif sub.begins_with("[speed="):
				var close_idx = sub.find("]")
				if close_idx != -1:
					current_speed = sub.substr(7, close_idx - 7).to_float()
					i += close_idx + 1
					continue
			elif sub.begins_with("[/speed]"):
				current_speed = -1.0
				i += 8
				continue
			elif sub.begins_with("[pause="):
				var close_idx = sub.find("]")
				if close_idx != -1:
					next_pause = sub.substr(7, close_idx - 7).to_float()
					i += close_idx + 1
					continue
			elif sub.begins_with("[wait="):
				var close_idx = sub.find("]")
				if close_idx != -1:
					next_pause = sub.substr(6, close_idx - 6).to_float()
					i += close_idx + 1
					continue

			var char_code = paragraph.unicode_at(i)
			var token = {
				"code": char_code,
				"shake": is_shaking,
				"wave": is_waving,
				"speed": current_speed,
				"pause": next_pause
			}
			tokens.append(token)
			_flat_tokens.append(token)
			next_pause = 0.0
			_plain_char_count += 1
			i += 1

		parsed_paragraphs.append(tokens)

	for tokens in parsed_paragraphs:
		if not enable_word_limit or max_words_per_line <= 0 or tokens.is_empty():
			_formatted_lines.append(tokens)
			continue

		var current_line: Array = []
		var word_count: int = 0
		var in_word: bool = false

		for token in tokens:
			var is_space = (token["code"] == 32)
			if not is_space and not in_word:
				in_word = true
				word_count += 1
				if word_count > max_words_per_line and not current_line.is_empty():
					_formatted_lines.append(current_line.duplicate())
					current_line.clear()
					word_count = 1
			elif is_space:
				in_word = false
			
			current_line.append(token)

		if not current_line.is_empty():
			_formatted_lines.append(current_line)

func _recalculate_glyphs() -> void:
	_glyphs.clear()
	if not font_texture or character_map.is_empty() or columns <= 0 or rows <= 0:
		return

	var img: Image = font_texture.get_image()
	if not img:
		return

	img = img.duplicate()
	if img.is_compressed():
		img.decompress()

	_cell_w = int(font_texture.get_width() / float(columns))
	_cell_h = int(font_texture.get_height() / float(rows))
	_active_h = _cell_h

	var clean_map = character_map.replace("\n", "").replace("\r", "")
	var top_offset: int = 0

	if proportional:
		var global_min_y: int = _cell_h
		var global_max_y: int = -1

		for i in range(clean_map.length()):
			var col = i % columns
			var row = int(i / columns)
			var cell_x = col * _cell_w
			var cell_y = row * _cell_h

			for px in range(_cell_w):
				for py in range(_cell_h):
					if img.get_pixel(cell_x + px, cell_y + py).a > 0.05:
						if py < global_min_y: global_min_y = py
						if py > global_max_y: global_max_y = py

		if global_max_y >= global_min_y:
			top_offset = global_min_y
			_active_h = global_max_y - global_min_y + 1

	for i in range(clean_map.length()):
		var char_code = clean_map.unicode_at(i)
		var col = i % columns
		var row = int(i / columns)

		var cell_x = col * _cell_w
		var cell_y = row * _cell_h

		var crop_x = cell_x
		var crop_w = _cell_w
		var src_y = cell_y + top_offset

		if proportional:
			var min_x: int = _cell_w
			var max_x: int = -1

			for px in range(_cell_w):
				for py in range(top_offset, top_offset + _active_h):
					if img.get_pixel(cell_x + px, cell_y + py).a > 0.05:
						if px < min_x: min_x = px
						if px > max_x: max_x = px

			if max_x >= min_x:
				crop_x = cell_x + min_x
				crop_w = max_x - min_x + 1
			else:
				crop_w = int(_cell_w * 0.4)

		var data = {
			"rect": Rect2(crop_x, src_y, crop_w, _active_h),
			"advance": crop_w + letter_spacing
		}

		_glyphs[char_code] = data

		if case_insensitive:
			var char_str = String.chr(char_code)
			if char_str >= "A" and char_str <= "Z":
				var lower_code = char_str.to_lower().unicode_at(0)
				_glyphs[lower_code] = data

	if not _glyphs.has(32):
		var space_w = int(_cell_w * 0.4) if proportional else _cell_w
		_glyphs[32] = {
			"rect": Rect2(0, 0, 0, 0),
			"advance": space_w + letter_spacing
		}

func _draw() -> void:
	if not font_texture or _glyphs.is_empty() or _formatted_lines.is_empty():
		return

	var total_h = (_formatted_lines.size() * _active_h) + max(0, (_formatted_lines.size() - 1) * line_spacing)

	var start_y: float = 0.0
	match vertical_alignment:
		0: start_y = 0.0
		1: start_y = (size.y - total_h) / 2.0
		2: start_y = size.y - total_h

	var current_y: float = start_y
	var drawn_chars: int = 0

	for line_tokens in _formatted_lines:
		var line_width = _get_token_line_width(line_tokens)
		var start_x: float = 0.0

		match horizontal_alignment:
			0: start_x = 0.0
			1: start_x = (size.x - line_width) / 2.0
			2: start_x = size.x - line_width

		var current_x = start_x

		for token in line_tokens:
			if visible_characters >= 0 and drawn_chars >= visible_characters:
				return

			var c_code = token["code"]
			var is_shaking = token["shake"]
			var is_waving = token["wave"]

			if _glyphs.has(c_code):
				var g = _glyphs[c_code]
				if g["rect"].size.x > 0:
					var offset = Vector2.ZERO
					
					if is_shaking:
						offset += Vector2(
							randf_range(-shake_intensity, shake_intensity),
							randf_range(-shake_intensity, shake_intensity)
						)
					
					if is_waving:
						var wave_y = sin(_time_passed * wave_speed + (drawn_chars * 0.5)) * wave_amplitude
						offset.y += wave_y

					var dest_rect = Rect2(Vector2(current_x, current_y) + offset, g["rect"].size)
					draw_texture_rect_region(font_texture, dest_rect, g["rect"])
				current_x += g["advance"]
			else:
				current_x += _cell_w + letter_spacing

			drawn_chars += 1

		current_y += _active_h + line_spacing

func _get_token_line_width(tokens: Array) -> float:
	var w: float = 0.0
	for token in tokens:
		var c_code = token["code"]
		if _glyphs.has(c_code):
			w += _glyphs[c_code]["advance"]
		else:
			w += _cell_w + letter_spacing
	return w

func _get_minimum_size() -> Vector2:
	if _formatted_lines.is_empty() or _glyphs.is_empty():
		return Vector2(_cell_w, _cell_h)

	var max_w: float = 0.0
	for line_tokens in _formatted_lines:
		max_w = max(max_w, _get_token_line_width(line_tokens))

	var total_h = (_formatted_lines.size() * _active_h) + max(0, (_formatted_lines.size() - 1) * line_spacing)
	return Vector2(max_w, total_h)
