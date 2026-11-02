@tool
class_name SpriteFont
extends RefCounted

## Genera un FontFile a partir de un spritesheet ordenado en filas y columnas.
static func add_sprite_ext(
	texture: Texture2D,
	string_map: String,
	columns: int = 1,
	rows: int = 1,
	separation: int = 0,
	case_insensitive: bool = true,
	proportional: bool = false
) -> FontFile:
	
	if not texture or string_map.is_empty() or columns <= 0 or rows <= 0:
		push_error("SpriteFont: Parámetros inválidos.")
		return null
	
	# Limpiar saltos de línea del mapa de caracteres
	var clean_map = string_map.replace("\n", "").replace("\r", "")
	var char_count = clean_map.length()
	
	var font = FontFile.new()
	
	# Dimensiones base del cuadro de cada carácter
	var char_width = int(texture.get_width() / float(columns))
	var char_height = int(texture.get_height() / float(rows))
	
	# Configuración de fuente Bitmap
	font.fixed_size = char_height
	font.fixed_size_scale_mode = TextServer.FIXED_SIZE_SCALE_ENABLED
	font.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	font.generate_mipmaps = true
	
	var font_size: int = char_height
	var font_size_vec := Vector2i(font_size, 0)
	
	# Obtener la imagen, descomprimirla, convertir a RGBA8 y generar mipmaps
	var img: Image = texture.get_image()
	if not img:
		return null
		
	img = img.duplicate()
	if img.is_compressed():
		img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	img.generate_mipmaps()
	
	font.set_texture_image(0, font_size_vec, 0, img)
	
	# Configurar línea base vertical
	font.set_cache_ascent(0, font_size, char_height)
	font.set_cache_descent(0, font_size, 0)
	
	var registered_codes := {}
	
	for i in range(char_count):
		var char_code = clean_map.unicode_at(i)
		
		var col = i % columns
		var row = int(i / columns)
		
		var cell_x = col * char_width
		var cell_y = row * char_height
		
		var crop_x = cell_x
		var crop_w = char_width
		
		# Si la opción proporcional está activa, escanear píxeles visibles
		if proportional:
			var min_x: int = char_width
			var max_x: int = -1
			
			for px in range(char_width):
				for py in range(char_height):
					var pixel_color = img.get_pixel(cell_x + px, cell_y + py)
					if pixel_color.a > 0.05: # Pixel visible
						if px < min_x:
							min_x = px
						if px > max_x:
							max_x = px
			
			# Recortar solo el área ocupada por la letra
			if max_x >= min_x:
				crop_x = cell_x + min_x
				crop_w = max_x - min_x + 1
			else:
				# Celda transparente/vacía
				crop_w = int(char_width * 0.4)
		
		var src_rect = Rect2(crop_x, cell_y, crop_w, char_height)
		var advance_width = crop_w + separation
		
		_register_glyph(font, font_size, char_code, crop_w, char_height, advance_width, src_rect)
		registered_codes[char_code] = true
		
		if case_insensitive:
			var char_str = String.chr(char_code)
			if char_str >= "A" and char_str <= "Z":
				var lower_code = char_str.to_lower().unicode_at(0)
				_register_glyph(font, font_size, lower_code, crop_w, char_height, advance_width, src_rect)
				registered_codes[lower_code] = true
	
	# Espacio en blanco (' ')
	if not registered_codes.has(32):
		var space_w = int(char_width * 0.4) if proportional else char_width
		var space_advance = space_w + separation
		_register_glyph(font, font_size, 32, space_w, char_height, space_advance, Rect2(0, 0, 0, 0))
	
	return font

static func _register_glyph(font: FontFile, size: int, char_code: int, char_w: int, char_h: int, advance: int, src_rect: Rect2) -> void:
	var font_size_vec := Vector2i(size, 0)
	var glyph_id: int = char_code
	
	font.set_glyph_advance(0, size, glyph_id, Vector2(advance, 0))
	font.set_glyph_offset(0, font_size_vec, glyph_id, Vector2i(0, -char_h))
	font.set_glyph_size(0, font_size_vec, glyph_id, Vector2i(char_w, char_h))
	font.set_glyph_uv_rect(0, font_size_vec, glyph_id, src_rect)
	font.set_glyph_texture_idx(0, font_size_vec, glyph_id, 0)
